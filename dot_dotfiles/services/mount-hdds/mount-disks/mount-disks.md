
# MONTAJE DE HDDS USANDO SERVICIO SYSTEMD

## DESCRIPCIÓN

Uso de script y servicio systemd para gestionar el montaje de las unidades en un servidor/PC.

## JUSTIFICACIÓN

Los problemas con `/etc/fstab` se deben comúnmente a errores de sintaxis, UUID incorrectos, dispositivos no conectados o opciones de montaje obsoletas. **Los fallos pueden causar que el sistema no arranque o que no monte dispositivos como se espera**. 

**Problemas comunes:**

- **Errores de sintaxis:** Cualquier error de formato, como espacios incorrectos o tabulaciones mal puestas, impedirá que el sistema lea el archivo.
- **UUID incorrecto:** Si se formatea una partición, su UUID cambia. Si /etc/fstab tiene el UUID antiguo, el sistema no la encontrará durante el arranque.
- **Dispositivos no conectados:** Intentar montar un dispositivo que no está enchufado o disponible resultará en un error de montaje al inicio.
- **Dependencias:** Un problema de dependencia, como intentar montar un sistema de archivos que requiere una red que no está activa, puede causar fallos.
- **Errores de orden de montaje:** Intentar montar una partición que depende de otra (por ejemplo, /var/lib antes que /var) puede fallar. Esto se puede control>
- **Codificación de archivo:** En raras ocasiones, la codificación del archivo puede ser incorrecta (por ejemplo, UTF-8 en lugar de ASCII), lo que puede causar>

Si el problema persiste, el disco podría tener fallos físicos o un sistema de archivos corrupto que requeriría herramientas de diagnóstico o reparación del sistema de archivos. 

Al existir muchas causas de fallos, es preferible usar un servicio para que monte las unidades automáticamente después del inicio del sistema y así evitar que el sistema no arranque.

## ESTRATEGIAS/PASOS:

1. Identificar las unidades/particiones.
2. Identificar el ID de las unidades/particiones.
3. Crear el script o copiar el script `mount_disks.sh` ya probado (no se te olvide darle permisos de ejecución).
4. Probar el script. Debemos demontamor la unidades previamente si están montadas (podemos utilizar el script `umount_drives.sh` para ello).
5. Crear el servicio o copiamos el archivo `mount-disks.service` ya probado.
6. Habilitar el servicio.
8. Comentar o eliminar las líneas en el `/etc/fstab` que montas las unidades/particiones.
9. Reiniciar el equipo.
10. Revisar los logs (/var/log/ultimo_montaje.log).

## IDENTIFICAR UNIDADES 

Primero identificamos las unidades de nuestro interés:

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
├─nvme0n1p2 259:2    0   238M  0 part /boot/efi/mnt/Nueva
└─nvme0n1p3 259:3    0  93.1G  0 part /
```

En nuestro caso nos interesan las unidades:

- `sda4` que corresponde con la partición `Nueva` la cual es de `713.8G`
- `sdb1` que corresponde con la partición `Datos` la cual es de `1.8T`
- `sdc2` que corresponde con la partición `Navarro` la cual es de `3.6T`
- `sdd2` que corresponde con la partición `Archivos` la cual es de `1T`

## IDENTIFICAR ID DE UNIDADES/PARTICIONES

El siguiente paso es conocer el id de esas unidades/particiones:

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

## COPIAMOS EL SCRIPT 

1. Copiamos el script `mount_disks.sh` (ya probado)

```bash
$ sudo cp ~/.dotfiles/services/mount-hdds/mmount -t xfs -o defaultsount-disks/mount-disks.sh /usr/local/bin/
```

2. Damos permisos de ejecución si no los tiene:
 
```bash
$ sudo chmod +x /usr/local/bin/mount_disks.sh
```

## PROBAR EL SCRIPT 

1. Demontar las unidades si hemos estado usando fstab

```bash
$ sudo umount /dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2
$ sudo umount /dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1 
$ sudo umount /dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2
$ sudo umount /dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4
```

2. Usar script para desmontar

```bash
# Si tenemos algun script para desmontar
$ . /usr/local/bin/umount_disks.sh 

