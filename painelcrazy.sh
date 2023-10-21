#!/bin/bash
clear
rm criarusuario.sh
wget https://raw.githubusercontent.com/CoutySSH/imagens-png/main/criarusuario.sh
chmod 777 *sh
service ssh restart
echo -e "\n\033[1;32mCONCLUIDO!\033[0m"
sleep 1.5
echo -e "\033[1;36mENTRE NO PAINEL E CRIE UMA CONTA SSH PRA VER SE ESTA TUDO OK!\033[0m"
clear
sleep 1
