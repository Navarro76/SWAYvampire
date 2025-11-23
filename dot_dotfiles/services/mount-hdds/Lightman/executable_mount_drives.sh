#!/bin/sh

sleep 1m
mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1
mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2
echo "Discos montados."

df -h | grep mnt
