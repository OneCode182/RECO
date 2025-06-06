#!/bin/bash
# ls_oldest.sh
# Muestra los archivos ordenados por fecha de modificación (más antigua primero)
# Agrupa los archivos por fecha (YYYY-MM-DD) y muestra el conteo de elementos en cada grupo.

clear
echo "=== Ordenar por fecha: Más antigua ==="
read -p "Ingrese el directorio a analizar: " dir
if [ ! -d "$dir" ]; then
    echo "Directorio no válido."
    exit 1
fi

read -p "¿Incluir subdirectorios? (s/n): " rec
if [[ "$rec" =~ ^[sS] ]]; then
    find_opts="-mindepth 1"
else
    find_opts="-maxdepth 1 -mindepth 1"
fi

tempfile=$(mktemp)

while IFS= read -r file; do
    mod_date=$(stat -c "%y" "$file" | cut -d' ' -f1)
    epoch=$(stat -c "%Y" "$file")
    echo "$epoch|$mod_date|$file" >> "$tempfile"
done < <(find "$dir" $find_opts)

if [ ! -s "$tempfile" ]; then
    echo "No se encontraron archivos o directorios."
    rm "$tempfile"
    exit 0
fi

# Ordena de forma ascendente (más antigua primero)
sorted=$(mktemp)
sort -t'|' -k1,1n "$tempfile" > "$sorted"

prev_date=""
count=0

echo "Archivos ordenados por fecha (más antigua primero):"
echo "-----------------------------------------------------"
while IFS='|' read -r epoch mod_date file_path; do
    if [ "$mod_date" != "$prev_date" ]; then
        if [ -n "$prev_date" ]; then
            echo "Total para $prev_date: $count"
            echo "----------------------------------------"
        fi
        echo "Fecha: $mod_date"
        count=1
        prev_date="$mod_date"
        echo "  $file_path"
    else
        count=$((count+1))
        echo "  $file_path"
    fi
done < "$sorted"

if [ -n "$prev_date" ]; then
    echo "Total para $prev_date: $count"
fi

rm "$tempfile" "$sorted"
read -p "Presione Enter para continuar..."