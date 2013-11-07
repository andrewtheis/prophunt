--
-- shared.lua
-- Prop Hunt
--
-- Created by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
--


-- Include the required lua files.
include("player.lua")


-- Include the configuration for this map.
if file.Exists("../gamemodes/prop_hunt/gamemode/maps/"..game.GetMap()..".lua", "LUA") || file.Exists("../lua_temp/prop_hunt/gamemode/maps/"..game.GetMap()..".lua", "LUA") then

	include("maps/"..game.GetMap()..".lua")
	
end


-- Player classes
include("player_class/player_hunter.lua")
include("player_class/player_prop.lua")


-- Information about the gamemode.
GM.Name		= "Prop Hunt"
GM.Author	= "Andrew Theis"
GM.Email	= "theis.andrew@gmail.com"
GM.Website	= "http://www.github.com/andrewtheis/prop-hunt"


-- Help info.
GM.Help = [[Prop Hunt is a twist on the classic backyard game Hide and Seek.

As a Prop you have ]]..GetConVarNumber("ph_hunter_blindlock_time")..[[ seconds to replicate an existing prop on the map and then find a good hiding spot. Press [E] to replicate the prop you are looking at. Your health is scaled based on the size of the prop you replicate.

As a Hunter you will be blindfolded for the first ]]..GetConVarNumber("ph_hunter_blindlock_time")..[[ seconds of the round while the Props hide. When your blindfold is taken off, you will need to find props controlled by players and kill them. Damaging non-player props will lower your health significantly. However, killing a Prop will increase your health by ]]..GetConVarNumber("ph_hunter_kill_bonus")..[[ points.

Both teams can press [F3] to play a taunt sound.]]


-- Gamemode configuration.
GM.AutomaticTeamBalance		= true
GM.AddFragsToTeamScore		= true
GM.CanOnlySpectateOwnTeam 	= true
GM.Data 					= {}
GM.EnableFreezeCam			= true
GM.NoAutomaticSpawning		= true
GM.NoNonPlayerPlayerDamage	= true
GM.NoPlayerPlayerDamage 	= true
GM.RoundBased				= true
GM.RoundLimit				= GetConVarNumber("ph_rounds_per_map")
GM.RoundLength 				= GetConVarNumber("ph_round_length")
GM.RoundPreStartTime		= 0
GM.SelectModel				= false
GM.SuicideString			= "couldn't take the pressure and committed suicide."
GM.TeamBased 				= true
GM.HudSkin 					= "PropHuntSkin" -- The Derma skin to use for the HUD components
GM.RoundPostLength 			= 8	-- Seconds to show the 'x team won!' screen at the end of a round


-- Called on gamemdoe initialization to create teams.
function GM:CreateTeams()
	
	TEAM_HUNTERS = 1
	team.SetUp(TEAM_HUNTERS, "Hunters", Color(150, 205, 255, 255))
	team.SetSpawnPoint(TEAM_HUNTERS, {"info_player_counterterrorist", "info_player_combine", "info_player_deathmatch", "info_player_axis"})
	team.SetClass(TEAM_HUNTERS, {"Hunter"})

	TEAM_PROPS = 2
	team.SetUp(TEAM_PROPS, "Props", Color(255, 60, 60, 255))
	team.SetSpawnPoint(TEAM_PROPS, {"info_player_terrorist", "info_player_rebel", "info_player_deathmatch", "info_player_allies"})
	team.SetClass(TEAM_PROPS, {"Prop"})
	
end


function util.ToMinutesSeconds(seconds)
	local minutes = math.floor(seconds / 60)
	seconds = seconds - minutes * 60

    return string.format("%02d:%02d", minutes, math.floor(seconds))
end