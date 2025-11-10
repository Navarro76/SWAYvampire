# ZELLIJ

## 🚀 DESCRIPCIÓN

Zellij la alternativa a Tmux como multiplexador de tu terminal

Un espacio de trabajo terminal con baterías incluidas. Tiene la funcionalidad básica de un multiplexor de terminal (similar a tmux o screen) pero incluye muchas funciones integradas

## 🔧 PRERREQUISITOS:
- Sistema Operativo: Debian 13
- Usuario con permisos sudo
- Conexión a Internet

## MODOS DE ZELLIJ

Las combinaciones de teclas de Zellij se agrupan en diferentes modes, que constituyen una separación lógica destinada a reducir la carga mental y permitir duplicar atajos en diferentes situaciones. 

- **normal, locked, resize, pane, move, tab, scroll, search, entersearch, renametab, renamepane, session, tmux**

## INSTALACIÓN

1. Utilizar el script `~/.dotfiles/scripts/install-zellij.sh`:
 
```bash
# Accedemos al directorio 
cd ~/.dotfiles/scripts/

# Establecemos permisos de ejecución
chmod +x install-zellij.sh

# Ejecutamos el script
./install-zellij.sh
```

2. Otros métodos. 

```bash
# Nota: con cargo se tarda mucho en compilar.
```

## ARCHIVO DE CONFIGURACIÓN:

```bash
# Inicio rápido:
mkdir ~/.config/zellij
zellij setup --dump-config > ~/.config/zellij/config.kdl
```
**Nota:** En la mayoría de los casos, Zellij creará automáticamente el archivo mencionado anteriormente la primera vez que se ejecute. Asegúrese de comprobar primero si existe. 

## 🎯 INSTRUCCIONES DE USO:

**► INICIAR ZELLIJ:**

```bash
# Inicio rápido:
mkdir ~/.config/zellij
zellij setup --dump-config > ~/.config/zellij/config.kdl
```

**► CONFIGURACIÓN:**

```bash
nano ~/.config/zellij/config.kdl
```

**► ATAJOS PRINCIPALES:**

| Atajo | Acción |
|---------|-------------|
| `Ctrl + n` | Abrir navi (desde cualquier panel) | 
| `Ctrl + t` | Nueva pestaña| 
| `Ctrl + =` | Dividir verticalmente| 
| `Ctrl + -` | Dividir horizontalmente| 
| `Ctrl + q` | Salir| 

**► COMANDOS:**

| Comando | Acción |
|---------|-------------|
| `zellij --help` | Ver ayuda completa| 
| `setup --check` | Verificar configuración| 
| `zellij list-sessions ` | Listar sesiones activas| 


## ATAJOS 

1. **RESIZE (Redimensionar)** `Ctrl + n`

| Atajo | Acción |
|---------|-------------|
| `Ctrl + n` | **Cambiar a modo "Normal"** | 
| `h` `←`| Aumentar a la `izquierda`| 
| `j` `↓`| Aumentar hacia `abajo`| 
| `l` `→`| Aumentar a la `derecha`|
| `k` `↑`| Aumentar hacia `arriba`|
| `H` | Disminuir a la `izquierda`| 
| `J` | Disminuir hacia `abajo`| 
| `L` | Disminuir a la `derecha`|
| `K` | Disminuir hacia `arriba`|
| `=` `+`| Redimensionar: `aumentar`|
| `-` | Redimensionar: `disminuir`|

2. **PANE** `Ctrl + p`

| Atajo | Acción |
|---------|-------------|
| `Ctrl + p` | **Cambiar a modo "Normal"** | 
| `h` `←`| Mover el foco a la `izquierda`| 
| `l` `→`| Mover el foco a la `derecha`|
| `j` `↓`| Mover el foco hacia `abajo`| 
| `k` `↑`| Mover el foco hacia `arriba`|
| `p` | Cambiar el foco|
| `n` | Nuevo panel: *Cambiar a modo "Normal"*| 
| `d` | Nuevo panel hacia `abajo`: *Cambiar a modo "Normal"*| 
| `r` | Nuevo panel hacia la `derecha`: *Cambiar a modo "Normal"*|
| `s` | Nuevo panel `apilado`: *Cambiar a modo "Normal"*|
| `x` | Cerrar el foco: *Cambiar a modo "Normal"*|
| `f` | Alternar pantalla completa; *Cambiar a modo "Normal"*|
| `z` | Activar/desactivar marcos del panel; *Cambiar a modo "Normal"*|
| `w` | Activar/desactivar paneles flotantes; *Cambiar a modo "Normal"*|
| `e` | Activar/desactivar panel incrustado o flotante; *Cambiar a modo "Normal"*|
| `c` | Cambiar a modo "Renombrar panel"; Nombre del panel: 0|
| `i` | Activar/desactivar panel anclado; *Cambiar a modo "Normal"*|

3. **MOVE** `Ctrl + h`

| Atajo | Acción |
|---------|-------------|
| `Ctrl + h` | **Cambiar a modo "Normal** | 
| `n` `Tab`  | Mover panel| 
| `p` | Mover panel hacia `atrás`| 
| `h` `←`| Mover panel a la `izquierda`| 
| `j` `↓`| Mover panel hacia `abajo`| 
| `k` `↑`| Mover panel hacia `arriba`|
| `l` `→`| Mover panel a la `derecha`|

4. **TAB** `Ctrl + t`

| Atajo | Acción |
|---------|-------------|
| `Ctrl + t` | **Cambiar a modo "Normal** | 
| `r` | Cambiar a modo "Renombrar pestaña"; Introducir nombre de pestaña 0| 
| `h` `←` `k` `↑` | Ir a la pestaña `anterior`| 
| `l` `→` `j` `↓`| Ir a la pestaña `siguiente`| 
| `n` | Nueva pestaña; **Cambiar a modo "Normal"**| 
| `x` | Cerrar pestaña; **Cambiar a modo "Normal"**|
| `s` | Alternar pestaña de ActiveSync; **Cambiar a modo "Normal"**|
| `b` | Romper panel; *Cambiar a modo "Normal"*|
| `]` | Romper panel a la `derecha`; *Cambiar a modo "Normal"*| 
| `[` | Romper panel a la `izquierda`; *Cambiar a modo "Normal"*|
| `1` | Ir a la pestaña `1`; *Cambiar a modo "Normal"*|
| `2` | Ir a la pestaña `2`; *Cambiar a modo "Normal"*|
| `3` | Ir a la pestaña `3`; *Cambiar a modo "Normal"*|
| `4` | Ir a la pestaña `4`; *Cambiar a modo "Normal"*|
| `5` | Ir a la pestaña `5`; *Cambiar a modo "Normal"*|
| `6` | Ir a la pestaña `6`; *Cambiar a modo "Normal"*|
| `7` | Ir a la pestaña `7`; *Cambiar a modo "Normal"*|
| `8` | Ir a la pestaña `8`; *Cambiar a modo "Normal"*|
| `9` | Ir a la pestaña `9`; *Cambiar a modo "Normal"*|
| `Tab` | Alternar pestaña|
