/*
 * Updated by Andrew Theis on 5/16/2010.
 * Copyright 2010 Andrew Theis. All rights reserved.
 * 
 * This file contains functions specifically for players who spawn as a Prop.
 */
 

// Create an array to store the class settings and functions in.
local CLASS = {}


// Some settings for the class.
CLASS.DisplayName			= "Prop"
CLASS.WalkSpeed 			= 250
CLASS.CrouchedWalkSpeed 	= 0.2
CLASS.RunSpeed				= 250
CLASS.DuckSpeed				= 0.2
CLASS.DrawTeamRing			= false


// Called after OnSpawn. Sets the player loadout.
function CLASS:Loadout(pl)

	// Props do not get anything.
	
end


// Called when player spawns,
function CLASS:OnSpawn(pl)

	// Make sure player model doesn't show up to anyone else.
	pl:SetColor(255, 255, 255, 0)
	
	// Create a new ph_prop entity, set its collision type, and spawn it.
	pl.ph_prop = ents.Create("ph_prop")
	pl.ph_prop:SetSolid(SOLID_BSP)
	pl.ph_prop:SetOwner(pl)
	pl.ph_prop:Spawn()
	
	// Set initial max health.
	pl.ph_prop.max_health = 100
end


// Called when a player dies.
function CLASS:OnDeath(pl, attacker, dmginfo)

	pl:RemoveProp()
	
end


// Register our array of settings and functions as a new class.
player_class.Register("Prop", CLASS)