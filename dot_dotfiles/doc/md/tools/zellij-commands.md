# COMANDOS

## BÁSICOS

1. Versión de zellij

```bash
# Verificar la instalación
zellij --version
```
2. Iniciar zellij

```bash
# Inicia Zellij fresco
zellij
```

3. Limpiar sesiones

```bash
# Limpiar sesiones temporales
zellij kill-all-sessions
```

4. Configuraciones de layouts

```bash
# Usar tu versión personalizada
zellij --layout my-layout
zellij --layout compact

# Mostrar configuraciones
zellij setup --dump-layout compact
zellij setup --dump-layout default
zellij setup --dump-layout strider

# Crear layout a partir del layout default
zellij setup --dump-layout default > ~/.config/zellij/layouts/my-layout.kdl
```

## SESIONES

1. Crear sesión con nombre

```bash
# Crear sesión llamada "proyecto-ansible"
zellij --session proyecto-ansible

# O desde dentro de Zellij
Ctrl+o → :new-session --name proyecto-ansible
```

2. Listar sesiones activas

```bash
# Ver todas las sesiones existentes
zellij list-sessions

# Desde dentro de Zellij
Ctrl+o → :list-sessions
```

3. Conectarse a sesión existente

```bash
# Reconectar a una sesión
zellij attach proyecto-ansible

# O si solo hay una sesión:
zellij attach

# Desde terminal, forzar reconexión
zellij a --create proyecto-ansible
```

4. Cerrar/eliminar sesiones

```bash
# Cerrar sesión actual (sin eliminar)
Ctrl+o → :quit

# Eliminar sesión permanentemente
zellij kill-session proyecto-ansible

# Eliminar TODAS las sesiones
zellij kill-all-sessions
```

## CASOS DE USO PRÁCTICOS:

1. Para Tu Flujo de Trabajo con Guías

```bash
# Sesión dedicada para documentación
zellij --session guias

# Dentro: crear paneles para:
# - Panel 1: Editor con guías (nano)
# - Panel 2: Ejecutar comandos
# - Panel 3: Navegación de archivos
```

2. Sesiones por Proyecto

```bash
# Desarrollo Ansible
zellij --session ansible-dev

# Configuración sistema
zellij --session system-config

# Monitoreo
zellij --session monitoring
```

## Configuración Avanzada de Sesiones

1. Layouts Automáticos por Sesión

```bash
# Crea un archivo ~/.config/zellij/layouts/ansible.kdl:
nano ~/.config/zellij/layouts/ansible.kdl

layout {
    pane size=1 borderless=true {
        plugin location="zellij:tab-bar"
    }
    pane split_direction="vertical" {
        pane split_direction="horizontal" {
            pane name="editor" {
                command "nano"
                args "guia-ansible.md"
            }
            pane name="terminal" {
                command "bash"
            }
        }
        pane name="navegacion" {
            command "ls"
            args "-la"
        }
    }
}

# Luego inicia la sesión con el layout:
zellij --session ansible-work --layout ansible
```
2. Sesiones con Directorios Específicos

```bash
# Iniciar sesión en directorio específico
zellij --session docs --cwd ~/guias-trabajo
```

## Flujo de Trabajo Recomendado

1. Al Iniciar el Día:

```bash
# Ver qué sesiones tengo
zellij list-sessions

# Reconectar a mi sesión de trabajo
zellij attach proyecto-principal
```

2. Al Terminar:

```bash
# Simplemente cierro la terminal
# La sesión se mantiene viva automáticamente
```
3. Si la Terminal se Cierra por Error:

```bash
# Reconectar sin perder nada
zellij attach
```

## Ejemplo Real para Ti

```bash
# Crear sesión para tus guías Ansible
zellij --session ansible-guides

# Dentro, configurar:
# - Pestaña 1: Guías Samba
# - Pestaña 2: Guías Red  
# - Pestaña 3: Guías Ansible
# - Cada pestaña con paneles divididos

# Al desconectarte: todo se mantiene
# Al reconectarte: todo está exactamente igual
```



