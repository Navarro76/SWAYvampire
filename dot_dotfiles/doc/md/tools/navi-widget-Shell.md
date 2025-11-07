# NAVI CON WIDGET SHELL

## 🚀 DESCRIPCIÓN

Instalación y configuración del widget de navi para integración nativa en el shell, permitiendo acceso rápido con atajos de teclado.

## ✅ VENTAJAS

- El historial del shell está correctamente completo (es decir, con el comando real que ejecutó en lugar de navi) y puedes editar el comando como desees antes de ejecutarlo.

## 💡WIDGET SHELL ES MEJOR SI:

- Principalmente trabajas en el prompt de comandos
- Quieres poder editar los comandos antes de ejecutarlos
- Prefieres atajos de teclado más simples

## 🛠️ INSTALACIÓN DEL WIDGET DE SHELL:

Para instalarlo, agrega esta línea a tu archivo tipo .bashrc:

```bash
# bash
eval "$(navi widget bash)"

# zsh
eval "$(navi widget zsh)"

# fish
navi widget fish | source

# elvish
eval (navi widget elvish | slurp)

# xonsh
# xpip install xontrib-navi # run in your xonsh session to install xontrib
xontrib load navi # add to your xonsh run control file
```

## 🔧 CÓMO FUNCIONA:

- Activación: Ctrl+G mientras estás en el prompt del shell.
- Solo disponible cuando tienes un prompt activo esperando comandos
- Modifica temporalmente tu línea de comandos actual

**Nota:** De forma predeterminada, Ctrl+G está asignado para iniciar navi

## ⚡ EJEMPLO:

```bash
# Estás escribiendo...
usuario@servidor:~$ git log --oneline -10

# Presionas Ctrl+G, buscas un comando git, seleccionas
# Vuelves a tu línea con el comando insertado:
usuario@servidor:~$ git push origin main

# Editas si quieres y presionas Enter
```

