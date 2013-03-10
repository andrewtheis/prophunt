--
-- Updated by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
-- 
-- First gamemode file that is called by server. Sends required client files, etc.
--

 
-- Send the required lua files to the client.
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("sh_config.lua")
AddCSLuaFile("sh_init.lua")
AddCSLuaFile("sh_player.lua")


-- If there is a mapfile send it to the client (sometimes servers want to change settings for certain maps).
if file.Exists("../gamemodes/prop_hunt/gamemode/maps/"..game.GetMap()..".lua", "LUA") then

	AddCSLuaFile("maps/"..game.GetMap()..".lua")
	
end


-- Include the required lua files.
include("sh_init.lua")


-- Server only constants.
EXPLOITABLE_DOORS = {
	"func_door",
	"prop_door_rotating", 
	"func_door_rotating"
}

USABLE_PROP_ENTITIES = {
	"prop_physics",
	"prop_physics_multiplayer"
}


-- Send the required resources to the client.
for _, taunt in pairs(HUNTER_TAUNTS) do 
	
	resource.AddFile("sound/"..taunt)
	
end

for _, taunt in pairs(PROP_TAUNTS) do

	resource.AddFile("sound/"..taunt)

end


-- Called when a player dies. Checks to see if the round should end.
function GM:CheckPlayerDeathRoundEnd()

	if !GAMEMODE.RoundBased || !GAMEMODE:InRound() then 
	
		return
		
	end

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


-- Called when an entity takes damage.
function EntityTakeDamage(ent, inflictor, attacker, amount)

	if GAMEMODE:InRound() && ent && ent:GetClass() != "ph_prop" && !ent:IsPlayer() && attacker && attacker:IsPlayer() && attacker:Team() == TEAM_HUNTERS && attacker:Alive() then
	
		attacker:SetHealth(attacker:Health() - HUNTER_FIRE_PENALTY)
		
		if attacker:Health() <= 0 then
		
			MsgAll(attacker:Name() .. " felt guilty for hurting so many innocent props and committed suicide\n")
			attacker:Kill()
			
		end
		
	end
	
end
hook.Add("EntityTakeDamage", "PropHunt_EntityTakeDamage", EntityTakeDamage)


-- Called before start of round.
function GM:OnPreRoundStart(num)

	game.CleanUpMap()
	
	-- Swap teams only if this isn't the first round and the setting is enabled.
	if GetGlobalInt("RoundNumber") != 1 && SWAP_TEAMS_EVERY_ROUND == 1 && (team.GetScore(TEAM_PROPS) + team.GetScore(TEAM_HUNTERS)) > 0 then
	
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


-- Called when player tries to pickup a weapon.
function GM:PlayerCanPickupWeapon(pl, ent)

 	if pl:Team() != TEAM_HUNTERS then
	
		return false
		
	end
	
	return true
	
end


-- Sets the player model
function GM:PlayerSetModel(pl)

	local player_model = "models/Gibs/Antlion_gib_small_3.mdl"
	
	if pl:Team() == TEAM_HUNTERS then
	
		player_model = "models/player/combine_super_soldier.mdl"
		
	end
	
	util.PrecacheModel(player_model)
	pl:SetModel(player_model)
	
end


-- Called when a player tries to use an object.
function GM:PlayerUse(pl, ent)

	-- Prevent dead or spectating players from being able to use stuff.
	if !pl:Alive() || pl:Team() == TEAM_SPECTATOR then
	
		return false
		
	end
	
	-- If player is a Prop, set their prop entity to whatever they are looking at.
	if pl:Team() == TEAM_PROPS && pl:IsOnGround() && !pl:Crouching() && table.HasValue(USABLE_PROP_ENTITIES, ent:GetClass()) && ent:GetModel() then
	
		-- Make sure the prop hasn't been banned by the server.
		if table.HasValue(BANNED_PROP_MODELS, ent:GetModel()) then
		
			pl:ChatPrint("That prop has been banned by the server.")
			
			return false
			
		end

		-- Check for valid entity.
		if ent:GetPhysicsObject():IsValid() && pl.ph_prop:GetModel() != ent:GetModel() then
		
			-- Calculate tne entity's max health based on size. Then calculate the players's new health based on existing health percentage.
			local ent_health = math.Clamp(ent:GetPhysicsObject():GetVolume() / 250, 1, 200)
			local new_health = math.Clamp((pl.ph_prop.health / pl.ph_prop.max_health) * ent_health, 1, 200)
			
			-- Set prop entity health and max health.
			pl.ph_prop.health 		= new_health
			pl.ph_prop.max_health 	= ent_health
			
			-- Setup new model/texture/new collision bounds.
			pl.ph_prop:SetModel(ent:GetModel())
			pl.ph_prop:SetSkin(ent:GetSkin())
			pl.ph_prop:SetSolid(SOLID_BSP)
			
			-- Calculate new player hull based on prop size.
			local hull_xy_max 	= math.Round(math.Max(ent:OBBMaxs().x, ent:OBBMaxs().y))
			local hull_xy_min 	= hull_xy_max * -1
			local hull_z 		= math.Round(ent:OBBMaxs().z)
			
			-- Set player hull server side.
			pl:SetHull(Vector(hull_xy_min, hull_xy_min, 0), Vector(hull_xy_max, hull_xy_max, hull_z))
			pl:SetHullDuck(Vector(hull_xy_min, hull_xy_min, 0), Vector(hull_xy_max, hull_xy_max, hull_z))
			pl:SetHealth(new_health)
			
			-- Set the player hull client side so movement predictions work correctly.
			umsg.Start("SetHull", pl)
				umsg.Long(hull_xy_max)
				umsg.Long(hull_z)
				umsg.Short(new_health)
			umsg.End()
			
		end
		
	end
	
	-- Prevent the door exploit (players spamming use key).
	if table.HasValue(EXPLOITABLE_DOORS, ent:GetClass()) && pl.last_door_time && pl.last_door_time + 1 > CurTime() then
	
		return false
		
	end
	
	pl.last_door_time = CurTime()
	
	return true
	
