#!/bin/bash


#Preguntar nombre (repetir hasta que no haya escrito algo)

while [[ -z "$NOMBRE" ]]; do
    read -p "introduce tu nombre " NOMBRE
    if [[ -z "$NOMBRE" ]]; then
        echo "el nombre no puede estar vacío"
    fi
done

#Preguntar el lenguaje (repetir hasta que no haya escrito algo)

while [[ -z "$LENGUAJE" ]]; do
    read -p "introduce tu nombre " LENGUAJE
    if [[ -z "$LENGUAJE" ]]; then
        echo "el lenguaje no puede estar vacío"
    fi
done

echo "══════════════════════════════════════"

echo "  Hola ${NOMBRE} "
			
echo " __  _  __ ____ |  |   ____  ____   _____   ____  "
echo " \ \/ \/ // __ \|  | _/ ___\/  _ \ /     \_/ __ \ " 
echo "  \     /\  ___/|  |_\  \__(  <_> )  Y Y  \  ___/ "
echo "   \/\_/  \___  >____/\___  >____/|__|_|  /\___>  "
echo "    \/          \/            \/     \/           "
			
