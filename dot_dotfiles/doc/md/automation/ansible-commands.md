# Comandos básicos Ansible

## 🚀 Descripción

Referencia rápida de los comandos esenciales de Ansible para administración de sistemas, incluyendo ejemplos de uso común.

## 🔧 Prerrequisitos
- Sistema Operativo: Debian 13
- Usuario ansible con permisos sudo
- Entorno virtual para Ansible
- Conexión a Internet

## ⚠️ Recuerda estar en la carpeta adecuada

```bash
cd ~/ansible-project/ansible-vampire 
```

## 📋 Comandos para el Entorno virtual

```bash
# Entrar al entorno virtual ansible-env
ansible-env

# Salir del entorno virtual ansible-env
deactivate
```

## 📋 Comandos para ejecutar las tareas de los roles

```bash
# Tareas rol common
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "common"

# Tareas rol desktop
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "desktop"

# Tareas rol terminal
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "terminal"

# Tareas rol multimedia
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "multimedia"

# Tareas rol resources
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "resources"

# Tareas rol scripts
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "scripts"

# Tareas rol chezmoi
ansible-playbook -i inventory/hosts.ini playbook.yml --tags "chezmoi"
```
