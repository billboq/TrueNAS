#!/bin/sh

update_jail() {
    local jail_name="$1"
    echo "##" > /dev/tty
    echo "## Updating $jail_name jail..." > /dev/tty
    echo "##" > /dev/tty

    # ZFS destroy snapshot if exists, stop the jail, snapshot, and start the jail
    zfs destroy -r PoolRaid5/iocage/jails/$jail_name@backupjailupdate
    iocage stop $jail_name
    iocage snapshot $jail_name -n backupjailupdate
    iocage start $jail_name

    sleep 5

    # Update and upgrade packages inside the jail
    /usr/local/bin/iocage exec "$jail_name" "env IGNORE_OSVERSION=yes pkg update && pkg upgrade -y" --force

    # Restart the jail
    /usr/local/bin/iocage restart "$jail_name"
}

# Jails list to update
jails=(
    "adguard"
    "filebrowser"
    #"lidarr"
    "plex"
    "prowlarr"
    "radarr"
    #"readarr"
    "sonarr"
    "syncthing"
    "tailscaled"
)

# Update jails
for jail in "${jails[@]}"; do
    update_jail "$jail"
done

# Specific operation for Plex after jail update
/usr/local/bin/iocage exec "plex" "/root/PMS_Updater.sh"
/usr/local/bin/iocage restart "plex"

# Send email when updates are done
echo "Subject: Jails have been updated." | sendmail -v example@mail.com
