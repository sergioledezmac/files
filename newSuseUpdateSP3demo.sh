#/bin/bash

#Contacto: SergioLedezma


#####################################

BIBlack='\033[1;90m'      # Black
BIRed='\033[1;91m'        # Red
BIGreen='\033[1;92m'      # Green
BIYellow='\033[1;93m'     # Yellow
BIBlue='\033[1;94m'       # Blue
BIPurple='\033[1;95m'     # Purple
BICyan='\033[1;96m'       # Cyan
BIWhite='\033[1;97m'      # White


LOGUPDATE=/tmp/logUpdateSP3.log
LOGERRORUPDATE=/tmp/logUpdateSP3_ERROR.log
if [ -f $LOGUPDATE ]
then 
       rm -r /tmp/logUpdateSP3.log  >/dev/null && touch /tmp/logUpdateSP3.log  >/dev/null
else
  echo "creando log" && touch /tmp/logUpdateSP3.log  >/dev/null
 fi
 
 if [ -f $LOGUPDATE ]
then 
       rm -r /tmp/logUpdateSP3_ERROR.log >/dev/null && touch /tmp/logUpdateSP3_ERROR.log >/dev/null
else
  echo "creando log" && touch /tmp/logUpdateSP3.log >/dev/null
 fi

UPDATESP="S15SP3Update.tar.gz"
LOG="/tmp/logUpdateSP3.log"
LOGERROR="/tmp/logUpdateSP3_ERROR.log"


VALIDARSP=$(grep "VERSION_ID" /etc/os-release | cut -c 1-12,17 --complement)
#VALIDARGRUB=$(grep "GRUB_CMDLINE_LINUX_DEFAULT" /etc/default/grub | cut -c 1-27  --complement)




#sp="15.2"
#if   [[ ${VALIDARSP} = $sp ]]  
#then
#        echo  -e "\n${BIGreen}Se valido la version SP$VALIDARSP, continuando con el update a SP3 ${BIWhite}\n"
#else
#        echo -e "\n${BIYellow}No es posible Actualizar al SP3 porque este equipo tiene la version ${BIPurple}SUSE ${VALIDARSP} ${BIWhite}\n" 
#		exit		
#	   fi
	   
	   
	   
	   
	   
sed -i "s/resume=\/dev\/sda3/${GRUBSP3}/g" /etc/default/grub



STKERNEL='splash=0  quiet crashkernel=220M,high mitigations=auto'
FILEKERNEL='/etc/default/grub'

if  grep -q "$STKERNEL" "$FILEKERNEL" ; then
         echo  -e "\n${BIGreen}BootLoader validado corectamente ${BIWhite}\n"
else
         echo -e "\n${BIYellow}No es posible Actualizar al SP3 porque debe eliminar ${BIPurple}resume=/dev/sda3 ${BIYellow} desde el yast, system, bootloader ${BIWhite}\n"  ;
		 exit
fi
	   
	   
	   
	   
	   
	  
	   
	   
	   
cd /
#sudo rm -r -f /sp3
#sudo mkdir /sp3
echo -e "\n${BIPurple} Digite la contraseña del servidor ARS ${BIWhite}\n"
##########################################################
#sudo scp -o "StrictHostKeyChecking no" root@22.42.211.40:/tmp/S15SP3Update.tar.gz /sp3
########################################################

echo -e "\n${BIPurple} Bajando interfaz Grafica del POS  ${BIWhite}\n" 
init 3 #&& cd /sp3 
echo -e "${BICyan} Descomprimiendo Update Favor espere......  ${BIWhite}\n" && #sudo tar -xvf S15SP3Update.tar.gz 1>>${LOG} 2>>${LOGERROR} #/dev/null

FU=/sp3/fu1
if [ -d "$FU" ]
then
   echo -e "\n${BIGreen} Se ha descargado el Update correctamente, Iniciando la Actualizacion${BIWhite}\n"
else
  echo -e "\n${BIYellow}NO SE PUEDE CONTINUAR PORQUE NO SE ENCUENTRA EL PAQUETE DE ACTUALIZACION EN EL POS ${BIRed} Verifique que el paquete S15SP3Update.tar.gz este disponible en el ARS ruta /tmp${BIWhite}\n"
   exit
