#!/bin/bash

# ==============================================================================
# MISIÓN ARTEMIS - RETO NIVEL 1: Saludo Personalizado
# ==============================================================================
# Autor: Alumno IFCD0112
# Descripción: Script interactivo que recibe entradas de usuario y muestra 
#              una tarjeta de bienvenida personalizada utilizando colores ANSI.
# ==============================================================================

# --- Definición de Colores ---
CYAN='\033[0;36m'
VERDE='\033[0;32m'
AMARILLO='\033[1;33m'
RESET='\033[0m'

# --- 1. Cabecera ASCII ---
clear
echo -e "${CYAN}"
cat << 'EOF'
     ___  ____  _____ _____ __  __ ___ ____  
    / _ \|  _ \|_   _| ____|  \/  |_ _/ ___| 
   | | | | |_) | | | |  _| | |\/| || |\___ \ 
   | |_| |  _ <  | | | |___| |  | || | ___) |
    \___/|_| \_\ |_| |_____|_|  |_|___|____/ 
EOF
echo -e "         --- BIENVENIDO CADETE ---${RESET}"
echo ""

# --- 2. Recogida de Entradas de forma Interactiva ---
read -r -p " Introduce tu nombre completo: " NOMBRE
read -r -p " ¿Cuál es tu lenguaje de programación favorito?: " LENGUAJE
echo ""

# --- 3. Tarjeta de Bienvenida con Bordes ---
echo -e "${VERDE}╔═════════════════════════════════════════════════════╗${RESET}"
echo -e "  Astronauta registrado: ${AMARILLO}${NOMBRE:-Cadete Anónimo}${RESET}"
echo -e "  Especialidad técnica:  ${CYAN}${LENGUAJE:-Bash Scripting}${RESET}"
echo -e "  Estado:                ${VERDE}Listo para el despegue${RESET}"
echo -e "${VERDE}╚═════════════════════════════════════════════════════╝${RESET}"
echo ""