#!/bin/sh

umount /dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2
umount /dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1 
umount /dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2
umount /dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4

echo "Discos desmontados."

df -h | grep mnt
```

3. Probamos el script:

```bash
$ sudo . /usr/local/bin/mount_disks.sh
```

## SERVICIO PARA EJECUTAR EL SCRIPT AL INICIO 

Crea un servicio que:

1. Espere a que el sistema esté listo (After=local-fs.target).
2. No bloquee el arranque si falla (Type=oneshot).

**Paso 1:** Crea un servicio systemd para ejecutar el script TRAS el arranque:

```bash
$ sudo nano /etc/systemd/system/mount-disks.service 

[Unit]
Description=Montar discos
After=local-fs.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mount-disks.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**Paso 2:** Habilitar el servicio:

```bash
$ sudo systemctl enable mount-disks.service

# Para reiniciar el servicio:
sudo systemctl daemon-reload
sudo systemctl start mount-disks.service
sudo systemctl status mount-disks.service
```

**Paso 3:** Reboot

```bash
$ sudo reboot
```

## ESTABLECER PERMISOS EN PARTICIONES/UNIDADES XFS

Si los permisos no están correctamente, establecerlos:

```bash
$ sudo chown alex:alex /mnt/Nueva
$ sudo chmod -R 775 /mnt/Nueva

$ ls -la /mnt/
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:41:02 2025  .
drwxr-xr-x root root 4.0 KB Mon Nov 17 17:25:36 2025  ..
drwxrwxr-x alex alex  16 KB Fri Nov 14 23:43:41 2025  Archivos
drwxrwxr-x alex alex 8.0 KB Sun Nov  2 12:05:03 2025  Datos
drwxrwxr-x alex alex 8.0 KB Sat Nov  8 09:36:54 2025  Navarro
drwxrwxr-x alex alex 183 B  Thu Nov 20 18:07:47 2025  Nueva
```

**NOTA:** Hacer esto sólo la primera vez y de preferencia que el disco/partición este vacío dado que se tardará demasiado si tiene muchos archivos.

## REVISAR EL LOG

