veralias() {
    # 1. 'sed' elimina las primeras 2 líneas (cabeceras)
    # 2. 'fzf' permite buscar
    # 3. 'awk' limpia los separadores '|' para que se vea más estético al final
    cat "/home/alex/.dotfiles/shell/_ver/alias.txt" | sed '1,2d' | \
    fzf --height 40% --reverse --header "Buscador de Atajos (Esc para salir)" | \
    awk -F'|' '{print "\n\033[1;32mApp:\033[0m" $2 "\n\033[1;33mTecla:\033[0m" $3 "\n\033[1;34mInfo:\033[0m" $4 "\n"}'
}