end


-- This is called when the round time ends (props win).
function GM:RoundTimerEnd()

	if !GAMEMODE:InRound() then
	
		return
		
	end
	
	-- If the timer reached zero, then we know the Props team won beacause they didn't all die.
	GAMEMODE:RoundEndWithResult(TEAM_PROPS, "Props win!")
	
end


-- Called when player presses [F3]. Plays a taunt for their team.
function GM:ShowSpare1(pl)

	if GAMEMODE:InRound() && pl:Alive() && (pl:Team() == TEAM_HUNTERS || pl:Team() == TEAM_PROPS) && pl.last_taunt_time + TAUNT_DELAY <= CurTime() && #PROP_TAUNTS > 1 && #HUNTER_TAUNTS > 1 then
	
		-- Select random taunt until it doesn't equal the last taunt.
		repeat
		
			if pl:Team() == TEAM_HUNTERS then
			
				rand_taunt = table.Random(HUNTER_TAUNTS)
				
			else
			
				rand_taunt = table.Random(PROP_TAUNTS)
				
			end
			
		until rand_taunt != pl.last_taunt
		
		pl.last_taunt_time 	= CurTime()
		pl.last_taunt 		= rand_taunt
		
		pl:EmitSound(rand_taunt, 100)
		
	end	
	
end


-- Called when the gamemode is initialized.
function Initialize()

	game.ConsoleCommand("mp_flashlight 0\n")
	
end
hook.Add("Initialize", "PropHunt_Initialize", Initialize)


-- Called when a player leaves.
function PlayerDisconnected(pl)

	pl:RemoveProp()
	
end
hook.Add("PlayerDisconnected", "PropHunt_PlayerDisconnected", PlayerDisconnected)


-- Called when the players spawns.
function PlayerSpawn(pl)

	pl:Blind(false)
	pl:RemoveProp()
	pl:SetColor(255, 255, 255, 255)
	pl:UnLock()
	pl:ResetHull()
	pl.last_taunt_time = 0
	
	umsg.Start("ResetHull", pl)
	umsg.End()
	
end
hook.Add("PlayerSpawn", "PropHunt_PlayerSpawn", PlayerSpawn)


-- Removes all weapons on a map.
function RemoveWeaponsAndItems()

	for _, wep in pairs(ents.FindByClass("weapon_*")) do
	
		wep:Remove()
		
	end
	
	for _, item in pairs(ents.FindByClass("item_*")) do
	
		item:Remove()
		
	end
	
end
hook.Add("InitPostEntity", "PropHunt_RemoveWeaponsAndItems", RemoveWeaponsAndItems)


-- Called when round ends.
function RoundEnd()

	for _, pl in pairs(team.GetPlayers(TEAM_HUNTERS)) do
	
		pl:Blind(false)
		pl:UnLock()
		
	end
	
end
hook.Add("RoundEnd", "PropHunt_RoundEnd", RoundEnd)


-- Called every server tick.
function Think()

	-- Calculate the location of every Prop's prop entity.
	for _, pl in pairs(team.GetPlayers(TEAM_PROPS)) do
	
		-- Check for a valid player/prop, and if they aren't freezing their prop.
		if pl && pl:IsValid() && pl:Alive() && pl.ph_prop && pl.ph_prop:IsValid() && !(pl:KeyDown(IN_ATTACK2) && pl:GetVelocity():Length() == 0) then
				
			pl.ph_prop:SetPos(pl:GetPos() - Vector(0, 0, pl.ph_prop:OBBMins().z))
			pl.ph_prop:SetAngles(pl:GetAngles())
		
		end
	
	end
		
end
hook.Add("Think", "PropHunt_Think", Think)