--
-- cl_skin.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-31. Modified from original Facepunch fretta file.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--

--[[---------------------------------------------------------
   Name: gamemode:GetValidSpectatorModes( Player ply )
   Desc: Gets a table of the allowed spectator modes (OBS_MODE_INEYE, etc)
		 Player is the player object of the spectator
---------------------------------------------------------]]
function GM:GetValidSpectatorModes( ply )

	// Note: Override this and return valid modes per player/team

	return GAMEMODE.ValidSpectatorModes

end

--[[--------------------------------------------------------
   Name: gamemode:GetValidSpectatorEntityNames( Player ply )
   Desc: Returns a table of entities that can be spectated (player etc)
---------------------------------------------------------]]
function GM:GetValidSpectatorEntityNames( ply )

	// Note: Override this and return valid entity names per player/team

	return GAMEMODE.ValidSpectatorEntities

end

--[[--------------------------------------------------------
   Name: gamemode:IsValidSpectator( Player ply )
   Desc: Is our player spectating - and valid?
---------------------------------------------------------]]
function GM:IsValidSpectator( pl )

	if ( !IsValid( pl ) ) then return false end
	if ( pl:Team() != TEAM_SPECTATOR && !pl:IsObserver() ) then return false end
	
	return true

end

--[[--------------------------------------------------------
   Name: gamemode:IsValidSpectatorTarget( Player pl, Entity ent )
   Desc: Checks to make sure a spectated entity is valid.
		 By default, you can change GM.CanOnlySpectate own team if you want to
		 prevent players from spectating the other team.
---------------------------------------------------------]]
function GM:IsValidSpectatorTarget( pl, ent )

	if ( !IsValid( ent ) ) then return false end
	if ( ent == pl ) then return false end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorEntityNames( pl ), ent:GetClass() ) ) then return false end
	if ( ent:IsPlayer() && !ent:Alive() ) then return false end
	if ( ent:IsPlayer() && ent:IsObserver() ) then return false end
	if ( pl:Team() != TEAM_SPECTATOR && ent:IsPlayer() && GAMEMODE.CanOnlySpectateOwnTeam && pl:Team() != ent:Team() ) then return false end
	
	return true

end


--[[--------------------------------------------------------
   Name: gamemode:GetSpectatorTargets( Player pl )
   Desc: Returns a table of entities the player can spectate.
---------------------------------------------------------]]
function GM:GetSpectatorTargets( pl )

	local t = {}
	for k, v in pairs( GAMEMODE:GetValidSpectatorEntityNames( pl ) ) do
		t = table.Merge( t, ents.FindByClass( v ) )
	end
	
	return t

end


--[[---------------------------------------------------------
   Name: gamemode:FindRandomSpectatorTarget( Player pl )
   Desc: Finds a random player/ent we can spectate.
		 This is called when a player is first put in spectate.
---------------------------------------------------------]]
function GM:FindRandomSpectatorTarget( pl )

	local Targets = GAMEMODE:GetSpectatorTargets( pl )
	return table.Random( Targets )

end


--[[-------------------------------------------------------
   Name: gamemode:FindNextSpectatorTarget( Player pl, Entity ent )
   Desc: Finds the next entity we can spectate.
		 ent param is the current entity we are viewing.
---------------------------------------------------------]]
function GM:FindNextSpectatorTarget( pl, ent )

	local Targets = GAMEMODE:GetSpectatorTargets( pl )
	return table.FindNext( Targets, ent )

end


--[[-------------------------------------------------------
   Name: gamemode:FindPrevSpectatorTarget( Player pl, Entity ent )
   Desc: Finds the previous entity we can spectate.
		 ent param is the current entity we are viewing.
---------------------------------------------------------]]
function GM:FindPrevSpectatorTarget( pl, ent )

	local Targets = GAMEMODE:GetSpectatorTargets( pl )
	return table.FindPrev( Targets, ent )

end


