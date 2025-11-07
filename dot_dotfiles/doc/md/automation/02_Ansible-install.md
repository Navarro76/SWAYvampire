# 01 Ansible - Instalación

## 🚀 Descripción

Instalación de Ansible dentro de un entorno virtual Python (venv) para aislar dependencias y evitar conflictos con otros paquetes del sistema.

## 🔧 Prerrequisitos
- Sistema Operativo: Debian 13
- Usuario ansible con permisos sudo
- Conexión a Internet

## 📋 INSTALACIÓN:

1. Requisitos previos

```bash
# Comprobar la versión de Python instalada.
ansible@debian:~$ python3 --version
Python 3.11.2

# Si no tenemos instalado python
ansible@debian:~$ sudo apt update
ansible@debian:~$ sudo apt install python3 python3-venv -y
```

2. Crear entorno virtual para Ansible.

```bash
# No ejecutes pip como root y sobreescribas los paquetes del sistema
# Crea el directorio venvs en home para guardar entornos virtuales de Python
ansible@debian:~$ mkdir -p ~/venvs
ansible@debian:~$ cd ~/venvs

# Crea un entorno virtual de Python llamado ansible-env
ansible@debian:~/venvs$ python3 -m venv ansible-env

# Activa el entorno virtual (ahora trabajas dentro de él)
ansible@debian:~/venvs$ source ansible-env/bin/activate

# Cuando esté activo, verás algo así en tu terminal:
(ansible-env) ansible@debian:~/venvs$
```

3. Actualizar pip a la última versión dentro del entorno.

```bash
# opcional pero recomendado
(ansible-env) ansible@debian:~/venvs$ pip install --upgrade pip  
```

4. Instalar Ansible dentro del entorno virtual.

```bash
(ansible-env) ansible@debian:~/venvs$ pip install ansible
```

## ✅ VERIFICACIONES:

```bash
# Revisa la versión de Ansible instalada (para verificar que la instalación fue correcta).
(ansible-env) ansible@debian:~/venvs$ ansible –version
ansible [core 2.18.4]
. . .

# Prueba Ansible ejecutando el módulo ping contra localhost.
(ansible-env) ansible@debian:~/venvs$ ansible localhost -m ping --connection=local
[WARNING]: No inventory was parsed, only implicit localhost is available
localhost | SUCCESS => {
    "changed": false,
    "ping": "pong"
}
# Esto confirma que Ansible funciona correctamente.
```

## 🛠️ ENTORNO VIRTUAL:

1. Comandos básicos:

```bash
# Para salir del entorno virtual ansible-env ejecuta.
(ansible-env) ansible@debian:~/venvs$ deactivate
ansible@debian:~/venvs$

# Ahora cada vez que quieras usar Ansible de nuevo, solo necesitas:
ansible@debian:~/venvs$ source ~/venvs/ansible-env/bin/activate
```

2. Alias en .bashrc o .zshrc

```bash
# Editamos el archivo de configuración de la shell (.bashrc o .zshrc) 
ansible@debian:~/venvs$ nano ~/.bashrc

# Añadimos un alias que active rápido el entorno virtual
alias ansible-env='source ~/venvs/ansible-env/bin/activate'

# Recargamos .bashrc para aplicar los cambios.
ansible@debian:~/venvs$ source ~/.bashrc  # Si usas Bash
ansible@debian:~/venvs$ source ~/.zshrc   # Si usas Zsh
```

3. Usar el alias

```bash
# Ahora, cada vez que quieras usar Ansible, solo escribes:
ansible@debian:~/venvs$ ansible-env
(ansible-env) ansible@debian:~/venvs$
```





