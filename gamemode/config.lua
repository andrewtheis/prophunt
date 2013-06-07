--
-- Updated by Andrew Theis on 2013-03-09.
-- Copyright (c) 2010-2013 Andrew Theis. All rights reserved.
-- 
-- Gamemode configuration file.
--


-- Props will not be able to become these models.
BANNED_PROP_MODELS = {
	"models/props/cs_assault/dollar.mdl",
	"models/props/cs_assault/money.mdl",
	"models/props/cs_office/snowman_arm.mdl"
}


-- Maximum time (in minutes) for this fretta gamemode (Default: 30).
GAME_TIME = 30


-- Number of seconds hunters are blinded/locked at the beginning of the map (Default: 30).
HUNTER_BLINDLOCK_TIME = 30


-- Health points removed from hunters when they shoot  (Default: 5).
HUNTER_FIRE_PENALTY = 5


-- How much health to give back to the Hunter after killing a prop (Default: 20).
HUNTER_KILL_BONUS = 20


-- If you loose one of these will be played. Set blank to disable.
LOSS_SOUNDS = {
	"vo/announcer_failure.wav",
	"vo/announcer_you_failed.wav"
}


-- Sound files hunters can taunt with. You need at least 2 files listed here.
HUNTER_TAUNTS = {
	"taunts/you_dont_know_the_power.wav",
	"taunts/you_underestimate_the_power.wav"
}


-- Sound files props can taunt with. You need at least 2 files listed here.
PROP_TAUNTS = {
	"taunts/boom_headshot.wav",
	"taunts/doh.wav",
	"taunts/go_away_or_i_shall.wav",
	"taunts/ill_be_back.wav",
	"taunts/negative.wav",
	"taunts/oh_yea_he_will_pay.wav",
	"taunts/ok_i_will_tell_you.wav",
	"taunts/please_come_again.wav",
	"taunts/threat_neutralized.wav",
	"taunts/what_is_wrong_with_you.wav",
	"taunts/woohoo.wav"
}


-- Seconds a player has to wait before they can taunt again (Default: 5).
TAUNT_DELAY = 5


-- Rounds played on a map (Default: 10).
ROUNDS_PER_MAP = 10


-- Time (in seconds) for each round (Default: 300).
ROUND_TIME = 300


-- Determains if players should be team swapped every round [0 = No, 1 = Yes] (Default: 1).
SWAP_TEAMS_EVERY_ROUND = 1


-- If you win, one of these will be played. Set blank to disable.
VICTORY_SOUNDS = {
	"vo/announcer_success.wav",
	"vo/announcer_victory.wav",
	"vo/announcer_we_succeeded.wav"
}