```bash
# Con nano
$ nano /var/log/ultimo_montaje.log

=== REGISTRO DE MONTAJE - vie 21 nov 2025 17:46:05 CST ===
[2025-11-21 17:46:05] Iniciando script de montaje...
[2025-11-21 17:46:05] Verificando puntos de montaje...
[2025-11-21 17:46:05] Montando partición 1 (Archivos)...
[2025-11-21 17:46:06] ✓ Partición 1 (Archivos) montada correctamente
[2025-11-21 17:46:06] Montando partición 2 (Datos)...
[2025-11-21 17:46:07] ✓ Partición 2 (Datos) montada correctamente
[2025-11-21 17:46:07] Montando partición 3 (Navarro)...
[2025-11-21 17:46:08] ✓ Partición 3 (Navarro) montada correctamente
[2025-11-21 17:46:08] Montando partición 4 (Nueva)...
[2025-11-21 17:46:08] ✓ Partición 4 (Nueva) montada correctamente
[2025-11-21 17:46:08] --- VERIFICACIÓN FINAL ---
[2025-11-21 17:46:08] ✓ /mnt/Archivos: MONTADO (drwxrwxr-x alex:alex)
[2025-11-21 17:46:08] ✓ /mnt/Datos: MONTADO (drwxrwxr-x alex:alex)
[2025-11-21 17:46:08] ✓ /mnt/Navarro: MONTADO (drwxrwxr-x alex:alex)
[2025-11-21 17:46:08] ✓ /mnt/Nueva: MONTADO (drwxrwxr-x alex:alex)
[2025-11-21 17:46:08] --- INFORMACIÓN DETALLADA ---
[2025-11-21 17:46:08] SISTEMA: /mnt/Archivos - Tipo: fuseblk
[2025-11-21 17:46:08] SISTEMA: /mnt/Datos - Tipo: fuseblk
[2025-11-21 17:46:08] SISTEMA: /mnt/Navarro - Tipo: fuseblk
[2025-11-21 17:46:08] SISTEMA: /mnt/Nueva - Tipo: xfs
[2025-11-21 17:46:08] Script de montaje completado

# Con cat
$ cat /var/log/ultimo_montaje.log
───────┬─────────────────────────────────────────────────────────────────────────────
       │ File: /var/log/ultimo_montaje.log
───────┼─────────────────────────────────────────────────────────────────────────────
   1   │ === REGISTRO DE MONTAJE - sáb 22 nov 2025 08:50:05 CST ===
   2   │ [2025-11-22 08:50:05] Iniciando script de montaje...
   3   │ [2025-11-22 08:50:05] Verificando puntos de montaje...
   4   │ [2025-11-22 08:50:05] Montando partición 1 (Archivos)...
   5   │ [2025-11-22 08:50:05] ✓ Partición 1 (Archivos) montada correctamente
   6   │ [2025-11-22 08:50:05] Montando partición 2 (Datos)...
   7   │ [2025-11-22 08:50:06] ✓ Partición 2 (Datos) montada correctamente
   8   │ [2025-11-22 08:50:06] Montando partición 3 (Navarro)...
   9   │ [2025-11-22 08:50:07] ✓ Partición 3 (Navarro) montada correctamente
  10   │ [2025-11-22 08:50:07] Montando partición 4 (Nueva)...
  11   │ [2025-11-22 08:50:08] ✓ Partición 4 (Nueva) montada correctamente
  12   │ [2025-11-22 08:50:08] --- VERIFICACIÓN FINAL ---
  13   │ [2025-11-22 08:50:08] ✓ /mnt/Archivos: MONTADO (drwxrwxr-x alex:alex)
  14   │ [2025-11-22 08:50:08] ✓ /mnt/Datos: MONTADO (drwxrwxr-x alex:alex)
  15   │ [2025-11-22 08:50:08] ✓ /mnt/Navarro: MONTADO (drwxrwxr-x alex:alex)
  16   │ [2025-11-22 08:50:08] ✓ /mnt/Nueva: MONTADO (drwxrwxr-x alex:alex)
  17   │ [2025-11-22 08:50:08] --- INFORMACIÓN DETALLADA ---
  18   │ [2025-11-22 08:50:08] SISTEMA: /mnt/Archivos - Tipo: fuseblk
  19   │ [2025-11-22 08:50:08] SISTEMA: /mnt/Datos - Tipo: fuseblk
  20   │ [2025-11-22 08:50:08] SISTEMA: /mnt/Navarro - Tipo: fuseblk
  21   │ [2025-11-22 08:50:08] SISTEMA: /mnt/Nueva - Tipo: xfs
  22   │ [2025-11-22 08:50:08] Script de montaje completado
───────┴─────────────────────────────────────────────────────────────────────────────
```

**Confirmación importante:**

- Los permisos XFS se mantienen persistentes entre reinicios (como esperabas)
- NTFS también mantiene los permisos gracias a las opciones de montaje en tu script

**Tu configuración está optimizada:**

- Para NTFS: Necesitas las opciones en cada montaje (porque NTFS no almacena permisos Unix nativamente)
- Para XFS: Los permisos son persistentes en el filesystem - solo los estableciste una vez

Dado que todo funciona perfectamente, podrías considerar usar **solo fstab** para el montaje automático y eliminar el script, pero el script te da:

1. Logging detallado para diagnóstico
2. Verificación de que todo se montó correctamente
3. Flexibilidad para manejar casos especiales

# Cambiamos la partición Nueva de disco:

```bash
$ lsblk /dev/sda
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0 931.5G  0 disk 
├─sda1   8:1    0     1G  0 part /boot/efi
├─sda2   8:2    0   100G  0 part /
├─sda3   8:3    0    40G  0 part /tmp
├─sda4   8:4    0    40G  0 part /var
├─sda5   8:5    0   200G  0 part /home
└─sda6   8:6    0 550.5G  0 part 
``` 