fi

 

UPV=/tmp/upv
if [ -e "$UPV" ]
then
   echo -e "\n${BIRed} ||///////////--El update se volvera a reanudar en el % siguiente --\\\\\\\\\\\\||${BIWhite}\n"
   echo -e "\n${BIRed} Eliminando Repositorios SP2 ......  ${BIWhite}\n" 
	
	cd /tmp 
	#tar -xvf sp2backrepo.tar.gz 1>>${LOG} 2>>${LOGERROR} 
	echo -e "\n${BIRed} Restableciendo SP2 Repos...Favor Espere ......  ${BIWhite}\n"  
	sudo zypper remove -y xscreensaver 1>>${LOG} 2>>${LOGERROR} 
	sudo zypper remove -y xscreensaver-data 1>>${LOG} 2>>${LOGERROR} 
	sudo zypper refresh 1>>${LOG} 2>>${LOGERROR}    zy
	sudo zypper lr 1>>${LOG} 2>>${LOGERROR}
	sudo zypper rr sle-module-basesystem #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper rr sle-module-desktop-applications #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper rr sle-module-legacy #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper rr sle-module-python2 #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper rr sle-module-server-applications #1>>${LOG} 2>>${LOGERROR}
	sudo zypper rr SLES15-SP2-15.2-0 #1#>>${LOG} 2>>${LOGERROR}
	sudo zypper rr Module-Legacy 
	sudo zypper rr Module-Desktop-Applications
	sudo zypper rr Module-Python2
	sudo zypper rr Module-Server-Applications
	sudo zypper rr Module-Basesystem
	  sudo zypper refresh 1>>${LOG} 2>>${LOGERROR} 
	  zypper remove open
	
	echo -e "\n${BIRed} Agregando nuevo paquete de Repositorios SP2 ......  ${BIWhite}\n" 
	sudo zypper refresh 1>>${LOG} 2>>${LOGERROR} &&   echo -e "\n${BIRed} Generando Modulos SP2......  ${BIWhite}\n"
	cd /tmp  && rm -R /tmp/sp2backrepo >>${LOG} 2>>${LOGERROR}  && tar -xvf sp2backrepo.tar.gz #1>>${LOG} 2>>${LOGERROR}
	sudo zypper addrepo /tmp/sp2backrepo/Module-Legacy Module-Legacy #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper addrepo /tmp/sp2backrepo/Module-Desktop-Applications Module-Desktop-Applications #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper addrepo /tmp/sp2backrepo/Module-Basesystem Module-Basesystem #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper addrepo /tmp/sp2backrepo/Module-Python2 Module-Python2 #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper addrepo /tmp/sp2backrepo/Product-SLES SLES15-SP2-15.2-0 #>>${LOG} 2>>${LOGERROR} 
	sudo zypper addrepo /tmp/sp2backrepo/Module-Server-Applications Module-Server-Applications #1>>${LOG} 2>>${LOGERROR} 
	sudo zypper refresh 1>>${LOG} 2>>${LOGERROR} 
	
	#zypper packages --unneeded | grep ^i|cut -d '|' -f3|xargs zypper rm --clean-deps --no-confirm
	#zypper verify  --force-resolution --download-only -y
	 zypper list-updates
	 zypper update
	 #zypper dist-upgrade --replacefiles
 
	 #rpm --rebuilddb

	
	echo -e "\n${BICyan} Finalizando  update.....  ${BIWhite}\n"	
	# echo -e "\n${BIYellow} Eliminando Repositorios SP2......  ${BIWhite}\n" 
	# sudo zypper mr -d SLES15-SP3-15.3-0 1>>${LOG} 2>>${LOGERROR} #Disable SLES15-SP3-15
	# sudo zypper remove -y xscreensaver 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper remove -y xscreensaver-data 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper refresh 1>>${LOG} 2>>${LOGERROR}  
	# sudo zypper lr 1>>${LOG} 2>>${LOGERROR}
	# sudo zypper rr sle-module-basesystem 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper rr sle-module-desktop-applications 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper rr sle-module-legacy 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper rr sle-module-python2 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper rr sle-module-server-applications 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper rr SLES15-SP2-15.2-0 1>>${LOG} 2>>${LOGERROR} 


	# #Patch delete old kernel  57.22 Devel
	# rpm -e kernel-default-devel-5.3.18-22.2.x86_64 1>>${LOG} 2>>${LOGERROR} && rpm -e kernel-devel-5.3.18-22.2.noarch 1>>${LOG} 2>>${LOGERROR}
	# rpm -e kernel-default-5.3.18-22.2.x86_64 1>>${LOG} 2>>${LOGERROR}


	# echo -e "\n${BIGreen} Renombrando Repositorios......  ${BIWhite}\n"
	# sudo zypper mr -n sle-module-legacy Module-Legacy-sp3 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper mr -n sle-module-desktop-applications Module-Desktop-Applications-sp3 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper mr -n sle-module-basesystem Module-Basesystem-sp3 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper mr -n sle-module-python2 Module-Python2-sp3 1>>${LOG} 2>>${LOGERROR} 
	# sudo zypper mr -n sle-module-server-applications Module-Server-Application-sp3 1>>${LOG} 2>>${LOGERROR} 

	# #Renombrando Alias Repositorios
	# sudo zypper renamerepo Module-Legacy-sp3 Legacy-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
	# sudo zypper renamerepo Module-Desktop-Applications-sp3 Desktop-Applications-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
	# sudo zypper renamerepo Module-Basesystem-sp3 Basesystem-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
	# sudo zypper renamerepo Module-Python2-sp3 Python2-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
	# sudo zypper renamerepo Module-Server-Application-sp3 Server-Applications-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}

	# echo -e "\n${BIGreen} ......Actualizacion Completada, el POS se Reiniciara......  ${BIGreen}\n" ## && sudo reboot 1>>${LOG}
	# #cd /sp3 && rm *tar*	&& reboot 1>>${LOG} 2>>${LOGERROR}
	# reboot
		
   
