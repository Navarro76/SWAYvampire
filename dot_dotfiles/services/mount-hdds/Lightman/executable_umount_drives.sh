#!/bin/sh

umount /mnt/disk1
umount /mnt/disk2
echo "Discos desmontados."

df -h | grep mnt
