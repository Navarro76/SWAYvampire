# 03. Ansible - Proyecto

## 🚀 Descripción

Esta guía cubre la obtención del repositorio personal que contiene todos los roles y playbooks de Ansible para desplegar automáticamente un entorno de escritorio Sway completo. Incluye la creación del directorio de trabajo, clonación del repositorio y verificación de la rama correcta antes de proceder con la instalación masiva de software y configuración del sistema.

## 🔧 Prerrequisitos
- Sistema Operativo: Debian 13
- Usuario ansible con permisos sudo
- Conexión a Internet
- Paquete git instalado

## 📋 PASOS A SEGUIR:

1. Verificar si git está instalado

```bash
# Comprobamos si git está instalado
apt search git

# Si no tenemos instalado git
sudo apt update
sudo apt install git
```

2. Crear el directorio del proyecto

```bash
# Creamos el directorio ~/ansible-project
mkdir -p ~/ansible-project

# Entramos al directorio
cd ~/ansible-project
```

3. Clonar el repositorio 

```bash
# Clonamos el repositorio específico de la rama ansible-vm13-sway
git clone -b ansible-vm13-sway https://github.com/Navarro76/ansible-vampire.git
```

4. Verificar rama

```bash
# Entramos al directorio
cd ansible-vampire

# Verificamos que estamos en la rama correcta
git branch
```

