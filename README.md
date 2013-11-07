# Installation

First, download the latest version by clicking the [download zip](https://github.com/andrewtheis/prophunt/archive/master.zip) button to the right. After downloading, extract the contents of the zip to the below directory. Restart Garry's Mod and you're all set!

`<Steam Directory>/SteamApps/common/GarrysMod/garrysmod/gamemodes/prophunt`

If you wish to install the latest and greatest version, head over to the develop branch. You can download the zip or clone the repository using Git. This will allow you to test the latest and greatest code, and - if you fork to your own space on GitHub - contribute back to the project.


# Creating a Server

After you have installed, launch Garry's Mod and select the Prop Hunt gamemode from the dropdown in the bottom right. From there, create a server as you normally would.


# Running a Dedicated Server

*To be written.*


# Console Variables

The variables below allow you to configure various aspects of the gamemode. You can use these commands in Console when running an ad-hoc server, or set them in your dedicated server's config file.

- `ph_hunter_blindlock_time`	The number of seconds that hunters should be blinded/locked at the beginning of a round (Default: 30).
- `ph_hunter_fire_penalty`		Health points removed from hunters when they shoot (Default: 5).
- `ph_hunter_kill_bonus`		How much health to give back to the Hunter after killing a prop (Default: 20).
- `ph_prop_taunt_delay`			Seconds a player has to wait before they can taunt again (Default: 5).
- `ph_rounds_per_map`			Rounds played on a map (Default: 10).
- `ph_round_length`				Time (in seconds) for each round (Default: 300).
- `ph_swap_teams_every_round`	Determains if players should be team swapped every round (0 = No, 1 = Yes; Default: 1).

# Credits

- Originally developed for Counter-Strike: Source by *Unknown*
	- Know who? Let us know on [this reported issue](https://github.com/andrewtheis/prophunt/issues/2)
- Cloned to Garry's Mod by Andrew Theis ([A-MT](http://steamcommunity.com/id/amt))
- Special thanks to [Leleudk](http://steamcommunity.com/id/leleudk) and [Kow@lski](http://steamcommunity.com/id/kowalski7cc) for maintaining a GMod 13 compatible version in my absence.