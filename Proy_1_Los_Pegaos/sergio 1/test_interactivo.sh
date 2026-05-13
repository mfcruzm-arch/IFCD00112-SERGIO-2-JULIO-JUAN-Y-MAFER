#!/bin/bash

# Inicializamos el contador

aciertos=0

test_pregunta() {
    local enunciado="$1"
    local correcta="$2"
    shift 2
    local opciones=("$@")

    echo -e "\n$enunciado"

    select respuesta in "${opciones[@]}"; do
        if [[ "$respuesta" == "$correcta" ]]; then
            echo "¡Correcto!"
            ((aciertos++))
            break
        elif [[ -z "$respuesta" ]]; then
            echo "Por favor, elige un número válido del menú."
        else
            echo "Incorrecto. La respuesta era: $correcta"
            break
        fi
    done
}

echo "---- EXAMEN DE BASH ----"

# Preguntas
test_pregunta "1. ¿Qué comando muestra el contenido de un archivo?" "cat" "cat" "ls" "mv"
test_pregunta "2. ¿Símbolo para segundo plano?" "&" "&" "*" "%"
test_pregunta "3. ¿Propósito de chmod?" "Cambiar los permisos" "Cambiar los permisos" "Cambiar el propietario" "Cambiar el nombre"
test_pregunta "4. ¿Variable con rutas de ejecutables?" "PATH" "PATH" "HOME" "SHELL"
test_pregunta "5. ¿Comando para contar líneas/palabras?" "wc" "wc" "count" "stat"
test_pregunta "6. ¿Qué hace el operador ||?" "Ejecuta el siguiente si el anterior falla" "Ejecuta el siguiente si el anterior falla" "Ejecuta ambos" "Conecta salida"
test_pregunta "7. ¿Qué indica el 'shebang' (#!)?" "Indica el intérprete a usar" "Indica el intérprete a usar" "Hace el archivo ejecutable" "Es una etiqueta"
test_pregunta "8. ¿Por qué falla: USUARIO = 'root'?" "Por los espacios en el =" "Uso de minúsculas" "Uso de comillas" "Por los espacios en el ="
test_pregunta "9. ¿Qué representa la variable \$#?" "Cantidad total de argumentos" "Cantidad total de argumentos" "Código de salida" "Nombre del script"

# Pregunta 10
echo -e "\n10. ¿Qué comando lista el contenido del directorio actual?"
read -p "Respuesta: " respuesta
if [[ "${respuesta}" == "ls" ]]; then
    echo "¡Correcto!"
    ((aciertos++))
else
    echo "Incorrecto"
fi

echo -e "\n---- RESULTADO TEST: $aciertos/10 ---"

# Lógica de rangos corregida
if [[ "$aciertos" -eq 10 ]]; then
    echo "Rango: Maestro"
elif [[ "$aciertos" -ge 7 ]]; then
    echo "Rango: Jedi"
elif [[ "$aciertos" -ge 5 ]]; then
    echo "Rango: Padawan"
else
    echo "Sigue practicando, joven Padawan."
fi
