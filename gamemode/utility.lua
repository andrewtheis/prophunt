--
-- utility.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-10-14. Modified from original Facepunch fretta file.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
--


-- Respawn all non-spectators, providing they are allowed to spawn. 
function UTIL_SpawnAllPlayers()

	for k,v in pairs( player.GetAll() ) do
		if ( v:Team() != TEAM_SPECTATOR && v:Team() != TEAM_CONNECTING ) then
			v:Spawn()
		end
	end

end


-- Clears all weapons and ammo from all players.
function UTIL_StripAllPlayers()

	for k,v in pairs( player.GetAll() ) do
		if ( v:Team() != TEAM_SPECTATOR && v:Team() != TEAM_CONNECTING ) then
			v:StripWeapons()
			v:StripAmmo()
		end
	end

end


-- Freeze all non-spectators.
function UTIL_FreezeAllPlayers()

	for k,v in pairs( player.GetAll() ) do
		if ( v:Team() != TEAM_SPECTATOR && v:Team() != TEAM_CONNECTING ) then
			v:Freeze( true )
		end
	end

end


--  Removes frozen flag from all players.
function UTIL_UnFreezeAllPlayers()

	for k,v in pairs( player.GetAll() ) do
		if ( v:Team() != TEAM_SPECTATOR && v:Team() != TEAM_CONNECTING ) then
			v:Freeze( false )
		end
	end

end