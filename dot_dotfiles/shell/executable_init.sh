# init.sh

ulimit -n 200000
ulimit -u 2048

# Enable aliases to be sudo'ed
alias sudo='sudo '

# Evita errores si una carpeta está vacía
setopt nullglob

# Register all aliases
for aliasToSource in "$DOTFILES_PATH/shell/_aliases/"*; do source "$aliasToSource"; done

# Register all exports
for exportToSource in "$DOTFILES_PATH/shell/_exports/"*; do source "$exportsToSource"; done

# Register all aliases
for functionToSource in "$DOTFILES_PATH/shell/_functions/"*; do source "$functionToSource"; done
