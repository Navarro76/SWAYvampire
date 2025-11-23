# MONTAJE DE UNIDADES EN FSTAB

## IDENTIFICAR UNIDADES 

Primero identificamos las unidades de nuestro interes:

```bash
$ lsblk
NAME        MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda           8:0    0 931.5G  0 disk 
├─sda1        8:1    0   549M  0 part 
├─sda2        8:2    0 159.4G  0 part 
├─sda3        8:3    0     1K  0 part 
├─sda4        8:4    0 713.8G  0 part 
├─sda5        8:5    0   1.9G  0 part /tmp
├─sda6        8:6    0  18.6G  0 part /var
└─sda7        8:7    0  37.3G  0 part /home
sdb           8:16   0   1.8T  0 disk 
└─sdb1        8:17   0   1.8T  0 part 
sdc           8:32   0   3.6T  0 disk 
├─sdc1        8:33   0    16M  0 part 
└─sdc2        8:34   0   3.6T  0 part 
sdd           8:48   0 931.5G  0 disk 
├─sdd1        8:49   0    10G  0 part 
└─sdd2        8:50   0 851.5G  0 part 
sde           8:64   1  57.7G  0 disk 
└─sde1        8:65   1  57.7G  0 part /media/usb
nvme0n1     259:0    0 238.5G  0 disk 
├─nvme0n1p1 259:1    0   1.9G  0 part /boot
├─nvme0n1p2 259:2    0   238M  0 part /boot/efi
└─nvme0n1p3 259:3    0  93.1G  0 part /
```

En nuestro caso nos interesan las unidades:

- `sda4` que corresponde con la partición `Nueva` la cual es de `713.8G`
- `sdb1` que corresponde con la partición `Datos` la cual es de `1.8T`
- `sdc2` que corresponde con la partición `Navarro` la cual es de `3.6T`
- `sdd2` que corresponde con la partición `Archivos` la cual es de `1T`

El siguiente paso es conocer el id de esas unidades: 

```bash
# sda4 Nueva [xfs]
$ ls -la /dev/disk/by-id/ | grep sda4
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4 ⇒ ../../sda4
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 wwn-0x50014ee26242694a-part4 ⇒ ../../sda4

# sdb1 Datos [ntfs]
$ ls -la /dev/disk/by-id/ | grep sdb1
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1 ⇒ ../../sdb1
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 wwn-0x50014ee2662cded8-part1 ⇒ ../../sdb1

# sdc2 Navarro [ntfs]
$ ls -la /dev/disk/by-id/ | grep sdc2
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 ata-ST4000DM004-2CV104_ZTT0R6BZ-part2 ⇒ ../../sdc2
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 wwn-0x5000c500c8a5ec46-part2 ⇒ ../../sdc2

# sdd2 Archivos [ntfs]
$ ls -la /dev/disk/by-id/ | grep sdd2
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2 ⇒ ../../sdd2
lrwxrwxrwx root root  10 B Wed Nov 12 08:04:14 2025 wwn-0x50014ee65cb68d48-part2 ⇒ ../../sdd2
```

## PUNTOS DE MONTAJE 

Es tradicional usar `/mnt` para discos internos y `/media` para unidades extraíbles como memorias USB, ya que estas últimas suelen montarse automáticamente en `/media/USUARIO/ETIQUETA`.

```bash
# Creamos los directorios en /mnt
$ sudo mkdir /mnt/Navarro
$ sudo mkdir /mnt/Datos
$ sudo mkdir /mnt/Archivos
$ sudo mkdir /mnt/Nueva

# Más sencillo
$ sudo mkdir -p /mnt/Archivos /mnt/Datos /mnt/Navarro /mnt/Nueva

# Cambiar propietario de los directorios de montaje
$ sudo chown alex:alex /mnt/Archivos /mnt/Datos /mnt/Navarro /mnt/Nueva


# Verificamos que se hayan creado correctamente
$ ls -la /mnt
ls -la /mnt
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:13:58 2025  .
drwxr-xr-x root root 4.0 KB Mon Nov 10 09:50:29 2025  ..
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:13:58 2025  Archivos
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:13:46 2025  Datos
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:13:35 2025  Navarro
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:41:02 2025  Nueva
```

## ENTRADAS FSTAB

Ahora pasamos a montarla en el FSTAB.

```bash
$ sudo nano /etc/fstab

  GNU nano 8.4                                                             /etc/fstab                                                                       
# /etc/fstab: static file system information.
#
# Use 'blkid' to print the universally unique identifier for a
# device; this may be used with UUID= as a more robust way to name devices
# that works even if disks are added and removed. See fstab(5).
#
# systemd generates mount units based on this file, see systemd.mount(5).
# Please run 'systemctl daemon-reload' after making changes here.
#
# <file system> <mount point>   <type>  <options>       <dump>  <pass>
# / was on /dev/nvme0n1p3 during installation
UUID=379b42d5-c390-4571-ba71-b41e07dd635e /               ext4    errors=remount-ro 0       1
# /boot was on /dev/nvme0n1p1 during installation
UUID=347064d6-1bfe-44b9-89a7-3e8bef99806d /boot           ext4    defaults        0       2
# /boot/efi was on /dev/nvme0n1p2 during installation
UUID=A4F5-0BE7  /boot/efi       vfat    umask=0077      0       1
# /home was on /dev/sda7 during installation
UUID=4061ad62-fec9-4ddd-93f1-d5269be6d0d6 /home           ext4    defaults        0       2
# /tmp was on /dev/sda5 during installation
UUID=4722d805-2367-4ae1-85e4-32a1f494f1b9 /tmp            ext4    defaults        0       2
# /var was on /dev/sda6 during installation
UUID=b1d31482-60c6-436e-b8c3-eabb3ebfff53 /var            ext4    defaults        0       2

# Data Drivers
/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2 /mnt/Archivos ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1 /mnt/Datos    ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2          /mnt/Navarro  ntfs-3g defaults,uid=1000,gid=1000,umask=0002,permissions 0 0
/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4 /mnt/Nueva    xfs     defaults 0 0
```

