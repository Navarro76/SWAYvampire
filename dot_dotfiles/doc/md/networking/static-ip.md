# IP Estática

## 🚀 Descripción

Configuración manual de dirección IP estática en Debian, asegurando conectividad de red permanente sin depender de DHCP.

## 🔧 Prerrequisitos
- Sistema Operativo: Debian 13
- Usuario alex con permisos sudo
- Conexión a Internet

## 📋 PASOS A SEGUIR:

1. Conocer tu interface de red.

```bash
# Comprueba las interfaces de red que tienes en el equipo.
ip a
```

2. Edita el archivo de configuración de las interfaces de red:

```bash
sudo nano /etc/network/interfaces


# This file describes the network interfaces available on your system
# and how to activate them. For more information, see interfaces(5).

source /etc/network/interfaces.d/*

# The loopback network interface
auto lo
iface lo inet loopback

# The primary network interface
#allow-hotplug eth0
#iface eth0 inet dhcp
auto eth0
iface eth0 inet static
address 192.168.1.7
netmask 255.255.255.0
gateway 192.168.1.1
```

3. Reinicia las interfaces de red de tu ordenador para aplicar los cambios. 

```bash
sudo /etc/init.d/networking restart

# Para deshabilitar y habilitar la interfaz de red en caso de problemas:
sudo ifconfig eth0 down 
sudo ifconfig eth0 up
```

4. Comprueba conectividad en tu red local y a Internet.

```bash
# Usa el comando ping
ping -c 5 192.168.1.1 
ping -c 5 google.com 
```
