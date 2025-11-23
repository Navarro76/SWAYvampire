
# MONTAJE DE HDDS USANDO SERVICIO SYSTEMD

## DESCRIPCIÓN

Uso de script y servicio systemd para gestionar el montaje de las unidades en un servidor multimedia dónde se debe esperar el montaje de los HDDs antes de arrancar el servidor Jellyfin con docker.

## JUSTIFICACIÓN

Problema con script anterior (by Lightman): como el script espera 1 minuto antes de montar las unidades para evitar que el sistema se cuelgue al tratar de montar algunas de las unidades con errores, en ocaciones al iniciar jellyfin comienza antes de que las unidades esten listas y ocacionando que las peliculas no esten disponibles en el servidor.

## OBJETIVOS

1. Solución definitiva (sin bloqueos y con sincronización) al problema del método de Lightman.
2. Mantener el montaje manual (para evitar bloqueos).
3. Asegurar que Jellyfin inicie solo después de montar los discos.


## ESTRATEGIAS/PASOS:

1. Deténer y eliminar los contenedores actuales (Jellyfin)
2. Demontar las unidades (podemos utilizar el script `umount_drives.sh` para ello)
3. Crear script `/usr/local/bin/mount_media_disks.sh` el cual se encarga de montar las unidades (disk1 y disk2) y una vez que el montaje fue exitoso inicia/reinicia Jellyfin.
4. En el archivo `/mnt/disk1/Docker/jellyfin/docker-compose.yml` debemos asegurarnos que no tenga políticas de reinicio automático como restart: always y restart: unless-stopped y comentarlas o cambiarlas a "no".
5. Lanzar el script mediante systemd y para ello creamos el servicio `/etc/systemd/system/mount-and-start-jellyfin.service` que se encargará de:
  - Esperar a que el sistema est� listo (After=local-fs.target).
  - No bloquee el arranque si falla (Type=oneshot).

**NOTA:** se realizaron varios pasos extras para poder probar el script porque ya tenía en uso Jellyfin y estaba utilizando en ese momento el script de Lightman y tube que deshabilitarlo ya que no quería elimarlo en ese momento por si quería seguir utilizando el script.

## EL SCRIPT 

1. Creamos el script

```bash
$ sudo nano /usr/local/bin/mount_media_disks.sh
```

2. Primer script

```bash
#!/bin/bash

# Montar discos (sin sleep, pero con verificación)
mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1 || echo "¡Error al montar /mnt/disk1!"
mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2 || echo "¡Error al montar /mnt/disk2!"

# Verificar montaje exitoso
if grep -qs "/mnt/disk1" /proc/mounts && grep -qs "/mnt/disk2" /proc/mounts; then
    echo "Discos montados. Reiniciando Jellyfin..."
    docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml down
    docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml up -d jellyfin
else
    echo "¡Advertencia! No se montaron todos los discos. Jellyfin no se reiniciará."
fi
```

3. **Script Mejorado:**

```bash
#!/bin/bash

# Montar discos
mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1 || echo "¡Error al montar /mnt/disk1!"
mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2 || echo "¡Error al montar /mnt/disk2!"

# Verificar montaje exitoso
if grep -qs "/mnt/disk1" /proc/mounts && grep -qs "/mnt/disk2" /proc/mounts; then
    echo "Discos montados. Reiniciando Jellyfin..."
    
    # Solo hacer 'down' si hay contenedores corriendo
    if docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml ps | grep -q "Up"; then
        docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml down
    fi
    
    docker compose -f /mnt/disk1/Docker/jellyfin/docker-compose.yml up -d
else
    echo "¡Advertencia! No se montaron todos los discos. Jellyfin no se reiniciará."
fi
```

4. Dar permisos:

```bash
$ sudo chmod +x /usr/local/bin/mount_media_disks.sh
```
Cambios clave:

  1. docker compose ps | grep -q "Up": Verifica si hay contenedores en ejecución antes de hacer down.
  2. Elimina el warning innecesario.

## FUNCIONAMIENTO DEL SCRIPT

```bash
- Si los discos NO se montan:
  - El script NO ejecuta 'docker-compose up -d > Jellyfin' no se inicia.
  - Estado resultante:
    - Contenedores quedan en el último estado (running/stopped).
    - En el próximo reinicio:
      - Si usas restart: always en 'docker-compose.yml', Docker intentará 
        iniciar Jellyfin aunque los discos fallen (¡problema!).
      - Si usas restart: no, Jellyfin no auto-iniciará.
- Si los discos se montan CORRECTAMENTE:
  - El script reinicia Jellyfin (down + up -d).
  - En el próximo reinicio:
    - Docker Compose no auto-inicia a menos que tengas:
      - restart: always en 'docker-compose.yml' (malo para tu caso).
      - Un servicio systemd gestionando el compose (ej: jellyfin.service).
```

