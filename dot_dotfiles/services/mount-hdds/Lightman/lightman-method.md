Scripting en Linux (V): Bash. Ejecutar un Script en el Inicio o Apagado
https://computernewage.com/2019/03/09/scripting-linux-bash-ejecutar-script-arranque/


				////////////////////////////
				/// IDENTIFICAR UNIDADES ///
				////////////////////////////


Identifique la unidad existente y tome nota de la partición que desea montar. Esto generalmente se muestra como -part1 usando /dev/disk/by-id. 

root@beatles:~# ls -la /dev/disk/by-id/
total 0
drwxr-xr-x 2 root root 300 ago 27 21:08 .
drwxr-xr-x 8 root root 160 ago 27 21:08 ..
lrwxrwxrwx 1 root root   9 ago 27 21:08 ata-ADATA_SU650_2N31291S48UU -> ../../sda
lrwxrwxrwx 1 root root  10 ago 27 21:08 ata-ADATA_SU650_2N31291S48UU-part1 -> ../../sda1
lrwxrwxrwx 1 root root  10 ago 27 21:08 ata-ADATA_SU650_2N31291S48UU-part2 -> ../../sda2
lrwxrwxrwx 1 root root  10 ago 27 21:08 ata-ADATA_SU650_2N31291S48UU-part3 -> ../../sda3
lrwxrwxrwx 1 root root  10 ago 27 21:08 ata-ADATA_SU650_2N31291S48UU-part4 -> ../../sda4
lrwxrwxrwx 1 root root   9 ago 27 21:08 ata-ST4000DM004-2U9104_ZTT5W9F3 -> ../../sdc
lrwxrwxrwx 1 root root  10 ago 27 21:08 ata-ST4000DM004-2U9104_ZTT5W9F3-part1 -> ../../sdc1
lrwxrwxrwx 1 root root   9 ago 27 21:08 ata-ST4000VN006-3CW104_ZW62MXMK -> ../../sdb
lrwxrwxrwx 1 root root  10 ago 27 21:08 ata-ST4000VN006-3CW104_ZW62MXMK-part1 -> ../../sdb1
lrwxrwxrwx 1 root root   9 ago 27 21:08 wwn-0x5000c500e63213f1 -> ../../sdc
lrwxrwxrwx 1 root root  10 ago 27 21:08 wwn-0x5000c500e63213f1-part1 -> ../../sdc1
lrwxrwxrwx 1 root root   9 ago 27 21:08 wwn-0x5000c500e8fb46c0 -> ../../sdb
lrwxrwxrwx 1 root root  10 ago 27 21:08 wwn-0x5000c500e8fb46c0-part1 -> ../../sdb1

Podemos deducir que:

  - sda es donde se instaló Debian y esto lo sabemos porque esta unidad contiene 4 particiones. 
  - Tanto sdb como sdc solo contienen una partición. 
  - Si buscamos ADATA_SU650 en internet nos muestra que corresponde un disco ADATA SSD Ultimate SU650 (sda)
  - ST4000DM004 corresponde a un disco Seagate Barracuda de 4T (sdc).     
  - Y ST4000VN006 corresponte a un disco ironwolf de 4T (sdb).


				/////////////////////////
				/// PUNTOS DE MONTAJE ///
				/////////////////////////

Como previamente habiamos montado el primer disco, ahora vamos a crear el directorio disk2.

  root@beatles:~# ls /mnt
  disk1  ntfs1
  root@beatles:~# mkdir /mnt/disk1
  root@beatles:~# mkdir /mnt/disk2
  root@beatles:~# mkdir /mnt/parity1 #Pendiente
  root@beatles:~# mkdir /mnt/storage #Pendiente

  root@beatles:~# ls -la /mnt
  total 20
  drwxr-xr-x  5 root root 4096 ago 15 19:18 .
  drwxr-xr-x 18 root root 4096 dic 24  2023 ..
  drwxr-xr-x  2 root root 4096 mar 18 17:51 disk1
  drwxr-xr-x  2 root root 4096 ago 15 19:18 disk2
  drwxr-xr-x  2 root root 4096 mar 18 19:00 parity


				//////////////////////////////////
				/// SCRIPT MONTAJE PARA PROBAR ///
				//////////////////////////////////

Primero creamos el script

  root@beatles:~# cd
  root@beatles:~# touch mount_drives.sh
  root@beatles:~# nano mount_drives.sh

  #!/bin/sh

  mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1
  mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2
  echo "Discos montados."

  df -h | grep mnt


Damos permisos de ejecución al script

  root@beatles:~# chmod +x mount_drives.sh


Probamos el script

  root@beatles:~# ./mount_drives.sh
  Discos montados.
  /dev/sdc1      xfs        3.7T    26G  3.7T   1% /mnt/disk2
  /dev/sdb1      xfs        3.7T   2.7T  964G  75% /mnt/disk1

   mergerfs -o cache.files=partial,dropcacheonclose=true,category.create=mfs /mnt/disk1:/mnt/disk2 /media


				/////////////////////////
				/// SCRIPT DESMONTAJE ///
				/////////////////////////

Primero creamos el script

  root@beatles:~# cd
  root@beatles:~# touch umount_drives.sh
  root@beatles:~# nano umount_drives.sh

  #!/bin/sh

  umount /mnt/disk1
  umount /mnt/disk2
  echo "Discos desmontados."

  df -h | grep mnt


Damos permisos de ejecución al script

  root@beatles:~# chmod +x umount_drives.sh


