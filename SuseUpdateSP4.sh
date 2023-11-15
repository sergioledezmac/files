#/bin/bash




#####################################

BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White


sudo rm -r /tmp/logUpdateSP4.log && sudo touch /tmp/logUpdateSP4.log
UPDATESP="S15SP4Update.tar.gz"
LOG="/tmp/logUpdateSP4.log"

VALIDARSP=$(grep "VERSION_ID" /etc/os-release | cut -c 1-12,17 --complement)



sp="15.3"
if   [[ ${VALIDARSP} = $sp ]]  
then
        echo  -e "${BIGreen}Se valido la version SP$VALIDARSP, continuando con el update a SP4 ${BIWhite}"
else
        echo -e "${BIYellow}No es posible Actualizar al SP4 porque este equipo tiene la version ${BIPurple}SUSE ${VALIDARSP} ${BIWhite}" 
		exit		
	   fi
	   
cd /
#sudo rm -r -f /sp4
#sudo mkdir /sp4
echo -e "${BIPurple} Digite la contraseña del servidor ARS ${BIWhite}" 
#scp root@22.42.211.10:/tmp/S15SP4Update.tar.gz /sp4

echo -e "${BIPurple} Bajando interfaz Grafica del POS  ${BIWhite}" 
init 3 && cd /sp4 
echo -e "${BICyan} Descomprimiendo Update Favor espere......  ${BIWhite}\n" && sudo tar -xvf ${UPDATESP} 1>>${LOG} #/dev/null

FU=/sp4/fu1
if [ -d "$FU" ]
then
   echo -e "${BIGreen} Se ha descargado el Update correctamente, Iniciando la Actualizacion${BIWhite}\n"
else
  echo -e "${BIYellow}NO SE PUEDE CONTINUAR PORQUE NO SE ENCUENTRA EL PAQUETE DE ACTUALIZACION EN EL POS ${BIRed} Verifique que el paquete S15SP4Update.tar.gz este disponible en el ARS ruta /tmp${BIWhite}"
   exit
fi

echo -e "${BIYellow} Bajando el servicio POSControlCenter......  ${BIWhite}\n" && sudo systemctl stop aipstart.service 1>>${LOG}

echo -e "${BIYellow} Limpiando Repositorios Duplicados......  ${BIWhite}\n" && sudo systemctl stop aipstart.service 1>>${LOG}
sudo zypper rr Module-Legacy-sp4 1>>${LOG} && sudo zypper rr Module-Desktop-Applications-sp4 1>>${LOG} && sudo zypper rr Module-Basesystem-sp4 1>>${LOG}
sudo zypper rr Module-Python3-sp4 1>>${LOG} && sudo zypper rr Module-Server-Application-sp4 1>>${LOG} && sudo zypper rr Product-SLES-sp4 1>>${LOG}}

echo -e "${BIGreen} + + Agregando Repositorios SP4 + +  ${BIWhite}\n"
sudo zypper addrepo /sp4/au1  Module-Legacy-sp4 1>>${LOG} && sudo zypper addrepo /sp4/bu1 Module-Desktop-Applications-sp4 1>>${LOG}
sudo zypper addrepo /sp4/cu1 Module-Basesystem-sp4 1>>${LOG} && sudo zypper addrepo /sp4/du1 Module-Python3-sp4 1>>${LOG}
sudo zypper addrepo /sp4/eu1 Module-Server-Application-sp4 1>>${LOG}&& sudo zypper addrepo /sp4/fu1 Product-SLES-sp4 1>>${LOG} 

sudo zypper refresh && echo -e "${BICyan} - - deshabilitando Repositorios  - -  ${BIWhite}\n"
sudo zypper mr -d sle-module-basesystem-sp3 1>>${LOG} && sudo zypper mr -d sle-module-desktop-applications-sp3 1>>${LOG}
sudo zypper mr -d sle-module-legacy-sp3 1>>${LOG} && sudo zypper mr -d sle-module-python2-sp3 1>>${LOG}
sudo zypper mr -d sle-module-server-applications-sp3 1>>${LOG} && sudo zypper refresh 1>>${LOG} && sudo zypper list-updates 1>>${LOG}
##REPO VIRGENES INSTALL MANUAL
sudo zypper mr -d sle-module-basesystem 1>>${LOG} && sudo zypper mr -d sle-module-desktop-applications 1>>${LOG}
sudo zypper mr -d sle-module-legacy 1>>${LOG} && sudo zypper mr -d sle-module-python2 1>>${LOG}
sudo zypper mr -d sle-module-server-applications 1>>${LOG} && sudo zypper refresh 1>>${LOG} && sudo zypper list-updates 1>>${LOG}

echo -e "${BICyan} - - deshabilitando util-linux  - -  ${BIWhite}\n" && sudo zypper remove -y util-linux-systemd 1>>${LOG}

echo -e "${BIGreen} ......Iniciando Update......  ${BIGreen}\n" && sudo zypper update 

echo -e "${BIPurple} - - - Eliminando xscreensaver - - -  ${BIWhite}\n" && sudo zypper remove -y xscreensaver 1>>${LOG} && sudo zypper remove -y xscreensaver-data 1>>${LOG}

echo -e "${BIGreen} ... Refrescando Repositorios...  ${BIWhite}\n" && sudo zypper refresh 1>>${LOG} 
echo -e "${BIRed} X x Eliminado Repositorios x  X  ${BIWhite}\n" && sudo zypper rr sle-module-basesystem-sp3 1>>${LOG}
sudo zypper rr sle-module-desktop-applications-sp3 1>>${LOG} && sudo zypper rr sle-module-legacy-sp3 1>>${LOG} && sudo zypper rr sle-module-python2-sp3 1>>${LOG}
sudo zypper rr sle-module-server-applications-sp3 1>>${LOG} && sudo zypper rr Product-SLES-sp4 1>>${LOG} && sudo zypper refresh 1>>${LOG}
###### REPO VIRGENES INSTALL MANUAL
sudo zypper rr sle-module-basesystem 1>>${LOG}
sudo zypper rr sle-module-desktop-applications 1>>${LOG} && sudo zypper rr sle-module-legacy 1>>${LOG} && sudo zypper rr sle-module-python2 1>>${LOG}
sudo zypper rr sle-module-server-applications 1>>${LOG} && sudo zypper rr Product-SLES-sp4 1>>${LOG} && sudo zypper refresh 1>>${LOG} & sudo zypper rr SLES15-SP3-15.3-0 1>>${LOG}

echo -e "${BIGreen} ......Actualizacion Completada, el POS se Reiniciara......  ${BIGreen}\n" && sudo reboot 1>>${LOG}


#cd /sp3 && rm *tar*		