Ahora corresponde a sda6.

```bash
 ls -la /dev/disk/by-id/ | grep sda6
lrwxrwxrwx root root  10 B Tue Jun 23 10:05:13 2026 ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part6 ⇒ ../../sda6
lrwxrwxrwx root root  10 B Tue Jun 23 10:05:13 2026 wwn-0x50014ee26242694a-part6 ⇒ ../../sda6
```

Modificamos el script:

```bash
 sudo nano /usr/local/bin/mount-disks.sh

part1="/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2"
part2="/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1"
part3="/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2"
#part4="/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part4"
part4="/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part6"

mnt1="/mnt/Archivos"
mnt2="/mnt/Datos"
mnt3="/mnt/Navarro"
mnt4="/mnt/Nueva"
```

Montamos manualmente para probar:

```bash
sudo mount -t xfs -o defaults /dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part6 /mnt/Nueva
```

Si todo queda bien, en el próximo reinicio se montara está partición.

Si los permisos no están correctamente, establecerlos:

```bash
$ sudo chown alex:alex /mnt/Nueva
$ sudo chmod -R 775 /mnt/Nueva

 ls -la /mnt/
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:41:02 2025  .
drwxr-xr-x root root 4.0 KB Sun Jun 21 21:00:39 2026  ..
drwxr-xr-x alex alex 4.0 KB Wed Nov 12 11:13:58 2025  Archivos
drwxrwxr-x alex alex 8.0 KB Mon Apr 27 13:01:10 2026  Datos
drwxrwxr-x alex alex 8.0 KB Sun Apr 12 08:25:45 2026  Navarro
drwxrwxr-x alex alex   6 B  Tue Jun 23 12:16:14 2026  Nueva

 lsblk /dev/sda -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
NAME   FSTYPE   SIZE MOUNTPOINT LABEL
sda           931.5G            
├─sda1 vfat       1G /boot/efi  
├─sda2 ext4     100G /          
├─sda3 ext4      40G /tmp       
├─sda4 ext4      40G /var       
├─sda5 ext4     200G /home      
└─sda6 xfs    550.5G /mnt/Nueva 
```

**¡Perfect!**


# Cambiamos la partición Archivos de disco:

```bash
 lsblk
NAME   MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda      8:0    0   1.8T  0 disk 
└─sda1   8:1    0   1.8T  0 part /mnt/Datos
sdb      8:16   0 931.5G  0 disk 
├─sdb1   8:17   0     1G  0 part /boot/efi
├─sdb2   8:18   0   100G  0 part /
├─sdb3   8:19   0    40G  0 part /tmp
├─sdb4   8:20   0    40G  0 part /var
├─sdb5   8:21   0   200G  0 part /home
└─sdb6   8:22   0 550.5G  0 part /mnt/Nueva
sdc      8:32   0 931.5G  0 disk 
└─sdc1   8:33   0 931.5G  0 part 
sdd      8:48   0   3.6T  0 disk 
├─sdd1   8:49   0    16M  0 part 
└─sdd2   8:50   0   3.6T  0 part /mnt/Navarro
``` 

Ahora corresponde a sdc1 (Disco de 1 TB sin montar).

```bash
 ls -la /dev/disk/by-id/ | grep sdc1
lrwxrwxrwx root root  10 B Thu Jun 25 11:52:15 2026 ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part1 ⇒ ../../sdc1
lrwxrwxrwx root root  10 B Thu Jun 25 11:52:15 2026 wwn-0x50014ee65cb68d48-part1 ⇒ ../../sdc1
```

Modificamos el script:

