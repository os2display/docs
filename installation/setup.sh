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
MIDDLEWARE_VERSION="v4.2.2"
ADMIN_VERSION="v4.2.2"
SCREEN_VERSION="v4.2.2"

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
  echo "${YELLOW}Installing Search Node:${RESET}"

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
  ln -s /etc/nginx/sites-available/search.conf /etc/nginx/sites-enabled/search.conf

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
      },
      {
        "type": "string",
        "country": "DK",
        "language": "da",
        "default_analyzer": "string_index",
        "default_indexer": "analyzed",
        "sort": true,
        "indexable": true,
        "raw": false,
        "geopoint": false,
        "field": "name"
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

  # Change owner of search node to the selected user.
  chown -R ${USER} ${INSTALL_PATH}

  # Start search node and activate index.
  service supervisor restart
  ## TODO: Activate index. Find out if the current version has this support.
}

##
# Setup and configure middleware.
##
function setupMiddleWare {
  echo "${YELLOW}Installing Middleware:${RESET}"

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
			git clone https://github.com/os2display/middleware.git ${INSTALL_PATH}/.
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

	# Install npm packages.
	echo "${GREEN}Installing middleware requirements...${RESET}"
	${INSTALL_PATH}/install.sh > /dev/null 2>&1

	# Configure nginx.
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
ln -s /etc/nginx/sites-available/middleware.conf /etc/nginx/sites-enabled/middleware.conf

# Configure middleware.
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

echo -n "Secret token used in communcation (MySuperSecret): "
read -s SECRET_TOKEN
echo " "
if [ -z $SECRET_TOKEN ]; then
  SECRET_TOKEN="MySuperSecret"
fi
cat > ${INSTALL_PATH}/config.json <<DELIM
{
  "port": 3020,
  "secret": "${SECRET_TOKEN}",
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

  # Config file for apikeys.
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

  # Change owner of the middleware to the selected user.
  chown -R ${USER} ${INSTALL_PATH}

  # Start search node and activate index.
  service supervisor restart
}

##
# Setup and configure administration site.
##
function setupAdmin {
  echo "${YELLOW}Installing Administration interface:${RESET}"

	# Clone admin
	while true; do
		read -p "Where to place administration interface (/home/www/example_com/admin): " INSTALL_PATH
		if [ -z $INSTALL_PATH ]; then
			INSTALL_PATH="/home/www/example_com/admin"
		fi
		if [ ! -d $INSTALL_PATH ]; then
			mkdir -p $INSTALL_PATH
			git clone https://github.com/os2display/admin.git ${INSTALL_PATH}/.
			break
		fi
		echo "${RED}Please use another path, that don't exists allready!${RESET}"
	done

	# Checkout version
	cd $INSTALL_PATH
	git checkout ${ADMIN_VERSION}

	# Configure nginx.
	read -p "Admin FQDN (admin.example.com): " DOMAIN
	if [ -z $DOMAIN ]; then
		DOMAIN="admin.example.com"
	fi
	FILENAME=${DOMAIN//./_}

	# Configure nginx.
  cat > /etc/nginx/sites-available/${FILENAME}.conf <<DELIM
server {
  listen 80;

  server_name ${DOMAIN};
  root ${INSTALL_PATH}/web;

  rewrite ^ https://\$server_name\$request_uri? permanent;

  access_log /var/log/nginx/${FILENAME}_access.log;
  error_log /var/log/nginx/${FILENAME}_error.log;
}


# HTTPS server
#
server {
  listen 443;

  server_name ${DOMAIN};
  root ${INSTALL_PATH}/web;

  client_max_body_size 300m;

  access_log /var/log/nginx/${FILENAME}_access.log;
  error_log /var/log/nginx/${FILENAME}_error.log;

  location / {
    # try to serve file directly, fallback to rewrite
    try_files \$uri @rewriteapp;
  }

  location @rewriteapp {
    # rewrite all to app.php
    rewrite ^(.*)\$ /app_dev.php/\$1 last;
  }

  location ~ ^/(app|app_dev|config)\.php(/|\$) {
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_split_path_info ^(.+\.php)(/.*)\$;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    fastcgi_param HTTPS off;
  }

  # deny access to .htaccess files, if Apache's document root
  # concurs with nginx's one
  location ~ /\.ht {
    deny all;
  }

  location /templates/ {
    add_header 'Access-Control-Allow-Origin' "*";
  }

  location /proxy/ {
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
  ln -s /etc/nginx/sites-available/${FILENAME}.conf /etc/nginx/sites-enabled/${FILENAME}.conf

  # Database information.
  read -p "Database (${FILENAME}): " DB
  if [ -z $DB ]; then
    DB=${FILENAME}
  fi
  read -p "Database username (root): " DB_USER
  if [ -z $DB_USER ]; then
    DB_USER="root"
  fi
  echo -n "Database password (root): "
  read -s DB_PASSWORD
  echo " "
  if [ -z $DB_PASSWORD ]; then
    DB_PASSWORD="root"
  fi

  # Symfony secret toke.
  echo -n "Secret token (ThisTokenIsNotSoSecretChangeIt): "
  read -s SECRET_TOKEN
  echo " "
  if [ -z $SECRET_TOKEN ]; then
    SECRET_TOKEN="ThisTokenIsNotSoSecretChangeIt"
  fi

  # Mail information.
  read -p "Mail from address (webmaster@os2display.dk): " MAIL_ADDRESS
  if [ -z $MAIL_ADDRESS ]; then
    MAIL_ADDRESS="webmaster@os2display.dk"
  fi
  read -p "Mail from name (webmaster): " MAIL_NAME
  if [ -z $MAIL_NAME ]; then
    MAIL_NAME="webmaster"
  fi

  # Search information.
  read -p "Search host (https://search.example.com): " SERACH_HOST
  if [ -z $SERACH_HOST ]; then
    SERACH_HOST="https://search.example.com"
  fi
  read -p "Search API key: " SERACH_APIKEY
  read -p "Search index: " SERACH_INDEX

  # Middleware information.
  read -p "Middleware host (https://middleware.example.com): " MIDDLEWARE_HOST
  if [ -z $MIDDLEWARE_HOST ]; then
    MIDDLEWARE_HOST="https://middleware.example.com"
  fi
  read -p "Middleware API key: " MIDDLEWARE_APIKEY

  # Koba information.
  read -p "KOBA host: " KOBA_HOST
  read -p "KOBA API key: " KOBA_APIKEY

  # Zencoder api key
  read -p "Zencoder API key: " ZENCODER_APIKEY

  # Site title
  read -p "Site title (OS2Display example): " SITE_TITLE
  if [ -z $SITE_TITLE ]; then
    SITE_TITLE="OS2Display example"
  fi

  # Build parameters for symfony.
  cat > ${INSTALL_PATH}/app/config/parameters.yml <<DELIM
parameters:
  database_driver: pdo_mysql
  database_host: 127.0.0.1
  database_port: null
  database_name: ${DB}
  database_user: ${DB_USER}
  database_password: ${DB_PASSWORD}

  mailer_transport: smtp
  mailer_host: 127.0.0.1
  mailer_user: null
  mailer_password: null

  locale: en
  secret: ${SECRET_TOKEN}
  debug_toolbar: false
  debug_redirects: false

  use_assetic_controller: true

  absolute_path_to_server: 'https://${DOMAIN}'

  zencoder_api: ${ZENCODER_APIKEY}

  mailer_from_email: ${MAIL_ADDRESS}
  mailer_from_name: ${MAIL_NAME}

  templates_directory: ik-templates/

  sharing_enabled: false
  sharing_host:
  sharing_path: /api
  sharing_apikey:

  search_host: ${SERACH_HOST}
  search_path: /api
  search_apikey: ${SERACH_APIKEY}
  search_index: ${SERACH_INDEX}
  search_filter_default: all

  middleware_host: ${MIDDLEWARE_HOST}
  middleware_path: /api
  middleware_apikey: ${MIDDLEWARE_APIKEY}

  templates_slides_directory: templates/slides/
  templates_slides_enabled:
    - manual-calendar
    - only-image
    - only-video
    - portrait-text-top
    - text-bottom
    - text-left
    - text-right
    - text-top
    - ik-iframe
    - header-top
    - event-calendar
    - wayfinding

  templates_screens_directory: templates/screens/
  templates_screens_enabled:
    - full-screen
    - five-sections
    - full-screen-portrait

  site_title: ${SITE_TITLE}

  koba_apikey: ${KOBA_APIKEY}
  koba_path: ${KOBA_HOST}

  version: ${ADMIN_VERSION}

  itk_log_version: 1
  itk_log_error_callback: /api/error
  itk_log_log_to_console: true
  itk_log_log_level: all
DELIM

  # Install symfony.
  SYMFONY_ENV=prod
  echo "${GREEN}Installing administration...${RESET}"
  cd $INSTALL_PATH
  echo "create database ${DB}" | mysql -u${DB_USER} -p${DB_PASSWORD} > /dev/null || exit 1
  composer install > /dev/null || exit 1

  echo "${GREEN}Setup database...${RESET}"
  php app/console doctrine:migrations:migrate --no-interaction > /dev/null || exit 1

  # Setup super-user.
  read -p "Super user name (admin): " SU_USER
  if [ -z $SU_USER ]; then
    SU_USER="admin"
  fi
  echo -n "Super user password (admin): "
  read -s SU_PASSWORD
  echo " "
  if [ -z $SU_PASSWORD ]; then
    SU_PASSWORD="admin"
  fi
  read -p "Super user mail (admin@example.com): " SU_MAIL
  if [ -z $SU_MAIL ]; then
    SU_MAIL="admin@example.com"
  fi

  cd $INSTALL_PATH
  echo "Setting up super-user: admin/admin"
  php app/console fos:user:create --super-admin ${SU_USER} ${SU_MAIL} $SU_PASSWORD > /dev/null || exit 1

  # Cron job.
  (crontab -l && echo "*/1 * * * * /usr/bin/php ${INSTALL_PATH}/app/console ik:cron") | crontab

  # Change owner.
  read -p "Name of the normal OS user ($(whoami)): " NORMAL_USER
  if [ -z $NORMAL_USER ]; then
    NORMAL_USER=$(whoami)
  fi
  mkdir -p ${INSTALL_PATH}/web/uploads
  mkdir -p ${INSTALL_PATH}/app/{cache,logs}
  chown -R ${NORMAL_USER}:${NORMAL_USER} ${INSTALL_PATH} || exit 1
  chown -R www-data:${NORMAL_USER} ${INSTALL_PATH}/web/uploads ${INSTALL_PATH}/app/{cache,logs} || exit 1
  chmod -R g+w ${INSTALL_PATH}/web/uploads ${INSTALL_PATH}/app/{cache,logs} || exit 1
}

##
# Install screen.
##
function setupScreen {
  echo "${YELLOW}Installing Screen:${RESET}"

	# Clone screen.
	while true; do
		read -p "Where to place screen (/home/www/example_com/screen): " INSTALL_PATH
		if [ -z $INSTALL_PATH ]; then
			INSTALL_PATH="/home/www/example_com/screen"
		fi
		if [ ! -d $INSTALL_PATH ]; then
			mkdir -p $INSTALL_PATH
			git clone https://github.com/os2display/screen.git ${INSTALL_PATH}/.
			break
		fi
		echo "${RED}Please use another path, that don't exists allready!${RESET}"
	done

	# Checkout version.
	cd $INSTALL_PATH
	git checkout ${SCREEN_VERSION}

	# Configure nginx.
	read -p "Screen FQDN (screen.example.com): " DOMAIN
	if [ -z $DOMAIN ]; then
		DOMAIN="screen.example.com"
	fi
	FILENAME=${DOMAIN//./_}

	# Configure nginx.
	cat > /etc/nginx/sites-available/${FILENAME}.conf <<DELIM
server {
  listen 80;

  server_name ${DOMAIN};
  root ${INSTALL_PATH};

  rewrite ^ https://\$server_name\$request_uri? permanent;

  access_log /var/log/nginx/${FILENAME}_access.log;
  error_log /var/log/nginx/${FILENAME}_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name ${DOMAIN};
  root ${INSTALL_PATH}/;

  client_max_body_size 300m;

  access_log /var/log/nginx/${FILENAME}_access.log;
  error_log /var/log/nginx/${FILENAME}_error.log;

  location / {
    try_files \$uri \$uri/index.html =404;
  }

  location /proxy/ {
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
  ln -s /etc/nginx/sites-available/${FILENAME}.conf /etc/nginx/sites-enabled/${FILENAME}.conf

  # Configuration for screen
  read -p "Admin FQDN (admin.example.com): " ADMIN_DOMAIN
  if [ -z $ADMIN_DOMAIN ]; then
    ADMIN_DOMAIN="admin.example.com"
  fi

  read -p "Middleware API key: " MIDDLEWARE_APIKEY

  cat > ${INSTALL_PATH}/app/config.js <<DELIM
window.config = {
  "resource": {
    "server": "//${DOMAIN}/",
    "uri": 'proxy'
  },
  "ws": {
    "server": "https://${DOMAIN}/"
  },
  "backend": {
    "address": "https://${ADMIN_DOMAIN}/"
  },
  "apikey": "${MIDDLEWARE_APIKEY}",
  "cookie": {
    "secure": false
  },
  "debug": false,
  "version": "dev",
  "itkLog": {
    "version": "1",
    "errorCallback": null,
    "logToConsole": false,
    "logLevel": "all"
  },
  fallback_image: "assets/images/os2display-fallback.jpg"
};
DELIM
}

##
# Restart services.
##
function restartServices {
	service supervisor restart
	service nginx restart
}

getSSLCertificate;

while (true); do
  echo "##########################################"
  echo "##            ${YELLOW}Installation${RESET}              ##"
  echo "##########################################"
  echo "##                                      ##"
  echo "##  1 - Complete system                 ##"
  echo "##  2 - Search node (if not installed)  ##"
  echo "##  3 - Middleware (if not installed)   ##"
  echo "##  4 - New site (admin/screen)         ##"
  echo "##  5 - Exit                            ##"
  echo "##                                      ##"
  echo "##########################################"
  read -p "What should we install (1-5)? " SELECTED
  case $SELECTED in
    1)
      setupSearchNode;
      setupMiddleWare;
      setupAdmin;
      setupScreen;
      restartServices;
      ;;

    2)
      setupSearchNode;
      restartServices;
      ;;

    3)
      setupMiddleWare;
      restartServices;
      ;;

    4)
      setupAdmin;
      setupScreen;
      restartServices;
      ;;

    5)
      break;;

  esac
done
