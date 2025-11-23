# GITHUB 
(https://github.com/ErikReider/SwayNotificationCenter?tab=readme-ov-file)

## INSTALACIÓN

```bash
# Debian
sudo apt install sway-notification-center
```

## USO DE SWAY
```bash
# Notification Daemon
exec swaync

# Toggle control center
bindsym $mod+Shift+n exec swaync-client -t -sw

# Recargar la configuración (config.json)
swaync-client -R

# Recargar solo el CSS del tema
swaync-client -rs
```

## RUN 

Para iniciar el demonio (recuerda matar cualquier otro demonio de notificación antes de correr)

```bash
./build/src/swaync
```

Para alternar el panel

```bash
./build/src/swaync-client -t
```

Para recargar la configuración

```bash
./build/src/swaync-client -R
```

Para recargar css después de los cambios

```bash
./build/src/swaync-client -rs
```

## ACCESOS DIRECTOS DEL CENTRO DE CONTROL

- **Up/Down:** Navegue por las notificaciones
- **Home:** Navegar a la última notificación
- **End:** Navegar a la notificación más antigua
- **Escape/Caps_Lock:** Cerrar el panel de notificaciones
- **Return:** Ejecute la acción predeterminada o cierre la notificación si ninguna
- **Delete/BackSpace:** Cerrar la notificación
- **Shift+C:** Cierra todas las notificaciones
- **Shift+D:** Toggle No Molestar
- **Buttons 1-9:** Ejecutar acciones alternativas
- **Left click button/actions:** Activar la acción de notificación
- **Middle/Right click notification:** Cerrar notificación

## CONFIGURACIÓN

El archivo de configuración principal se encuentra en `/etc/xdg/swaync/config.json`. Cópielo a su carpeta `.config/swaync/` para personalizarlo sin necesidad de permisos de administrador. Consulte la página del manual de `swaync(5)` para obtener más información.

Para recargar la configuración, ejecute `swaync-client --reload-config`.

El archivo de estilo CSS principal se encuentra en `/etc/xdg/swaync/style.css`. Cópielo a su carpeta `~/.config/swaync/` para personalizarlo sin necesidad de permisos de administrador. Para temas más complejos o de mayor tamaño, se recomienda usar los archivos SCSS del código fuente y personalizarlos. Para usar los archivos SCSS, compile con sassc.

**Tip:** ejecutar `swaync` con `GTK_DEBUG=interactive` abrirá una ventana de inspector que le permitirá ver todas las clases CSS y otra información.

## TOGGLE BUTTONS

Para añadir botones Toggle a tu centro de control, puedes configurar el "type" de cualquier acción como "toggle". El botón Toggle admite diferentes comandos según su estado y un "update-command" para actualizar el estado en caso de cambios externos a SwayNC. El update-command se ejecuta cada vez que se abre el centro de control. El botón Toggle activo también adquiere la clase CSS ".toggle:checked".

Ejemplo `config.json`:

```bash
{
  "buttons-grid": { // also works with actions in menubar widget
    "actions": [
      {
        "label": "WiFi",
        "type": "toggle",
        "active": true,
        "command": "sh -c '[[ $SWAYNC_TOGGLE_STATE == true ]] && nmcli radio wifi on || nmcli radio wifi off'",
        "update-command": "sh -c '[[ $(nmcli radio wifi) == \"enabled\" ]] && echo true || echo false'"
      }
    ]
  }
}
```

## INHIBICIÓN DE NOTIFICACIÓN

Las notificaciones se pueden inhibir mediante el ejecutable `swaync-client` o a través de la interfaz DBus `org.erikreider.swaync.cc`.

Aquí se muestra un ejemplo de inhibición de notificaciones al compartir pantalla mediante `xdg-desktop-portal-wlr`.

```bash
# xdg-desktop-portal-wlr config
[screencast]
exec_before=swaync-client --inhibitor-add "xdg-desktop-portal-wlr"
exec_after=swaync-client --inhibitor-remove "xdg-desktop-portal-wlr"
```

## PROGRAMACIÓN DE SCRIPTS

Reglas y lógica de programación de scripts:

**Solo se puede ejecutar un script por notificación**. Cada script requiere el permiso `exec` y al menos una de las demás propiedades. Todas las propiedades listadas deben coincidir con la notificación para que el script se ejecute. Si alguna de las propiedades no coincide, el script se omitirá. Si una notificación no incluye alguna de las propiedades, esa propiedad se omitirá. Si un script tiene la opción `run-on` configurada como `action`, el script solo se ejecutará cuando se realice una acción sobre la notificación.

Para obtener más información, consulte la página del manual de `swaync(5)`.

La información de la notificación se puede imprimir en una terminal ejecutando `G_MESSAGES_DEBUG=all swaync` (cuando aparezca una notificación).

Propiedades de configuración:

```bash
{
  "scripts": {
    "example-script": {
      "exec": "Your shell command or script here...",
      "app-name": "Notification app-name Regex",
      "summary": "Notification summary Regex",
      "body": "Notification body Regex",
      "urgency": "Low or Normal or Critical",
      "category": "Notification category Regex"
    }
  }
  // other non scripting properties...
}
```

Ejemplo de `config.json`:

```bash
{
  "scripts": {
    // This script will only run when Spotify sends a notification containing
    // that exact summary and body
    "example-script": {
      "exec": "/path/to/myRickRollScript.sh",
      "app-name": "Spotify",
      "summary": "Never Gonna Give You Up",
      "body": "Rick Astley - Whenever You Need Somebody"
    }
  }
  // other non scripting properties...
}
```

## DESHABILITAR SCRIPTS

Para deshabilitar completamente los scripts, el proyecto debe compilarse de la siguiente manera:

```bash
meson build -Dscripting=false
ninja -C build
meson install -C build
```

## EJEMPLO WAYBAR

Este ejemplo requiere una fuente de Nerd Fonts para que los iconos se vean correctamente.

Archivo config de Waybar

```bash
"custom/notification": {
  "tooltip": true,
  "format": "<span size='16pt'>{icon}</span>",
  "format-icons": {
    "notification": "󱅫",
    "none": "󰂜",
    "dnd-notification": "󰂠",
    "dnd-none": "󰪓",
    "inhibited-notification": "󰂛",
    "inhibited-none": "󰪑",
    "dnd-inhibited-notification": "󰂛",
    "dnd-inhibited-none": "󰪑"
  },
  "return-type": "json",
  "exec-if": "which swaync-client",
  "exec": "swaync-client -swb",
  "on-click": "swaync-client -t -sw",
  "on-click-right": "swaync-client -d -sw",
  "escape": true
},
```

Archivo CSS de Waybar

```bash
#custom-notification {
  font-family: "NotoSansMono Nerd Font";
}
```

Como alternativa, se puede mostrar el número de notificaciones añadiendo {0} en cualquier parte del campo de formato en la configuración de la barra de notificaciones.

```bash
"custom/notification": {
  "format": "{0} {icon}",
  // ...
},
```

Variables de entorno de depuración

- **G_MESSAGES_DEBUG=all:** Muestra todos los mensajes de depuración.
- **GTK_DEBUG=interactive:** Abre el Inspector GTK.
- **G_ENABLE_DIAGNOSTIC=1:** Si se establece en un valor distinto de cero, esta variable de entorno habilita los mensajes de diagnóstico, como los mensajes de obsolescencia para las propiedades y señales de GObject.
- **G_DEBUG=fatal_criticals** o **G_DEBUG=fatal_warnings**: Hace que GLib finalice la ejecución del programa en la primera llamada a g_warning() o g_critical().













