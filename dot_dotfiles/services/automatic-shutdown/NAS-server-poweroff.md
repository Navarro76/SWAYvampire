# APAGADO DEL SERVIDOR NAS

/etc/systemd/system/apagado.timer > /etc/systemd/system/apagado.service > /usr/local/bin/apagado.sh

## SCRIPT [apagado.sh]

1. Creamos el script

```bash
root@debian:~# nano /usr/local/bin/apagado.sh

#!/bin/sh
echo "The NAS server was shut down successfully on: $(date)" >> /home/alex/schedule-test-output.txt
/sbin/shutdown -h now
```
2. Damos permisos de ejecución al script

```bash
root@debian:~# chmod +x /usr/local/bin/apagado.sh

root@beatles:~# ls -la /usr/local/bin/
total 12
drwxr-xr-x  2 root root 4096 ene  2 15:18 .
drwxr-xr-x 10 root root 4096 dic 24  2023 ..
-rwxr-xr-x  1 root root  132 ene  2 15:18 apagado.sh
```

## ARCHIVO DE SERVICIO [apagado.service]

Creamos el archivo de servicio

```bash
root@debian:~# nano /etc/systemd/system/apagado.service

[Unit]
Description="Apagado script"

[Service]
ExecStart=/usr/local/bin/apagado.sh
```

## ARCHIVO TIMER [apagado.timer]

Creamos el archivo timer

```bash
root@debian:~# nano /etc/systemd/system/apagado.timer

[Unit]
Description="Turn off the NAS server at 00:30 minutes daily"

[Timer]
#OnBootSec=5min
#OnUnitActiveSec=24h
#OnCalendar=Mon..Fri *-*-* 10:00:*
#OnCalendar=Mon..Sun *-*-* 5:00:00
OnCalendar=*-*-* 13:30:00
Unit=apagado.service

[Install]
WantedBy=multi-user.target
```

## COMPROBACIONES:

1. Comprueba que los archivos que has creado anteriormente no contienen errores:

```bash
root@debian:~# systemd-analyze verify /etc/systemd/system/apagado.*
/etc/systemd/system/rc-local.service:11: Support for option SysVStartPriority= has been removed and it is ignored
```
Si el comando no devuelve ningún resultado, los archivos han pasado la verificación correctamente.

2. Todas las piezas están en su lugar pero debes realizar pruebas para asegurarte de que todo funciona. Primero, habilite el servicio de usuario: 

```bash
root@debian:~# systemctl enable apagado.timer

# El resultado será similar a este: 
Created symlink /etc/systemd/system/multi-user.target.wants/apagado.timer -> /etc/systemd/system/apagado.timer.
```

3. Ahora haga una ejecución de prueba del trabajo:

```bash
root@debian:~# systemctl start apagado.service
root@debian:~#
```
El equipo se deberá apagar.

## IMPLEMENTACIÓN:

1. Una vez que el trabajo funcione correctamente, prográmelo de verdad habilitando e iniciando el temporizador de usuario para su servicio: 

```bash
root@debian:~# systemctl enable apagado.timer
root@debian:~# systemctl start apagado.timer
```

2. Mostrar todos los temporizadores activos:

```bash
root@debian:~# systemctl list-timers
NEXT                        LEFT        LAST     PASSED     UNIT               ACTIVATES
---------------------------------------------------------------------------------------------------
. . .
Fri 2025-01-03 13:30:00 CST 23h left    -        -          apagado.timer      apagado.service
. . .
```

Donde:

- **NEXT.** El momento en el que se ejecutará el temporizador la próxima vez. 
- **LEFT.** El tiempo que queda hasta la próxima ejecución del temporizador.
- **LAST.** El momento en el que se ejecutó el temporizador por última vez.
- **PASSED.** El tiempo transcurrido desde la última ejecución del temporizador.
- **UNIT.** El nombre de la unidad de temporizador.
- **ACTIVATES.** El nombre del servicio que activa el temporizador.

Como ya se ejecuto el script nos muestra que:

- **NEXT.** La próxima vez se ejecutará mañana viernes (hoy es jueves).
- **LEFT.** Faltan 23 horas para que se ejecute nuevamente.

3. Mostrar el ESTADO DEL TEMPORIZADOR

```bash
root@debian:~# systemctl status apagado.timer
? apagado.timer - "Turn off the computer at 00:30 minutes daily"
     Loaded: loaded (/etc/systemd/system/apagado.timer; enabled; preset: enabled)
     Active: active (waiting) since Thu 2025-01-02 13:49:07 CST; 8min ago
    Trigger: Fri 2025-01-03 13:30:00 CST; 23h left
   Triggers: ? apagado.service
 ene 02 13:49:07 debian systemd[1]: Started apagado.timer - "Turn off the computer at 00:30 minutes daily".
```

## SI QUEREMOS EDITAR EL TIMER POR ALGUN MOTIVO:

1. Editamos el archivo.
2. Ahora haga una ejecución de prueba del trabajo [OPCIONAL]:

```bash
root@debian:~# systemctl start apagado.service
root@debian:~#
```

El equipo se deberá apagar.

3. Una vez que el trabajo funcione correctamente, prográmelo de verdad habilitando e iniciando el temporizador de usuario para su servicio: 

```bash
root@debian:~# systemctl enable apagado.timer
root@debian:~# systemctl start apagado.timer
```

4. Mostrar todos los temporizadores activos:

```bash
root@debian:~# systemctl list-timers
NEXT                          LEFT            LAST     PASSED     UNIT               ACTIVATES
-------------------------------------------------------------------------------------------------------
Thu 2025-01-02 14:10:00 CST   2min 25s left   -        -          apagado.timer      apagado.service
```

Ahora nos muestra que:

- **NEXT.** La proxima vez que se ejecutará será el jueves (hoy es jueves)
- **LEFT.** Faltan 2 minutos para que se ejecute.
- **LAST.** No muestra este dato.
- **PASSED.** No muestra este dato.
- **UNIT.** El nombre de la unidad de temporizador es apagado.timer
- **ACTIVATES.** El nombre del servicio que activa el temporizador es apagado.service 


**NOTA:** después de editar el archivo, debe ejecutar el siguiente comando para que systemd conozca los cambios en su configuración. Cada vez que modifique un archivo de los que se indican a continuación `/etc/systemd/system/`, debe ejecutar este comando.

```bash
root@debian:~# systemctl daemon-reload
```
