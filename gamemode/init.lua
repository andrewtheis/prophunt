--
-- init.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
--

 
-- Send the required lua files to the client.
AddCSLuaFile("vgui/vgui_hudbase.lua")
AddCSLuaFile("vgui/vgui_hudcommon.lua")
AddCSLuaFile("vgui/vgui_hudelement.lua")
AddCSLuaFile("vgui/vgui_hudlayout.lua")
AddCSLuaFile("vgui/vgui_scoreboard.lua")
AddCSLuaFile("vgui/vgui_scoreboard_team.lua")
AddCSLuaFile("vgui/vgui_scoreboard_small.lua")
AddCSLuaFile("cl_skin.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_splashscreen.lua")
AddCSLuaFile("config.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("player.lua")


-- If there is a mapfile send it to the client (sometimes servers want to change settings for certain maps).
if file.Exists("../gamemodes/prop_hunt/gamemode/maps/"..game.GetMap()..".lua", "LUA") then

	AddCSLuaFile("maps/"..game.GetMap()..".lua")
	
end


-- Include the required lua files.
include("utility.lua")
include("round_controller.lua")
include("shared.lua")
include("spectator.lua")


-- Make base class available
DEFINE_BASECLASS("gamemode_base")


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


-- Called when an entity takes damage.
function GM:EntityTakeDamage(ent, info)

	if GAMEMODE:InRound() && ent && ent:GetClass() != "ph_prop" && !ent:IsPlayer() && attacker && attacker:IsPlayer() && attacker:Team() == TEAM_HUNTERS && attacker:Alive() then
	
		attacker:SetHealth(attacker:Health() - HUNTER_FIRE_PENALTY)
		
		if attacker:Health() <= 0 then
		
			MsgAll(attacker:Name() .. " felt guilty for hurting so many innocent props and committed suicide\n")
			attacker:Kill()
			
		end
		
	end
	
end


-- Called when gamemode loads and starts.
function GM:Initialize()
	
	timer.Simple( 3, function() GAMEMODE:StartRoundBasedGame() end )
	game.ConsoleCommand("mp_flashlight 0\n")
	
end


-- Called after all entities have been spawned.
function GM:InitPostEntity()
	
	for _, wep in pairs(ents.FindByClass("weapon_*")) do
	
		wep:Remove()
		
	end
	
	for _, item in pairs(ents.FindByClass("item_*")) do
	
		item:Remove()
		
	end
	
end


-- Called when player tries to pickup a weapon.
function GM:PlayerCanPickupWeapon(pl, ent)

 	if pl:Team() != TEAM_HUNTERS then
	
		return false
		
	end
	
	return true
	
end


-- Called when a player disconnects.
function GM:PlayerDisconnected(pl)
	
	pl:RemoveProp()
	self.BaseClass:PlayerDisconnected(pl)
	
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



-- Called when a player spawns.
function PlayerSpawn(pl)
	
	-- Set the player class based on team
	if pl:Team() == TEAM_HUNTERS then
		player_manager.SetPlayerClass( pl, "player_hunter" )
	elseif pl:Team() == TEAM_PROPS then
		player_manager.SetPlayerClass( pl, "player_prop" )
	end
	
	pl:Blind(false)
	pl:RemoveProp()
	pl:SetColor(255, 255, 255, 255)
	pl:UnLock()
	pl:ResetHull()
	pl.last_taunt_time = 0
	
	umsg.Start("ResetHull", pl)
	umsg.End()
	
end
hook.Add("PlayerSpawn", "PH_PlayerSpawn", PlayerSpawn)


-- Called when a player tries to use an object.
function GM:PlayerUse(pl, ent)

	-- Prevent dead or spectating players from being able to use stuff.
	if !pl:Alive() || pl:Team() == TEAM_SPECTATOR then
	
		return false
		
	end

	--	Props should never be able to pickup or use stuff
	if pl:Team() == TEAM_PROPS then
	
		-- If player is a Prop, set their prop entity to whatever they are looking at.
		if pl:IsOnGround() && !pl:Crouching() && table.HasValue(USABLE_PROP_ENTITIES, ent:GetClass()) && ent:GetModel() then
	
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
		
		return false;
		
	end
	
	-- Prevent the door exploit (players spamming use key).
	if table.HasValue(EXPLOITABLE_DOORS, ent:GetClass()) && pl.last_door_time && pl.last_door_time + 1 > CurTime() then
	
		return false
		
	end
	
	pl.last_door_time = CurTime()
	
	return true
	
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


-- Called every server tick.
function GM:Think()

	-- Calculate the location of every Prop's prop entity.
	for _, pl in pairs(team.GetPlayers(TEAM_PROPS)) do
	
		-- Check for a valid player/prop, and if they aren't freezing their prop.
		if pl && pl:IsValid() && pl:Alive() && pl.ph_prop && pl.ph_prop:IsValid() && !(pl:KeyDown(IN_ATTACK2) && pl:GetVelocity():Length() == 0) then
				
			pl.ph_prop:SetPos(pl:GetPos() - Vector(0, 0, pl.ph_prop:OBBMins().z))
			pl.ph_prop:SetAngles(pl:GetAngles())
		
		end
	
	end
		
end


local function SeenSplash( ply )

	if ( ply.m_bSeenSplashScreen ) then return end
	ply.m_bSeenSplashScreen = true
	
	if ( !GAMEMODE.TeamBased && !GAMEMODE.NoAutomaticSpawning ) then
		ply:KillSilent()
	end
	
end

concommand.Add( "seensplash", SeenSplash )