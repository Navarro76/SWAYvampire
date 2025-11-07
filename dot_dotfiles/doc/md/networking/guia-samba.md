# Guía: Instalar Samba en Debian

## 📋 Prerrequisitos

- Sistema Debian 13
- Acceso sudo
- Conexión a Internet

## 🚀 INSTALACIÓN

```bash
sudo apt update
sudo apt install samba 
```

## 🔧 CONFIGURACIONES

1. Crear directorio a compartir

```bash
# Creamos la carpeta donde vamos a compartir los archivos.
mkdir /home/alex/compartida

# Establecemos permisos
chmod 777 /home/alex/compartida
```

2. Editar el archivo de configuración de samba

```bash
# Creamos backup del archivo original
sudo cp /etc/samba/smb.conf /etc/samba/smb.conf.orig

# Abrimos el archivo de configuración
sudo nano /etc/samba/smb.conf

# Al final del archivo insertamos:
[remoto]
   comment = compartida
   path = /home/alex/compartida
   valid users = alex
   browseable = yes
   guest ok = no
   writable = yes 
   public = yes

# Configuración de mi servidor:
[d1_Ironwolf]
   comment = disco Ironwolf 8T
   path = /mnt/disk1
   read only = no
   browsable = yes

[d2_Ironwolf]
   comment = disco Ironwolf 4T
   path = /mnt/disk2
   read only = no
   browsable = yes

[d3_seagete]
   comment = disco Seagete 4T
   path = /mnt/disk3
   read only = no
   browsable = yes
```

3. Guardar los cambios y reiniciar el servicio

```bash
# Reiniciamos el servicio samba
service smbd restart

# Verificamos que este activo y corriendo el servicio
sudo /etc/init.d/smbd status
```

## 🛠️ USUARIOS SAMBA

```bash
# Creamos usuario local en la maquina Linux
useradd alex

# Configumos la contraseña o password del usuario Samba
sudo smbpasswd -a alex

# Listamos los usuarios samba
sudo pdbedit -L

# Nos mostrara algo como:
alex:1000:Alex
```

## 📚 ADICIONAL

Una vez añadido el usuario a samba, podemos añadir otros parámetros adicionales al archivo /etc/samba/smb.conf para configurar los permisos de cada usuario.

**Ejemplo:**

```bash
[remoto] path=/carpeta
read only=yes/no (solo una de las 2 opciones)
guest ok=yes/no (solo una de las 2 opciones)
write list=usuario (aquí se ponen todos los usuarios que pueden
escribir en caso de que “read only=yes” esté habilitado)
```

**Dónde:**

- [remoto] path=/carpeta
- read only=yes/no (solo una de las 2 opciones)
- guest ok=yes/no (solo una de las 2 opciones)
- write list=usuario (aquí se ponen todos los usuarios que pueden escribir en caso de que “read only=yes” esté habilitado)
