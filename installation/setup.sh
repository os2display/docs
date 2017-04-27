#!/usr/bin/env bash

###################################################
# Configure new os2display site
#
# 1) Setup clone search node - if it don't exists
# 2) Setup clone middleware - if it don't exists
# 3) Add screen UI
# 4) Add administrative UI
#
###################################################

## Define colors.
BOLD=$(tput bold)
UNDERLINE=$(tput sgr 0 1)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
RESET=$(tput sgr0)

# Versions
SERACH_NODE_VERSION="v2.1.8"
MIDDLEWARE_VERSION="v4.0.2"

##
# Add SSL certificates.
##
function getSSLCertificate {
	while true; do
    read -p "Use fake SSL certificate (y/n)? " yn
    case $yn in
        [Yy]* )
					if [ ! -d '/etc/ssl/nginx' ]; then
						mkdir -p /etc/ssl/nginx
					fi
					cat > /etc/ssl/nginx/server.key <<DELIM
-----BEGIN RSA PRIVATE KEY-----
MIIEpAIBAAKCAQEAr/XEHIjUq9JiI2ciKjJ6a/bdf5/3FxrJXIYiw+rFO7GEy+ly
RfALVhMiZpZQOo4fYk0AvTb3ZtTmwRDvP3uIsE/xicK7p+F+78xXUzFDDJGoFtSg
jyiSS3Vqv/Eo7tQWPcZI0xRlKUMH1X2yerasesodBfUArEU7o7aXP8pv03saU2YG
wITIMV5kKN51+AiqWu7BFFNsf1djBIahGt20vFTJvbKdWMSv/9hqDE2Bm2fW2qZf
Sd5+VF1R9LTIERuvrkR/pOwcDXxOYUf8DBOFVINZOaBAIU3+2cZEXsskyfAfhS3W
aT4DIQA8pVqvn9E4bnopGzWhLgu44IhKlHGEgQIDAQABAoIBAHFO15xwWFLUxTF7
BjsaCk9fxr6aaejM7QHRtq1mjt+jrpoIl/eFXidtZuecv8kVIAyS/Xja3nGvg3Cr
0QSWLi0rLaTCa0juImmUsl72B/EeEpmxDjthquNAlx9G0k8I79GTz+1s4r+xVGgb
60SuQV9Iq2vcmzRT2NXRjJAdcelB+KO+0Vb/y7e5D6QKwbXXSQGOZ2XvQ3/KsO1p
lw1zLmbZ5FtqtXFP469hjjiI30R71kYSpH5tcCDvLrkHbvBiQoiToedPWF8bVnvl
CJRUmXWgVedGc3xciBC63BQ46ebJu+2/4oTcWJMxjPAAN8SRe7hcVCHQhlOLv3gl
76INt2kCgYEA4NDzDzmk6WGbnFRd7dFBiIyhnweMVkRUkcQlq3eW9JZhgkH7Tlzp
kvIZxcWSNwpnLJW1GaUWw2S/VPeESLuWgePIfUPKOdLtAd0/gSPQQC873t8LhtTy
Pvf5pryDG9BiMeg6JwrHUMRkwPX3RjcQM3qTAWzfY7qUuvMZuYg8QC8CgYEAyF34
mH88ixc24HOczRtbAWI7XaQPsFze4K7TlL6MR9umwSw1L67L9FSgDAFjzsYrxzFe
J4mReNNm6RQ0APeJmf4IZju1lQd/VeLr4b43wgtj949K+uqAJLE9q44WZtri+FQy
WIjrvSAwSGrfBwNMLE9whipGUmQCDmpoljdOKk8CgYEAt0/pQNrh6yKZvejVBhuA
chUpnACNn7Hru0fS53OF9T3BmHKwtX7xPc6G0Up+JL8ozaPsnVKNsxktId0JUj0T
RiozymBCPtAMTV7YbzaCkjNxgBMi1PhB5rJQMHK5/S33Q3Z2JGuXhfX9qZFl5Sz0
2uTxhVH+/NSgfafHrA64AiUCgYAZdt/mOZ1vK+cchXTzGDvrpBlZYEViK5tjwLRB
Hipj44WA3WZxBe0Dw1GH1RFjMQpVSW/m5HPpgCx/CMNHMC57tK5Kl+IO66ICP1Gt
IeiiL6Jnzv0/gFgC0ce9qtQsBDt+Re0UFWqoYZPhUDvB/2hJ5VquombHh9A/FsTt
+l9jvwKBgQC8utARFyZbhpa42HSq8JpE2GV4/JHGo+a+jGI4CKus+HYLG4ILL3sd
dsyYppekDo9LOvD7jMCKb2bmNcLeGhihcwzVYSg+ivpO9kVGB8wzpxdTVXKH4bCo
QiaYLGAU81Y0EJrmw1vin6jQY92+JSnou/ZgOKTqWEpvBV4pvOBacA==
-----END RSA PRIVATE KEY-----
DELIM

				cat > /etc/ssl/nginx/server.cert <<DELIM