--[[-------------------------------------------------------
   Name: gamemode:StartEntitySpectate( Player pl )
   Desc: Called when we start spectating.
---------------------------------------------------------]]
function GM:StartEntitySpectate( pl )

	local CurrentSpectateEntity = pl:GetObserverTarget()
	
	for i=1, 32 do
	
		if ( GAMEMODE:IsValidSpectatorTarget( pl, CurrentSpectateEntity ) ) then
			pl:SpectateEntity( CurrentSpectateEntity )
			return
		end
	
		CurrentSpectateEntity = GAMEMODE:FindRandomSpectatorTarget( pl )
	
	end

end

--[[--------------------------------------------------------
   Name: gamemode:NextEntitySpectate( Player pl )
   Desc: Called when we want to spec the next entity.
---------------------------------------------------------]]
function GM:NextEntitySpectate( pl )

	local Target = pl:GetObserverTarget()
	
	for i=1, 32 do
	
		Target = GAMEMODE:FindNextSpectatorTarget( pl, Target )	
		
		if ( GAMEMODE:IsValidSpectatorTarget( pl, Target ) ) then
			pl:SpectateEntity( Target )
			return
		end
	
	end

end


--[[--------------------------------------------------------
   Name: gamemode:PrevEntitySpectate( Player pl )
   Desc: Called when we want to spec the previous entity.
---------------------------------------------------------]]
function GM:PrevEntitySpectate( pl )

	local Target = pl:GetObserverTarget()
	
	for i=1, 32 do
	
		Target = GAMEMODE:FindPrevSpectatorTarget( pl, Target )	
		
		if ( GAMEMODE:IsValidSpectatorTarget( pl, Target ) ) then
			pl:SpectateEntity( Target )
			return
		end
	
	end

end


--[[-------------------------------------------------------
   Name: gamemode:ChangeObserverMode( Player pl, Number mode )
   Desc: Change the observer mode of a player.
---------------------------------------------------------]]
function GM:ChangeObserverMode( pl, mode )

	if ( pl:GetInfoNum( "cl_spec_mode", 0) != mode ) then
		pl:ConCommand( "cl_spec_mode "..mode )
	end

	if ( mode == OBS_MODE_IN_EYE || mode == OBS_MODE_CHASE ) then
		GAMEMODE:StartEntitySpectate( pl, mode )
	end
	
	pl:SpectateEntity( NULL )
	pl:Spectate( mode )

end


--[[--------------------------------------------------------
   Name: gamemode:BecomeObserver( Player pl )
   Desc: Called when we first become a spectator.
---------------------------------------------------------]]
function GM:BecomeObserver( pl )

	local mode = pl:GetInfoNum( "cl_spec_mode", OBS_MODE_CHASE )
	
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), mode ) ) then 
		mode = table.FindNext( GAMEMODE:GetValidSpectatorModes( pl ), mode )
	end
	
	GAMEMODE:ChangeObserverMode( pl, mode )

end


local function spec_mode( pl, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( pl ) ) then return end
	
	local mode = pl:GetObserverMode()
	local nextmode = table.FindNext( GAMEMODE:GetValidSpectatorModes( pl ), mode )
	
	GAMEMODE:ChangeObserverMode( pl, nextmode )

end

concommand.Add( "spec_mode",  spec_mode )


local function spec_next( pl, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( pl ) ) then return end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), pl:GetObserverMode() ) ) then return end
	
	GAMEMODE:NextEntitySpectate( pl )

end

concommand.Add( "spec_next",  spec_next )


local function spec_prev( pl, cmd, args )

	if ( !GAMEMODE:IsValidSpectator( pl ) ) then return end
	if ( !table.HasValue( GAMEMODE:GetValidSpectatorModes( pl ), pl:GetObserverMode() ) ) then return end
	
	GAMEMODE:PrevEntitySpectate( pl )

end

concommand.Add( "spec_prev",  spec_prev )