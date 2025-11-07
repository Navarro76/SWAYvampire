# NAVI

## 🚀 DESCRIPCIÓN

Introducción a navi: herramienta interactiva que proporciona acceso rápido a comandos mediante hojas de referencia navegables con búsqueda en tiempo real.

## ✅ VENTAJAS

- Te evitará saber los CLI de memoria
- Te evitará tener que copiar y pegar el resultado de los comandos intermedios
- Te hará escribir menos
- Te enseñará nuevas frases ingeniosas

## 🔧 PRERREQUISITOS
- Sistema Operativo: Debian 13
- Usuario alex con permisos sudo
- Conexión a Internet

## 🛠️ INSTALACIÓN

```bash
# Usando el script de instalación
bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)

# (optional) to set directories:
BIN_DIR=/usr/local/bin bash <(curl -sL https://raw.githubusercontent.com/denisidoro/navi/master/scripts/install)
```

## 📋 USOS

Hay varias formas de utilizar navi:

1. Escribiendo navi en la terminal
   - *Ventajas*: tienes acceso a todos los subcomandos y banderas posibles.
2. Como un widget de shell para la terminal
   - *Ventajas*: el historial del shell está correctamente completo (es decir, con el comando real que ejecutó en lugar de navi) y puede editar el comando como desee antes de ejecutarlo
3. Como un widget Tmux
   - *Ventajas*: puedes usar tus hojas de trucos en cualquier aplicación de línea de comandos, incluso en sesiones SSH
4. Como alias
5. Como herramienta de scripting de shell
6. Como un flujo de trabajo de Alfred