## PREPARACIONES PARA HACER PRUEBAS CON EL SCRIPT 

Antes de realizar las pruebas con el script si ya estamos utilizando el metodo de Lightman u otro debemos:

- Deténer y eliminar los contenedores actuales
- Demontar las unidades

1. Usar cd para cambiarte al directorio donde tienes tu archivo `docker-compose.yml`:

```bash
$ cd /mnt/disk1/Docker/jellyfin/
```

2. Detener los contenedores

```bash
$ docker compose down
```

3. Demontamos los discos ya montados (esto para probar nuestro script de montaje)

```bash
$. /root/umount_drives.sh

#!/bin/sh

umount /mnt/disk1
umount /mnt/disk2
echo "Discos desmontados."

df -h | grep mnt
```

4. Probamos el script:

```bash
root@beatles:/mnt/disk1/Docker/jellyfin# . /usr/local/bin/mount_media_disks.sh
```

### PREPARACIONES PARA HACER PRUEBAS CON EL SCRIPT AL INICIO 

**Paso 1:** primero debemos deshabilitar el servicio de Lightman para que no ejecute el `rc.local` y montar las unidades. Lo más facil que se me ocurre es comentar el contenido de rc.local para que no tenga efecto:

```bash
$ sudo nano /etc/rc.local

#!/bin/sh -e

#sleep 1
#mount -t xfs /dev/disk/by-id/ata-ST4000DM004-2U9104_ZTT5W9F3-part1 /mnt/disk1
#mount -t xfs /dev/disk/by-id/ata-ST4000VN006-3CW104_ZW62MXMK-part1 /mnt/disk2
```

**Paso 2:** edita tu `docker-compose.yml`. Asegúrate de que no tenga políticas de reinicio automático. Busca y elimina/comenta estas líneas:

```bash
#   restart: always	#  Comenta o cambia a "no"
#   restart: unless-stopped #  Comenta o cambia a "no"

---
services:
  jellyfin:
    image: lscr.io/linuxserver/jellyfin:latest
    container_name: jellyfin
    network_mode: 'host'
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=America/Mexico_City
      - JELLYFIN_PublishedServerUrl=http://192.168.1.6 #optional
    volumes:
      - /mnt/disk1/Docker/jellyfin/config:/config
      - /mnt/disk1/MEDIA:/disk1
      - /mnt/disk2/MEDIA:/disk2
      - /mnt/disk1/Docker/jellyfin/dlna/devices:/config/data/dlna/devices
#      - /mnt/disk1/SERIES:/series
#      - /mnt/disk1/PELICULAS:/peliculas
#      - /mnt/disk2/SERIES:/series2
#      - /mnt/disk2/PELICULAS:/peliculas2
#   restart: unless-stopped
    restart: "no"
    extra_hosts:
      - "host.docker.internal:host-gateway"
```

**Paso 3:** reinicia manualmente cuando lo necesites

```bash
$ docker compose up -d  # Inicio manual
```

**Paso 4:** después de reiniciar verifica el estado del contenedor:

```bash
$ docker ps -a | grep jellyfin
$ docker ps  # No deber�a aparecer Jellyfin
```

**Paso 5:** ejecutamos nuevamente el script

```bash
root@beatles:/mnt/disk1/Docker/jellyfin# . /usr/local/bin/mount_media_disks.sh
```

## EJECUTAR EL SCRIPT AL INICIO 

Crea un servicio que:

1. Espere a que el sistema esté listo (After=local-fs.target).
2. No bloquee el arranque si falla (Type=oneshot).

**Paso 1:** Crea un servicio systemd para ejecutar el script TRAS el arranque:

```bash
$ sudo nano /etc/systemd/system/mount-and-start-jellyfin.service

[Unit]
Description=Montar discos e iniciar Jellyfin
After=local-fs.target
Before=  # Nada, para no bloquear otros servicios

[Service]
Type=oneshot
ExecStart=/usr/local/bin/mount_media_disks.sh
TimeoutSec=0  # Sin timeout para evitar interrupciones
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
```

**Paso 2:** Habilitar el servicio:

```bash
$ sudo systemctl enable mount-and-start-jellyfin.service
```

**Paso 3:** Reboot

```bash
$ sudo reboot
```
