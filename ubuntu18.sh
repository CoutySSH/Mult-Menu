#!/bin/bash
#https://askubuntu.com/questions/1031921/php-mcrypt-package-missing-in-ubuntu-server-18-04-lts

function inst_base 
{
	apt update > /dev/null 2>&1
	apt dist-upgrade -y > /dev/null 2>&1
	apt install apache2 -y > /dev/null 2>&1
	apt install cron curl unzip dirmngr apt-transport-https -y > /dev/null 2>&1
	apt install php-dev libmcrypt-dev gcc make autoconf libc-dev pkg-config -y > /dev/null 2>&1
	echo | pecl install mcrypt-1.0.1 > /dev/null 2>&1
	#echo "extension=mcrypt.so" | sudo tee -a /etc/php/7.2/cli/conf.d/mcrypt.ini > /dev/null 2>&1
	apt install libapache2-mod-php7.2 php7.2-xml php7.2-curl php7.2-mbstring -y > /dev/null 2>&1

	echo "extension=mcrypt.so" >> /etc/php/7.2/apache2/php.ini
	echo "extension=mcrypt.so" >> /etc/php/7.2/mods-available/mcrypt.ini
								  #/etc/php/7.2/apache2/conf.d/mcrypt.ini

	systemctl restart apache2
	apt-get install mariadb-server -y > /dev/null 2>&1
	cd || exit
	mysqladmin -u root password "$pwdroot"
	mysql -u root -p"$pwdroot" -e "UPDATE mysql.user SET Password=PASSWORD('$pwdroot') WHERE User='root'"
	mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.user WHERE User=''"
	mysql -u root -p"$pwdroot" -e "DELETE FROM mysql.db WHERE Db='test' OR Db='test\_%'"
	mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
	#mysql -u root -p"$pwdroot" -e "CREATE USER 'root'@'localhost';'"
	mysql -u root -p"$pwdroot" -e "CREATE DATABASE sshplus;"
	mysql -u root -p"$pwdroot" -e "GRANT ALL PRIVILEGES ON root.* To 'root'@'localhost' IDENTIFIED BY '$pwdroot';"
	mysql -u root -p"$pwdroot" -e "FLUSH PRIVILEGES"
	echo '[mysqld]' >> /etc/mysql/my.cnf
	echo 'max_connections = 1000' >> /etc/mysql/my.cnf
	apt install php7.2-mysql -y > /dev/null 2>&1
	phpenmod mcrypt
	systemctl restart apache2
	ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin > /dev/null 2>&1
	apt install php7.2-ssh2 -y > /dev/null 2>&1
	php -m | grep ssh2 > /dev/null 2>&1
	curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
	mv composer.phar /usr/local/bin/composer
	chmod +x /usr/local/bin/composer
	cd /var/www/html || exit
	wget https://raw.githubusercontent.com/CoutySSH/SSH-WEB/main/gestorssh.zip > /dev/null 2>&1
	apt-get install unzip > /dev/null 2>&1
	unzip gestorssh.zip > /dev/null 2>&1
	chmod -R 777 /var/www/html
	rm gestorssh.zip index.html > /dev/null 2>&1
	(echo yes; echo yes; echo yes; echo yes) | composer install > /dev/null 2>&1
	(echo yes; echo yes; echo yes; echo yes) | composer require phpseclib/phpseclib:~2.0 > /dev/null 2>&1
	systemctl restart mysql
	clear
}
function phpmadm_old
{
	cd /usr/share || exit
	wget https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-all-languages.zip > /dev/null 2>&1
	unzip phpMyAdmin-5.1.0-all-languages.zip > /dev/null 2>&1
	mv phpMyAdmin-5.1.0-all-languages phpmyadmin
	chmod -R 0755 phpmyadmin
	ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin > /dev/null 2>&1
	systemctl restart apache2 
	rm phpMyAdmin-5.1.0-all-languages.zip
	cd /root || exit
}
function phpmadm 
{
	cd /usr/share || exit
	wget https://files.phpmyadmin.net/phpMyAdmin/5.2.1/phpMyAdmin-5.2.1-all-languages.zip > /dev/null 2>&1
	unzip phpMyAdmin-5.2.1-all-languages.zip > /dev/null 2>&1
	mv phpMyAdmin-5.2.1-all-languages phpmyadmin
	chmod -R 0755 phpmyadmin
	ln -s /usr/share/phpmyadmin /var/www/html/phpmyadmin
	systemctl restart apache2 
	rm phpMyAdmin-5.2.1-all-languages.zip
	mkdir /usr/share/phpmyadmin/tmp
	CHAVE_BLOWFISH=$(openssl rand -hex 16)
	echo "<?php" > /usr/share/phpmyadmin/config.inc.php
	echo "declare(strict_types=1);" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['blowfish_secret'] = '$CHAVE_BLOWFISH';" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$i = 0;" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$i++;" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['Servers'][\$i]['auth_type'] = 'cookie';" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['Servers'][\$i]['host'] = 'localhost';" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['Servers'][\$i]['compress'] = false;" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['Servers'][\$i]['AllowNoPassword'] = false;" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['UploadDir'] = '';" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['SaveDir'] = '';" >> /usr/share/phpmyadmin/config.inc.php
	echo "\$cfg['TempDir'] = '/usr/share/phpmyadmin/tmp/';" >> /usr/share/phpmyadmin/config.inc.php
	chmod -R 0777 /usr/share/phpmyadmin/tmp
	systemctl restart apache2
	cd /root || exit
}

