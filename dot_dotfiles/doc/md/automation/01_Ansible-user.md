# 01. Ansible - usuario ansible

## 🚀 Descripción

Creación de un usuario dedicado 'ansible' con privilegios sudo controlados, siguiendo mejores prácticas de seguridad para la automatización.

## 🔧 Prerrequisitos
- Sistema Operativo: Debian 13
- Usuario root o con permisos sudo
- Conexión a Internet

## 📋 PASOS A SEGUIR:

1. Actualizar sistema
```bash
# Actualiza la lista de paquetes disponibles en el sistema.
root@debian:~# apt update
```

2. Instalar paquete sudo

```bash
# Instalar sudo.
root@debian:~# apt install sudo
```

3. Crear usuario ansible

```bash
# Crear el usuario ansible con su home y shell.
root@debian:~# useradd -m -s /bin/bash ansible

# Ponerle contraseña.
root@debian:~# passwd ansible
```

4. Darle permisos sudo al usuario ansible.

```bash
# Editamos /etc/sudoers
root@debian:~# sudo visudo

# Agregamos está línea al final del archivo
@includedir /etc/sudoers.d

# Creamos el archivo /etc/sudoers.d/99-ansible-nopasswd  
root@debian:~# nano /etc/sudoers.d/99-ansible-nopasswd

# Agregamos estas líneas
ansible ALL=(ALL) NOPASSWD:ALL
alex ALL=(ALL) NOPASSWD:ALL
```

5. Camabiar a usuario ansible

```bash
# Cambiarse a usuario ansible.
root@debian:~# su - ansible
```



