#!/bin/bash

echo "-------modelo 145------"

#crear variables para rellenar el modelo

echo " responda a las siguientes preguntas para rellenar su declaración censal"

echo " 1.datos del perceptor que efectua la comunicación"

read -p "Indique NIF: " nif
read -p "Nombre completo: " nombre
read -p "Año nacimiento: " ano_nac
echo "Indique situación familiar (seleccione opciones 1, 2 o 3) "

opciones_familia=(
"soltero, viudo separado con hijos a cargo que convivan con usted"
"casado o no separado legalmente sí su conyuge obtiene rentas superiores a 1.500 euros al año" "situaciones distintas a las anteriores [soltero sin hijos, su conyuge obtiene rentas superiores a 1500 euros al año..etc]"
)

for i in "${!opciones_familia[@]}"; do
    echo "$((i+1))) ${opciones_familia[$i]}"
done
read -p "Opción: " situacion

if [[ "$situacion" -eq 2 ]]; then
    read-p "indique NIF cónyuge: " nif_conyuge
fi

echo "indique grado de discapacidad reconocido: "
opciones_discapacidad=(
"igual o superior al 33% e inferior al 65%"
"además tengo necesidad ayuda a terceras personas o movilidad reducida" 
"igual o superior al 65%"
)

for i in "${!opciones_discapacidad[@]}"; do
    echo "$((i+1))) ${opciones_discapacidad[$i]}"
done


