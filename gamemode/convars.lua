--
-- convars.lua
-- Prop Hunt
--	
-- Created by Andrew Theis on 2013-11-07.
-- Copyright (c) 2013 Andrew Theis. All rights reserved.
--


-- See README.md for more information. You should not edit these convars in this file, instead use a server config file to set them.
CreateConVar("ph_hunter_blindlock_time", "30", { FCVAR_NOTIFY, FCVAR_REPLICATED })
CreateConVar("ph_hunter_fire_penalty", "5", { FCVAR_NOTIFY })
CreateConVar("ph_hunter_kill_bonus", "20", { FCVAR_NOTIFY, FCVAR_REPLICATED })
CreateConVar("ph_taunt_delay", "5", { FCVAR_NOTIFY })
CreateConVar("ph_rounds_per_map", "10", { FCVAR_NOTIFY, FCVAR_REPLICATED })
CreateConVar("ph_round_length", "300", { FCVAR_NOTIFY, FCVAR_REPLICATED })
CreateConVar("ph_swap_teams_every_round", "1", { FCVAR_NOTIFY })