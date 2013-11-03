--
-- de_port.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
--


if SERVER then

	last_hurt_interval = 0
	
	hook.Add("Think", "PropHunt_DePort_Think", function()
	
		if last_hurt_interval + 1 < CurTime() then
		
			for _, pl in pairs(team.GetPlayers(TEAM_PROPS)) do
			
				if pl && pl:WaterLevel() >= 1 then
				
					pl:SetHealth(pl:Health() - 25)
					
					if pl:Alive() && pl:Health() < 1 then
					
						pl:Kill()
						
					end
					
				end
				
			end
			
			last_hurt_interval = CurTime()
			
		end
		
	end)
	
end