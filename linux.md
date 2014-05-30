# Install SteamCMD and Gmod

Replace the "USER" with your username. Feel Free to change any of the directory names or locations if you wish.
```
sudo mkdir /srv/steamcmd
sudo chown USER /srv/steamcmd
cd /srv/steamcmd
wget http://media.steampowered.com/installer/steamcmd_linux.tar.gz
tar xf steamcmd_linux.tar.gz
mkdir -p /srv/steamcmd/server/gmod
```

Install Gmod
```
./steamcmd.sh
login anonymous
force_install_dir /srv/steamcmd/server/gmod
app_update 4020
quit
```
Or with one command. You can also save this as a script for easy updating.
```
./steamcmd.sh +login anonymous +force_install_dir /srv/steamcmd/server/gmod +app_update 4020 +quit
```

# Install Prophunt

You can change whatever option you want on the server command or add more.
```
cd /srv/steamcmd/server/gmod/garrysmod/gamemodes
wget https://github.com/andrewtheis/prophunt/archive/master.zip
unzip prophunt-master.zip
mv prophunt-master prophunt
cd /srv/steamcmd/server/gmod
./srcds_run -game garrysmod +maxplayers 8 +map cs_assault +gamemode prophunt -autoupdate
```
You can edit the gamemode settings in `/srv/steamcmd/server/gmod/garrysmod/gamemodes/prophunt/gamemode/config.lua`.

# Startup Script

First start your script in a text editor.
```
cd /srv/steamcmd/server/gmod
nano prophunt.sh
```

Copy the following text into your text editor and save it. To save in nano use "Control + X" and follow the prompts.
Feel free to change any of these options to your preference.
```
#!/bin/sh
cd /srv/steamcmd/server/gmod
screen -dms prophunt ./srcds_run -game garrysmod +gamemode prophunt +maxplayers 8 +map cs_assault -autoupdate
```

Now make the script executable and then run it.
```
chmod +x prophunt.sh
./prophunt.sh
```
Use "Control + D" to detach from the screen and `screen -r prophunt` to re-attach.

# Other Stuff
- Dont forget to forward the steam ports on your router to your server pc.
- You will only have the default garrysmod maps at first, which dont have any props, so you will have to get new ones.
- You can download your own maps from various sources and place them in the `/srv/steamcmd/server/gmod/garrysmod/maps` directory.
- Dont forget about the global Garrysmod server setting in `/srv/steamcmd/server/gmod/garrysmod/cfg/server.cfg`. Here is an example of a simple one.

```
hostname          "My PropHunt Server"
rcon_password     "password"
sv_password       "password"
sv_region         1
sv_lan            0
```
