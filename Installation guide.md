@TODO Rename Github organization Indholdskanalen -> Aroskanalen

This is an installation guide to setup and configure the aroskanalen display system.

# Requirements
The guide assumes that you have an installed linux based server with the following packages installed and at least the versions given.

 * nginx 1.4.x
 * redis 2.8.x
 * php 5.5.x
 * node 0.10.x
 * elastic search 1.5.x
 * supervisor 3.x
 * Valid SSL certificates for you domain. 
 
The document also assumes that you are logged in as the user _deploy_, if this is not the case, you need to change this (e.g. the supervisor run script).

## The parts
The system consists of four parts:

__Admin__ - administration interface (symfony)

__Screen__ - that serves content on the screens

__Middleware__ - that handles web-sockets and connection between the ones above.

__Search node__ - that interfaces with elastic search and provide fast content search in the administration interface.

# The setup
The _middleware_ and _search node_ is only installed once on each server and then all administration interfaces and screens communicates with the them using API keys to identify them self and ensure content separation.

## Conventions
This document uses __[]__ square brackets around the different variables in the configuration templates that needs to be exchanged with the actual values from other parts of the configuration (e.g. API keys).

Her is an explanation of the different key configuration variables.

  * [server name]
  * [client name]
  * [SSL CERT]
  * [SSL KEY]
  * [CHANGE ME]
  * [PASSWORD]
  * [DB NAME]
  * [DB USER]
  * [DB PASSWORD]
  * [ZENCODER API KEY]
  * [SHARING API KEY]
  * [SEARCH API KEY]
  * [SEARCH INDEX KEY]
  * [MIDDLEWARE API KEY]
  * @TODO Document placeholders [...]
  
<pre>
Things in boxes are commands that should be executed or configuration thats need in the files given.
</pre>

## Naming
We have chosen to use the following naming convention and place the application in _/home/www_/.

We have used the following naming in DNS:

  * search-[server name].aroskanalen.dk
  * middleware-[server name].aroskanalen.dk
  * screen-[client name].aroskanalen.dk
  * admin-[client name].aroskanalen.dk

And this will give the folders:

  * /home/www/[client name]_aroskanalen_dk/admin
  * /home/www/[client name]_aroskanalen_dk/screen
  * /home/www/[client name]_aroskanalen_dk/logs

The Middleware and search node is located in:

  * /home/www/middleware
  * /home/www/search_node









# Installation

If you already have a running middleware and search node on the server you can skip the steps and just add the needed api-keys in both and add mappings in the search node.
You can use the UI or edit the JSON files directly.

__Note:__ To install the newest version (development version that's not aways stable), you should checkout the development branches in the all the cloned repositories instead of the latest version tag.

## Middleware

### Clone
Start by cloning the git repository for the middleware and checkout the latest release tag (which can be found using _git tag_).

<pre>
cd /home/www
git clone git@github.com:aroskanalen/middleware.git
cd middleware
git checkout [v3.x.x]
</pre>

### Node packages
The middleware is build as a NodeJS application and the different plugins require libraries to be installed. The application comes with an installation script that do this, just run it.

<pre>
./install.sh
</pre>

### Configuration
First we need to configure nginx in front of the middleware so it's accessible through normal web-ports and also to proxy web-socket connections.

<pre>
sudo nano -w /etc/nginx/sites-available/nodejs
</pre>

In this file add an upstream connection to the middleware application. Later a connection for the search node will also added as well.

<pre>
upstream nodejs_middleware {
  server 127.0.0.1:3020;
}
</pre>

To access the middleware administration and allow the screen to communication with the middleware a virtual host configuration is needed. You need to change the _[server name]_ with the actual name of the server.

<pre>
sudo nano -w /etc/nginx/sites-available/middleware_[server name]_aroskanalen_dk
</pre>

<pre>
server {
  listen 80;

  server_name middleware-[server name].aroskanalen.dk;
  rewrite ^ https://$server_name$request_uri? permanent;

  access_log /var/log/nginx/middleware_access.log;
  error_log /var/log/nginx/middleware_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name middleware-[server name].aroskanalen.dk;

  access_log /var/log/nginx/middleware_access.log;
  error_log /var/log/nginx/middleware_error.log;

  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;

    proxy_buffering off;

    proxy_pass http://nodejs_middleware/;
    proxy_redirect off;
  }

  location /socket.io/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://nodejs_middleware;
  }

  ssl on;
  ssl_certificate /etc/nginx/ssl/[SSL CERT].crt;
  ssl_certificate_key /etc/nginx/ssl/[SSL KEY].key;

  ssl_session_timeout 5m;
  ssl_session_cache shared:SSL:10m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
