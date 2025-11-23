# SSH-KEY

Si quieres que Git ya no te pida usuario y contraseña nunca más, debes asegurarte de usar SSH keys o guardar tus credenciales HTTPS en un helper.

La opción con la SSH-KEY es la OPCIÓN RECOMENDADA. Usar SSH (no pedirá más contraseña)

## Generación de una nueva clave SSH

1. Genera una clave SSH con el algoritmo ed25519 (si no la tienes). **ED25519** es un algoritmo basado en curvas elípticas que sigue esta estructura de claves. Está optimizado para firmas digitales, lo que lo hace altamente eficiente en procesos criptográficos. Utiliza matemáticas avanzadas en criptografía de curvas elípticas para generar pares de claves seguras.

```bash
ssh-keygen -t ed25519 -C "tu_email@example.com"
```

Esto crea una nueva clave SSH, utilizando el correo electrónico proporcionado como etiqueta.

```bash
> Generating public/private ALGORITHM key pair.
```

Cuando se le solicite «Introducir un archivo donde guardar la clave», puede pulsar Intro para aceptar la ubicación predeterminada. Tenga en cuenta que si ya ha creado claves SSH, es posible que ssh-keygen le pida que sobrescriba otra clave; en ese caso, le recomendamos crear una clave SSH con un nombre personalizado. Para ello, escriba la ubicación predeterminada y sustituya id_ALGORITHM por el nombre de su clave personalizada.

```bash
> Enter a file in which to save the key (/home/YOU/.ssh/id_ALGORITHM):[Press enter]
```

2. Cuando se le solicite, escriba una contraseña segura. Para obtener más información, consulte la sección sobre cómo trabajar con contraseñas de claves SSH.

```bash
> Enter passphrase (empty for no passphrase): [Type a passphrase]
> Enter same passphrase again: [Type passphrase again]
```

## Añadir la tecla SSH al agente ssh

Antes de agregar una nueva clave SSH al agente ssh para administrar sus claves, debe haber comprobado si existen claves SSH existentes y generado una nueva clave SSH.

1. Inicia el agente ssh en el background

```bash
eval "$(ssh-agent -s)"
> Agent pid 59566
```

Dependiendo de tu entorno, puede que necesites usar un comando diferente. Por ejemplo, puede que necesites acceso de administrador ejecutando `sudo -s -H` antes de iniciar el agente SSH, o puede que necesites usar `exec ssh-agent bash` o `exec ssh-agent zsh` para ejecutar el agente SSH.

2. Añada su clave privada SSH al agente ssh.

Si creó su clave con un nombre diferente, o si está agregando una clave existente que tiene un nombre diferente, reemplace id_ed25519 en el comando con el nombre de su archivo de clave privada.

```bash
ssh-add ~/.ssh/id_ed25519
```

## Añadir la clave pública SSH a tu cuenta en GitHub

1. Copia la clave pública:

```bash
cat ~/.ssh/id_ed25519.pub
```

2. Agrégala en GitHub 

```bash
Icono de usuario → Settings → SSH and GPG keys → New SSH key
```

## Cambiar tu remoto de HTTPS a SSH

```bash
git remote set-url origin git@github.com:usuario/repositorio.git
```

Listo.
A partir de ahora nunca volverá a pedir usuario/contraseña.


## Cómo trabajar con contraseñas de claves SSH

Puedes proteger tus claves SSH y configurar un agente de autenticación para no tener que volver a introducir tu contraseña cada vez que las uses.

**Acerca de las contraseñas para claves SSH**

Con las claves SSH, si alguien obtiene acceso a tu ordenador, el atacante puede acceder a todos los sistemas que utilizan esa clave. Para añadir una capa adicional de seguridad, puedes agregar una contraseña a tu clave SSH. Para evitar introducir la contraseña cada vez que te conectes, puedes almacenarla de forma segura en la caché del agente SSH.

**Añadir o cambiar una contraseña**

Puedes cambiar la contraseña de una clave privada existente sin regenerar el par de claves escribiendo el siguiente comando:

```bash
$ ssh-keygen -p -f ~/.ssh/id_ed25519
> Enter old passphrase: [Type old passphrase]
> Key has comment 'your_email@example.com'
> Enter new passphrase (empty for no passphrase): [Type new passphrase]
> Enter same passphrase again: [Repeat the new passphrase]
> Your identification has been saved with the new passphrase.
```

Si su clave ya tiene una contraseña, se le pedirá que la ingrese antes de poder cambiarla por una nueva.

## OPCIÓN C: usar el helper del sistema (más seguro)

Linux (Gnome/KDE/etc.) puede guardar credenciales cifradas:

```bash
git config --global credential.helper libsecret
```


