#!/usr/bin/env bash

#
#
# update package and firmware
function update_package(){

	# update package
	apt -y update
	apt-mark hold raspberrypi-kernel
	apt -y full-upgrade
	apt-mark unhold raspberrypi-kernel
	#apt -y update
	#apt -y upgrade
	#apt dist-upgrade

	# update firmware
	#rpi-update
}

# install apt package
function apt_install(){

	# Install nginx
	apt -y install nginx

	# Install php-fpm
	apt -y install php-fpm

	sed -i -e "44s:index index.html:index index.php index.html:" /etc/nginx/sites-enabled/default
	sed -i -e "56,57s:^	#:	:" /etc/nginx/sites-enabled/default
	sed -i -e "60s:^	#:	:" /etc/nginx/sites-enabled/default
	sed -i -e "63s:^	#:	:" /etc/nginx/sites-enabled/default

	if ! grep "www-data" "/etc/sudoers" >/dev/null; then
		echo "www-data ALL=NOPASSWD:/sbin/shutdown" >> /etc/sudoers
		echo "www-data ALL=NOPASSWD:/usr/bin/pkill" >> /etc/sudoers
	fi
}
	
# install rascsi-php
function rascsiphp_install(){

	# Install rascsi-php
	cd /var/www/html
	wget https://raw.githubusercontent.com/ztto/rascsi-php/master/index.php
}

function conform_check() {

	# sudo 
	if [[ "$(id -u)" -ne 0 ]]; then
	 	echo "Try 'sudo $0'"
	        echo "  実行する場合は 'sudo $0' と入力して下さい."
		exit 1
	fi
}

conform_check
update_package
apt_install
rascsiphp_install

echo "Please sudo reboot"
exit 0