</pre>

Next step is to configure the application by setting the secret (used to encode security tokens use to ensure safe communication with the middleware) and administrator users password. If you have other applications on the server that's using Redis, you can change the default database using the "db" key under cache section in the configuration file (by default redis has the database 1 to 15 available).

<pre>
nano -w /home/www/middleware/config.json
</pre>

<pre>
{
  "port": 3020,
  "secret": "[CHANGE ME]",
  "log": {
    "file": "messages.log",
    "debug": false
  },
  "admin": {
    "username": "admin",
    "password": "[PASSWORD]"
  },
  "cache": {
    "port": "6379",
    "host": "localhost",
    "auth": null,
    "db": 1
  },
  "apikeys": "apikeys.json"
}
</pre>

Before starting and testing the middleware application you need to create the _apikeys.json_ file with an empty JSON object or optionally added the demo key below. If you only add an empty (_{}_) JSON object you need to use the middleware UI through a web-browser to add API keys. It will help you generate random keys. 

__Note:__ Each installation of the administration interface (Symfony backend) and screens requires a new API key to ensure separation of data in the middleware. The middleware UI also provides a status page to reload and logout screen and see if the screens are connected to the middleware.

<pre>
nano -w /home/www/middleware/apikeys.json
</pre>

Demo content for the _apikeys.json_ file. This API key should not be used in production environments as the key is public known.
<pre>
{
  "03303f8bf868b517bb732326aca86714": {
    "name": "[client name]",
    "expire": 300,
    "backend": "https://admin-[client name].aroskanalen.dk"
  }
}
</pre>

Enable nginx configuration by adding symbolic links into the _sites-enabled_ folder and restarting the service.
<pre>
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/middleware_[server name]_aroskanalen_dk
sudo ln -s ../sites-available/nodejs
sudo service nginx restart
</pre>

The middleware needs to be started at boot time which requires a Supervisor run script. Supervisor will also ensure that the node application is started again, if an error happens and it stops running.

<pre>
sudo nano -w /etc/supervisor/conf.d/middleware.conf
</pre>

The run script to keep the middleware running.
<pre>
[program:middleware]
command=/usr/bin/node /home/www/middleware/app.js
autostart=true
autorestart=true
environment=NODE_ENV=production
stderr_logfile=/var/log/middleware.err.log
stdout_logfile=/var/log/middleware.out.log
user=deploy
</pre>

Now restart the supervisor service to get the middleware running.
<pre>
sudo service supervisor restart
</pre>

### UI

@TODO: How to use the UI to add more configuration ap-keys.








## Search node
The search node application is a general purpose application to provide a fast search engine through web-socket connections (using elasticsearch) and is designed to be used by other projects as well as aroskanalen. As a result of this, it will not follow the same versioning as the other parts of this installation. It's also why its UI is somewhat complex to use when setting up the right mappings to be used with aroskanalen.

### Clone
Start by cloning the git repository for the search node and checkout the latest release tag (which can be found using _git tag_).

<pre>
cd /home/www
git clone git@github.com:aroskanalen/search_node.git
cd search_node
git checkout [v1.x.x]
</pre>

### Node packages
Search node, as the middleware, uses a plugin architecture that requires installation of libraries from the node package manager (npm). The application comes with an installation script to handle this, simply go to the root of the application and execute the script.

