# ==============================================================================
# MISIÓN ARTEMIS - RETO NIVEL 5: Biblioteca de Funciones Auxiliares
# ==============================================================================
# Descripción: Funciones reutilizables importadas mediante 'source' para 
#              mejorar la modularidad y arquitectura del código de producción.
# ==============================================================================

# Efecto Typewriter (imprime texto carácter por carácter de forma cinemática)
typewriter() {
    local text="$1"
    local delay="${2:-0.02}"
    local i=0
    while [[ $i -lt ${#text} ]]; do
        local char="${text:$i:1}"
        echo -ne "$char"
        sleep "$delay"
        i=$((i + 1))
    done
    echo ""
}

# Verificación de Herramientas del Sistema instaladas en la VM
verificar_dependencias() {
    local DEPS=("curl" "ping" "awk")
    for CMD in "${DEPS[@]}"; do
        if ! command -v "$CMD" &>/dev/null; then
            echo "ERROR: La herramienta requerida '$CMD' no está instalada en el sistema." >&2
            return 1
        fi
    done
    return 0
}