Probamos el script

  root@beatles:~# ./umount_drives.sh
  Discos desmontados.




				////////////////////////////////////
				/// EJECUTAR EL SCRIPT AL INICIO ///
				////////////////////////////////////

				PRUEBA REALIZADA EN MAQUINA VIRTUAL y CON UUID


1. Editamos el archivo /etc/rc.local

   root@beatles:~# nano /etc/rc.local

#!/bin/sh -e

sleep 1m

## by-id
mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1
mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2

docker compose down
docker compose up -d jellyfin

## by-uuid
#mount -t xfs UUID=fdbfdf76-18e7-44d5-a06d-369fcaca37b8 /mnt/disk1
#mount -t xfs UUID=53c41275-af8a-421e-b3c0-da13f89dca0c /mnt/disk2
#mount -t xfs UUID=786fbd7e-d596-4472-aea2-a98b1faf6e9d /mnt/parity1

mergerfs -o defaults,nonempty,allow_other,use_ino,cache.files=off,moveonenospc=true,dropcacheonclose=true,minfreespace=200G,fsname=mergerfs /mnt/disk1:/mnt/disk2 /mnt/storage

OPCIÓN 2. Si no queremos volver a editar el /etc/rc.local a mano podemos pasar el contenido de nuestro mount_drives.sh al archivo /etc/rc.local con el siguiente comando:

   root@beatles:~# cat mount_drives.sh >> /etc/rc.local

Y lo modificamos para adaptarlo:

   root@beatles:~# nano /etc/rc.local

#!/bin/sh -e

sleep 1m

## by-id
mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1
mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2

sleep 1m para que duerma un minuto y después montar los discos.

2. Revisamos permisos

   root@beatles:~# ls -la /etc/rc.local

   Asignar derechos de ejecución:

   root@beatles:~# chmod +x /etc/rc.local
   root@beatles:~# ll /etc/rc.local
   .rwxr-xr-x root root 224 B Tue Aug 27 17:44:41 2024 ? /etc/rc.local


3. Vamos a crear un archivo de servicio

   Problema: los Linux de hoy no traen rc.local.
   Solución: agregar el entry en el systemd para que lo ejecute como si fuera un programa.

   Como ahora todas las distros linux tienen systemd el /etc/rc.local ya no anda por lo cual hay 
   que hacer una tramoya.

   root@beatles:~# nano /etc/systemd/system/rc-local.service


[Unit]
Description=/etc/rc.local Compatibility
ConditionPathExists=/etc/rc.local

[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99

[Install]
WantedBy=multi-user.target

Ahora habilitamos el servicio

   root@beatles:~# systemd enable rc-local

Reiniciamos

   root@beatles:~# reboot


				//////////////////////////////////////////////////
				/// ERRORES AL FALLAR O DESCONECTAR UNA UNIDAD ///
				//////////////////////////////////////////////////


root@beatles:~# systemctl status rc-local.service

x rc-local.service - /etc/rc.local Compatibility
     Loaded: loaded (/etc/systemd/system/rc-local.service; enabled-runtime; preset: enabled)
    Drop-In: /usr/lib/systemd/system/rc-local.service.d
               debian.conf
     Active: failed (Result: exit-code) since Wed 2024-08-28 09:33:23 CST; 46min ago
    Process: 630 ExecStart=/etc/rc.local start (code=exited, status=32)
        CPU: 2ms

ago 28 09:32:23 beatles systemd[1]: Starting rc-local.service - /etc/rc.local Compatibility...
ago 28 09:33:23 beatles rc.local[651]: mount: /mnt/disk1: el dispositivo especial /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 no existe.
ago 28 09:33:23 beatles rc.local[651]:        dmesg(1) may have more information after failed mount system call.
ago 28 09:33:23 beatles systemd[1]: rc-local.service: Control process exited, code=exited, status=32/n/a
ago 28 09:33:23 beatles systemd[1]: rc-local.service: Failed with result 'exit-code'.
ago 28 09:33:23 beatles systemd[1]: Failed to start rc-local.service - /etc/rc.local Compatibility.


SIN ERRORES

root@beatles:~# systemctl status rc-local.service
* rc-local.service - /etc/rc.local Compatibility
     Loaded: loaded (/etc/systemd/system/rc-local.service; enabled-runtime; pre>
    Drop-In: /usr/lib/systemd/system/rc-local.service.d
               debian.conf
     Active: active (exited) since Wed 2024-08-28 10:39:52 CST; 26s ago
    Process: 638 ExecStart=/etc/rc.local start (code=exited, status=0/SUCCESS)
        CPU: 6ms

ago 28 10:38:52 beatles systemd[1]: Starting rc-local.service - /etc/rc.local C>
ago 28 10:39:52 beatles systemd[1]: Started rc-local.service - /etc/rc.local Co>
lines 1-10/10 (END)
* rc-local.service - /etc/rc.local Compatibility
     Loaded: loaded (/etc/systemd/system/rc-local.service; enabled-runtime; preset: enabled)
    Drop-In: /usr/lib/systemd/system/rc-local.service.d
               debian.conf
     Active: active (exited) since Wed 2024-08-28 10:39:52 CST; 26s ago
    Process: 638 ExecStart=/etc/rc.local start (code=exited, status=0/SUCCESS)
        CPU: 6ms

ago 28 10:38:52 beatles systemd[1]: Starting rc-local.service - /etc/rc.local Compatibility...
ago 28 10:39:52 beatles systemd[1]: Started rc-local.service - /etc/rc.local Compatibility.
