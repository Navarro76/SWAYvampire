#!/bin/bash
# install-zellij.sh - Instalación desde binario precompilado

set -e  # Detener en caso de error

echo "=================================================="
echo "  INSTALANDO ZELLIJ DESDE BINARIO PRECOMPILADO"
echo "=================================================="

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[OK]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[AVISO]${NC} $1"; }

# ============================================================================
# VERIFICACIONES INICIALES
# ============================================================================
print_status "Verificando sistema..."

# Verificar arquitectura
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
    echo -e "${RED}[ERROR] Arquitectura no soportada: $ARCH${NC}"
    echo "Solo se soporta x86_64 para el binario precompilado"
    exit 1
fi

# Verificar si ya está instalado
if command -v zellij &> /dev/null; then
    print_warning "Zellij ya está instalado. Versión actual:"
    zellij --version
    read -p "¿Continuar con la reinstalación? (s/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Ss]$ ]]; then
        echo "Instalación cancelada."
        exit 0
    fi
fi

# ============================================================================
# DESCARGAR BINARIO PRECOMPILADO
# ============================================================================
print_status "Obteniendo última versión de Zellij..."

# URL de descarga (última versión estable)
ZELLIJ_URL="https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz"
DOWNLOAD_FILE="zellij-latest.tar.gz"

# Descargar
print_status "Descargando binario desde GitHub..."
if command -v wget &> /dev/null; then
    wget -q --show-progress -O "$DOWNLOAD_FILE" "$ZELLIJ_URL"
elif command -v curl &> /dev/null; then
    curl -L --progress-bar -o "$DOWNLOAD_FILE" "$ZELLIJ_URL"
else
    echo -e "${RED}[ERROR] Se requiere wget o curl para la descarga${NC}"
    exit 1
fi

# Verificar descarga
if [ ! -f "$DOWNLOAD_FILE" ]; then
    echo -e "${RED}[ERROR] No se pudo descargar el archivo${NC}"
    exit 1
fi

# ============================================================================
# INSTALACIÓN
# ============================================================================
print_status "Instalando Zellij..."

# Descomprimir
print_status "Descomprimiendo archivo..."
tar -xzf "$DOWNLOAD_FILE" zellij

if [ ! -f "zellij" ]; then
    echo -e "${RED}[ERROR] No se encontró el binario después de descomprimir${NC}"
    exit 1
fi

# Hacer ejecutable
chmod +x zellij

# Mover a directorio en PATH
print_status "Moviendo binario a /usr/local/bin/"
sudo mv zellij /usr/local/bin/

# Limpiar archivo temporal
rm -f "$DOWNLOAD_FILE"

# ============================================================================
# VERIFICACIÓN
# ============================================================================
print_status "Verificando instalación..."

if command -v zellij &> /dev/null; then
    ZELLIJ_VERSION=$(zellij --version)
    print_success "Zellij instalado correctamente: $ZELLIJ_VERSION"
else
    echo -e "${RED}[ERROR] La instalación falló - zellij no encontrado en PATH${NC}"
    exit 1
fi

# ============================================================================
# CONFIGURACIÓN INICIAL
# ============================================================================
print_status "Configuración inicial..."

# Crear directorio de configuración si no existe
mkdir -p ~/.config/zellij

# Crear configuración básica con atajo para navi
if [ ! -f ~/.config/zellij/config.kdl ]; then
    print_status "Creando configuración básica..."
    cat > ~/.config/zellij/config.kdl << 'EOF'
// Configuración básica Zellij - Atajos personalizados
keybinds {
    normal {
        bind "Ctrl n" { Run "navi"; }
        bind "Ctrl t" { NewTab; }
        bind "Ctrl q" { Quit; }
        bind "Ctrl h" { MoveFocus "Left"; }
        bind "Ctrl j" { MoveFocus "Down"; }
        bind "Ctrl k" { MoveFocus "Up"; }
        bind "Ctrl l" { MoveFocus "Right"; }
        bind "Ctrl =" { Split "Vertical"; }
        bind "Ctrl -" { Split "Horizontal"; }
    }
}

// Tema y apariencia
theme "default"

// Barra de estado mejorada
ui {
    pane_frames {
        rounded_corners true
    }
}
EOF
    print_success "Configuración básica creada en ~/.config/zellij/config.kdl"
else
    print_warning "Configuración ya existe en ~/.config/zellij/config.kdl"
    print_status "Puedes agregar manualmente el atajo: bind \"Ctrl n\" { Run \"navi\"; }"
fi

# ============================================================================
# INFORMACIÓN FINAL
# ============================================================================
print_success "¡Instalación completada!"
echo ""
echo "=================================================="
echo "🎯 INSTRUCCIONES DE USO:"
echo "=================================================="
echo ""
echo "🚀 INICIAR ZELLIJ:"
echo "   zellij"
echo ""
echo "🎯 ATAJOS PRINCIPALES:"
echo "   Ctrl + n      → Abrir navi (desde cualquier panel)"
echo "   Ctrl + t      → Nueva pestaña"
echo "   Ctrl + =      → Dividir verticalmente"
echo "   Ctrl + -      → Dividir horizontalmente"
echo "   Ctrl + h/j/k/l → Navegar entre paneles"
echo "   Ctrl + q      → Salir"
echo ""
echo "🔧 CONFIGURACIÓN:"
echo "   ~/.config/zellij/config.kdl  → Archivo de configuración"
echo ""
echo "📚 MÁS COMANDOS:"
echo "   zellij --help                → Ver ayuda completa"
echo "   zellij setup --check         → Verificar configuración"
echo "   zellij list-sessions         → Listar sesiones activas"
echo ""
echo "=================================================="

# Preguntar si iniciar ahora
read -p "¿Quieres iniciar Zellij ahora? (s/n): " -n 1 -r
echo
if [[ $REPLY =~ ^[Ss]$ ]]; then
    echo "Iniciando Zellij..."
    zellij
else
    echo "Puedes iniciar después con: zellij"
fi
