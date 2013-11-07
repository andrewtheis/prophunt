--
-- round_controller.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-14. Modified from original Facepunch fretta file.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
--


function GM:SetRoundWinner( ply, resulttext ) SetGlobalEntity( "RoundWinner", ply ) SetGlobalString( "RRText", tostring(resulttext) ) end
function GM:SetRoundResult( i, resulttext ) SetGlobalInt( "RoundResult", i ) SetGlobalString( "RRText", tostring(resulttext) ) end
function GM:ClearRoundResult() SetGlobalEntity( "RoundWinner", NULL ) SetGlobalInt( "RoundResult", 0 ) SetGlobalString( "RRText", "" ) end
function GM:SetInRound( b ) SetGlobalBool( "InRound", b ) end
function GM:InRound() return GetGlobalBool( "InRound", false ) end


function GM:OnRoundStart( num )

	UTIL_UnFreezeAllPlayers()

end


function GM:OnRoundEnd( num )
end


function GM:OnRoundResult( result, resulttext )

	-- The fact that result might not be a team 
	-- shouldn't matter when calling this..
	team.AddScore( result, 1 )

end


function GM:OnRoundWinner( ply, resulttext )

	-- Do whatever you want to do with the winner here (this is only called in Free For All gamemodes)...
	ply:AddFrags( 1 )

end


-- Called before start of round.
function GM:OnPreRoundStart(num)

	game.CleanUpMap()
	
	-- Swap teams only if this isn't the first round and the setting is enabled.
	if GetGlobalInt("RoundNumber") != 1 && GetConVarNumber("ph_swap_teams_every_round") == 1 && (team.GetScore(TEAM_PROPS) + team.GetScore(TEAM_HUNTERS)) > 0 then
	
		for _, pl in pairs(player.GetAll()) do
		
			if pl:Team() == TEAM_PROPS || pl:Team() == TEAM_HUNTERS then
			
				if pl:Team() == TEAM_PROPS then
				
					pl:SetTeam(TEAM_HUNTERS)
					
				else
				
					pl:SetTeam(TEAM_PROPS)
					
				end
				
				-- Let everyone know.
				pl:ChatPrint("Teams have been swapped!")
				
			end
			
		end
		
	end
	
	-- Reset players.
	UTIL_StripAllPlayers()
	UTIL_SpawnAllPlayers()
	UTIL_FreezeAllPlayers()
	
end


function GM:CanStartRound( iNum )
	return true
end


function GM:StartRoundBasedGame()
	GAMEMODE:PreRoundStart( 1 )	
end


-- Number of rounds
function GM:GetRoundLimit()
	return GAMEMODE.RoundLimit;
end


-- Has the round limit been reached?
function GM:HasReachedRoundLimit( iNum )

	local iRoundLimit = GAMEMODE:GetRoundLimit();
	
	if( iRoundLimit > 0 && iNum > iRoundLimit ) then
		return true
	end
	
	return false
	
end


-- This is for the timer-based game end. set this to return true if you want it to end mid-round
function GM:CanEndRoundBasedGame()
	return false
end


-- You can add round time by calling this (takes time in seconds)
function GM:AddRoundTime( iAddedTime )
	
	if( !GAMEMODE:InRound() ) then -- don't add time if round is not in progress
		return
	end
	
	SetGlobalFloat( "RoundEndTime", GetGlobalFloat( "RoundEndTime", CurTime() ) + iAddedTime );
	timer.Adjust( "RoundEndTimer", GetGlobalFloat( "RoundEndTime" ) - GetGlobalFloat( "RoundStartTime" ), 0, function() GAMEMODE:RoundTimerEnd() end );
	
	local rf = RecipientFilter()
	rf:AddAllPlayers()

	umsg.Start( "RoundAddedTime", rf ); -- send a umsg so you can do something with the HUD
		umsg.Float( iAddedTime ); -- time added
	umsg.End();

end


-- This gets the timer for a round (you can make round number dependant round lengths, or make it cvar controlled)
function GM:GetRoundTime( iRoundNumber )
	return GAMEMODE.RoundLength;
end


-- Internal, override OnPreRoundStart if you want to do stuff here
function GM:PreRoundStart( iNum )

	-- Should the game end?
	if (GAMEMODE:HasReachedRoundLimit(iNum)) then
		GAMEMODE:EndOfGame(true);
		return;
	end
	
	if ( !GAMEMODE:CanStartRound( iNum ) ) then
	
		timer.Simple( 1, function() GAMEMODE:PreRoundStart( iNum ) end ) -- In a second, check to see if we can start
		return;
		
	end

	timer.Simple( GAMEMODE.RoundPreStartTime, function() GAMEMODE:RoundStart() end )
	SetGlobalInt( "RoundNumber", iNum )
	SetGlobalFloat( "RoundStartTime", CurTime() + GAMEMODE.RoundPreStartTime )
	
	GAMEMODE:ClearRoundResult()
	GAMEMODE:OnPreRoundStart( GetGlobalInt( "RoundNumber" ) )
	GAMEMODE:SetInRound( true )

end