-----BEGIN CERTIFICATE-----
MIIDCzCCAfOgAwIBAgIJAOeMvrD8wE0fMA0GCSqGSIb3DQEBBQUAMBwxGjAYBgNV
BAMMEWluZm9zdGFuZGVyLmxvY2FsMB4XDTE0MDMzMTEwMzYyNVoXDTI0MDMyODEw
MzYyNVowHDEaMBgGA1UEAwwRaW5mb3N0YW5kZXIubG9jYWwwggEiMA0GCSqGSIb3
DQEBAQUAA4IBDwAwggEKAoIBAQCv9cQciNSr0mIjZyIqMnpr9t1/n/cXGslchiLD
6sU7sYTL6XJF8AtWEyJmllA6jh9iTQC9Nvdm1ObBEO8/e4iwT/GJwrun4X7vzFdT
MUMMkagW1KCPKJJLdWq/8Sju1BY9xkjTFGUpQwfVfbJ6tqx6yh0F9QCsRTujtpc/
ym/TexpTZgbAhMgxXmQo3nX4CKpa7sEUU2x/V2MEhqEa3bS8VMm9sp1YxK//2GoM
TYGbZ9bapl9J3n5UXVH0tMgRG6+uRH+k7BwNfE5hR/wME4VUg1k5oEAhTf7ZxkRe
yyTJ8B+FLdZpPgMhADylWq+f0ThueikbNaEuC7jgiEqUcYSBAgMBAAGjUDBOMB0G
A1UdDgQWBBS2aKYdKQHo9VWVz5a+PUFwubdsRzAfBgNVHSMEGDAWgBS2aKYdKQHo
9VWVz5a+PUFwubdsRzAMBgNVHRMEBTADAQH/MA0GCSqGSIb3DQEBBQUAA4IBAQAj
wmFkHq5NXwqG0QF98tVG+7iU9LqT18gyOjLw/oZeSgE+FI4D1+2ejft838/usE7M
8IEps5apWVJ1RtUv5yiFatxMhbrYEQLiTuMv395MzOiYcnf6Q3hV5cC3ADOquuLq
LRd4KWb2Y7gx0dzO9+bPd5l+JjF3OXNJuGFKhq8K0/UrYz1X+hXQWmDxzUyv8W63
fCtg8B4069q5jh2nk8Zz5PjxWpekQ9kRGhu59vSQa2Bk+lVhlKo4sGF5o22Nu2Es
MPIM5fVpjlk86lZVGGCN97Y1Jghl01p6ZkmIwyd7Heg+Xdc+yTHGWKrzgOOjH9Tr
FRMjoVlMmXmMnDeGuB4l
-----END CERTIFICATE-----
DELIM

					CERT=/etc/ssl/nginx/server.cert
					CERTKEY=/etc/ssl/nginx/server.key
					break
					;;

        [Nn]* )
					read -p "Location of the SSL certificate: " CERT
					read -p "Location of the SSL certificate key: " CERTKEY
					break
					;;

        * ) echo "${YELLOW}Please answer yes or no!${RESET}";;
    esac
	done
}

