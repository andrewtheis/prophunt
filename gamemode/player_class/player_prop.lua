--
-- player_prop.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
--


AddCSLuaFile()


DEFINE_BASECLASS("player_default")
 

-- Create an array to store the class settings and functions in.
local PLAYER = {}


-- Some settings for the class.
PLAYER.DisplayName			= "Prop"
PLAYER.WalkSpeed 			= 250
PLAYER.CrouchedWalkSpeed 	= 0.2
PLAYER.RunSpeed				= 250
PLAYER.DuckSpeed			= 0.2
PLAYER.DrawTeamRing			= false


-- Called after OnSpawn. Sets the player loadout. Props do not get anything.
function PLAYER:Loadout()

end


-- Called when player spawns.
function PLAYER:Spawn()
	
	-- Make sure player model doesn't show up to anyone else.
	self.Player:SetColor(255, 255, 255, 0)
	
	-- Create a new ph_prop entity, set its collision type, and spawn it.
	self.Player.ph_prop = ents.Create("ph_prop")
	self.Player.ph_prop:SetSolid(SOLID_BSP)
	self.Player.ph_prop:SetOwner(self.Player)
	self.Player.ph_prop:Spawn()
	
	-- Set initial max health.
	self.Player.ph_prop.max_health = 100
	
end


-- Called when a player dies.
function PLAYER:Death(attacker, dmginfo)

	self.Player:RemoveProp()
	
end


-- Register our array of settings and functions as a new class.
player_manager.RegisterClass("player_prop", PLAYER, "player_default")