function pconf
{ 
	sed "s/1020/$pwdroot/" /var/www/html/pages/system/pass.php > /tmp/pass
	mv /tmp/pass /var/www/html/pages/system/pass.php
	sed -i "s/1020/$pwdroot/" /var/www/html/lib/Database/Connection.php > /dev/null 2>&1
}
function inst_db 
{ 
	cd || exit
	wget https://github.com//alian87/psshplus/raw/main3/gestorssh/bdgestorssh.sql > /dev/null 2>&1
	sleep 1
	if [[ -e "$HOME/bdgestorssh.sql" ]]; then
		mysql -h localhost -u root -p"$pwdroot" --default_character_set utf8 sshplus < bdgestorssh.sql
		rm /root/bdgestorssh.sql
	else
		clear
		echo -e "\033[1;31m ERRO CRÍTICO\033[0m"
		sleep 2
		systemctl restart apache2 > /dev/null 2>&1
	cat /dev/null > ~/.bash_history && history -c
	rm /root/*.sh* > /dev/null 2>&1
	clear
		exit
	pweb
	fi
	clear
}
function cron_set
{
	crontab -l > cronset  > /dev/null 2>&1
	echo "
	* * * * * /bin/userteste.sh
	*/5 * * * * /bin/autobackup.sh
	* * * * * /usr/bin/php /var/www/html/pages/system/cron.online.ssh.php
	@daily /usr/bin/php /var/www/html/pages/system/cron.rev.php
	* * * * * /usr/bin/php /var/www/html/pages/system/cron.ssh.php
	* * * * * /usr/bin/php /var/www/html/pages/system/cron.php
	*/1 * * * * /usr/bin/php /var/www/html/pages/system/cron.limpeza.php
	0 */12 * * * cd /var/www/html/pages/system/ && bash cron.backup.sh && cd /root
	5 */12 * * * cd /var/www/html/pages/system/ && /usr/bin/php cron.backup.php && cd /root" > cronset
	crontab cronset && rm cronset
}
function fun_swap 
{
	swapoff -a
	rm -rf /bin/ram.img > /dev/null 2>&1
	fallocate -l 4G /bin/ram.img > /dev/null 2>&1
	chmod 600 /bin/ram.img > /dev/null 2>&1
	mkswap /bin/ram.img > /dev/null 2>&1
	swapon /bin/ram.img > /dev/null 2>&1
	echo 50  > /proc/sys/vm/swappiness
	echo '/bin/ram.img none swap sw 0 0' | sudo tee -a /etc/fstab > /dev/null 2>&1
	sleep 2
}
function tst_bkp
{
	cd /bin || exit
	wget https://github.com//alian87/psshplus/raw/main3/gestorssh/userteste.sh > /dev/null 2>&1
	wget https://github.com//alian87/psshplus/raw/main3/gestorssh/autobackup.sh > /dev/null 2>&1
	chmod 777 /bin/userteste.sh > /dev/null 2>&1
	chmod 777 /bin/autobackup.sh > /dev/null 2>&1
	mkdir /root/backupsql > /dev/null 2>&1
	chmod 777 -R /root/backupsql > /dev/null 2>&1
	_key=$(echo $(openssl rand -hex 5))
	sed -i "s;49875103u;$_key;g" /var/www/html/pages/system/config.php > /dev/null 2>&1
	sed -i "s;localhost;$IP;g" /var/www/html/pages/system/config.php > /dev/null 2>&1
}
IP=$(wget -qO- ipv4.icanhazip.com)
echo "America/Sao_Paulo" > /etc/timezone
ln -fs /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime > /dev/null 2>&1
dpkg-reconfigure --frontend noninteractive tzdata > /dev/null 2>&1
clear
echo -e "\E[44;1;37m    INSTALAR PAINELWEB SWIT-T     \E[0m" 
echo ""
echo -e "                 \033[1;31mBy @swittecnologia\033[1;36m"
echo ""
read -p "DIGITE SUA SENHA ROOT: " pwdroot
echo "root:$pwdroot" | chpasswd
echo -e "\n\033[1;36mINICIANDO INSTALAÇÃO \033[1;33mAGUARDE..."
sleep 6
clear
echo "INSTALANDO DEPENDÊNCIAS"
echo "..."
sleep 2
inst_base
phpmadm
pconf
inst_db
cron_set
fun_swap
tst_bkp
clear
echo -e "\033[1;32m P-SWIT-T INSTALADO COM SUCESSO!"
echo ""
echo -e "                 \033[1;31mBy @swittecnologia\033[1;36m"
echo ""
echo -e "\033[1;36m SEU PAINEL:\033[1;37m http://$IP/admin\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m admin\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m admin\033[0m"
echo ""
echo -e "\033[1;36m LOJA DE APPS:\033[1;37m http://$IP/apps\033[0m"
echo ""
echo -e "\033[1;36m LOJA DE APPS:\033[1;37m http://$IP/phpmyadmin\033[0m"
echo -e "\033[1;36m USUÁRIO:\033[1;37m root\033[0m"
echo -e "\033[1;36m SENHA:\033[1;37m $pwdroot\033[0m"
echo ""
echo -e "\033[1;33m MAIS INFORMAÇÕES \033[1;31m(\033[1;36mTELEGRAM\033[1;31m): \033[1;37m@swittecnologia\033[0m"
echo ""
sed -i "s;upload_max_filesize = 2M;upload_max_filesize = 64M;g" /etc/php/7.2/apache2/php.ini > /dev/null 2>&1
sed -i "s;post_max_size = 8M;post_max_size = 64M;g" /etc/php/7.2/apache2/php.ini > /dev/null 2>&1
echo -e "\033[1;36m REINICIANDO\033[1;37m EM 20 SEGUNDOS\033[0m"
sleep 20
shutdown -r now
cat /dev/null > ~/.bash_history && history -c
clear
exit