read-p "¿ la aceptación de este trabajo ha supuesto el traslado de su residencia habital a un nuevo municipio? (indique si/no)" movilidad
    if [[ ("$movilidad" =~ ^(si|SI|S|sí|Si|Sí) ]]; then
        read-p "indique la fecha de dicho traslado (DD/MM/AAAA)" traslado
    fi

read -p "¿Ha percibido rendimientos del trabajo con período de generación superior a 2 años en los 5 años anteriores? (si/no): " rendimientos
    if [[ ("$rendimientos" =~ ^(si|SI|S|sí|Si|Sí)$ ]]; then
        "$rendimientos_tipo"="irregulares"
    fi

echo "2. Hijos y otros descendientes menores de 25 años, o mayores de dicha edad si son discapacitados, que conviven con el perceptor"

read-p "¿tiene hijos o descendientes menores de 25 años o mayores de esta edad sí están incapacitados que convivan con usted? (s/n)" tiene_descendientes
if [[ ("$tiene_descendientes" =~ ^(si|SI|S|sí|Si|Sí) ]]; then
    
    echo "------ Registro de desciendentes-----"

    while true; do
    echo -e "\n--- Introduzca los datos del descendiente ---"
    
    read -p "Año de nacimiento: " anio_nacimiento_des
    read -p "Año de adopción: " anio_adopcion_des
    read -p "Grado de discapacidad % " discapacidad_des

     if [[ "$discapacidad_des" -ge 65 ]]; then
        $discapacidad_des == "gran_discapacidad"
     fi
     
    read -p "¿convive únicamente con usted?(s/n) " convivencia
    read -p "¿quiere añadir otro descendiente? (s/n) " "otra_opcion"
        if [[ "$otra_opcion" == n|no|NO|No)$ ]]; then
        break
        fi
    done
fi
    
echo "3. Ascendientes mayores de 65 años, o menores de dicha edad si son discapacitados, que conviven con el perceptor"
    
read-p "¿tiene ascendientes mayores de 65 años o menores de esta edad sí están incapacitados que convivan con usted? (s/n) " tiene_ascendientes
if [[ "$tiene_ascendientes" =~ ^(si|SI|S|sí|Si|Sí) ]]; then
    
    echo"------ Registro de ascendientes-----"

    while true; do
    echo -e "\n--- Introduzca los datos del ascendiente ---"
    
    read -p "Año de nacimiento: " anio_nacimiento_as
    read -p "Grado de discapacidad % " discapacidad_as
     if [[ "$discapacidad_as -ge 65 ]]; then
        $discapacidad_as_tipo == gran_discapacidad_as
     fi
    read -p "si no conviven todo el año con usted ¿conviven al menos la mitad del año?(s/n)" convivencia_a
        if [[ "$convivencia_a" =~ ^(si|SI|S|sí|Si|Sí) ]];then
        convivencia_b="si"
        fi
        
    read -p "¿quiere añadir otro ascendiente? (sí/no)" option
        if [[ "$option" =~ (n|no|NO|No) ]]; then
        break
        fi
    done
fi

echo "4. Pensiones compensatorias en favor del cónyuge y anualidades por alimentos en favor de los hijos, fijadas ambas por decisión judicial"

read -p ¿Esta usted obligado a satisfacer pensiones compensatorias en favor del cónyuge y anualidades por alimentos en favor de los hijos, fijadas ambas por decisión judicial? (si/no) " pensiones
    if [[ "$pensiones =~ ^(si|SI|S|sí|Si|Sí) ]]; then
        read -p "indique el importe anual que está Vd. obligado a satisfacer por pensión a favor del cónyuge " conyuge
        read -p "indique el importe anual que está Vd. obligado a satisfacer por pensión a favor de los hijos " hijos
    fi

echo "5. Pagos por la adquisición o rehabilitación de la vivienda habitual utilizando financiación ajena, con derecho a deducción en el IRPF"

read -p "¿ Pagó usted  por la adquisición o rehabilitación de la vivienda habitual utilizando financiación ajena antes del 1 de Enero de 2013? (sí/no)" rehabilitación

#----VISUALIZACIÓN-------

echo"--------------------------MODELO 145-----------------------------------------------------------"

echo"----Impuesto sobre las personas físicas----retenciones y rendimientos del trabajo--------------"

echo"-----Comunicación de datos al pagador-------artículo 88 RIRPF----------------------------------"

echo"------------Ejemplar para el contribuyente-----------------------------------------------------"

echo"---- 1.Datos del perceptor que efectua la comunicación-----------------------------------------"
echo"|                                                                              
echo"|  NIF                Nombre y apellidos                    año nacimiento                    |"
echo"|  $nif               $nombre                               $ano_nac                          |"
echo"|                                                                                             |"
echo"| SITUACIÓN FAMILIAR :                                                                        |"
echo"|                                                                                             |"
echo"| . Soltero/a, viudo/a, divorciado/a o separado/a legalmente con hijos solteros               |"
echo"|   menores de 18 años o incapacitados exclusivamente con Vd                                  |"
if ($opciones_familia eq 1);then                                                                                              echo "X"                                                                                                                  fi
echo"| .Casado o no separado legalmente sí su conyuge obtiene rentas superiores a 1.500 euros al   |"
echo"|  año                                                                                        |"
if ($opciones_familia eq 2);then
    echo "X"
fi 
echo"| NIf conyuge                                                                                 |"
       nif_conyuge 
echo"|                                                                                             |"
echo"| . Situaciones distintas a las anteriores                                                    |"

if ($opciones_familia eq 3);then
    echo "X"
fi      
echo"|                                                                                             |"
echo"|DISCAPACIDAD:                                                                                |"
echo"|                                                                                             |"
echo"| . Igual o superior al 33% e inferior al 65%                                                 |"
if ($opciones_discapacidad eq 1);then                                                                                         echo"X"                                                                                                              fi
echo"| .Además tengo necesidad ayuda a terceras personas o movilidad reducida 
if ($opciones_familia eq 2);then
    echo "X"
fi                                                                                                                                            
echo"| .Igual o superior al 65%                                                                    |"                                    
if ($opciones_familia eq 3);then
    echo "X"
fi      
echo"|                                                                                             |"
echo"| ¿ la aceptación de este trabajo ha supuesto el traslado de su residenciahabital a un nuevo  |" 
echo"|  municipio?                                                                                 |"
if [[ ("$movilidad" =~ ^(si|SI|S|sí|Si|Sí) ]]; then
    $traslado
fi    
echo"|                                                                                             |"
echo"|¿Ha percibido rendimientos del trabajo con período de generación superior a 2 años en los 5  |"
echo"|años anteriores?                                                                             |"
if [[ ("$rendimientos" =~ ^(si|SI|S|sí|Si|Sí)$ ]]; then
    echo "x"
fi
echo"-------------------------------------------------------------------------------------------------"

echo"---- 2.Hijos y otros descendientes menores de 25 años, o mayores de dicha edad discapacitados----"
echo"|                                                                                               |"
echo"|  Año de nacimiento   Año de adopción   Incapacidad > 33% e inferior al 65%   Incapacidad >65% |"

        anio_nacimiento_des anio_adopcion_des discapacidad_des                      gran_discapacidad
echo"|                                                                                               |"
echo"------------------------------------------------------------------------------------------------|"

echo"----3.Ascendientes mayores de 65 años /menores de dicha edad si son discapacitados---------------"
echo"|                                                                                               |"
echo"|  Año de nacimiento   Año de adopción   Incapacidad > 33% e inferior al 65%   Incapacidad >65% |"

        anio_nacimiento_as  anio_adopcion_as  discapacidad_as                       gran_discapacidad_as
echo"|                                                                                               |"
echo"------------------------------------------------------------------------------------------------|"

echo"-----4. Pensiones compensatorias en favor del cónyuge y anualidades por alimentos en favor de los" 
echo"        hijos,fijadas por decisión judicial"-----------------------------------------------------"

echo" Pensión compensatoria en favor del cónyuge                                                      |"
      conyuge
      
echo" Anualidades por alimentos a favor de los hijos                                                  |"
      hijos
echo"-------------------------------------------------------------------------------------------------|"


echo"---5.Pagos por la adquisición o rehabilitación de la vivienda habitual utilizando financiación----"
echo"|  ajena, con derecho a deducción en el IRPF                                                     |"
echo"|                                                                                                |"
if [[ "$rehabilitacion =~ ^(si|SI|S|sí|Si|Sí) ]]; then
    echo "X"
fi
echo"|                                                                                                |"
echo"-------------------------------------------------------------------------------------------------|"