<pre>
cd /home/www/search_node/
./install.sh
</pre>

### Configuration

We need to configure nginx to sit in front of the search node so it is accessible through normal web-ports and also proxy web-socket connections. So we add the upstream connection configuration in the nodejs configuration file used by the middleware.

<pre>
sudo nano -w /etc/nginx/sites-available/nodejs
</pre>

Append this upstream connection definition to the file.

<pre>
upstream nodejs_search {
  server 127.0.0.1:3010;
}
</pre>

To access the search node UI and allow the aroskanalen administration interface to communication with the search node a virtual host configuration is needed. You need to change the _[server name]_ with the actual name of the server.

<pre>
sudo nano -w /etc/nginx/sites-available/search_[server name]_aroskanalen_dk
</pre>

<pre>
server {
  listen 80;

  server_name search-[server name].aroskanalen.dk;
  rewrite ^ https://$server_name$request_uri? permanent;

  access_log /var/log/nginx/search_access.log;
  error_log /var/log/nginx/search_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name search-[server name].aroskanalen.dk;

  access_log /var/log/nginx/search_access.log;
  error_log /var/log/nginx/search_error.log;

  location / {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;

    proxy_buffering off;

    proxy_pass http://nodejs_search/;
    proxy_redirect off;
  }

  location /socket.io/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://nodejs_search;
  }

  ssl on;
  ssl_certificate /etc/nginx/ssl/[SSL CERT].crt;
  ssl_certificate_key /etc/nginx/ssl/[SSL KEY].key;

  ssl_session_timeout 5m;
  ssl_session_cache shared:SSL:10m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
</pre>

Enable the configuration by adding a symbolic links for the search node. The nodejs configuration file should be linked during configuration of the middleware. Restart nginx to enable the configuration.

<pre>
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/search_[server name]_aroskanalen_dk
sudo service nginx restart
</pre>

Next the application needs to be configured by adding the following content to config.json. Remember to update the administration password and secret.

<pre>
sudo nano -w /home/www/search_node/config.json
</pre>

<pre>
{
  "port": 3010,
  "secret": "[CHANGE ME]",
  "admin": {
    "username": "admin",
    "password": "[PASSWORD]"
  },
  "log": {
    "file": "messages.log",
    "debug": false
  },
  "search": {
    "hosts": [ "localhost:9200" ],
    "mappings": "mappings.json"
  },
  "apikeys": "apikeys.json"
}
</pre>

Before the application can be started the _apikeys.json_ and _mappings.json_ needs to exist and at least contain an empty JSON object (_{}_).

<pre>
cat '{}' > /home/www/search_node/apikeys.json
cat '{}' > /home/www/search_node/mappings.json
</pre>

The search node needs to be started at boot time which requires a Supervisor run script. Supervisor will also ensure that the node application is restarted, if an error happens and it stops unexpectedly.

<pre>
sudo nano -w /etc/supervisor/conf.d/search_node.conf
</pre>

Supervisor run script for the search node.

<pre>
[program:search-node]
command=node /home/www/search_node/app.js
autostart=true
autorestart=true
environment=NODE_ENV=production
stderr_logfile=/var/log/search-node.err.log
stdout_logfile=/var/log/search-node.out.log
user=deploy
</pre>

<pre>
sudo service supervisor restart
</pre>

As mentioned the search node is not specially created for aroskanalen, so the mappings (configuration for elasticsearch) can be somewhat complex to setup in the UI. To get you started the mapping below can be used as a template for the configuration.

As we need the UI to complete the setup correctly the node application needs to have write access to the files. 
<pre>
cd /home/www/search_node/
chmod +w apikeys.json mappings.json
</pre>

