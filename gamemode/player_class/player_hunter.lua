--
-- Updated by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
-- 
-- This file contains functions specifically for players who spawn as a Hunter.
--


DEFINE_BASECLASS("player_default")


-- Create an array to store the player class settings and functions in.
local PLAYER = {}


-- Some settings for the class.
PLAYER.DisplayName			= "Hunter"
PLAYER.WalkSpeed 			= 230
PLAYER.CrouchedWalkSpeed 	= 0.2
PLAYER.RunSpeed				= 230
PLAYER.DuckSpeed			= 0.2
PLAYER.DrawTeamRing			= false


-- Called after OnSpawn. Sets the player loadout.
function PLAYER:Loadout()

	self.Player:GiveAmmo(64, "Buckshot")
	self.Player:GiveAmmo(255, "SMG1")
	
	self.Player:Give("weapon_shotgun")
	self.Player:Give("weapon_smg1")
	self.Player:Give("item_ar2_grenade")
	
	local cl_defaultweapon = self.Player:GetInfo("cl_defaultweapon") 
 	 
 	if self.Player:HasWeapon(cl_defaultweapon) then 
	
 		self.Player:SelectWeapon(cl_defaultweapon)
	
 	end 
	
end


-- Called when player spawns.
function PLAYER:OnSpawn()

	local unlock_time = math.Clamp(PLAYER_BLINDLOCK_TIME - (CurTime() - GetGlobalFloat("RoundStartTime", 0)), 0, PLAYER_BLINDLOCK_TIME)
	
	if unlock_time > 2 then
	
		self.Player:Blind(true)
		timer.Simple(unlock_time, self.Player.Blind, pl, false)
		
		timer.Simple(2, self.Player.Lock, pl)
		timer.Simple(unlock_time, self.Player.UnLock, pl)
		
	end
	
end


-- Called when a player dies.
function PLAYER:OnDeath(attacker, dmginfo)

	self.Player:CreateRagdoll()
	self.Player:UnLock()
	
end


-- Register our array of settings and functions as a new class.
player_manager.RegisterClass("player_hunter", PLAYER, "player_default")