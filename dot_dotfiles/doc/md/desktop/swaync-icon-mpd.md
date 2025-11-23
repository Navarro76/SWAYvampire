
# SWAYNC PERSONALIZAR ICONO DE MPD

## DIAGNOSTICO DEL PROBLEMA

Tu SwayNC está siendo ejecutado dentro de sway, así que la iconificación funciona perfectamente una vez:

- sepamos qué app está enviando las notificaciones de MPD
- sepamos el nombre de icono Freedesktop que manda

Para eso ejecuta:

```bash
$ dbus-monitor "interface='org.freedesktop.Notifications'" 
signal time=1763229930.570243 sender=org.freedesktop.DBus -> destination=:1.26 serial=2 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=>
   string ":1.26"
signal time=1763229930.570262 sender=org.freedesktop.DBus -> destination=:1.26 serial=4 path=/org/freedesktop/DBus; interface=org.freedesktop.DBus; member=>
   string ":1.26"
```

Verás un montón de líneas.
Ahora cambia la canción en MPD.

```bash
method call time=1763229977.009491 sender=:1.5 -> destination=org.freedesktop.Notifications serial=1288 path=/org/freedesktop/Notifications; interface=org.freedesktop.Notifications; member=Notify
   string "Music Player Daemon"
   uint32 0
   string "/usr/share/icons/hicolor/scalable/apps/mpd.svg"
   string "Playing"
   string "<b>Marta Sanchez - Desesperada</b>"
   array [
      string "play-pause"
      string "⏸"
      string "next"
      string "⏭"
   ]
   array [
      dict entry(
         string "image-path"
         variant             string "/usr/share/icons/hicolor/scalable/apps/mpd.svg"
      )
      dict entry(
         string "urgency"
         variant             int32 0
      )
   ]
   int32 5000
```

Perfecto. Ya tenemos toda la información necesaria.

- **AppName** → "Music Player Daemon"
- **IconName / image-path** → "/usr/share/icons/hicolor/scalable/apps/mpd.svg"

Con esto ya queda claro por qué SwayNC usa el icono genérico en vez del tuyo:

**Motivo exacto del problema**

MPD está enviando el icono por ruta absoluta, no por nombre de ícono:

```bash
/usr/share/icons/hicolor/scalable/apps/mpd.svg
```

Esto hace que SwayNC ignore iconos personalizados en `~/.local/share/icons`, porque:

- cuando el cliente manda un icon path,
- el compositor debe usar esa ruta exacta
- y NO busca el icono por tema ni por nombre

Así que aunque tengas:

```bash
~/.local/share/icons/hicolor/scalable/apps/mpd.svg
```

SwayNC no lo va a usar nunca, porque MPD le dice estrictamente:

usa /usr/share/icons/hicolor/scalable/apps/mpd.svg

## SOLUCIONES

**OPCIÓN 1** — Reemplazar el icono del sistema (la más simple y efectiva)

Reemplaza el icono que MPD manda directamente:

```bash
sudo mv /usr/share/icons/hicolor/scalable/apps/mpd.svg \
        /usr/share/icons/hicolor/scalable/apps/mpd.svg.bak
```

Luego copia tu icono personalizado ahí:

```bash
sudo cp ~/.icons/ePapirus-Dark/48x48/apps/mpd.svg \
        /usr/share/icons/hicolor/scalable/apps/mpd.svg
```

Actualiza caché:

```bash
sudo gtk-update-icon-cache /usr/share/icons/hicolor
```

**OPCIÓN 2** — Evitar que MPD envíe “image-path”

Esto depende del cliente que uses para enviar notificaciones de MPD.

En tu salida se ve:

```bash
sender=:1.5
string "Music Player Daemon"
```

Esto casi siempre es:

- mpd-notification
- o algún script personalizado usando notify-send

Si usas `mpd-notification`, revisa su config:

```bash
~/.config/mpd-notification/config
```

Busca y comenta:

```bash
icon = /usr/share/icons/hicolor/scalable/apps/mpd.svg
```

O cámbiala a:

```bash
icon = mpd
```

Eso hará que mande un icon name en vez de un image path, permitiendo personalización.

**OPCIÓN 3** — Usar un script externo que fuerce tu icono

Si usas mpDris2, tienes:

```bash
~/.config/mpDris2/mpDris2.conf
```

Y puedes hacer:

```bash
[Notifications]
use-custom-icon=true
custom-icon=/ruta/a/tu/icono.svg
```

**COMPROBACIÓN**

Confirmación rápida (haz esto si quieres probar ahora mismo)

Ejecuta:

```bash
notify-send "Test" "MPD icon" -i /usr/share/icons/hicolor/scalable/apps/mpd.svg
```

Si ves el icono genérico → SwayNC no encuentra el icono.
Si ves tu icono personalizado → ¡funcionó!