else
  echo -e "\n${BIGreen} Creando punto de validacion! ${BIWhite}\n" && touch /tmp/upv 1>>${LOG} 2>>${LOGERROR} 
  
   
fi


echo -e "\n${BIYellow} Bajando el servicio POSControlCenter......  ${BIWhite}\n" && sudo systemctl stop aipstart.service 1>>${LOG}

echo -e "\n${BIYellow} Habilitando Repositorios SP2......  ${BIWhite}\n"
sudo zypper mr -e sle-module-basesystem 1>>${LOG} 2>>${LOGERROR}  
sudo zypper mr -e sle-module-desktop-applications 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -e sle-module-legacy 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -e sle-module-python2 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -e sle-module-server-applications 1>>${LOG} 2>>${LOGERROR} 
sudo zypper refresh 1>>${LOG} 2>>${LOGERROR} 

echo -e "\n${BIYellow} Desabilitando Repositorios duplicados.....  ${BIWhite}\n"
sudo zypper mr -d Module-Legacy-sp3 1>>${LOG} 2>>${LOGERROR}
sudo zypper mr -d Module-Desktop-Applications-sp3 1>>${LOG} 2>>${LOGERROR}
sudo zypper mr -d Module-Basesystem-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -d Module-Python2-sp3 1>>${LOG} 2>>${LOGERROR}
sudo zypper mr -d Module-Server-Application-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -d Product-SLES-sp3 1>>${LOG} 2>>${LOGERROR}

echo -e "\n${BIYellow} Eliminando Repositorios duplicados.....  ${BIWhite}\n"
sudo zypper rr Module-Legacy-sp3 1>>${LOG} 2>>${LOGERROR}
sudo zypper rr Module-Desktop-Applications-sp3 1>>${LOG} 2>>${LOGERROR}
sudo zypper rr Module-Basesystem-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr Module-Python2-sp3 1>>${LOG} 2>>${LOGERROR}
sudo zypper rr Module-Server-Application-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr Product-SLES-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr SLES15-SP3-15.3-0 1>>${LOG} 2>>${LOGERROR}

##

sudo zypper refresh 1>>${LOG} 2>>${LOGERROR} 


  
 

