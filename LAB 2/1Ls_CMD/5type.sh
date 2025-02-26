#!/bin/bash
# ls_type.sh
# Muestra los archivos y directorios agrupados según su tipo (Archivo o Directorio)
# y muestra el conteo de cada grupo.

clear
echo "=== Agrupar por tipo (Archivo/Directorio) ==="
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

# Se usarán arrays para almacenar los archivos y directorios por separado.
files_list=()
dirs_list=()

while IFS= read -r file; do
    if [ -d "$file" ]; then
        dirs_list+=("$file")
    else
        files_list+=("$file")
    fi
done < <(find "$dir" $find_opts)

echo "Archivos encontrados:"
for f in "${files_list[@]}"; do
    echo "  $f"
done
echo "Total Archivos: ${#files_list[@]}"
echo "--------------------------------------"
echo "Directorios encontrados:"
for d in "${dirs_list[@]}"; do
    echo "  $d"
done
echo "Total Directorios: ${#dirs_list[@]}"

read -p "Presione Enter para continuar..."
