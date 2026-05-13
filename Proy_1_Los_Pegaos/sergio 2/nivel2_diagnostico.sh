#!/bin/bash

# ==============================================================================
# MISIÓN ARTEMIS - RETO NIVEL 2: Diagnóstico de mi Máquina
# ==============================================================================
# Autor: Alumno IFCD0112
# Descripción: Analiza los recursos de hardware y red del sistema local
#              e imprime resultados usando colores y barras de progreso.
# ==============================================================================

# --- Colores ---
VERDE='\033[0;32m'
ROJO='\033[0;31m'
CYAN='\033[0;36m'
AMARILLO='\033[1;33m'
RESET='\033[0m'

# --- Función Simuladora de Barra de Progreso en RAM ---
mostrar_barra() {
    local PROGRESO=0
    echo -ne "  Analizando sistemas: ["
    while [ $PROGRESO -le 20 ]; do
        echo -ne "${CYAN}█${RESET}"
        sleep 0.05
        PROGRESO=$((PROGRESO + 1))
    done
    echo -e "] ${VERDE}100%${RESET}\n"
}

# --- Recopilación de Métricas Reales del OS ---
DISCO_USADO=$(df -h / | tail -n 1 | awk '{print $5}' | tr -d '%')
RAM_LIBRE=$(free -m | grep "Mem:" | awk '{print $4}')
# Intentamos buscar en enp0s9, enp0s8, o enp0s3 si alguna tiene IP
IP_AULA=$(ip -4 addr show enp0s9 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
if [[ -z "$IP_AULA" ]]; then
    IP_AULA=$(ip -4 addr show enp0s3 2>/dev/null | grep "inet " | awk '{print $2}' | cut -d/ -f1)
fi

# --- Secuencia de Diagnóstico en Pantalla ---
clear
echo -e "${CYAN}=== SISTEMA DE DIAGNÓSTICO ARTEMIS ===${RESET}"
echo ""
mostrar_barra

# --- Evaluación Lógica de Recursos ---
echo "--- RESULTADOS DEL ESCANEO ---"

# 1. Chequeo de Disco
if [ "$DISCO_USADO" -gt 85 ]; then
    echo -e "  Disco Principal:  ${ROJO}PELIGRO (${DISCO_USADO}% usado)${RESET}"
else
    echo -e "  Disco Principal:  ${VERDE}OK (${DISCO_USADO}% usado)${RESET}"
fi

# 2. Chequeo de RAM
if [ "$RAM_LIBRE" -lt 250 ]; then
    echo -e "  Memoria RAM:      ${ROJO}CRÍTICA (${RAM_LIBRE} MB libres)${RESET}"
else
    echo -e "  Memoria RAM:      ${VERDE}OK (${RAM_LIBRE} MB libres)${RESET}"
fi

# 3. Chequeo de IP de Red
if [[ -z "$IP_AULA" ]]; then
    echo -e "  Conexión de Red:  ${ROJO}DESCONECTADO (Sin IP detectada)${RESET}"
else
    echo -e "  Conexión de Red:  ${VERDE}CONECTADO (IP: $IP_AULA)${RESET}"
fi
echo ""