```bash
 sudo nano /usr/local/bin/mount-disks.sh

part1="/dev/disk/by-id/ata-WDC_WD20EZAZ-00GGJB0_WD-WXR1AC822LC5-part1"
part2="/dev/disk/by-id/ata-ST4000DM004-2CV104_ZTT0R6BZ-part2"
part3="/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part1"
part4="/dev/disk/by-id/ata-WDC_WD10EZEX-00WN4A0_WD-WCC6Y3SYY5AK-part6"

mnt1="/mnt/Datos"
mnt2="/mnt/Navarro"
mnt3="/mnt/Archivos"
mnt4="/mnt/Nueva"
```

Montamos manualmente para probar:

```bash
sudo mount -t xfs -o defaults /dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part1 /mnt/Archivos
```

Si todo queda bien, en el próximo reinicio se montara está partición.

Si los permisos no están correctamente, establecerlos:

```bash
$ sudo chown alex:alex /mnt/Archivos
$ sudo chmod -R 775 /mnt/Archivos

 ls -la /mnt/
drwxr-xr-x root root 4.0 KB Wed Nov 12 11:41:02 2025  .
drwxr-xr-x root root 4.0 KB Sun Jun 21 21:00:39 2026  ..
drwxrwxr-x alex alex   6 B  Thu Jun 25 07:56:29 2026  Archivos
drwxrwxr-x alex alex 8.0 KB Mon Apr 27 13:01:10 2026  Datos
drwxrwxr-x alex alex 8.0 KB Sun Apr 12 08:25:45 2026  Navarro
drwxrwxr-x alex alex 157 B  Tue Jun 23 20:37:03 2026  Nueva

  lsblk -o NAME,FSTYPE,SIZE,MOUNTPOINT,LABEL
NAME   FSTYPE   SIZE MOUNTPOINT    LABEL
sda             3.6T               
├─sda1           16M               
└─sda2 ntfs     3.6T /mnt/Navarro  Navarro
sdb             1.8T               
└─sdb1 ntfs     1.8T /mnt/Datos    Datos
sdc           931.5G               
├─sdc1 vfat       1G /boot/efi     
├─sdc2 ext4     100G /             
├─sdc3 ext4      40G /tmp          
├─sdc4 ext4      40G /var          
├─sdc5 ext4     200G /home         
└─sdc6 xfs    550.5G /mnt/Nueva    
sdd           931.5G               
└─sdd1 xfs    931.5G /mnt/Archivos 
```

**¡Perfect!**

## Montar unidades en paralelo

Objetivos:

- Reducir el tiempo de montaje de las unidades.
- Quitar el mensaje que aparece al apagar/reiniciar equipo con esta estrategia de montaje:

```bash
[2175.877120] libvirt-guests.sh [86806]: No se puede conectar a default. Omitiendo.
```

### Modificaciones al script

Para lograrlo debemos modificar la estructura interna del script `/usr/local/bin/mount-disks.sh`. En lugar de hacer esto:

```bash
mount /dev/sdaX /mnt/Datos
mount /dev/sdaY /mnt/Navarro
```

Ahora lanzamos los montajes al fondo (`&`) y luego usar `wait` para que el script no termine (respetando el `oneshot`) hasta que todos los discos estén listos:

```bash
#!/bin/bash
# ... (tus cabeceras y verificaciones previas) ...

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Montando particiones en paralelo..."

mount /dev/disk/by-uuid/TU_UUID_1 /mnt/Datos &
PID1=$!
mount /dev/disk/by-uuid/TU_UUID_2 /mnt/Navarro &
PID2=$!
mount /dev/disk/by-uuid/TU_UUID_3 /mnt/Archivos &
PID3=$!
mount /dev/disk/by-uuid/TU_UUID_4 /mnt/Nueva &
PID4=$!

# Esperamos a que todos los procesos de montaje terminen
wait $PID1 $PID2 $PID3 $PID4

# ... (aquí pones tu bloque actual de VERIFICACIÓN FINAL) ...
```

De esta forma, el tiempo total del script será únicamente lo que tarde la partición más lenta en responder, en lugar de la suma de todas ellas.

### Modificaciones al servicio

