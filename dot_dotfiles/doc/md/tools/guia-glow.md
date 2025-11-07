# GUÍA DE NAVEGACIÓN EN GLOW

## **MÉTODOS DE NAVEGACIÓN**

### 1. Modo Pager (Por Defecto - Similar a less)

```bash
# Abrir un archivo en modo pager
glow mi-documento.md
```

| Tecla | Acción |
|---------|-------------|
| `↑ ↓ ` | Desplazarse línea por línea |
| `Espacio` | Avanzar una página completa |
| `Enter ` | Avanzar una línea (a veces página) |
| `b` | Retroceder una página |
| `g` | Ir al inicio del documento |
| `G` | Ir al final del documento |
| `/ + texto ` | Buscar texto en el documento |
| `n` | Siguiente coincidencia en búsqueda |
| `N` | Anterior coincidencia en búsqueda |
| `q` | Salir de glow |


### 2. Modo TUI (Interfaz Interactiva)

```bash
# Forzar modo TUI (si no abre automáticamente)
glow -p mi-documento.md
```

| Tecla | Acción |
|---------|-------------|
| `↑ ↓ ` | Desplazarse línea por línea |
| `Espacio` | Avanzar página |
| `b` | Retroceder página |
| `g` | Ir al inicio |
| `G` | Ir al final |
| `?` | Mostrar ayuda con todos los atajos |
| `q` | Salir |
