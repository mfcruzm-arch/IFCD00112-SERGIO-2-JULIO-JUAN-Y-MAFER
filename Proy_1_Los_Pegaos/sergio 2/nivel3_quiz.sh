#!/bin/bash

# ==============================================================================
# MISIÓN ARTEMIS - RETO NIVEL 3: Quiz Interactivo (Entrenador de Examen)
# ==============================================================================
# Autor: Alumno IFCD0112
# Descripción: Juego interactivo que evalúa los conocimientos del alumno
#              sobre programación Bash usando arrays, menús select y case.
# ==============================================================================

# --- Configuración Visual ---
CYAN='\033[0;36m'
VERDE='\033[0;32m'
ROJO='\033[0;31m'
AMARILLO='\033[1;33m'
RESET='\033[0m'

# --- Variables de Puntuación ---
PUNTUACION=0

# --- Base de Datos del Quiz (Arrays) ---
PREGUNTAS=(
    "¿Qué comando se usa para cambiar permisos de un script?"
    "¿Qué valor toma \$0 dentro de un script?"
    "¿Cuál es el cinturón de seguridad que frena un script ante fallos?"
)

RESPUESTAS_CORRECTAS=("chmod" "El nombre del script" "set -euo pipefail")

OPCIONES_1=("chown" "chmod" "chmodx" "attrib")
OPCIONES_2=("El nombre del script" "El primer argumento" "La cantidad de parámetros" "El proceso actual")
OPCIONES_3=("trap cleanup" "set -euo pipefail" "if [ -f ]" "set -x")

# --- Función Evaluadora ---
evaluar_respuesta() {
    local ELECCION="$1"
    local CORRECTA="$2"
    if [ "$ELECCION" == "$CORRECTA" ]; then
        echo -e "\n  ${VERDE}✓ ¡RESPUESTA CORRECTA!${RESET}\n"
        PUNTUACION=$((PUNTUACION + 1))
    else
        echo -e "\n  ${ROJO}✗ INCORRECTO. La respuesta era: ${CORRECTA}${RESET}\n"
    fi
    sleep 1.5
}

# --- Ejecución del Quiz ---
clear
echo -e "${AMARILLO}=== ENTRENADOR ACADÉMICO ARTEMIS ===${RESET}"
echo -e "Pon a prueba tus conocimientos sobre sistemas Linux.\n"

# --- Pregunta 1 ---
echo -e "${CYAN}Pregunta 1: ${PREGUNTAS[0]}${RESET}"
PS3="Selecciona una opción [1-4]: "
select opt in "${OPCIONES_1[@]}"; do
    case $opt in
        "chown"|"chmod"|"chmodx"|"attrib")
            evaluar_respuesta "$opt" "${RESPUESTAS_CORRECTAS[0]}"
            break
            ;;
        *) echo "Opción no válida." ;;
    esac
done

# --- Pregunta 2 ---
echo -e "${CYAN}Pregunta 2: ${PREGUNTAS[1]}${RESET}"
select opt in "${OPCIONES_2[@]}"; do
    case $opt in
        "El nombre del script"|"El primer argumento"|"La cantidad de parámetros"|"El proceso actual")
            evaluar_respuesta "$opt" "${RESPUESTAS_CORRECTAS[1]}"
            break
            ;;
        *) echo "Opción no válida." ;;
    esac
done

# --- Pregunta 3 ---
echo -e "${CYAN}Pregunta 3: ${PREGUNTAS[2]}${RESET}"
select opt in "${OPCIONES_3[@]}"; do
    case $opt in
        "trap cleanup"|"set -euo pipefail"|"if [ -f ]"|"set -x")
            evaluar_respuesta "$opt" "${RESPUESTAS_CORRECTAS[2]}"
            break
            ;;
        *) echo "Opción no válida." ;;
    esac
done

# --- Resultados y Rangos ---
clear
echo -e "${CYAN}=== EVALUACIÓN COMPLETADA ===${RESET}"
echo -e "Aciertos: ${PUNTUACION} / 3"

case $PUNTUACION in
    3) RANGO="${VERDE}COMANDANTE (Rango Máximo)${RESET}" ;;
    2) RANGO="${AMARILLO}PILOTO (Nivel Intermedio)${RESET}" ;;
    *) RANGO="${ROJO}CADETE (Necesitas repasar)${RESET}" ;;
esac

echo -e "Tu rango militar asignado es: ${RANGO}\n"
