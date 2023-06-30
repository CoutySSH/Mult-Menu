#!/bin/bash
clear
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e "\E[44;1;37m    INSTALAR PAINEL WEB      \E[0m" 
echo ""
echo -e "                 \033[1;31mBy @Couty_SSHG\033[1;36m"
echo ""
echo -ne "\n\033[1;32mDE UM ENTER PARA \033[1;33mCONTINUAR...\033[1;37m: "; read -r
clear
echo -e "\n\033[1;36mINICIANDO INSTALAÇÃO \033[1;33mAGUARDE..."
apt-get install figlet -y > /dev/null 2>&1
apt-get install lolcat -y > /dev/null 2>&1
rm /bin/CoutySSH > /dev/null 2>&1
sleep 5
cd /bin || exit
wget https://raw.githubusercontent.com/CoutySSH/imagens-png/main/CoutySSH > /dev/null 2>&1
chmod 777 CoutySSH > /dev/null 2>&1
clear
mkdir /bin/ppweb > /dev/null 2>&1
cd /bin/ppweb || exit
rm *.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/install.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/ubuinst.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/ubu20inst.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/ubu22inst.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/senharoot.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/restbanco.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/restbanco18.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/empresa.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/updatepainel.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/updatepainel18.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/updatepainelarm.sh > /dev/null 2>&1
wget https://raw.githubusercontent.com/alian87/psshplus/main3/gestorssh/updatepainelarm18.sh > /dev/null 2>&1
chmod 777 *.sh > /dev/null 2>&1
clear
echo -e "        \033[1;33m • \033[1;32mDEPENDENCIAS CONCLUÍDA\033[1;33m • \033[0m"
echo ""
echo -e "\033[1;31m \033[1;33mCOMANDO PRINCIPAL: \033[1;32mCoutySSH\033[0m"
clear
CoutySSH
#echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@swittecnologia\033[0m"
#cat /dev/null > ~/.bash_history && history -c
#exit
