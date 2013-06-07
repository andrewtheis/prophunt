--
-- Updated by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
-- 
-- Adds functions to the player meta table so they can be called from a player object. For example ply:MyNewFunction().
--


-- Grab a copy of the player meta table.
local meta = FindMetaTable("Player")

-- If there is none, then stop executing this file.
if !meta then
	
	return 

end


-- Blinds the player by setting view out into the void.
function meta:Blind(bool)
	
	-- If the player isn't valid, terminate.
	if !self:IsValid() then 
		
		return 
	
	end
	
	-- If we are on the server then send the blind setting via a usermessage. If we are on client just set the variable.
	if SERVER then
	
		umsg.Start("SetBlind", self)
		umsg.Bool(bool)
		umsg.End()
	
	elseif CLIENT then
	
		blind = bool
		
	end
	
end


-- Removes the player prop if it exists.
function meta:RemoveProp()

	-- If we are executing from client side or the player/player's prop isn't valid, terminate.
	if CLIENT || !self:IsValid() || !self.ph_prop || !self.ph_prop:IsValid() then
	
		return

	end
	
	-- Remove the player's prop and set the variable to nil.
	self.ph_prop:Remove()
	self.ph_prop = nil
		
end