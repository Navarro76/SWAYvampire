
# SWAYNC

## SOBRE NOTIFICADORES

| Notificador | Tiene systemd-user | ¿Usar exec? | ¿Usar systemd? |
|---------|-------------|---------|---------|
| SwayNC | ✔ Sí | NO (si usas systemd)  | ✔ Sí (recomendado)  |
| Dunst | ✔ Sí | NO (si usas systemd)  | ✔ Sí (recomendado) |
| Mako | No | ✔ SÍ | A menos que crees tu propio servicio |

En pocas palabras

- Si un notifier trae servicio systemd, mejor usar systemd.
- Si no trae, úsalo con exec.
- Nunca mezcles ambos métodos -> doble instancia -> glitches.

Así entiendes por qué SwayNC te daba problemas: estabas mezclando exec + systemd, y systemd dejaba el servicio en dead porque ya había una instancia corriendo.

## INSTALACIÓN:

```bash
# En debian
$ sudo apt install sway-notification-center
```

## FUNCIONAMIENTO DE SWAYNC

SwayNC instala automáticamente un servicio systemd de usuario, incluso cuando usas sway.

No importa que estés usando Sway (que no tiene systemd integration como Gnome/KDE): el servicio es de usuario, no del sistema gráfico, y systemd-user está disponible en Debian para cualquier entorno.

Al instalar SwayNC, se instala automáticamente:

El binario:

```bash
/usr/bin/swaync
```

El cliente:

```bash
/usr/bin/swaync-client
```

Su unidad systemd de usuario:

```bash
/usr/lib/systemd/user/swaync.service
```

## CONFIGURACIÓN INCORRECTA:

Si tienes activado el servicio systemd y también tienes exec swaync, entonces lanzas dos instancias del demonio.

En tu caso esto provoca:

- El servicio systemd está en estado dead (no corre)

```bash
$ systemctl --user status swaync.service
○ swaync.service - Swaync notification daemon
     Loaded: loaded (/usr/lib/systemd/user/swaync.service; enabled; preset: enabled)
     Active: inactive (dead)
       Docs: https://github.com/ErikReider/SwayNotificationCenter

$ ps aux | grep swaync
alex        1157  0.0  0.0   2680  1844 ?        S    07:51   0:00 sh -c swaync
alex        1160  0.0  0.4 593220 74784 ?        Sl   07:51   0:02 swaync
alex       19299  0.0  0.0  61860 11096 pts/1    T    08:29   0:00 journalctl --user -u swaync -f
alex       19718  0.0  0.0  61860 11108 pts/1    T    08:30   0:00 journalctl --user -u swaync -f
alex       51811  0.0  0.0   6548  2352 pts/2    S+   09:43   0:00 grep swaync
```

- La instancia ejecutada por sway no tiene logs en journalctl

```bash
journalctl --user -u swaync -f
```

- No se carga bien la integración de iconos Freedesktop
- SwayNC funciona, pero incompleto

Ese es EXACTAMENTE el problema que tenías.

## BUG CONOCIDO EN DEBIAN y ARCH

1) Desactivar autostart manual en `~/.config/sway/config`:

```bash
# exec swaync
```

2) Activar el daemon real

```bash
$ systemctl --user enable swaync.service
Created symlink '/home/alex/.config/systemd/user/graphical-session.target.wants/swaync.service' → '/usr/lib/systemd/user/swaync.service'.

$ systemctl --user start swaync.service
```

3) Comprobar

```bash
$ systemctl --user status swaync.service
× swaync.service - Swaync notification daemon
     Loaded: loaded (/usr/lib/systemd/user/swaync.service; enabled; preset: enabled)
     Active: failed (Result: exit-code) since Sat 2025-11-15 11:15:38 CST; 40s ago
 Invocation: b4636361fe5b4637aa9b6c4ef6484a10
       Docs: https://github.com/ErikReider/SwayNotificationCenter
    Process: 91993 ExecStart=/usr/bin/swaync (code=exited, status=1/FAILURE)
   Main PID: 91993 (code=exited, status=1/FAILURE)

nov 15 11:15:38 debian systemd[1065]: swaync.service: Scheduled restart job, restart counter is at 5.
nov 15 11:15:38 debian systemd[1065]: swaync.service: Start request repeated too quickly.
nov 15 11:15:38 debian systemd[1065]: swaync.service: Failed with result 'exit-code'.
nov 15 11:15:38 debian systemd[1065]: Failed to start swaync.service - Swaync notification daemon.

$ journalctl --user -xeu swaync.service
```

