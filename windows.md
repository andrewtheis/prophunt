# Install SteamCMD and Gmod

- Create a folder for SteamCMD. Such as "C:\steamcmd".
- [Download](http://media.steampowered.com/installer/steamcmd.zip) SteamCMD and extract to the folder you just created.
- Make a Garrysmod folder within the steamcmd folder. You can just call it gmod.
- Open a command prompt and enter the following commands.
```
cd C:\steamcmd
steamcmd.exe
login anonymous
force_install_dir C:\steamcmd\gmod
app_update 4020
quit
```

Or with one command. You can also save this as a script for easy updating.
```
cd C:\steamcmd
steamcmd.exe +login anonymous +force_install_dir C:\steamcmd\gmod +app_update 4020 +quit
```

#Install PropHunt
- [Download](https://github.com/andrewtheis/prophunt/archive/master.zip) PropHunt and extract to the "C:\steamcmd\gmod\garrysmod\gamemodes" folder.
- Rename it from prophunt-master to just prophunt
- To start the server open a command prompt and type `srcds.exe -game garrysmod +gamemode prophunt -autoupdate`
- Now change whatever settings you want and hit "Start Server" button.
- You can edit the gamemode settings in `\srv\steam\gmod\garrysmod\gamemodes\prophunt\gamemode\config.lua`.

# Startup Script
- Create a text file in your "C:\steamcmd\gmod"
- Copy the following command into the text file
`srcds.exe -game garrysmod +gamemode prophunt -autoupdate`
- Rename the file prophunt.bat and just double click it.

# Other Stuff
- Dont forget to forward the steam ports on your router to your server pc.
- You will only have the default garrysmod maps at first, which dont have any props, so you will have to get new ones.
- You can download your own maps from various sources and place them in the `C:\steamcmd\gmod\garrysmod\maps` folder.
- Dont forget about the global Garrysmod server setting in `C:\steamcmd\gmod\garrysmod\cfg\server.cfg`. Here is an example of a simple one.

```
hostname          "My PropHunt Server"
rcon_password     "password"
sv_password       "password"
sv_region         1
sv_lan            0
```
