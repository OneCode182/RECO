#!/bin/bash
# ls_size_desc.sh
# Muestra los archivos ordenados por tamaño (de mayor a menor)
# Agrupa los archivos por tamaño (en bytes) y muestra el conteo de elementos por grupo.

clear
echo "=== Ordenar por tamaño: De mayor a menor ==="
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
    size=$(stat -c "%s" "$file")
    echo "$size|$file" >> "$tempfile"
done < <(find "$dir" $find_opts)

if [ ! -s "$tempfile" ]; then
    echo "No se encontraron archivos o directorios."
    rm "$tempfile"
    exit 0
fi

# Ordena por tamaño descendente (mayor a menor)
sorted=$(mktemp)
sort -t'|' -k1,1nr "$tempfile" > "$sorted"

prev_size=""
count=0

echo "Archivos ordenados por tamaño (de mayor a menor):"
echo "-------------------------------------------------"
while IFS='|' read -r size file_path; do
    if [ "$size" != "$prev_size" ]; then
        if [ -n "$prev_size" ]; then
            echo "Total para tamaño $prev_size bytes: $count"
            echo "----------------------------------------"
        fi
        echo "Tamaño: $size bytes"
        count=1
        prev_size="$size"
        echo "  $file_path"
    else
        count=$((count+1))
        echo "  $file_path"
    fi
done < "$sorted"

if [ -n "$prev_size" ]; then
    echo "Total para tamaño $prev_size bytes: $count"
fi

rm "$tempfile" "$sorted"
read -p "Presione Enter para continuar..."