##
# Install search node and configuration.
##
function setupSearchNode {
	# Check if search node have been installed.
	if [ -f '/etc/nginx/sites-available/search.conf' ]; then
		echo "${YELLOW}Search node exists and will not be installed, so ${GREEN}skipping${YELLOW} this part.${RESET}"
		return;
	fi

	# Clone serch node
	while true; do
		read -p "Where to place search node (/home/www/search_node): " INSTALL_PATH
		if [ -z $INSTALL_PATH ]; then
			INSTALL_PATH="/home/www/search_node"
		fi
		if [ ! -d $INSTALL_PATH ]; then
			mkdir -p $INSTALL_PATH
			git clone https://github.com/search-node/search_node.git ${INSTALL_PATH}/.
			break
		fi
		echo "${RED}Please use another path, that don't exists allready!${RESET}"
	done

	# Checkout version
	cd $INSTALL_PATH
	git checkout ${SERACH_NODE_VERSION}

	# Ensure logs folder exists.
	if [ ! -d ${INSTALL_PATH}/logs ]; then
		mkdir -p ${INSTALL_PATH}/logs
	fi

	# Install npm packages
	echo "${GREEN}Installing search_node requirements...${RESET}"
	${INSTALL_PATH}/install.sh > /dev/null 2>&1

	# Configure nginx
	read -p "Search node FQDN (search.example.com): " DOMAIN
	if [ -z $DOMAIN ]; then
		DOMAIN="search.exsample.com"
	fi

	cat > /etc/nginx/sites-available/search.conf <<DELIM
upstream nodejs_search {
  server 127.0.0.1:3010;
}

server {
  listen 80;

  server_name ${DOMAIN};
  rewrite ^ https://\$server_name\$request_uri? permanent;


  access_log /var/log/nginx/search_access.log;
  error_log /var/log/nginx/search_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name ${DOMAIN};

  access_log /var/log/nginx/search_access.log;
  error_log /var/log/nginx/search_error.log;

  location / {
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;

    proxy_buffering off;

    proxy_pass http://nodejs_search/;
    proxy_redirect off;
  }

  location /socket.io/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://nodejs_search;
  }

  ssl on;
  ssl_certificate ${CERT};
  ssl_certificate_key ${CERTKEY};

  ssl_session_timeout 5m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
DELIM

	# Configure search node.
	echo "${GREEN}Configure search node...${RESET}"
	cd $INSTALL_PATH
	cp example.config.json config.json

	read -p "Name to identify the search index by (os2display-index): " NAME
	if [ -z $NAME ]; then
		NAME="os2display-index"
	fi
	INDEX=`echo $NAME | md5sum | cut -f1 -d" "`

	cat > ${INSTALL_PATH}/mappings.json <<DELIM
{
  "${INDEX}": {
    "name": "${NAME}",
    "tag": "private",
    "fields": [
      {
        "field": "title",
        "type": "string",
        "language": "da",
        "country": "DK",
        "default_analyzer": "string_index",
        "default_indexer": "analyzed",
        "sort": true,
        "indexable": true,
        "raw": false
      }
    ],
    "dates": [ "created_at", "updated_at" ]
  }
}
DELIM

	# Config file for apikeys
	read -p "Name to identify the API key by (os2display-test): " APINAME
	if [ -z $APINAME ]; then
		APINAME="os2display-test"
	fi
	APIKEY=`echo $APINAME | md5sum | cut -f1 -d" "`

	cat > ${INSTALL_PATH}/apikeys.json <<DELIM
{
  "${APIKEY}": {
    "name": "${APINAME}",
    "expire": 300,
    "indexes": [
      "${INDEX}"
    ],
    "access": "rw"
  }
}
DELIM

	# Add supervisor startup script.
	read -p "Who should the search node be runned as ($(whoami)): " USER
	if [ -z $USER ]; then
		USER=$(whoami)
	fi
	cat > /etc/supervisor/conf.d/search_node.conf <<DELIM
[program:search-node]
command=node ${INSTALL_PATH}/app.js
autostart=true
autorestart=true
environment=NODE_ENV=production
stderr_logfile=/var/log/search-node.err.log
stdout_logfile=/var/log/search-node.out.log
user=${USER}
DELIM

	# Start search node and activate index.
	service supervisor restart
	## TODO: Activate index. Find out if the current version has this support.
}