echo -e "\n${BIYellow} Agregando nuevos repositorios......  ${BIWhite}\n"
sudo zypper addrepo /sp3/au1 Module-Legacy-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper addrepo /sp3/bu1 Module-Desktop-Applications-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper addrepo /sp3/cu1 Module-Basesystem-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper addrepo /sp3/du1 Module-Python2-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper addrepo /sp3/fu1 SLES15-SP3-15.3-0 1>>${LOG} 2>>${LOGERROR} 
sudo zypper addrepo /sp3/eu1 Module-Server-Application-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper refresh 1>>${LOG} 2>>${LOGERROR}
sudo zypper lr 1>>${LOG} 2>>${LOGERROR}
echo -e "\n${BIYellow} Desabilitando Repositorios Antiguos......  ${BIWhite}\n"
sudo zypper mr -d sle-module-basesystem 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -d sle-module-desktop-applications 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -d sle-module-legacy 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -d sle-module-python2 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -d sle-module-server-applications 1>>${LOG} 2>>${LOGERROR} 
					
echo -e "\n${BIYellow} ......Iniciando Update......  ${BIWhite}\n"					

sudo zypper refresh 1>>${LOG} 2>>${LOGERROR} 
sudo zypper list-updates 1>>${LOG} 2>>${LOGERROR} 

echo -e "\n${BICyan} Precione  ${BIWhite} YES ${BICyan} para comenzar el update.....  ${BIWhite}\n"										
#sudo zypper update 2>>${LOGERROR}
sudo zypper update --auto-agree-with-licenses --with-interactive  --no-confirm   2>>${LOGERROR} 

echo -e "\n${BICyan} Finalizando  update.....  ${BIWhite}\n"	
echo -e "\n${BIYellow} Eliminando Repositorios SP2......  ${BIWhite}\n" 
sudo zypper mr -d SLES15-SP3-15.3-0 1>>${LOG} 2>>${LOGERROR} #Disable SLES15-SP3-15
sudo zypper remove -y xscreensaver 1>>${LOG} 2>>${LOGERROR} 
sudo zypper remove -y xscreensaver-data 1>>${LOG} 2>>${LOGERROR} 
sudo zypper refresh 1>>${LOG} 2>>${LOGERROR}  
sudo zypper lr 1>>${LOG} 2>>${LOGERROR}
sudo zypper rr sle-module-basesystem 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr sle-module-desktop-applications 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr sle-module-legacy 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr sle-module-python2 1>>${LOG} 2>>${LOGERROR} 
sudo zypper rr sle-module-server-applications 1>>${LOG} 2>>${LOGERROR}
sudo zypper rr SLES15-SP2-15.2-0 1>>${LOG} 2>>${LOGERROR} 


#Patch delete old kernel  57.22 Devel
rpm -e kernel-default-devel-5.3.18-22.2.x86_64 1>>${LOG} 2>>${LOGERROR} && rpm -e kernel-devel-5.3.18-22.2.noarch 1>>${LOG} 2>>${LOGERROR}
rpm -e kernel-default-5.3.18-22.2.x86_64 1>>${LOG} 2>>${LOGERROR}


echo -e "\n${BIGreen} Renombrando Repositorios......  ${BIWhite}\n"
sudo zypper mr -n sle-module-legacy Module-Legacy-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -n sle-module-desktop-applications Module-Desktop-Applications-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -n sle-module-basesystem Module-Basesystem-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -n sle-module-python2 Module-Python2-sp3 1>>${LOG} 2>>${LOGERROR} 
sudo zypper mr -n sle-module-server-applications Module-Server-Application-sp3 1>>${LOG} 2>>${LOGERROR} 

#Renombrando Alias Repositorios
sudo zypper renamerepo Module-Legacy-sp3 Legacy-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
sudo zypper renamerepo Module-Desktop-Applications-sp3 Desktop-Applications-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
sudo zypper renamerepo Module-Basesystem-sp3 Basesystem-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
sudo zypper renamerepo Module-Python2-sp3 Python2-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}
sudo zypper renamerepo Module-Server-Application-sp3 Server-Applications-Module_15.3-0 1>>${LOG} 2>>${LOGERROR}

echo -e "\n${BIGreen} ......Actualizacion Completada, el POS se Reiniciara......  ${BIGreen}\n" ## && sudo reboot 1>>${LOG}
#cd /sp3 && rm *tar*	&& reboot 1>>${LOG} 2>>${LOGERROR}
reboot










