#!/bin/bash

# --- Función de Spinner (Cargador) ---
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# --- Función para efecto de escritura lenta ---
escribir() {
    local texto="$1"
    local delay=0.03
    for (( i=0; i<${#texto}; i++ )); do
        echo -n "${texto:$i:1}"
        sleep $delay
    done
    echo ""
}

# ==========================================================
# INICIO: Cargando el sistema
# ==========================================================
clear
echo -n "Cargando módulos del sistema... "
(sleep 2) & spinner $! 
echo -e "\033[0;32m[OK]\033[0m"
sleep 0.5
clear

# ==========================================================
# PASO 1: SISTEMA INTERACTIVO Y BIENVENIDA
# ==========================================================
cat << "EOF"
 _   _  ____  _        _
| | | |/ __ \| |      / \
| |_| | |  | | |     / _ \
|  _  | |  | | |    / ___ \
|_| |_|\____/|_|   /_/   \_\

EOF

escribir "¡Bienvenido al sistema interactivo de misiones!"
echo "----------------------------------------------"

# --- VALIDACIÓN DE NOMBRE (Letras y más de 2 caracteres) ---
nombre=""
while true; do
    echo -n "¿Cómo te llamas? "
    read nombre
    if [[ ! "$nombre" =~ ^[A-Za-z[:space:]]+$ ]]; then
        echo "⚠️ Error: Solo se permiten letras."
    elif [ ${#nombre} -le 2 ]; then
        echo "⚠️ Error: El nombre debe tener más de 2 letras."
    else
        break
    fi
done

# --- MENÚ DE ESTADO DE ÁNIMO (Opciones fijas) ---
estado=""
while true; do
    echo -e "\nMucho gusto $nombre, ¿cómo te encuentras el día de hoy?"
    echo "1) BIEN"
    echo "2) SUPER BIEN"
    echo "3) REQUETEBIEN"
    echo -n "Selecciona una opción (1-3): "
    read opcion

    case $opcion in
        1) estado="BIEN"; break ;;
        2) estado="SUPER BIEN"; break ;;
        3) estado="REQUETEBIEN"; break ;;
        *) echo "⚠️ Opción no válida. Por favor marca 1, 2 o 3." ;;
    esac
done

clear
echo "------------------------------------------------"
escribir "¡Gracias por compartir, $nombre!"
escribir "Me alegra saber que estás: $estado."
echo "------------------------------------------------"

cat << "EOF"
       _
      / )
     ( (
   .-''-.  A miau!
  / ^  ^ \
 /   v   \
|         |
 \  \ /  /
  '-...-'
EOF

echo ""

# --- VALIDACIÓN DE CONTINUACIÓN (s/n únicamente) ---
while true; do
    escribir "¿Estás preparado para la siguiente misión, $nombre? (s/n)"
    read -p "> " respuesta
    respuesta=$(echo "$respuesta" | tr '[:upper:]' '[:lower:]' | xargs)

    if [[ "$respuesta" == "s" ]]; then
        break
    elif [[ "$respuesta" == "n" ]]; then
        clear
        echo -e "\033[0;31m"
        cat << "EOF"
  ____ _   _    _    ___
 / ___| | | |  / \  / _ \
| |   | |_| | / _ \| | | |
| |___|  _  |/ ___ \ |_| |
 \____|_| |_/_/   \_\___/

EOF
        escribir "Abortando misión. ¡Hasta la próxima, $nombre!"
        echo -e "\033[0m"
        exit 0
    else
        echo "⚠️ Opción no válida. Escribe 's' o 'n'."
    fi
done

# --- CUENTA REGRESIVA DINÁMICA ---
echo -n "🚀 ¡Excelente! Iniciando secuencia de entrenamiento en: "
for i in {3..1}; do
    echo -ne "\033[1;32m$i...\033[0m"
    sleep 1
    echo -ne "\b\b\b\b"
done
echo -e "\033[1;32m¡IGNICIÓN!\033[0m"

# --- SPINNER ANTES DEL CUESTIONARIO ---
echo -n "Preparando base de datos de preguntas... "
(sleep 2) & spinner $!
echo -e "\033[0;32m[LISTO]\033[0m"
sleep 1

clear
# (Aquí sigue el código del Quiz que ya tienes...)

# ==========================================================
# PASO 2: QUIZ DE FUNCIONES
# ==========================================================
puntos=0
total=10
TIEMPO_LIMITE=15

normalizar() {
    local entrada=$(echo "$1" | tr '[:upper:]' '[:lower:]' | xargs)
    case "$entrada" in
        verdadero|v|true|yes|si) echo "v" ;;
        falso|f|false|no) echo "f" ;;
        "") echo "timeout" ;;
        *) echo "error" ;;
    esac
}

