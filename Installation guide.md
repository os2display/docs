This is an installation guide to setup and configure the aroskanalen display system. 

# Requirements
The guide assumes that you have an installed linux based server with the following packages installed and at least the versions given.

 * nginx 1.4.x
 * redis 2.8.x
 * php 5.5.x
 * node 0.10.x
 * elastic search 1.5.x
 * supervisor 3.x

## The parts 
The system consists of four parts:

__Admin__ - administration interface (symfony)

__Screen__ - that serves content on the screens (symfony)
 
__Middleware__ - that handles web-sockets and connection between the ones above.

__Search node__ - that interfaces with elastic search and provide fast content search in the administration interface.

# The setup
The _middleware_ and _search node_ is only installed once on each server and then all administration interfaces and screens communicates with the them using API keys to identify them self and ensure content seperation.

## Naming
We have chosen to use the following naming convention and place the application in _/home/www_/.

We have used the following naming in DNS:

  * search-[server name].aroskanalen.dk
  * middleware-[server name].aroskanalen.dk
  * screen-[client name].aroskanalen.dk
  * admin-[client name].aroskanalen.dk

And this will give the folders:

  * /home/www/[client name]/admin
  * /home/www/[client name]/screen
  * /home/www/[client name]/logs

The Middleware and search node is located in:
 
  * /home/www/middleware
  * /home/www/search_node

# Installation
If you already have a running middleware and search node on the server you can skip the steps and just add the need api-keys in both and add mappings in the search node. You can use the UI or edit the JSON files directly.








## Middleware

### Clone
Start by cloning the git repository for the middleware and checkout the least release tag (which can be found using _git tag_).

<pre>
 ~$ cd /home/www
 ~$ git clone git@github.com:Indholdskanalen/middleware.git .
 ~$ cd middleware
 ~$ git checkout [v3.x.x]
</pre>

### Node packages
The middleware is build as a NodeJS application and it's different plugins requires libraries to be installed. The application comes with an installation script that do this, just run it. 

<pre>
 ~$ ./install.sh
</pre>

### Configuration
First we need to configure nginx in-front of the middleware so it's accessible through normal web-ports and also proxy web-socket connections. 

<pre>
 ~$ nano -w /etc/nginx/sites-available/nodejs
</pre>

In this file add an upstream connection to the middleware application. Later a connection for the search node also need to be added to this file as well.
<pre>
 upstream nodejs_middleware {
   server 127.0.0.1:3020;
 }
</pre>

To access the middleware administration and allow the screen to communication with the middleware a virtual host configuration is needed. You need to change the _[server name]_ with the actual name of the server. You may also need to change the paths to the ssl certificates.
<pre>
 ~$ nano -w /etc/nginx/sites-available/middleware_[server name]_aroskanalen_dk
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
   ssl_certificate /etc/ssl/certs2014/aroskanalen_dk.crt;
   ssl_certificate_key /etc/ssl/certs2014/aroskanalen_dk.key;

   ssl_session_timeout 5m;
   ssl_session_cache shared:SSL:10m;

   # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
   ssl_prefer_server_ciphers On;
   ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
   ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
 }
</pre>


Next step is to configure the application by setting the secret (used to encode tokens) and admin password. If you have other applications on the server that's using Redis, you can change the default database used (1-15 is available).
<pre>
 ~$ cd /home/www/middleware
 ~$ nano -w config.json
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
     "password": "[CHANGE ME]"
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

To get the application running you need to create the _apikeys.json_ file with an empty JSON object or optional added the demo key below.
<pre>
 ~$ cd /home/www/middleware
 ~$ nano -w apikeys.json
</pre>

Demo content for the _apikeys.json_ file.
<pre>
{
  "03303f8bf868b517bb732326aca86714": {
    "name": "Demo",
    "expire": 300,
    "backend": "https://admin-demo.aroskanalen.dk"
  }
}
</pre>

