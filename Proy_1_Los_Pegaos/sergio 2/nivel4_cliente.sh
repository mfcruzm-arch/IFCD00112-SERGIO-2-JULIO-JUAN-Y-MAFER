#!/bin/bash

# ==============================================================================
# MISIÓN ARTEMIS - RETO NIVEL 4: Cliente de Telemetría Bash
# ==============================================================================
# Autor: Alumno IFCD0112
# Descripción: Recopila métricas reales de hardware de la VM, genera un
#              reporte en RAM (/dev/shm) y lo envía a un servidor Python local.
# ==============================================================================

# --- Rutas de Archivos en RAM ---
REPORTE_TEMP="/dev/shm/telemetria_$$"
SERVER_IP="127.0.0.1" # Cambia por la IP de tu compañero o la del profesor
PORT="9999"

# --- Función de Limpieza Automática con TRAP ---
cleanup() {
    if [ -f "$REPORTE_TEMP" ]; then
        rm -f "$REPORTE_TEMP"
        echo -e "\n  [SISTEMA] Archivos temporales eliminados de la RAM."
    fi
}
trap cleanup EXIT INT TERM

# --- Función de Registro de Datos ---
registrar_dato() {
    local TITULO="$1"
    local COMANDO="$2"
    echo -e "=== $TITULO ===" >> "$REPORTE_TEMP"
    eval "$COMANDO" >> "$REPORTE_TEMP" 2>/dev/null
    echo -e "\n" >> "$REPORTE_TEMP"
}

# --- Recopilación de Telemetría ---
clear
echo "=== PREPARANDO TELEMETRÍA ==="

# Generar reporte estructurado en RAM (/dev/shm)
echo "═══════════════════════════════════════" > "$REPORTE_TEMP"
echo "  REPORTE DE TRANSMISIÓN DE TELEMETRÍA" >> "$REPORTE_TEMP"
echo "  Fecha: $(date)" >> "$REPORTE_TEMP"
echo "═══════════════════════════════════════" >> "$REPORTE_TEMP"
echo "" >> "$REPORTE_TEMP"

registrar_dato "MÉTRICAS DE RED" "ip -4 addr show"
registrar_dato "ESPACIO DE DISCO" "df -h /"
registrar_dato "MEMORIA DE LA VM" "free -m"

echo "  ✓ Reporte estructurado y guardado en RAM."
sleep 1

# --- Envío de Datos por Red ---
echo "  Transmitiendo telemetría a Ground Control ($SERVER_IP)..."
RESPUESTA=$(curl -s -X POST --data-binary "@$REPORTE_TEMP" "http://$SERVER_IP:$PORT/upload" || echo "FAIL")

if [ "$RESPUESTA" == "OK - Telemetria recibida y guardada." ]; then
    echo -e "\n  [ÉXITO] Ground Control confirma la recepción de tu telemetría."
else
    echo -e "\n  [FALLO] No se pudo establecer conexión con el servidor de la misión."
fi
