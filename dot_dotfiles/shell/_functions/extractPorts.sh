# extractPorts.zsh — función mejorada
extractPorts() {
  local file ip ports tmp copy_cmd

  # Validar argumento
  if [[ -z $1 || ! -r $1 ]]; then
    printf 'Usage: extractPorts <nmap-output-file>\n'
    return 2
  fi
  file=$1

  # Extraer puertos (usa grep/awk; si grep no soporta -P, puede fallar)
  # Intentamos usar grep -oP, si no está, fallback a perl
  if grep -oP . /dev/null >/dev/null 2>&1; then
    ports=$(grep -oP '\d{1,5}/open' "$file" | awk -F'/' '{print $1}' | xargs -r | tr ' ' ',')
    ip=$(grep -oP '\d{1,3}(?:\.\d{1,3}){3}' "$file" | sort -u | head -n1)
  else
    # fallback con perl-compatible one-liners
    ports=$(perl -nle 'print $1 if /(\d{1,5})\/open/' "$file" | xargs -r | tr ' ' ',')
    ip=$(perl -nle 'print $1 if /((?:\d{1,3}\.){3}\d{1,3})/' "$file" | sort -u | head -n1)
  fi

  # Si no hay puertos encontrados
  if [[ -z $ports ]]; then
    printf '[*] No open ports found in %s\n' "$file"
    return 1
  fi

  # Salida informativa
  tmp=$(mktemp /tmp/extractPorts.XXXXXX)
  {
    printf '\n[*] Extracting information...\n\n'
    printf '\t[*] IP Address: %s\n' "${ip:-N/A}"
    printf '\t[*] Open ports: %s\n\n' "$ports"
  } > "$tmp"

  # Copiar al clipboard: intentar wl-copy (Wayland) luego xclip (X11)
  if command -v wl-copy >/dev/null 2>&1; then
    printf '%s' "$ports" | wl-copy
    copy_cmd='wl-copy'
  elif command -v xclip >/dev/null 2>&1; then
    printf '%s' "$ports" | xclip -selection clipboard
    copy_cmd='xclip'
  else
    copy_cmd=''
  fi

  if [[ -n $copy_cmd ]]; then
    printf '[*] Ports copied to clipboard using %s\n\n' "$copy_cmd" >> "$tmp"
  else
    printf '[*] No clipboard tool found (install wl-clipboard or xclip) — ports not copied\n\n' >> "$tmp"
  fi

  # Mostrar y limpiar
  cat "$tmp"
  rm -f "$tmp"
  return 0
}