Opciones explicadas:

1. `uid=1000` - Establece el usuario propietario (alex)
2. `gid=1000` - Establece el grupo propietario (alex)
3. Permisos:
    - umask=0000 - Para escribir sin restricciones (777)
    - `umask=0002` - Para usuario y grupo completo, otros solo lectura (775) 
    - umask=0022 - Permisos 755 (rwxr-xr-x)
4. `permissions` - Opción específica para NTFS que habilita permisos Linux

**umask=0022 (actual):**

- Permisos: 755 (rwxr-xr-x)
- Tú (alex): Lectura, escritura, ejecución
- Grupo (alex): Solo lectura y ejecución
- Otros: Solo lectura y ejecución

**umask=0002 (recomendado):**

- Permisos: 775 (rwxrwxr-x)
- Tú (alex): Lectura, escritura, ejecución
- Grupo (alex): Lectura, escritura, ejecución
- Otros: Solo lectura y ejecución

**Nota:** Para NTFS necesitas el paquete `ntfs-3g`. Si no lo tienes:

```bash
# En Debian/Ubuntu
$ sudo apt install ntfs-3g
```

**Checar:**

```bash
tmpfs /tmp     tmpfs noexec,rw,auto,nouser,sync,noatime,nodev,nosuid,mode=1777 0 0
tmpfs /var/tmp tmpfs noexec,rw,auto,nouser,sync,noatime,nodev,nosuid,mode=1777 0 0
```

## RECARGAR FSTAB

```bash
# Probar montaje
sudo umount /mnt/Archivos /mnt/Datos /mnt/Navarro /mnt/Nueva 2>/dev/null
sudo mount -a

# Si aparece el mensaje debemos ejecutar el comando propuesto
mount: (consejo) fstab ha sido modificado, pero systemd sigue utilizando
       la versión antigua; utilice 'systemctl daemon-reload' para recargar.
alex@debian:~$ sudo systemctl daemon-reload
alex@debian:~$ sudo mount -a
```

## PERMISOS XFS

Para configurar los permisos de una partición XFS en Linux, no se modifican directamente en las opciones de montaje de fstab, sino después del montaje, utilizando los comandos `chown` y `chmod` sobre el punto de montaje.

A diferencia de los sistemas de archivos de Windows (como NTFS) donde se pueden usar opciones como uid o gid en fstab para establecer la propiedad de todos>

```bash
# Para XFS, cambiar propietario manualmente
$ sudo chown alex:alex /mnt/Nueva
$ sudo chmod -R 775 /mnt/Nueva
```

**Nota importante:** Para XFS, los permisos se manejan diferente. El chown en el punto de montaje asegura que los nuevos archivos que crees tengan a alex c>

## REVISAR UNIDADES

```bash
$ ls -la /mnt/
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:41:02 2025  .
drwxr-xr-x root root 4.0 KB Mon Nov 10 09:50:29 2025  ..
drwxrwxr-x alex alex  16 KB Tue Nov 11 21:05:36 2025  Archivos
drwxrwxr-x alex alex 8.0 KB Sun Nov  2 12:05:03 2025  Datos
drwxrwxr-x alex alex 8.0 KB Sat Nov  8 09:36:54 2025  Navarro
drwxrwxr-x alex alex   6 B  Mon Nov 10 21:04:05 2025  Nueva
```

Luego verifique los puntos de montaje con `df -h`. 

```bash
alex@debian:~$ df -Th
S.ficheros     Tipo     Tamaño Usados  Disp Uso% Montado en
udev           devtmpfs   7.8G      0  7.8G   0% /dev
tmpfs          tmpfs      1.6G   1.3M  1.6G   1% /run
/dev/nvme0n1p3 ext4        92G   4.8G   86G   6% /
tmpfs          tmpfs      7.8G   644K  7.8G   1% /dev/shm
efivarfs       efivarfs   128K    17K  107K  14% /sys/firmware/efi/efivars
tmpfs          tmpfs      5.0M      0  5.0M   0% /run/lock
tmpfs          tmpfs      1.0M      0  1.0M   0% /run/credentials/systemd-journald.service
/dev/nvme0n1p1 ext4       1.8G   110M  1.6G   7% /boot
/dev/sda5      ext4       1.8G   357M  1.5G  20% /tmp
/dev/sda6      ext4        19G  1004M   17G   6% /var
/dev/sda7      ext4        37G   2.2G   33G   7% /home
/dev/nvme0n1p2 vfat       235M   8.8M  226M   4% /boot/efi
tmpfs          tmpfs      1.6G    24K  1.6G   1% /run/user/1000
tmpfs          tmpfs      1.0M      0  1.0M   0% /run/credentials/getty@tty1.service
/dev/sde1      fuseblk     58G    42G   17G  72% /media/usb
/dev/sdd2      fuseblk    852G   438G  414G  52% /mnt/Archivos
/dev/sdb1      fuseblk    1.9T   1.5T  372G  81% /mnt/Datos
/dev/sdc2      fuseblk    3.7T   3.3T  446G  89% /mnt/Navarro
/dev/sda4      xfs        714G    14G  700G   2% /mnt/Nueva
```

## REINICIAMOS

```bash
alex@debian:~$ sudo reboot
```