-- Internal, override OnRoundStart if you want to do stuff here
function GM:RoundStart()

	local roundNum = GetGlobalInt( "RoundNumber" );
	local roundDuration = GAMEMODE:GetRoundTime( roundNum )
	
	GAMEMODE:OnRoundStart( roundNum )

	timer.Create( "RoundEndTimer", roundDuration, 0, function() GAMEMODE:RoundTimerEnd() end )
	timer.Create( "CheckRoundEnd", 1, 0, function() GAMEMODE:CheckRoundEnd() end )
	
	SetGlobalFloat( "RoundEndTime", CurTime() + roundDuration );
	
end


-- Decide what text should show when a team/player wins
function GM:ProcessResultText( result, resulttext )

	if ( resulttext == nil ) then resulttext = "" end
	
	-- the result could either be a number or a player!
	-- for a free for all you could do... if type(result) == "Player" and IsValid( result ) then return result:Name().." is the winner" or whatever
	
	return resulttext

end


-- Round Ended with Result
function GM:RoundEndWithResult( result, resulttext )

	resulttext = GAMEMODE:ProcessResultText( result, resulttext )
	
	if type( result ) == "number" then -- the result is a team ID

		GAMEMODE:SetRoundResult( result, resulttext )
		GAMEMODE:RoundEnd()
		GAMEMODE:OnRoundResult( result, resulttext )
		
	else -- the result is a player
	
		GAMEMODE:SetRoundWinner( result, resulttext )
		GAMEMODE:RoundEnd()
		GAMEMODE:OnRoundWinner( result, resulttext )
	
	end
	
end


-- Internal, override OnRoundEnd if you want to do stuff here
function GM:RoundEnd()

	if ( !GAMEMODE:InRound() ) then 
		-- if someone uses RoundEnd incorrectly then do a trace.
		MsgN("WARNING: RoundEnd being called while gamemode not in round...")
		debug.Trace()
		return 
	end
	
	GAMEMODE:OnRoundEnd( GetGlobalInt( "RoundNumber" ) )

	self:SetInRound( false )
	
	timer.Destroy( "RoundEndTimer" )
	timer.Destroy( "CheckRoundEnd" )
	SetGlobalFloat( "RoundEndTime", -1 )
	
	timer.Simple( GAMEMODE.RoundPostLength, function() GAMEMODE:PreRoundStart( GetGlobalInt( "RoundNumber" )+1 ) end )
	
	for _, pl in pairs(team.GetPlayers(TEAM_HUNTERS)) do
	
		pl:Blind(false)
		pl:UnLock()
		
	end
	
end


function GM:GetTeamAliveCounts()

	local TeamCounter = {}

	for k,v in pairs( player.GetAll() ) do
		if ( v:Alive() && v:Team() > 0 && v:Team() < 1000 ) then
			TeamCounter[ v:Team() ] = TeamCounter[ v:Team() ] or 0
			TeamCounter[ v:Team() ] = TeamCounter[ v:Team() ] + 1
		end
	end

	return TeamCounter

end


-- For round based games that end when a team is dead
function GM:CheckPlayerDeathRoundEnd()

	if !GAMEMODE:InRound() then return end

	local teams = GAMEMODE:GetTeamAliveCounts()

	if table.Count(teams) == 0 then
	
		GAMEMODE:RoundEndWithResult(1001, "Draw, everyone loses!")
		return
		
	end

	if table.Count(teams) == 1 then
	
		local team_id = table.GetFirstKey(teams)
		GAMEMODE:RoundEndWithResult(team_id, team.GetName(team_id).." win!")
		return
		
	end
	
end
hook.Add( "PlayerDisconnected", "RoundCheck_PlayerDisconnect", function() timer.Simple( 0.2, function() GAMEMODE:CheckPlayerDeathRoundEnd() end ) end )
hook.Add( "PostPlayerDeath", "RoundCheck_PostPlayerDeath", function() timer.Simple( 0.2, function() GAMEMODE:CheckPlayerDeathRoundEnd() end ) end )


-- You should use this to check any round end conditions 
function GM:CheckRoundEnd()

	-- Do checks.. 
	
	-- if something then call GAMEMODE:RoundEndWithResult( TEAM_BLUE, "Team Blue Ate All The Mushrooms!" )
	-- OR for a free for all you could do something like... GAMEMODE:RoundEndWithResult( SomePlayer )

end


function GM:CheckRoundEndInternal()

	if ( !GAMEMODE:InRound() ) then return end

	GAMEMODE:CheckRoundEnd()
	
	timer.Create( "CheckRoundEnd", 1, 0, function() GAMEMODE:CheckRoundEndInternal() end )

end


-- This is called when the round time ends (props win).
function GM:RoundTimerEnd()

	if !GAMEMODE:InRound() then
	
		return
		
	end
	
	-- If the timer reached zero, then we know the Props team won beacause they didn't all die.
	GAMEMODE:RoundEndWithResult(TEAM_PROPS, "Props win!")
	
end


-- This is called when time runs out and there is no winner chosen yet (free for all gamemodes only)
-- By default it chooses the player with the most frags but you can edit this to do what you need..
function GM:SelectCurrentlyWinningPlayer()
	
	local winner
	local topscore = 0

	for k,v in pairs( player.GetAll() ) do
	
		if v:Frags() > topscore and v:Team() != TEAM_CONNECTING and v:Team() != TEAM_UNASSIGNED and v:Team() != TEAM_SPECTATOR then
		
			winner = v
			topscore = v:Frags()
		
		end
	
	end
	
	return winner

end