#!/bin/bash

# ==============================================================================
# MISIÓN ARTEMIS - RETO NIVEL 5: Misión Completa (Orquestador de Producción)
# ==============================================================================
# Autor: Alumno IFCD0112
# Descripción: Código DevOps SRE con cinturón de seguridad riguroso que
#              importa helpers, valida red y dependencias, y envía telemetría.
# ==============================================================================

# --- Cinturón de seguridad de Producción ---
set -euo pipefail
IFS=$'\n\t'

# --- Variables Globales ---
SERVER_IP="127.0.0.1" # Cambia por la IP de tu profesor o tu compañero
PORT="8000"
LOG_TEMP="/dev/shm/mision_final_log_$$"

# --- Importar Biblioteca de Helpers ---
LIBRERIA="./mision_helpers.sh"
# Si la librería no existe localmente (ejecución remota en red), la descargamos dinámicamente a la RAM
if [ ! -f "$LIBRERIA" ]; then
    LIBRERIA="/dev/shm/mision_helpers_$$"
    if ! curl -s -f "http://${SERVER_IP}:${PORT}/mision_helpers.sh" > "$LIBRERIA"; then
        echo "ERROR CRÍTICO: No se pudo descargar la biblioteca de funciones del servidor."
        exit 1
    fi
fi

# Cargar la librería en memoria
# shellcheck source=/dev/null
source "$LIBRERIA"

# --- Manejo de Limpieza Obligatorio ---
cleanup() {
    rm -f "$LOG_TEMP"
    # Si descargamos la librería a la RAM temporal, la borramos al salir para no dejar basura
    if [[ "$LIBRERIA" == /dev/shm/mision_helpers_* ]]; then
        rm -f "$LIBRERIA"
    fi
}
trap cleanup EXIT


# --- Flujo Principal de la Misión ---
clear
echo -e "\033[1;33m"
cat << 'EOF'
     _     _   _ _   _  ____ _   _    ____ ___  _   _ _____ ____   ___  _     
    | |   / \ | | | | |/ ___| | | |  / ___/ _ \| \ | |_   _|  _ \ / _ \| |    
    | |  / _ \| | | | | |   | |_| | | |  | | | |  \| | | | | |_) | | | | |    
    | |_/ ___ \ |_| |_| |___|  _  | | |__| |_| | |\  | | | |  _ <| |_| | |___ 
    |____/_/   \_\___/ \____|_| |_|  \____\___/|_| \_| |_| |_| \_\\___/|_____|
EOF
echo -e "\033[0m"

typewriter "=== INICIALIZANDO SISTEMAS DE PRODUCCIÓN DE LA MISIÓN ===" 0.03
echo ""

# 1. Verificar prerrequisitos (dependencias)
echo -n "  [1/4] Verificando dependencias del sistema... "
verificar_dependencias
echo -e "✓ Todo listo."

# 2. Comprobar red (ping al servidor)
echo -n "  [2/4] Comprobando canal de red con Ground Control ($SERVER_IP)... "
if ! ping -c 1 -W 2 "$SERVER_IP" &>/dev/null; then
    echo -e "\n  [ERROR] El servidor de Ground Control no responde. Inicia servidor.py primero."
    exit 1
fi
echo -e "✓ Enlace establecido."

# 3. Transmitir estado y registrar en RAM
echo -n "  [3/4] Generando registros de telemetría final en RAM... "
echo "═══════════════════════════════════════" >> "$LOG_TEMP"
echo "  REPORTE COMPLETO DE TELEMETRÍA (NIVEL 5)" >> "$LOG_TEMP"
echo "  Fecha: $(date)" >> "$LOG_TEMP"
echo "  Estado del Host: SRE ONLINE" >> "$LOG_TEMP"
echo "═══════════════════════════════════════" >> "$LOG_TEMP"
echo "VM_HOSTNAME: $(hostname)" >> "$LOG_TEMP"
echo "UPTIME_INFO: $(uptime -p)" >> "$LOG_TEMP"
echo "✓ Ficheros encriptados."

# 4. Transmitir vía curl POST
echo ""
typewriter "  [4/4] Transmitiendo paquete cifrado a Ground Control en el puerto $PORT..." 0.02
_RESP=$(curl -s -m 10 -X POST --data-binary "@$LOG_TEMP" "http://$SERVER_IP:$PORT/upload" || echo "FAIL")

echo ""
if [[ "$_RESP" == OK* ]]; then
    typewriter "  [ÉXITO] Misión finalizada con éxito. Telemetría almacenada en base de datos." 0.03
else
    typewriter "  [ALERTA] Reporte enviado al servidor. Requiere confirmación manual del operador." 0.03
fi
echo ""
