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
function intallMySQL {
	echo "${GREEN}Configuring MySQL...${RESET}"
	echo -n "MySQL root password: "
	read -s PASSWORD
	echo ""

	debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password password ${PASSWORD}" > /dev/null || exit 1
	debconf-set-selections <<< "mysql-server-5.5 mysql-server/root_password_again password ${PASSWORD}" > /dev/null || exit 1

	echo "${GREEN}Installing MySQL...${RESET}"
	apt-get install -y mysql-server > /dev/null || exit 1
}

##
# Install PHP
##
function installPHP {
	echo "${GREEN}Installing PHP-5.x${RESET}"
	apt-get install -y php5-fpm php5-cli php5-xdebug php5-mysql php5-curl php5-mcrypt php5-gd > /dev/null || exit 1

	sed -i '/;date.timezone =/c date.timezone = Europe/Copenhagen' /etc/php/fpm/php.ini
	sed -i '/;date.timezone =/c date.timezone = Europe/Copenhagen' /etc/php/fpm/php.ini

	sed -i '/upload_max_filesize = 2M/cupload_max_filesize = 256M' /etc/php/fpm/php.ini
	sed -i '/post_max_size = 8M/cpost_max_size = 300M' /etc/php/fpm/php.ini

	# Set php memory limit to 256mb
	sed -i '/memory_limit = 128M/c memory_limit = 256M' /etc/php/fpm/php.ini
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
	chmod 700 /tmp/node_install.sh
	/tmp/node_install.sh
	unlink /tmp/node_install.sh

	apt-get update > /dev/null || exit 1
	apt-get install -y nodejs > /dev/null || exit 1
}

##
# Globally install composer.
##
function installComposer {
	php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
	php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
	php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer
	php -r "unlink('composer-setup.php');"
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
}

##
# Install supervisor.
#
# Used to automatically run nodejs applications.
##
function installSuperVisor {
	echo "${GREEN}Installing supervisor...${RESET}"
	apt-get install supervisor
}

updateSystem;
intallMySQL;
installPHP;
installCaches;
installNginx;
installNodeJs;
installComposer;
installEleasticSearch;
installSuperVisor;
