# GITHUB: NUEVA RAMA

## PASOS

1. Verifica en qué rama estás

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git branch
  ansible-vm13
* ansible-vm13-sway
```

2. Crea una nueva rama basada en lo que tienes ahora

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git checkout -b ansible-real13-sway
Cambiado a nueva rama 'ansible-real13-sway'
```

3. Agrega tus cambios

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git add .
```

4. Establecemos la identidad del autor (opcional si aún no están establecidos)

```bash
git config --global user.name "Alejandro Navarro"
git config --global user.email "alexnm76@gmail.com"
```

Verificación

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git config --list
core.repositoryformatversion=0
core.filemode=true
core.bare=false
core.logallrefupdates=true
remote.origin.url=https://github.com/Navarro76/ansible-vampire.git
remote.origin.fetch=+refs/heads/ansible-vm13:refs/remotes/origin/ansible-vm13
branch.ansible-vm13.remote=origin
branch.ansible-vm13.merge=refs/heads/ansible-vm13
branch.ansible-vm13-sway.remote=origin
branch.ansible-vm13-sway.merge=refs/heads/ansible-vm13-sway
```

5. Verfificamos el estado actual de la working directory y de la staging area

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git status
En la rama ansible-vm13-sway
Cambios no rastreados para el commit:
  (usa "git add/rm <archivo>..." para actualizar a lo que se le va a hacer commit)
  (usa "git restore <archivo>..." para descartar los cambios en el directorio de trabajo)
	modificados:     .gitignore
	modificados:     .vscode/settings.json
	modificados:     ansible.cfg
	modificados:     inventory/hosts.ini
	modificados:     playbook.yml
	modificados:     roles/common/README.md
	modificados:     roles/common/defaults/main.yml
	modificados:     roles/common/meta/main.yml
	modificados:     roles/common/tasks/install_env_packages.yml
	modificados:     roles/common/tasks/install_extra_packages.yml
	modificados:     roles/common/tasks/install_update.yml
	modificados:     roles/common/tasks/install_zig.yml
	modificados:     roles/common/tasks/main.yml
	modificados:     roles/desktop/README.md
        . . .
Archivos sin seguimiento:
  (usa "git add <archivo>..." para incluirlo a lo que será confirmado)
	roles/chezmoi/
	roles/common/tasks/install_cargo.yml
	roles/desktop/tasks/install_mako.yml
	roles/desktop/tasks/install_swaync.yml
	roles/multimedia/tasks/install_deadbeef.yml
	roles/multimedia/tasks/install_rmpc.yml

sin cambios agregados al commit (usa "git add" y/o "git commit -a")
```

6. Crea un commit con tu snapshot actual

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git commit -m "chore(ansible): migrar configuraciones a entorno real Debian 13 con sway"
```

7. Sube tu rama nueva a GitHub

```bash
ansible@debian:~/ansible-project/ansible-vampire$ git push origin ansible-real13-sway
Username for 'https://github.com': 
Password for 'https://Navarro76@github.com': 
Enumerando objetos: 97, listo.
Contando objetos: 100% (97/97), listo.
Compresión delta usando hasta 4 hilos
Comprimiendo objetos: 100% (68/68), listo.
Escribiendo objetos: 100% (74/74), 15.59 KiB | 1.42 MiB/s, listo.
Total 74 (delta 12), reused 0 (delta 0), pack-reused 0 (from 0)
remote: Resolving deltas: 100% (12/12), completed with 5 local objects.
remote:
remote: Create a pull request for 'ansible-vm13' on GitHub by visiting:
remote:      https://github.com/Navarro76/ansible-vampire/pull/new/ansible-vm13
remote:
To https://github.com/Navarro76/ansible-vampire.git
 * [new branch]      ansible-vm13 -> ansible-vm13
```

**Otra manera:**

```bash
git push --set-upstream origin ansible-real13-sway
```

Este comando hace lo mismo pero además establece el "upstream", para que después solo tengas que usar:

```bash
git push
git pull
```

**Resumen**

| Situación | Comando correcto |
|---------|-------------|
| Empujar la rama la primera vez | git push --set-upstream origin ansible-real13-sway |
| Empujar cambios posteriores  | git push o git push origin ansible-real13-sway |
| Confirmar en qué rama estás | git branch |

