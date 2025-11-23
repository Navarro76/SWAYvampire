
# ANSIBLE NODOS GESTIONADOS

## Requisitos nodos gestionados:

- Tener python instalado
- Tener SSH
- Crear un usuario con permisos de SUDO para poder lanzar comandos como root.
- Copiar las claves SSH del usuario con el que vayamos a trabajar.
- Maquinas virtuales para poder hacer las prácticas.


## Configurar SSH para usuario root

1. Generamos el par de claves publica-privada en el **Control Node**. Este comando crea el directorio .ssh donde se crean todas las claves ssh y dentro va a generar dos ficheritos, el `id_rsa` que contiene la clave privada y el `id_rsa.pub` que contiene la clave publica que es la que tengo que pasar al nodo remoto.

```bash
root@debian:~# ssh-keygen
Enter file in which to save the key (/root/.ssh/id_rsa): y
created directory '/root/.ssh'.
Enter passphrase (empty for no passphrase)
Enter same passphrase again:
Your identification has been saved in /root/.ssh/id_rsa
Your public key has been saved in /root/.ssh/id_rsa.pub
The key fingerprint is:
```

2. Creamos el directorio `.ssh` en el Manage Node.

```bash
root@gestionado:~# mkdir .ssh
root@gestionado:~# cd .ssh
root@gestionado:.ssh# 
```

3. Ahora desde el **Control Nodes** copiamos la clave al **Manage Node**

```bash
root@debian:~# cd .ssh
root@debian:.ssh# ssh-copy-id 192.168.1.5
. . .
This key is not known by any other names
Are you sure want to continue connecting (yes/no/[fingerprint])? yes
. . .
root@192.168.1.8's password: 
root@debian:.ssh#
```

4. Revisamos en el **Manage Node** la clave que acabamos de copiar.

```bash
root@gestionado:.ssh# ls
authorized_keys
root@gestionado:.ssh# cat authorized_keys
ssh-rsa
AAAAB3NzaC1yc2EAAAABIwAAAQEAmOWc0xMeFXogGrOxKJXVlYGy4pw2dmpnKHfE2lQ
YpuZpKyOhP3lSm6GPUVBGRtFATBG2WwifD5Xj1wUdheZYQ1UxeFP8A97d8PEhfhVADI
gG8rch3bLfrMlURwoxHimDBblSU4oTA/gKoJdlr5XAVbtYqYGFEse1nqq0ZCR24kj0h
/o/PAQ/lzF+0C+H4aYUkOnW5llJJPo7Xl70MlsEcg8y0wRUPTapjY2QCx1V9O8w8yp5
kZBHNIPCMcNPp7hgZCW3k97R4mRCPqZByyRHWSE2h1ngA12Mbsm0ZiW7kU56/A0eg8+
ZcPYiqougY5wWVCnBZc/JMoOp+o2io1JQVQ== la@la132.ibm.com
```

5. Comprobamos que nos podemos conectar al **Manage Node** desde el **Control Nodes**.

```bash
# No nos debe de pedir la clave
root@debian:.ssh# ssh 192.168.1.5
root@gestionado:~# exit
```

Con esto, si yo ahora utilizo Ansible para hacer las operaciones como root no me va a pedir un password porque al utilizar estas credenciales ssh entre las dos maquinas, las dos maquinas confian entre si.

## Crear usuario ansible y configurar ssh

1. En el **Manage Node** creamos al usuario ansible

```bash
root@gestionado:~# useradd ansible
```

2. Establecemos un password para este usuario

```bash
root@gestionado:~# passwd ansible
Changing password for user ansible.
New password:
Retype new password:
```

3. Comprobamos que en este sistema nos ha creado correctamente el directorio ansible

```bash
root@gestionado:~# ls /home/ansible
```

4. Ahora desde el**Control Nodes** con el usuario ansible (lo creamos si no existe) generamos las claves publicas y privadas.

```bash
ansible@debian:~$ ssh-keygen
```

5. Comprobamos que se hayan generado correctamente las claves.

```bash
ansible@debian:~$ cd .ssh
ansible@debian:~/.ssh$ ls -l
total 8
-rw------- 1 ansible ansible 2602 sep 27 16:10 id_rsa
-rw-r--r-- 1 ansible ansible  567 sep 27 16:10 id_rsa.pub
```

6. Copiamos la clave a la maquina remota

```bash
ansible@debian:~/.ssh$ ssh-copy-id 192.168.1.5
. . .
This key is not known by any other names
Are you sure want to continue connecting (yes/no/[fingerprint])? yes
. . .
ansible@192.168.1.8's password: 
ansible@debian:~/.ssh$
```

7. Comprobamos que nos podemos conectar al **Manage Node** desde el **Control Nodes**.

```bash
# No nos debe de pedir la clave
ansible@debian:~/.ssh$ ssh 192.168.1.5
ansible@gestionado:~$ 
```