Enable nginx configuration by adding symbolic links into _sites-enabled_ folder and restarting the service.
<pre>
 ~$ cd etc/nginx/sites-enabled/
 ~$ ln -s ../sites-available/middleware_[server name]_aroskanalen_dk 
 ~$ ln -s ../sites-available/nodejs
 ~$ service nginx restart
</pre>

The middleware needs to be started at boot time which requires a Supervisor run script. Supervisor will also ensure that the node application is started again, if an error happens and it stops running.
<pre>
 ~$ nano -w /etc/supervisor/conf.d/middleware.conf
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

<pre>
 ~$ service supervisor restart
</pre>

### UI

@TODO: How to use the UI to add more configuration ap-keys.








## Search node
The search node application is a general purpose application to provide a fast search engine through web-socket connections (using elasticsearch) and is designed to be used be other projects as well as aroskanalen. So it will not follow the same version number as the other parts of this installation. It's also why the administration UI is somewhat complex to in relation to setting up the right mappings to be used with aroskanalen.

### Clone
Start by cloning the git repository for the search node and checkout the least release tag (which can be found using _git tag_).

<pre>
 ~$ cd /home/www
 ~$ git clone git@github.com:Indholdskanalen/search_node.git home/www/search_node
 ~$ cd search_node
 ~$ git checkout [v1.x.x]
</pre>

### Node packages
Search node, as the middleware, uses a plugin architecture that requires installation of libraries from node package manager. The application comes with an installation script to handle this, simply goto the root of the application and execute the script.
<pre>
 ~$ ./install.sh
</pre>

### Configuration

We need to configure nginx in-front of the search node so it's accessible through normal web-ports and also proxy web-socket connections. So we add the upstream connection configuration in the nodejs config file used by the middleware
<pre>
 ~$ nano -w /etc/nginx/sites-available/nodejs
</pre>

The upstream connection definition.
<pre>
 upstream nodejs_search {
   server 127.0.0.1:3010;
 }
</pre>

To access the search node administration and allow the aroskanalen administration interface to communication with the search node a virtual host configuration is needed. You need to change the _[server name]_ with the actual name of the server. You may also need to change the paths to the ssl certificates.
<pre>
 ~$ nano -w /etc/nginx/sites-available/search_[server name]_aroskanalen_dk
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
   ssl_certificate /etc/ssl/certs2014/aroskanalen_dk.crt;
   ssl_certificate_key /etc/ssl/certs2014/aroskanalen_dk.key;

   ssl_session_timeout 5m;
   ssl_session_cache shared:SSL:10m;

   # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
   ssl_prefer_server_ciphers On;
   ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
   ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
 }
</pre>

Enable the configuration by adding a symbolic link for the search node. The nodejs configuration file should be linked under configuration of the middleware. Restart nginx to enable the configuration.
<pre>
 ~$ cd etc/nginx/sites-enabled/
 ~$ ln -s ../sites-available/search_[server name]
 ~$ service nginx restart
</pre>

Next the application needs to be configured by adding the following content to config.json in the root folder of the application _/home/www/search___node_. Remember to update the administration password and secret.
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

Before the application can be started the _apikeys.json_ and _mappings.json_ needs to exist and at least contain an empty JSON object.

As the search node is not specially created for aroskanalen the mappings (configuration for elasticsearch) can be somewhat complex. To get you started the mapping below can be used as a template for the configuration. Normally go into the administration interface and add a new api key go to the mappings in the interface and add a new empty mapping. Edit the mappings file and add the _fields_, _tag_ and _dates_ section as in the template. This is the fast way to do it, if you edit the mappings after adding the config to the JSON file you can see how it should look in the administration interface.
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

Add demo API key to apikeys.json where the _indexes_ match the ID in the mappings.json file.
<pre>
{
  "77f0dd4a5ff65891a6f8e5c853295c7e": {
    "name": "Demo",
    "expire": 300,
    "indexes": [
      "5d437a016271077510c640e450bde9c3"
    ]
  }
}
</pre>

