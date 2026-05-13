#!/bin/bash

# 1. Definir las funciones

muestra_IP() {
echo "---> $(ip addr show)"
}

muestra_hostname() {
echo "---> $(hostname)"
}

muestra_memoria() {
echo "[MEMORIA]"
free -h | awk '/Mem:/ {printf " Usada: %s de %s\n", $3, $2}'
}

mostrar_ultimo_login() {
echo "----> $(lastlog)"
}

espacio_disco() {
echo "[DISCO]
free -h | awk '/Mem:/ {printf "  Usada: %s de %s\n", $3, $2}'
} 

# 2. Mini -recon , ejecutar las funciones

echo "═══════════════════════════════════"

echo "------ iniciando diagnostico-------"

for i in {1..10}; do
    echo -ne "Progreso: [$i/10] ${i}0%\r"
    sleep 0.5
done
echo ""

#echo -ne : Para que no salte de línea con n y e permite que interprete caracteres especiales
#[$i/10]: el progreso x/10
#${i}0% : Lo pone en porcentaje
#\r: vuelve al inicio del ciclo (sobreescribe y parece que el anterior porcentaje ha desaparecido)

echo "═══════════════════════════════════"

echo ""

muestra_IP

muestra_hostname

muestra_memoria

mostrar_ultimo_login

espacio_disco

echo "═══════════════════════════════════"