```bash
[Unit]
Description=Montar discos
After=multi-user.target
Conflicts=umount.target
Before=umount.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mount-disks.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

Tenía un conflicto real el cual ocurría porque tenía dos mecanismos distintos peleándose por el mismo hardware al mismo tiempo:
- Por un lado, `/etc/fstab`: Al arrancar, monta de forma obligatoria y secuencial la raíz (`/`), `/home`, `/tmp` y `/var` para que el sistema pueda funcionar. Como `/var` está en el mismo disco mecánico de 1 TB (en la partición colindante), el sistema operativo empieza a escribir logs e información de inicio como loco en esa zona del disco.
- Por el otro, tu script original con `After=local-fs.target`: Se ejecutaba justo en ese mismo instante de máxima actividad de `/etc/fstab`. Al intentar montar la Partición 4 (que físicamente comparte los mismos platos y cabezales mecánicos que `/var`), el comando mount de tu script se quedaba esperando en una fila de acceso (`I/O bottleneck`). El cabezal del disco no podía leer la estructura de tu Partición 4 porque estaba ocupado escribiendo los datos de Linux en `/var`.
- `Conflicts=umount.target`: Le dice a systemd que tu servicio de montaje no puede coexistir con el proceso de desmontaje global del sistema. En cuanto el PC inicia el apagado (`umount.target`), systemd sabe que tiene que detener tu servicio primero de forma limpia.
- `Before=umount.target`: Fuerza a que tu script libere los discos antes de que el sistema operativo intente desmontar la estructura general de almacenamiento local.

Al estructurar esto, systemd reordena correctamente la cola de apagado: primero detendrá los servicios que dependen de tus discos (como tus contenedores de Jellyfin/Navidrome o libvirt), luego desmontará tus particiones multimedia a través del ciclo nativo, y finalmente apagará el demonio principal sin quedarse atrapado esperando a `libvirt-guests.sh`.

Haz los cambios y recuerda ejecutar un:

```bash
sudo systemctl daemon-reload
```

### Desactivar por completo el script de apagado de libvirt

Si tú controlas tus VMs de forma manual, no necesitas que un script de systemd intente automatizar nada al apagar el equipo. Puedes deshabilitar este comportamiento secundario sin romper tu capacidad de abrir `virt-manager` y usar tus VMs normalmente cuando quieras:

```bash
 sudo systemctl disable libvirt-guests.service
Synchronizing state of libvirt-guests.service with SysV service script with /usr/lib/systemd/systemd-sysv-install.
Executing: /usr/lib/systemd/systemd-sysv-install disable libvirt-guests
Removed '/etc/systemd/system/multi-user.target.wants/libvirt-guests.service'.
```

**¿Qué hace esto?** Evita que el script molesto se ejecute al apagar o reiniciar, eliminando el mensaje para siempre. Tus herramientas de virtualización (`libvirtd`, `virt-manager`, QEMU/KVM) seguirán funcionando al 100% cuando tú las abras.

# LOGS

El script crea un log cada que reinicia el sistema donde crea un reporte del estado de los discos al montarlos: 

```bash
 nano /var/log/ultimo_montaje.log
ntfs-3g: Failed to access volume '/dev/disk/by-id/ata-WDC_WD10JPVX-00JC3T0_WD-WXG1A178NNDL-part2': No existe el fichero o el directorio

ntfs-3g 2022.10.3 integrated FUSE 28 - Third Generation NTFS Driver
                Configuration type 7, XATTRS are on, POSIX ACLS are on

Copyright (C) 2005-2007 Yura Pakhuchiy
Copyright (C) 2006-2009 Szabolcs Szakacsits
Copyright (C) 2007-2022 Jean-Pierre Andre
Copyright (C) 2009-2020 Erik Larsson

Usage:    ntfs-3g [-o option[,...]] <device|image_file> <mount_point>

Options:  ro (read-only mount), windows_names, uid=, gid=,
          umask=, fmask=, dmask=, streams_interface=.
          Please see the details in the manual (type: man ntfs-3g).

Example: ntfs-3g /dev/sda1 /mnt/windows