clear
echo "===================================================="
escribir "      QUIZ DE FUNCIONES - ¡MODO CONTRA RELOJ!       "
echo "===================================================="
echo " Tienes $TIEMPO_LIMITE segundos por respuesta."
echo " Responde con 'v' (Verdadero) o 'f' (Falso)"
echo "----------------------------------------------------"

preguntas=(
    "¿Se recomienda usar mayúsculas y espacios al nombrar una función?|f|El nombre debe ser en minúsculas y sin espacios."
    "¿El 'cuerpo' de la función se encierra entre llaves { }?|v|Las llaves delimitan la lógica de la función."
    "¿Las variables locales se delaran usando la palabra clave 'local'?|v|Evita que la variable afecte a otras partes del script."
    "¿Una variable global solo puede ser vista por la función que la creó?|f|Las globales son visibles en todo el script."
    "¿El símbolo \$1 representa el primer dato que recibe la función?|v|Se llaman parámetros posicionales."
    "¿Es buena práctica usar variables globales para cálculos internos?|f|Se prefieren locales para no ensuciar el entorno global."
    "¿Las variables locales se borran de la memoria al terminar la función?|v|Se destruyen para liberar recursos."
    "¿La 'abstracción' oculta comandos técnicos tras un nombre sencillo?|v|Facilita la lectura y mantenimiento del código."
    "¿Se deben usar MAYÚSCULAS para constantes y variables globales?|v|Es una convención visual muy útil."
    "¿Para ejecutar una función es necesario escribir su nombre?|v|A esto se le llama invocación o llamado."
)

for i in "${!preguntas[@]}"; do
    IFS='|' read -r texto_pregunta correcta explicacion <<< "${preguntas[$i]}"

    echo -e "\n\033[1;33mPregunta $((i+1)):\033[0m $texto_pregunta"
    echo -n "⏱️  Tiempo: "
    
    read -t $TIEMPO_LIMITE user_input
    res_norm=$(normalizar "$user_input")

    if [[ "$res_norm" == "timeout" ]]; then
        echo -e "\n\n⏰ \033[0;31m¡TIEMPO AGOTADO!\033[0m"
        echo "💡 $explicacion"
    elif [[ "$res_norm" == "$correcta" ]]; then
        echo -e "✅ \033[0;32m¡CORRECTO!\033[0m"
        ((puntos++))
    else
        echo -e "❌ \033[0;31mINCORRECTO.\033[0m"
        echo "💡 $explicacion"
    fi
    sleep 1
done

# --- RESULTADO FINAL ---
clear
echo "===================================================="
escribir "               RESULTADOS FINALES"
echo "===================================================="
escribir " Puntuación: $puntos / $total"

if [ $puntos -le 4 ]; then
    rango="PADAWAN 👶"
    color="\033[0;31m"
elif [ $puntos -le 8 ]; then
    rango="JEDI ⚔️"
    color="\033[0;34m"
else
    rango="MAESTRO YODA 🍵"
    color="\033[0;32m"
fi

echo -e " Tu rango es: ${color}${rango}\033[0m"
echo "===================================================="
