# SMBMAP-with-prompted-for-obfuscated-credentials v1 (Just single target)
#!/bin/bash
#######################################################
#Ejemplo de comando de ejecucón:					  #
#	./script.sh -u usuario -d dominio -H IP			  #
#######################################################
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
	smbmap -u ${USER} -p ${PASSWORD} -d ${DOMAIN} -R --depth 1 -H ${IP} >> output_$IP.txt
fi