Now use the UI (https://search-[server name].aroskanalen.dk) and add a new api key. Then go to the mappings tabs in the UI and add a new empty mapping. Next edit the mappings file and add the _fields_, _tag_ and _dates_ section as in the template. This way you will get a new API key and search index key for each installation. __Note_ that each installation of the _admin_ application requires a new API key and search index. 

<pre>
nano -w /home/www/search_node/mappings.json
</pre>

<pre>
{
  "5d437a016271077510c640e450bde9c3": {
    "name": "demo",
    "tag": "private",
    "fields": [
      {
        "field": "title",
        "type": "string",
        "language": "da",
        "country": "DK",
        "default_analyzer": "string_index",
        "sort": true,
        "indexable": true
      },
      {
        "field": "name",
        "type": "string",
        "language": "da",
        "country": "DK",
        "default_analyzer": "string_index",
        "sort": true,
        "indexable": true
      }
    ],
    "dates": [
      "created_at",
      "updated_at"
    ]
  }
}
</pre>

When you have update the mappings file go back into the UI and select the indexes that you need by edit the API key and select it/them in the edit window. Before a given index can be used you need to activate it in the _indexes_ tab. So do that now.

### UI

@TODO: How to use the UI to add more configuration.






## Administration User Interface
The administration user interface is the _backend_ of the display system and used to add content and setup screens etc.

## Clone

<pre>
cd /home/www/[client name]_aroskanalen_dk
git clone git@github.com:aroskanalen/admin.git
</pre>

It needs to have an SQL database and in this guide we assumes that it's MySQL or MariaDB, so start by creating a database and user given the user privileges to use the database.
<pre>
mysql -u root -p -e "CREATE DATABASE [DB NAME];"
mysql -u root -p -e "CREATE USER '[DB USER]'@'localhost' IDENTIFIED BY '[DB PASSWORD]';"
mysql -u root -p -e "GRANT ALL PRIVILEGES ON [DB NAME].* TO '[DB USER]'@'localhost';"
mysql -u root -p -e "FLUSH PRIVILEGES;"
</pre>

Install the site using composer.
<pre>
cd /home/www/[client name]_aroskanalen_dk/admin
composer install
</pre>

Fill out the questions that you can and use default values for the rest. We will come back to the values below. See the parameters example below to help filling out the values. If you are interested in Symfony you can see their default installation manual at http://symfony.com/doc/current/book/installation.html.

If you want to be able to upload videos to the system you need to have a zencoder account at http://zencoder.com/, which is an online video conversion service. When you upload an video to the system, it sends it to zencoder that re-encodes the video to the formats supported by browser. It's a payed service an is optional, if you don't want videos just write _NULL_ as value.

The koba (Kalender Og Booking Applikation) is a project under Aarhus Kommmune that allows us to display Exchange location bookings on screens. But as this as somewhat a highly specialised service/API you may not have access to it. If not simply use _NULL_ as API key value.

In relation to the sharing section of the configuration it's used to share content across different installations by using a shared API key and index in the search node. The index requires to have the same configuration as a normal index or the aroskanalen, but with a _"tag"_ set to _"shared"_.

The final _app/config/parameters.yml_ file.
<pre>
parameters:
    database_driver: pdo_mysql
    database_host: 127.0.0.1
    database_port: null
    database_name: [DB NAME]
    database_user: [DB USER]
    database_password: '[DB PASSWORD]'

    mailer_transport: sendmail
    mailer_host: 127.0.0.1
    mailer_user: null
    mailer_password: null
    mailer_from_email: webmaster@ik3.aroskanalen.vm
    mailer_from_name: 'Webmaster Aroskanalen'

    locale: en
    secret: [CHANGE ME]
    debug_toolbar: false
    debug_redirects: false
    use_assetic_controller: true

    absolute_path_to_server: 'https://admin-[client name].aroskanalen.dk'
    zencoder_api: [ZENCODER API KEY]

    sharing_host: 'https://search-[server name].aroskanalen.dk'
    sharing_path: /api
    sharing_apikey: [SHARING API KEY]
    sharing_enabled: false

    search_host: 'https://search-[server name].aroskanalen.dk'
    search_path: /api
    search_apikey: [SEARCH API KEY]
    search_index: [SEARCH INDEX KEY]

    middleware_host: 'https://middleware-[server name].aroskanalen.dk'
    middleware_path: /api
    middleware_apikey: [MIDDLEWARE API KEY]

    site_title: 'Demo Aroskanalen'

    koba_apikey: [KOBA API KEY]
    koba_path: 'http://koba.aarhus.dk'
    
    version: [RELEASE_VERSION]

    itk_log_version: 1
    itk_log_error_callback: /api/error
    itk_log_log_to_console: false
    itk_log_log_level: all
</pre>

The web-server needs access to different locations in the filesystem, so you need to change the owner of the folders to the nginx user.
<pre>
cd /home/www/[client name]_aroskanalen_dk/admin
sudo chown -R www-data app/cache/ app/logs/ web/uploads/
</pre>

You can check you site configuration by running this command.
<pre>
cd /home/www/[client name]_aroskanalen_dk/admin
php app/check.php
</pre>

Now install the database tables by running the database update command.
<pre>
php app/console doctrine:schema:update --force
</pre>

Add an administrator user that can be used to test the site and create other users.
<pre>
php app/console fos:user:create [admin username] [test@example.com] [password] --super-admin
</pre>

### Templates
Templates reside in the /web/templates folder. They are separated into screen and slide templates. Each template has its own folder and .json file that needs to be imported into the database. This steps also needs to be executed every time templates are updated or new templates are added to the installation.

<pre>
cd /home/www/[client name]_aroskanalen_dk/admin
php app/console ik:templates:load
</pre>

In the administration menu there is a menu option to enable/disable imported templates.

### Cron
The system uses a cron job to push content from the administration interface to the middleware. To push content every minute edit crontab and add the line below, it will one push new content and updates.
<pre>
crontab -e
</pre>

Add this to crontab.
<pre>
*/1 * * * * /usr/bin/php /home/www/[client name]_aroskanalen_dk/admin/app/console ik:cron > /dev/null 2>&1
</pre>

### Nginx configuration

As with the node applications the administration interface needs a nginx configuration to be accessible from the network.
<pre>
sudo nano -w /etc/nginx/sites-available/admin_[client name]_aroskanalen_dk
</pre>

You need to update the name, paths and ssl certificates.
<pre>
server {
  listen 80;
  server_name admin-[client name].aroskanalen.dk;

  rewrite ^ https://$server_name$request_uri? permanent;

  access_log /home/www/[client name]_aroskanalen_dk/logs/backend_access.log;
  error_log /home/www/[client name]_aroskanalen_dk/logs/backend_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name admin-[client name].aroskanalen.dk;
  root /home/www/[client name]_aroskanalen_dk/admin/web;

  client_max_body_size 300m;

  access_log /home/www/[client name]_aroskanalen_dk/logs/backend_access.log;
  error_log /home/www/[client name]_aroskanalen_dk/logs/backend_error.log;

  location / {
    # try to serve file directly, fallback to rewrite
    try_files $uri @rewriteapp;
  }

  location /templates/ {
    add_header 'Access-Control-Allow-Origin' "*";
  }

  location @rewriteapp {
    # rewrite all to app.php
    rewrite ^(.*)$ /app.php/$1 last;
  }

  location ~ ^/(app|app_dev|config)\.php(/|$) {
    fastcgi_pass unix:/var/run/php5-fpm.sock;
    fastcgi_split_path_info ^(.+\.php)(/.*)$;
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param HTTPS off;
  }

  # deny access to .htaccess files, if Apache's document root
  # concurs with nginx's one
  location ~ /\.ht {
    deny all;
  }

  location /proxy/ {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;

    proxy_buffering off;

    proxy_pass http://nodejs_search/;
    proxy_redirect off;
  }

  location /socket.io/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://nodejs_search;
  }

  ssl on;
  ssl_certificate /etc/nginx/ssl/[SSL CERT].crt;
  ssl_certificate_key /etc/nginx/ssl/[SSL KEY].key;

  ssl_session_timeout 5m;
  ssl_session_cache shared:SSL:10m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
</pre>

Enable the configuration by adding a symbolic link for the configuration and restart nginx to enable it.

<pre>
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/admin_[client name]_aroskanalen_dk
sudo service nginx restart
</pre>

Login to the site and create a new screen, channel and slide to test that it works, you will get a search error until there is something in the search indexes for each of the content types. Also try to upload media, such as an image to test file permissions.








## Screens

Screens are the part of the system used to display the content on, well screens. It communicates via web-socket with the middleware and fetches images and templates form its backend.

### Clone

First clone the screen code.
<pre>
 cd /home/www/[client name]_aroskanalen_dk
 git clone git@github.com:aroskanalen/screen.git
</pre>

Edit the configuration file in _app/config.js_ and use the template below to fill out the configuration. __Note__ that this is not a JSON file but a javascript (.js) file.
<pre>
 cd /home/www/[client name]/screen
 nano app/config.js
</pre>
<pre>
window.config = {
  "resource": {
    "server": "//screen-[client name].aroskanalen.dk/",
    "uri": "proxy"
  },
  "ws": {
    "server": "https://screen-[client name].aroskanalen.dk/"
  },
  "backend": {
    "address": "https://admin-[client name].aroskanalen.dk/"
  },
  "apikey": "[MIDDLEWARE API KEY]",
  "cookie": {
    "secure": false
  },
  "debug": true,
  "version": "[RELEASE_VERSION]",
  "itkLog": {
    "version": "1",
    "errorCallback": "https://admin-[client name].aroskanalen.dk/api/error",
    "logToConsole": false,
    "logLevel": "error"
  }
};
</pre>

The screen application also needs to be configured to run in nginx.
<pre>
sudo nano -w /etc/nginx/sites-available/screen_[client name]_aroskanalen_dk
</pre>

<pre>
server {
  listen 80;

  server_name screen-[client name].aroskanalen.dk;

  rewrite ^ https://$server_name$request_uri? permanent;

  access_log /home/www/[client name]_aroskanalen_dk/logs/screen_access.log;
  error_log /home/www/[client name]_aroskanalen_dk/logs/screen_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name screen-[client name].aroskanalen.dk;
  root /home/www/[client name]_aroskanalen_dk/screen;

  access_log /home/www/[client name]_aroskanalen_dk/logs/screen_access.log;
  error_log /home/www/[client name]_aroskanalen_dk/logs/screen_error.log;

  location / {
    try_files $uri $uri/ /index.html;
  }

  location /templates/ {
    add_header 'Access-Control-Allow-Origin' "*";
  }

  location /proxy/ {
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header Host $http_host;

    proxy_buffering off;

    proxy_pass http://nodejs_middleware/;
    proxy_redirect off;
  }

  location /socket.io/ {
    proxy_http_version 1.1;
    proxy_set_header Upgrade $http_upgrade;
    proxy_set_header Connection "upgrade";

    proxy_pass http://nodejs_middleware;
  }

  ssl on;
  ssl_certificate /etc/ssl/certs2014/[SSL CERT].crt;
  ssl_certificate_key /etc/ssl/certs2014/[SSL KEY].key;

  ssl_session_cache shared:SSL:10m;
  ssl_session_timeout 5m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
</pre>

Enable the configuration by adding a symbolic link for the installation and restart nginx to enable the configuration.
<pre>
cd /etc/nginx/sites-enabled/
sudo ln -s ../sites-available/screen_[client name]_aroskanalen_dk
sudo service nginx restart
</pre>

# Troubleshooting

 * _nginx -t_ can be used to test configuration file.
 * _ps -ef | grep node_ to see if the node applications are running (middleware and search node)
 * _node app.js_ can be used to run the middleware and search node manual to see if they throw an errors, which may give an hit to whats wronge. 
 
 __Note__ that the supervisor have to be stop first our the communication port is already in use (an gives an error).
 * _php app/console ik:push --force_ can be used to force push content from the administration interface to the middleware.
 * You can logout of a screen by pressing __ctrl+l__ at any time.
