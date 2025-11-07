# Fuentes con soporte emoji en Foot

## 🚀 Descripción

Instalación de fuentes con soporte emoji (fonts-symbola, Noto Color Emoji) y configuración de Foot para mostrar correctamente los iconos Unicode en documentos de guías técnicas Markdown.

## 🔧 Prerrequisitos

- Sistema Operativo: Debian 13
- Usuario root o con permisos sudo
- Conexión a Internet

## 📋 PASOS A SEGUIR:

1. Editar configuración de foot

```bash
# Abrimos archivo de configuración de foot
nano ~/.config/foot/foot.ini

# Agregamos o modificamos la línea de fuentes:
font=Monospace:size=11, Noto Color Emoji:size=11

# o
font=JetBrainsMono NF:size=11, Noto Color Emoji:size=11
```

2. Instalar fuentes

```bash
# Instalamos fuentes con soporte emoji
sudo apt install fonts-symbola
sudo apt install fonts-noto-color-emoji
```
