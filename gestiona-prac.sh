#!/bin/bash

							#------------------------------------------------------#
							#                 ASO 22/23 - Práctica 6               #
							#                  Álvaro Alonso Devesa                #
							#                                                      #
							#                  Gestión de prácticas                #
							#------------------------------------------------------#

#---FUNCIONES DEL MENÚ PRINCIPAL----#

function copyprac
{
	declare -i dia=$(date +%d -d "tomorrow")
	declare -i mes=$(date +%m -d "tomorrow")

	echo -e "\n\n\n\n\t\t\t\e[1;36mMenú 1 - Programar recogida de prácticas\e[0m\n"
	read -p $'\t'"Asignatura cuyas prácticas desea recoger: " asignatura
	read -p $'\t'"Ruta con las cuentas de los alumnos (Escriba la ruta completa): " origen
	read -p $'\t'"Ruta para almacenar prácticas (Escriba la ruta completa): " destino 

	echo -e "\n\n\tSe va a programar la recogida de las practicas de $asignatura para mañana a las 8:00."
	echo -e "\tOrigen: $origen \t Destino: $destino"

	read -p $'\t'"¿Está de acuerdo (s/n)? " conforme

	if [ $conforme = "s" -o $conforme = "S" ]
	then
		if [ ${origen::1} != '/' ] # Para que el origen especificado sea ruta absoluta
		then
			origen=$PWD/$origen
		fi
		
		if [ ${destino::1} != '/' ]
		then
			destino=$PWD/$destino
		fi

		if [ -d $origen ] #Compruebo si existe el directorio origen
		then
			
			#Caso de que exista el directorio origen
			#Programar entrega
			echo existe
			crontab -l > saco.tmp
			echo "00 08 $dia $mes * /home/alvaro/cosasdeASO/gestionaprac/recoge-prac.sh $origen $destino" >> saco.tmp
			crontab saco.tmp
			rm -f saco.tmp
		else

			#Caso de que no existe el directorio origen
			#Escribir log
			echo -e "\n\tFichero de origen no encontrado"
			#logger -it gestionaprac "Menú 1, no existe el directorio origen $origen (Asignatura $asignatura)"
			echo "$(date) - Menú 1, no existe el directorio origen $origen (Asignatura: $asignatura)" >> prac.log
			echo "Pulse intro para continuar"
			read
		fi
	fi

}

function empaquetar
{

	declare -i dia=$(date +%d)
	declare -i mes=$(date +%m)
	declare -i year=$(date +%y)

	echo -e "\n\n\n\n\t\t\t\e[1;36mMenú 2 - Empaquetar prácticas de la asignatura\e[0m\n"
	read -p $'\t'"Asignatura cuyas prácticas se desea empaquetar: " asignatura
	read -p $'\t'"Ruta absoluta del directorio de prácticas: " ruta

	echo -e "\n\n\tSe van a empaquetar las prácticas de la asignatura $asignatura presentes en el directorio $ruta \n"

	read -p $'\t'"¿Está de acuerdo? (s/n)" conforme

	if [ $conforme = "s" -o $conforme = "S" ]
	then
		if [ -d $ruta ]	#Comprobar si existe la ruta de emapquetar
		then

			#Existe la ruta
			tar -czf $ruta/$asignatura-$year$mes$dia.tgz $ruta
		else

			#No existe la ruta
			#creo log
			echo -e "\n\tLa carpeta mencionada no existe"
			#logger -it gestionaprac "Menú 2, la ruta especificada para el emapaquetamiento no existe (Asignatura $asignatura)"
			echo "$(date) - Menú 2, la ruta especificada para el empaquetamiento no existe (Asignatura $asignatura)" >> prac.log
			echo "Pulse intro para coninuar"
			read
		fi
	fi

}

function sizefile
{
	echo -e "\n\n\n\n\t\t\t\e[1;36mMenú 3 - Obtener tamaño y fecha del fichero\e[0m\n"
	read -p $'\t'"Asignatura sobre la que queremos información: " asignatura
	read -p $'\t'"Ruta absoluta de la asignatura: " ruta
	#Completar solución de la opción 3

	if [ -f $ruta/$asignatura*.tgz ]	#Se comrpueba que existe el archivo en esa ruta (soporta que tno exista la ruta)
	then
		#Se ha encontraso del archio
		size=$(du -h $ruta/$asignatura*.tgz | cut -f1)
		echo -e "\tEl archivo de $asignatura $s ($ruta/$asignatura*.tgz) tiene un tamaño de $size"
		unset size
	else
		
		#No se ha encontrado el archivo en dicha ruta

		echo -e "\n\tNo se ha encontrado ningú arciho que empiece por $asignatura en la carpeta o la ruta no existe"
		#logger -it gestionaprac "Menú 3, La ruta, o el archivo comprimido de la asignatura no existe (Asignatura $asignatura)"
		echo " $(date) - Menú 3, la ruta o el archivo comprimido de la asignatura no existe (Asignatura $asignatura)" >> prac.log

	fi
	echo -e "\tPulse cualquier tecla para continuar"
	read
}


#---PROGRAMA PRINCIPAL---#

touch prac.log

salida=true

while $salida
do
	clear

	echo -e "\n\t\t\t\e[1;36m----- MENÚ PRINCIPAL -----\e[0m\n\n\n"

	echo -e "\t1) Programar recogida de prácticas"
	echo -e "\t2) Empaquetado de prácticas de una asignatura"
	echo -e "\t3) Ver tamaño y fecha del fichero de la asignatura"
	echo -e "\t4) Finalizar programa\n\n"

	read -p $'\t'"Opción: " opcion


	case $opcion in
		1)
			copyprac ;;
		2)
			empaquetar ;;
		3)
			sizefile ;;
		4)
			clear
			salida=false ;;
		*)
			echo -e "\n\n\nOpción no encontrada, pulsa cualquier tecla para continuar"
			read ;;
	esac
done