Esto confirma algo importante:

- **El servicio systemd falla antes de inicializar siquiera el backend de SwayNC.**
- **No aparece ningún error de Wayland, DBus o configuración.**

Eso indica una causa muy concreta:

- **Debian NO soporta iniciar SwayNC a través de systemd-user en sway (por defecto).**

Este es un bug conocido en Debian y Arch cuando Wayland + systemd-user no comparten variables como WAYLAND_DISPLAY, SWAYSOCK, etc.

Por eso tu servicio falla con exit code 1 sin más detalles.
El daemon se ejecuta correctamente solo cuando lo arrancas desde sway (como ya hacías antes).

**Conclusión:**

En sway, SwayNC NO debe ejecutarse mediante systemd-user en Debian.
Solo funciona correctamente mediante:

```bash
exec swaync
```
Y esto explica todo lo que viste:

- SwayNC sí trae un servicio systemd, pero no funciona correctamente en sway + Debian.
- Tu instancia ejecutada por sway funcionaba bien (por eso sí recibías notificaciones).
- Pero systemd no podía levantarla, y por eso parecía “dead”.

## CONFIGURACIÓN CORRECTA

1. Deshabilitar completamente el servicio systemd de swaync

```bash
$ systemctl --user disable --now swaync.service
Removed '/home/alex/.config/systemd/user/graphical-session.target.wants/swaync.service'.
The following unit files have been enabled in global scope. This means
they will still be started automatically after a successful disablement
in user scope:
swaync.service
```

2. Volver a tu método correcto. Coloca en `~/.config/sway/config`:

```bash
exec_always swaync
```

(`exec_always` se recomienda porque recarga swaync si recargas sway)



## RUTAS DE SERVICIOS

```bash
 ls ~/.config/systemd/user/*.service
 /home/alex/.config/systemd/user/dunst.service
 /home/alex/.config/systemd/user/mpdris2-rs.service
 /home/alex/.config/systemd/user/mpdris2-rs_backup.service
 /home/alex/.config/systemd/user/mpdris2-rs_fallido.service

 ls /etc/systemd/user/*.service
 default.target.wants   mpdris2-rs_backup.service
 dunst.service          mpdris2-rs_fallido.service
 mpdris2-rs.service    

 ls /usr/lib/systemd/user/*.service
 /usr/lib/systemd/user/at-spi-dbus-bus.service
 /usr/lib/systemd/user/dbus.service
 /usr/lib/systemd/user/dconf.service
 /usr/lib/systemd/user/dirmngr.service
 /usr/lib/systemd/user/filter-chain.service
 /usr/lib/systemd/user/foot-server.service
 /usr/lib/systemd/user/glib-pacrunner.service
 /usr/lib/systemd/user/gpg-agent.service
 /usr/lib/systemd/user/keyboxd.service
 /usr/lib/systemd/user/mpd.service
 /usr/lib/systemd/user/pipewire-pulse.service
 /usr/lib/systemd/user/pipewire.service
 /usr/lib/systemd/user/ssh-agent.service
 /usr/lib/systemd/user/swaync.service
 /usr/lib/systemd/user/systemd-exit.service
 /usr/lib/systemd/user/systemd-tmpfiles-clean.service
 /usr/lib/systemd/user/systemd-tmpfiles-setup.service
 /usr/lib/systemd/user/waybar.service
 /usr/lib/systemd/user/wireplumber.service
 /usr/lib/systemd/user/wireplumber@.service
 /usr/lib/systemd/user/xdg-desktop-portal-gtk.service
 /usr/lib/systemd/user/xdg-desktop-portal-rewrite-launchers.service
 /usr/lib/systemd/user/xdg-desktop-portal-wlr.service
 /usr/lib/systemd/user/xdg-desktop-portal.service
 /usr/lib/systemd/user/xdg-document-portal.service
 /usr/lib/systemd/user/xdg-permission-store.service
```


