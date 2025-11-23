# CHEZMOI

## INSTALACIÓN

```bash
# Instalamos chezmoi
alex@trixie:~$ sh -c "$(wget -qO- get.chezmoi.io)"
```
> No es necesario instalar chezmoi como root.

```bash
# Revisamos la versión
alex@trixie:~$ ~/bin/chezmoi --version
```

## SUBIR LOS DOTFILES 

```bash
# Ve al directorio de chezmoi
alex@trixie:~/.config/bin$ cd ~/.local/share/chezmoi

# Inicializa Git (si aún no lo hiciste)
alex@trixie:~/.local/share/chezmoi$ git init 

# Cambia el nombre de la rama a main (opcional, recomendado por GitHub):
alex@trixie:~/.local/share/chezmoi$ git branch -m main

# Agrega tu repositorio remoto:
alex@trixie:~/.local/share/chezmoi$ git remote add origin https://github.com/Navarro76/SWAYvampire.git

# Si ya tenías uno configurado y quieres reemplazarlo:
alex@trixie:~/.local/share/chezmoi$ git remote set-url origin 

# Agrega todos los archivos:
alex@trixie:~/.local/share/chezmoi$ git add .

# Verifica el estado:
alex@trixie:~/.local/share/chezmoi$ git status

# Haz un commit:
alex@trixie:~/.local/share/chezmoi$ git config --global user.email "alexnm76@gmail.com"
alex@trixie:~/.local/share/chezmoi$ git config --global user.name "Navarro76"
alex@trixie:~/.local/share/chezmoi$ git commit -m "Primer commit de dotfiles con chezmoi"

# Sube al repositorio en GitHub:
alex@trixie:~/.local/share/chezmoi$  git push -u origin main
```

## ELIMINAR ARCHIVOS 

```bash
~/bin/chezmoi destroy ~/.config/foot/INSTALL.md
~/bin/chezmoi destroy ~/.config/foot/LICENSE
~/bin/chezmoi destroy ~/.config/foot/README.md
~/bin/chezmoi destroy ~/.config/foot/screenshot.png

# Si queremos mantener los archivos locales:
~/bin/chezmoi forget ~/.config/bin/chezmoi-import.sh
```

## ESTABLECER ALIASES  

```bash
alias chezmoi="~/bin/chezmoi"

alias ll='lsd -lh --group-dirs=first'
alias la='lsd -a --group-dirs=first'
alias l='lsd --group-dirs=first'
alias lla='lsd -lha --group-dirs=first'
alias ls='lsd --group-dirs=first'
alias cat='/bin/batcat --paging=never'
alias catn='cat'
alias catnl='batcat'
alias ch="~/bin/chezmoi"
alias che="~/bin/chezmoi edit"
alias chea="~/bin/chezmoi edit --apply"
alias cha="~/bin/chezmoi add"
alias chap="~/bin/chezmoi apply"

# Luego recarga:
source ~/.zshrc 
```

## EDITAR ARCHIVOS EXISTENTES

```bash
~/bin/chezmoi edit ~/.zshrc

# Aplica los cambios automáticamente al salir del editor.
chezmoi edit --apply ~/.zshrc: 

# Aplica los cambios automáticamente cada vez que guardas el archivo.
chezmoi edit --watch ~/.zshrc: 

# Configurar el editor
nano ~/.config/chezmoi/chezmoi.toml

[edit]
  command = "nano"
```

## AGREGAR NUEVOS ARCHIVOS

```bash
~/bin/chezmoi add ~/.config/nvim/init.vim
```

## GUARDAR Y SINCRONIZAR CAMBIOS

Después de editar o agregar archivos, debes confirmar y sincronizar los cambios en tu repositorio Git.

```bash
# 1. Navegar al directorio fuente de chezmoi
~/bin/chezmoi cd

# 2. Añadir, confirmar y subir los cambios
git add .
git commit -m "feat: agregar configuración de nvim"
git push

# 3. Regresar al directorio anterior
exit
```
 
## APLICAR CAMBIOS EN OTRA MÁQUINA

```bash
~/bin/chezmoi update
~/bin/chezmoi chezmoi apply 
```

1. Hacer backup de dotfiles: 

Recuerda renombrar archivos dotfiles para evitar problemas o hacer backup de los dotfiles existentes antes de aplicar Chezmoi.

```bash
# Crear directorio de backup
mkdir ~/dotfiles-backup-$(date +%Y%m%d)

# Hacer backup de archivos críticos
cp ~/.zshrc ~/dotfiles-backup-$(date +%Y%m%d)/
cp ~/.bashrc ~/dotfiles-backup-$(date +%Y%m%d)/
cp -r ~/.config/* ~/dotfiles-backup-$(date +%Y%m%d)/config/ 2>/dev/null || true
```

2. Iniciar y aplicar 

```bash
# Aplicar directamente desde tu repositorio GitHub
chezmoi init --apply https://github.com/Navarro76/SWAYvampire.git

# Opción más sencialla
chezmoi init --apply Navarro76/SWAYvampire.git

# Si necesitas una rama específica
chezmoi init --apply https://github.com/Navarro76/SWAYvampire.git --branch main
```

> También se puede hace en dos paso:

```bash
# --- Método en dos pasos ---
# 1. Inicializar repositorio
chezmoi init https://github.com/Navarro76/SWAYvampire.git
chezmoi init Navarro76/SWAYvampire.git

# 2. Aplicar los dotfiles
chezmoi apply
```

## VERIFICAR ANTES DE APLICAR

```bash
# Ver qué se va a aplicar
chezmoi diff

# Ver estado actual
chezmoi status

# Si necesitas forzar sobreescribir:
chezmoi apply --force
```

## FLUJO COMPLETO TÍPICO

```bash
# 1. Inicializar y aplicar
chezmoi init --apply tu-usuario-github

# 2. Verificar que todo se aplicó
chezmoi status

# 3. Si hay problemas, diagnosticar
chezmoi doctor

# 4. Para futuras actualizaciones
chezmoi update
```

Puedes ejecutarlo desde CUALQUIER directorio 
No necesitas estar en el directorio de Chezmoi.
