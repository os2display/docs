#!/usr/bin/env bash

##################################################################
# This script is used to install the stack required to run the
# application.
#
# It assumes that you have a clean install Debian 8 server.
##################################################################

## Disable term blank
setterm -blank 0

## Define colors.
BOLD=$(tput bold)
UNDERLINE=$(tput sgr 0 1)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

##
# Update the OS packages.
##
function updateSystem {
	echo "${GREEN}Updating system packages...${RESET}"
  apt-get update > /dev/null || exit 1
  apt-get upgrade -y > /dev/null || exit 1
}

##
# Install MySQL server
##
function installMySQL {
	echo "${GREEN}Configuring MySQL...${RESET}"
	echo -n "MySQL root password: "
	read -s PASSWORD
	echo " "

	debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${PASSWORD}" > /dev/null || exit 1
	debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${PASSWORD}" > /dev/null || exit 1

	echo "${GREEN}Installing MySQL...${RESET}"
	apt-get install -y mysql-server > /dev/null || exit 1
}

##
# Install PHP
##
function installPHP {
    echo "${GREEN}Installing PHP-7.x${RESET}"

    apt-get install -y apt-transport-https lsb-release ca-certificates > /dev/null || exit 1
    wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | sudo tee /etc/apt/sources.list.d/php.list
    apt-get update > /dev/null || exit 1

    apt-get install -y php7.2-fpm php7.2-cli php7.2-xdebug php7.2-mysql php7.2-curl php7.2-gd php7.2-xml php7.2-mbstring > /dev/null || exit 1

    sed -i '/;date.timezone =/c date.timezone = Europe/Copenhagen' /etc/php/7.2/fpm/php.ini
    sed -i '/;date.timezone =/c date.timezone = Europe/Copenhagen' /etc/php/7.2/fpm/php.ini

    sed -i '/upload_max_filesize = 2M/cupload_max_filesize = 256M' /etc/php/7.2/fpm/php.ini
    sed -i '/post_max_size = 8M/cpost_max_size = 300M' /etc/php/7.2/fpm/php.ini

    # Set php memory limit to 256mb
    sed -i '/memory_limit = 128M/c memory_limit = 256M' /etc/php/7.2/fpm/php.ini
}

##
# Install redis-server (use as cache).
##
function installCaches {
	echo "${GREEN}Installing redis server...${RESET}"
	apt-get install -y redis-server > /dev/null || exit 1
}

##
# Install Nginx http server.
##
function installNginx {
	echo "${GREEN}Installing nginx...${RESET}"
	apt-get install -y nginx > /dev/null || exit 1
	unlink /etc/nginx/sites-enabled/default
}

##
# Install NodeJs.
##
function installNodeJs {
    echo "${RESET}Installing NodeJs...${GREEN}"

    wget https://deb.nodesource.com/setup_6.x -O /tmp/node_install.sh
#   TODO: Upgrade to node 10
#   Requires merge of PR: https://github.com/os2display/middleware/pull/6
#	wget https://deb.nodesource.com/setup_10.x -O /tmp/node_install.sh
    chmod 700 /tmp/node_install.sh
    /tmp/node_install.sh
    unlink /tmp/node_install.sh

    apt-get update > /dev/null || exit 1
    apt-get install -y nodejs > /dev/null || exit 1
}

##
# Globally install composer.
# See https://getcomposer.org/doc/faqs/how-to-install-composer-programmatically.md for more information.
##
function installComposer {
	echo "${GREEN}Installing composer...${RESET}"
	EXPECTED_SIGNATURE=$(wget -q -O - https://composer.github.io/installer.sig)
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	ACTUAL_SIGNATURE=$(php -r "echo hash_file('SHA384', 'composer-setup.php');")

	if [ "$EXPECTED_SIGNATURE" != "$ACTUAL_SIGNATURE" ]
	then
		>&2 echo 'ERROR: Invalid composer installer signature'
		rm composer-setup.php
		return;
	fi

	php composer-setup.php  --install-dir=/usr/local/bin/ --filename=composer
	rm composer-setup.php
}

##
# Install elastic search.
##
function installEleasticSearch {
	echo "${GREEN}Installing java...${RESET}"
	apt-get install openjdk-7-jre -y > /dev/null || exit 1

	echo "${GREEN}Installing elasticsearch...${RESET}"
	cd /tmp
	wget https://download.elastic.co/elasticsearch/elasticsearch/elasticsearch-1.7.1.deb > /dev/null || exit 1
	dpkg -i elasticsearch-1.7.1.deb > /dev/null || exit 1
	unlink elasticsearch-1.7.1.deb
	update-rc.d elasticsearch defaults 95 10 > /dev/null || exit 1

	# Elasticsearch plugins
	/usr/share/elasticsearch/bin/plugin -install elasticsearch/elasticsearch-analysis-icu/2.5.0 > /dev/null || exit 1

	# Start elasticsearch
	systemctl daemon-reload
	systemctl enable elasticsearch
	systemctl start elasticsearch
}

##
# Install supervisor.
#
# Used to automatically run nodejs applications.
##
function installSuperVisor {
	echo "${GREEN}Installing supervisor...${RESET}"
	apt-get install supervisor -y > /dev/null || exit 1
}

##
# Install tools need and that is nice to have on the server.
##
function installUtils {
	echo "${GREEN}Installing utils...${RESET}"
	apt-get install git bash-completion sudo nmap mc imagemagick git-core lynx rcconf build-essential automake autoconf -y > /dev/null || exit 1
}

updateSystem;
installMySQL;
installPHP;
installCaches;
installNginx;
installNodeJs;
installComposer;
installEleasticSearch;
installSuperVisor;
installUtils;
