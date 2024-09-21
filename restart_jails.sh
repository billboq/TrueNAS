#!/bin/sh

restart_jail() {
    local jail_name="$1"
	
	iocage stop $jail_name
	iocage start $jail_name
}

# Jails list
jails=(
    "adguard"
    "filebrowser"
    "lidarr"
    "plex"
    "prowlarr"
    "radarr"
    "readarr"
    "sonarr"
    "syncthing"
    "tailscaled"
)

# Reboot each jail from list
for jail in "${jails[@]}"; do
    restart_jail "$jail"
done
