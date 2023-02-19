#!/bin/bash

#Fichero origen seria $1
#fichero destino seria $2

if [ -d $1 ]
then #existe el fichero origen

	if [ ! -d $2 ] # Caso en el que no extiste el directorio destino
	then
	
		mkdir $2 #No creo que sea necesario hacer un log en caso de que no exista el fichero destino
	fi

	for i in $(ls $1) #Por cada directorio
	do
		echo $i
		if [ -f $1/$i/prac.sh ] # Copiar el fichero solo si existe el fichero dentro de un directorio
		then	
			cp $1/$i/prac.sh $2/$i.sh
		fi
	done
	unset i
else
	echo "$(date) - Recogida de practicas programadas, no existe el directorio $1" >> prac.log
fi

