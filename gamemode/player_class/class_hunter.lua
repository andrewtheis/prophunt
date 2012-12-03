/*
 * Updated by Andrew Theis on 5/16/2010.
 * Copyright 2010 Andrew Theis. All rights reserved.
 * 
 * This file contains functions specifically for players who spawn as a Hunter.
 */


// Create an array to store the class settings and functions in.
local CLASS = {}


// Some settings for the class.
CLASS.DisplayName			= "Hunter"
CLASS.WalkSpeed 			= 230
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 230
CLASS.DuckSpeed				= 0.2
CLASS.DrawTeamRing			= false


// Called after OnSpawn. Sets the player loadout.
function CLASS:Loadout(pl)

	pl:GiveAmmo(64, "Buckshot")
	pl:GiveAmmo(255, "SMG1")
	
	pl:Give("weapon_shotgun")
	pl:Give("weapon_smg1")
	pl:Give("item_ar2_grenade")
	
	local cl_defaultweapon = pl:GetInfo("cl_defaultweapon") 
 	 
 	if pl:HasWeapon(cl_defaultweapon) then 
	
 		pl:SelectWeapon(cl_defaultweapon)
	
 	end 
	
end


// Called when player spawns.
function CLASS:OnSpawn(pl)

	local unlock_time = math.Clamp(HUNTER_BLINDLOCK_TIME - (CurTime() - GetGlobalFloat("RoundStartTime", 0)), 0, HUNTER_BLINDLOCK_TIME)
	
	if unlock_time > 2 then
	
		pl:Blind(true)
		timer.Simple(unlock_time, pl.Blind, pl, false)
		
		timer.Simple(2, pl.Lock, pl)
		timer.Simple(unlock_time, pl.UnLock, pl)
		
	end
	
end


// Called when a player dies.
function CLASS:OnDeath(pl, attacker, dmginfo)

	pl:CreateRagdoll()
	pl:UnLock()
	
end


// Register our array of settings and functions as a new class.
player_class.Register("Hunter", CLASS)