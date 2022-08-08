#!/bin/bash
#################################################################
#Ejemplo 1 | Comando de ejecución (1 host):			 			#
#	./script.sh -u usuario -d dominio -H IP			  			#
#													  			#
#Ejemplo 2 | Comando de ejecución (Múltiples hosts):  			#
#	./script.sh -u usuario -d dominio -f ./archivo.txt	#
#################################################################
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -u|--user)
        USER="$2"
        shift # past argument
        ;;
        -p|--password)
        PASSWORD="$2"
        shift # past argument
        ;;
        -d|--domain)
        DOMAIN="$2"
		shift # past argument
        ;;
		-H)
        IP="$2"
		shift # past argument
        ;;
        -f|--host-file)
        HostFile="$2"
        shift # past argument
        ;;
        *)
        # unknown option
        usage
        ;;
    esac
    shift # past argument or value
done

if [[ -z $USER ]]
then
	USER=''
	echo [+] No se ingreso ningun usuario, se intentará acceso con usuario anonimo.
fi

if [[ -z $PASSWORD ]]
then
	echo [+] No se ingreso ninguna contraseña, ingresé una por teclado o presione enter para intentar acceso con credenciales nulas.
	echo -n contraseña:
	read -s PASSWORD
fi

if [[ -z $DOMAIN ]]
then
	DOMAIN='.'
	echo [+] No se ingreso ningun dominio, se intentará acceso al dominio local.
fi

if [[ ! -z $USER && ! -z $PASSWORD ]]
then
    echo [+] Utilizando las credenciales proporcionadas para el usuario $DOMAIN'\'$USER
	if [[ -z $HostFile ]]
	then
		smbmap -u ${USER} -p ${PASSWORD} -d ${DOMAIN} -R --depth 1 -H ${IP} >> output_$IP.txt
	else
		while read -r IP
			do
			####################################################################################
			echo [+] ************ Host: $IP ************ >> output_$IP.txt
			smbmap -u ${USER} -p ${PASSWORD} -d $DOMAIN -R --depth 1 -H $IP >> output_$IP.txt
			echo [+] ************ Finaliza $IP ************\n\n >> output_$IP.txt
			####################################################################################
		done < "$HostFile"
	fi
fi