The search node needs to be started at boot time which requires a Supervisor run script. Supervisor will also ensure that the node application is started again, if an error happens and it stops running.
<pre>
 ~$ nano -w /etc/supervisor/conf.d/search_node.conf
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
 ~$ service supervisor restart
</pre>


### UI

@TODO: Activate search indexes.

@TODO: How to use the UI to add more configuration.






## Administration User Interface
The administration user interface is the _backend_ of the display system and used to add content and configure screens etc.

## Clone

<pre>
 ~$ git clone git@github.com:Indholdskanalen/admin.git /home/www/[client name]/admin
</pre>

It needs to have a SQL database and in this guide we assumes that it's MySQL or MariaDB, so start by creating a database, user and give the user privileges to use the database.
<pre>
 ~$ mysql -u root -p -e "CREATE DATABASE [site name];"
 ~$ mysql -u root -p -e "CREATE USER '[site name]'@'localhost' IDENTIFIED BY '[RANDOM PASSWORD]';"
 ~$ mysql -u root -p -e "GRANT ALL PRIVILEGES ON [DB NAME].* TO '[USER NAME]'@'localhost';"
 ~$ mysql -u root -p -e "FLUSH PRIVILEGES;"
</pre>  

Install the site using composer and fill out the questions that you can a use default values for the rest. See the parameters example below to help filling out the values. 
<pre>
 ~$ cd /home/www/[client name]/admin
 ~$ composer install
 ~$ php app/check.php
</pre>

The final _app/config/parameters.yml_ file.
<pre>
parameters:
    database_driver: pdo_mysql
    database_host: 127.0.0.1
    database_port: null
    database_name: [DB NAME]
    database_user: [DB USERNAME]
    database_password: '[DB PASSWORD]'

    mailer_transport: sendmail
    mailer_host: 127.0.0.1
    mailer_user: null
    mailer_password: null
    mailer_from_email: webmaster@ik3.indholdskanalen.vm
    mailer_from_name: 'Webmaster Indholdskanalen'

    locale: en
    secret: [CHANGE ME]
    debug_toolbar: false
    debug_redirects: false
    use_assetic_controller: true
    
    absolute_path_to_server: 'https://admin-[CLIENT NAME].aroskanalen.dk'
    zencoder_api: [ZENCODER API KEY]
    
    sharing_host: 'https://search-[SERVER NAME].aroskanalen.dk'
    sharing_path: /api    
    sharing_apikey: [API KEY]
    sharing_enabled: false
    
    search_host: 'https://search-[SERVER NAME].aroskanalen.dk'
    search_path: /api
    search_apikey: [API KEY]
    search_index: [INDEX KEY]
    
    middleware_host: 'https://middleware-[SERVER NAME].aroskanalen.dk'
    middleware_path: /api
    middleware_apikey: [API KEY]
    
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


    site_title: 'Demo Aroskanalen'
    
    koba_apikey: [KOBA API KEY]
    koba_path: 'http://koba.aarhus.dk'
</pre> 

Now install the database tables by running the update command.
<pre>
 ~$ php app/console doctrine:schema:update --force
</pre>

Add an administrator user that can be used to test the site and create other users.
<pre>
 ~$ php app/console fos:user:create [admin_username] [test@example.com] [p@ssword] --super-admin
</pre> 


TEMPLATES
<pre>
 @TODO: TROELS PLEASE WRITE ME!
</pre> 

As with the node application the administration needs a nginx configuration to be accessible. 
<pre>
 ~$ nano -w /etc/nginx/sites-available/admin_[client name]_aroskanalen_dk
</pre>

You need to update the name, paths and ssl certificates. 
<pre>
server {
  listen 80;

  server_name admin-[CLIENT NAME].aroskanalen.dk;
  rewrite ^ https://$server_name$request_uri? permanent;

  access_log /home/www/[CLIENT NAME]_aroskanalen_dk/logs/backend_access.log;
  error_log /home/www/[CLIENT NAME]_aroskanalen_dk/logs/backend_error.log;
}