Plugin path: /usr/lib/x86_64-linux-gnu/ntfs-3g

News, support and information:  https://github.com/tuxera/ntfs-3g/
[2026-06-25 11:52:25] ✗ Error al montar Partición 1 (Archivos)
[2026-06-25 11:52:25] Montando partición 2 (Datos)...
[2026-06-25 11:52:26] ✓ Partición 2 (Datos) montada correctamente
[2026-06-25 11:52:26] Montando partición 3 (Navarro)...
[2026-06-25 11:52:27] ✓ Partición 3 (Navarro) montada correctamente
[2026-06-25 11:52:27] Montando partición 4 (Nueva)...
[2026-06-25 11:52:44] ✓ Partición 4 (Nueva) montada correctamente
[2026-06-25 11:52:44] --- VERIFICACIÓN FINAL ---
[2026-06-25 11:52:44] ✗ /mnt/Archivos: NO MONTADO
[2026-06-25 11:52:44] ✓ /mnt/Datos: MONTADO (drwxrwxr-x alex:alex)
[2026-06-25 11:52:44] ✓ /mnt/Navarro: MONTADO (drwxrwxr-x alex:alex)
[2026-06-25 11:52:44] ✓ /mnt/Nueva: MONTADO (drwxrwxr-x alex:alex)
[2026-06-25 11:52:44] --- INFORMACIÓN DETALLADA ---
[2026-06-25 11:52:44] SISTEMA: /mnt/Datos - Tipo: fuseblk
[2026-06-25 11:52:44] SISTEMA: /mnt/Navarro - Tipo: fuseblk
[2026-06-25 11:52:44] SISTEMA: /mnt/Nueva - Tipo: xfs
[2026-06-25 11:52:44] Script de montaje completado
```

En este momento reestructure el disco donde esta la partición 1 (Archivos):
- gpt
- xfs
- cambio su by-id

Montaje de todos los discos duros:

```bash
 nano /var/log/ultimo_montaje.log

=== REGISTRO DE MONTAJE - jue 25 jun 2026 13:30:50 CST ===
[2026-06-25 13:30:50] Iniciando script de montaje...
[2026-06-25 13:30:50] Verificando puntos de montaje...
[2026-06-25 13:30:50] Montando partición 1 (Datos)...
[2026-06-25 13:30:51] ✓ Partición 1 (Datos) montada correctamente
[2026-06-25 13:30:51] Montando partición 2 (Navarro)...
[2026-06-25 13:30:52] ✓ Partición 2 (Navarro) montada correctamente
[2026-06-25 13:30:52] Montando partición 3 (Archivos)...
[2026-06-25 13:30:53] ✓ Partición 3 (Archivos) montada correctamente
[2026-06-25 13:30:53] Montando partición 4 (Nueva)...
[2026-06-25 13:31:00] ✓ Partición 4 (Nueva) montada correctamente
[2026-06-25 13:31:00] --- VERIFICACIÓN FINAL ---
[2026-06-25 13:31:00] ✓ /mnt/Datos: MONTADO (drwxrwxr-x alex:alex)
[2026-06-25 13:31:00] ✓ /mnt/Navarro: MONTADO (drwxrwxr-x alex:alex)
[2026-06-25 13:31:00] ✓ /mnt/Archivos: MONTADO (drwxr-xr-x root:root)
[2026-06-25 13:31:00] ✓ /mnt/Nueva: MONTADO (drwxrwxr-x alex:alex)
[2026-06-25 13:31:00] --- INFORMACIÓN DETALLADA ---
[2026-06-25 13:31:00] SISTEMA: /mnt/Datos - Tipo: fuseblk
[2026-06-25 13:31:00] SISTEMA: /mnt/Navarro - Tipo: fuseblk
[2026-06-25 13:31:01] SISTEMA: /mnt/Archivos - Tipo: xfs
[2026-06-25 13:31:01] SISTEMA: /mnt/Nueva - Tipo: xfs
[2026-06-25 13:31:01] Script de montaje completado
```
