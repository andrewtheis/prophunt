--
-- Updated by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
-- 
-- Server file for ph_prop entity.
--


-- Send required files to client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")


-- Include needed files.
include("shared.lua")


-- Called when the entity initializes.
function ENT:Initialize()

	self:SetModel("models/player/Kleiner.mdl")
	self.health = 100
	
end 


-- Called when the entity takes damage.
function ENT:OnTakeDamage(dmg)
	
	-- Store dmg information in easier to use variables.
	local pl 		= self:GetOwner()
	local attacker 	= dmg:GetAttacker()
	local inflictor = dmg:GetInflictor()
	
	-- Check to make sure the player and attacker are valid.
	if pl && pl:IsValid() && pl:Alive() && pl:IsPlayer() && attacker:IsPlayer() && dmg:GetDamage() > 0 then
	
		-- Set new player health.
		self.health = self.health - dmg:GetDamage()
		pl:SetHealth(self.health)
		
		-- Check to see if the player should be dead.
		if self.health <= 0 then
			
			-- Kill the player and remove their prop.
			pl:KillSilent()
			pl:RemoveProp()
			
			-- Find out what player should take credit for the kill.
			if inflictor && inflictor == attacker && inflictor:IsPlayer() then
			
				inflictor = inflictor:GetActiveWeapon()
				
				if !inflictor || inflictor == NULL then
				
					inflictor = attacker
				
				end
				
			end
			
			-- Let everyone else know of the kill.
			umsg.Start("PlayerKilledByPlayer") 
				umsg.Entity(pl) 
				umsg.String(inflictor:GetClass())
				umsg.Entity(attacker) 
			umsg.End()
			
			MsgAll(attacker:Name() .. " found and killed " .. pl:Name() .. "\n") 
			
			-- Add points to the attacker's score and up their health.
			attacker:AddFrags(1)
			attacker:SetHealth(math.Clamp(attacker:Health() + HUNTER_KILL_BONUS, 1, 100))
			
		end
		
	end
	
end 