##
# Setup and configure middleware.
##
function setupMiddleWare {
	# Check if search node have been installed.
	if [ -f '/etc/nginx/sites-available/middleware.conf' ]; then
		echo "${YELLOW}Middelware exists and will not be installed, so ${GREEN}skipping${YELLOW} this part.${RESET}"
		return;
	fi

	# Clone middelware
	while true; do
		read -p "Where to place middleware (/home/www/middleware): " INSTALL_PATH
		if [ -z $INSTALL_PATH ]; then
			INSTALL_PATH="/home/www/middleware"
		fi
		if [ ! -d $INSTALL_PATH ]; then
			mkdir -p $INSTALL_PATH
			git clone https://github.com/itk-os2display/middleware.git ${INSTALL_PATH}/.
			break
		fi
		echo "${RED}Please use another path, that don't exists allready!${RESET}"
	done

	# Checkout version
	cd $INSTALL_PATH
	git checkout ${MIDDLEWARE_VERSION}

	# Ensure logs folder exists.
	if [ ! -d ${INSTALL_PATH}/logs ]; then
		mkdir -p ${INSTALL_PATH}/logs
	fi

	# Install npm packages
	echo "${GREEN}Installing middleware requirements...${RESET}"
	${INSTALL_PATH}/install.sh > /dev/null 2>&1

	# Configure nginx
	read -p "Middelware FQDN (middleware.example.com): " DOMAIN
	if [ -z $DOMAIN ]; then
		DOMAIN="middleware.example.com"
	fi

	cat > /etc/nginx/sites-available/middleware.conf <<DELIM
upstream nodejs_middleware {
  server 127.0.0.1:3020;
}

server {
  listen 80;

  server_name ${DOMAIN};
  rewrite ^ https://\$server_name\$request_uri? permanent;


  access_log /var/log/nginx/middleware_access.log;
  error_log /var/log/nginx/middleware_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name ${DOMAIN};

  access_log /var/log/nginx/middleware_access.log;
  error_log /var/log/nginx/middleware_error.log;

  location / {
    proxy_set_header X-Real-IP \$remote_addr;
    proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    proxy_set_header Host \$http_host;

    proxy_buffering off;

    proxy_pass http://nodejs_middleware/;
    proxy_redirect off;
  }

  location /socket.io/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade \$http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://nodejs_middleware;
  }

  ssl on;
  ssl_certificate ${CERT};
  ssl_certificate_key ${CERTKEY};

  ssl_session_timeout 5m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
DELIM

	# Configure middleware
	read -p "Administrator username (admin): " ADMIN_USER
	if [ -z $ADMIN_USER ]; then
		ADMIN_USER="admin"
	fi

	echo -n "Administrator password (admin): "
	read -s ADMIN_PASSWORD
	echo " "
	if [ -z $ADMIN_PASSWORD ]; then
		ADMIN_PASSWORD="admin"
	fi

	echo -n "Secrect token used in communcation (MySuperSecret): "
	read -s SECRECT_TOKEN
	echo " "
	if [ -z $SECRECT_TOKEN ]; then
		SECRECT_TOKEN="MySuperSecret"
	fi
	cat > ${INSTALL_PATH}/config.json <<DELIM
{
  "port": 3020,
  "secret": "${SECRECT_TOKEN}",
  "logs": {
    "info": "logs/info.log",
    "error": "logs/error.log",
    "debug": "logs/debug.log",
    "socket": "logs/socket.log"
  },
  "admin": {
    "username": "${ADMIN_USER}",
    "password": "${ADMIN_PASSWORD}"
  },
  "cache": {
    "port": "6379",
    "host": "localhost",
    "auth": null,
    "db": 0
  },
  "apikeys": "apikeys.json"
}
DELIM

# Config file for apikeys
read -p "Name to identify the API key by (os2display-test): " APINAME
if [ -z $APINAME ]; then
	APINAME="os2display-test"
fi
APIKEY=`echo $APINAME | md5sum | cut -f1 -d" "`

read -p "FQDN for the administration interface (admin.example.com): " ADMIN_DOMAIN
if [ -z $ADMIN_DOMAIN ]; then
	ADMIN_DOMAIN="admin.example.com"
fi

cat > ${INSTALL_PATH}/apikeys.json <<DELIM
{
  "${APIKEY}": {
    "name": "${APINAME}",
    "backend": "${ADMIN_DOMAIN}",
    "expire": 300
  }
}
DELIM

	# Add supervisor startup script.
	read -p "Who should the middleware be runned as ($(whoami)): " USER
	if [ -z $USER ]; then
		USER=$(whoami)
	fi
	cat > /etc/supervisor/conf.d/middleware.conf <<DELIM
[program:middleware]
command=node ${INSTALL_PATH}/app.js
autostart=true
autorestart=true
environment=NODE_ENV=production
stderr_logfile=/var/log/middleware.err.log
stdout_logfile=/var/log/middleware.out.log
user=${USER}
DELIM

	# Start search node and activate index.
	service supervisor restart
}

function setupAdmin {
	echo "tis";
}

function setupScreen {
	echo "tis";
}

getSSLCertificate;
setupSearchNode;
setupMiddleWare;