# HTTPS server
#
server {
  listen 443;

  server_name admin-[CLIENT NAME].aroskanalen.dk;
  root /home/www/[CLIENT NAME]_aroskanalen_dk/admin/web;

  client_max_body_size 300m;

  access_log /home/www/[CLIENT NAME]_aroskanalen_dk/logs/backend_access.log;
  error_log /home/www/[CLIENT NAME]_aroskanalen_dk/logs/backend_error.log;

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
  ssl_certificate /etc/ssl/certs2014/aroskanalen_dk.crt;
  ssl_certificate_key /etc/ssl/certs2014/aroskanalen_dk.key;

  ssl_session_timeout 5m;
  ssl_session_cache shared:SSL:10m;

  # https://hynek.me/articles/hardening-your-web-servers-ssl-ciphers/
  ssl_prefer_server_ciphers On;
  ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
  ssl_ciphers ECDH+AESGCM:DH+AESGCM:ECDH+AES256:DH+AES256:ECDH+AES128:DH+AES:ECDH+3DES:DH+3DES:RSA+AESGCM:RSA+AES:RSA+3DES:!aNULL:!MD5:!DSS;
}
</pre>

Enable the configuration by adding a symbolic link for the installation and restart nginx to enable the configuration.
<pre>
 ~$ cd /etc/nginx/sites-enabled/
 ~$ ln -s ../sites-available/admin_[client name]_aroskanalen_dk
 ~$ service nginx restart
</pre>

Login to the site and create a new screen to test that it works, you will get search errors until theres is something in the search indexes.

## Screens

@TODO: WRITE INTO TEXT.

### Clone

First clone the screen code.
<pre>
  ~$ git clone git@github.com:Indholdskanalen/screen.git /home/www/[client name]/screen
  ~$ cd /home/www/[client name]/screen
</pre>

Edit the configuration file in _app/config.js_ and use the template below to fill out the configuration. __Note__ that this i not a JSON file but a JS file.
<pre>
window.config = {
  "resource": {
    "server": "//screen-[CLIENT NAME].aroskanalen.dk/",
    "uri": "proxy"
  },
  "ws": {
    "server": "https://screen-[CLIENT NAME].aroskanalen.dk/"
  },
  "backend": {
    "address": "https://admin-[CLIENT NAME].aroskanalen.dk/"
  },
  "apikey": "[API KEY]",
  "cookie": {
    "secure": false
  },
  "debug": true
};
</pre> 

The screens client also needs to be configured to run i nginx.
<pre>
 ~$ nano -w /etc/nginx/sites-available/screen_[client name]_aroskanalen_dk
</pre>

<pre>
server {
  listen 80;

  server_name screen-[CLIENT NAME].aroskanalen.dk;

  rewrite ^ https://$server_name$request_uri? permanent;

  access_log /home/www/[CLIENT NAME]_aroskanalen_dk/logs/screen_access.log;
  error_log /home/www/[CLIENT NAME]_aroskanalen_dk/logs/screen_error.log;
}

# HTTPS server
#
server {
  listen 443;

  server_name screen-[CLIENT NAME].aroskanalen.dk;
  root /home/www/[CLIENT NAME]_aroskanalen_dk/screen;

  access_log /home/www/dokk1_aroskanalen_dk/logs/screen_access.log;
  error_log /home/www/dokk1_aroskanalen_dk/logs/screen_error.log;

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
  ssl_certificate /etc/ssl/certs2014/aroskanalen_dk.crt;
  ssl_certificate_key /etc/ssl/certs2014/aroskanalen_dk.key;

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
 ~$ cd /etc/nginx/sites-enabled/
 ~$ ln -s ../sites-available/screen_[client name]_aroskanalen_dk
 ~$ service nginx restart
</pre>

# Troubleshot

 * nginx -t can be used to test configuration file.

