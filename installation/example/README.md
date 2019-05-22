# Example installation of os2display in a vagrant box

The following sets up a test installation in vagrant box with the install scripts.

Change to fit your own setup.

## Installation process

<pre>
  # Copy installation files
  mkdir htdocs
  mkdir htdocs/install
  
  cp ../prepare_server.sh htdocs/install
  cp ../setup.sh htdocs/install

  vagrant up
  
  vagrant ssh
  
  sudo -i
  
  cd /vagrant/htdocs/install
  
  ./prepare_server.sh
  
  # MySQL root password: vagrant
    
  ./setup.sh
  
  #############
  ## Answers
  #############
  
  # Use fake SSL certificate (y/n)? y
  # What should we install (1-6)? 1
  
  ## Installing Search Node:
  
  # Where to place search node (/home/www/search_node): /vagrant/htdocs/search_node
  # Search node FQDN (search.example.com): search.test-os2display.vm
  # Name to identify the search index by (os2display-index):
  # Name to identify the API key by (os2display-test):
  # Who should the search node be runned as (root):
  
  ## Installing Middleware:
  
  # Where to place middleware (/home/www/middleware): /vagrant/htdocs/middleware
  # Middelware FQDN (middleware.example.com): middleware.test-os2display.vm
  # Administrator username (admin):
  # Administrator password (admin):
  # Secret token used in communcation (MySuperSecret):
  # Name to identify the API key by (os2display-test):
  # FQDN for the administration interface (admin.example.com): admin.test-os2display.vm
  # Who should the middleware be runned as (root):

  ## Installing Administration interface:
  
  # Where to place administration interface (/home/www/example_com/admin): /vagrant/htdocs/admin
  # Admin FQDN (admin.example.com): admin.test-os2display.vm
  # Database (admin_test-os2display_vm): os2display
  # Database username (root):
  # Database password (root): vagrant
  # Secret token (ThisTokenIsNotSoSecretChangeIt):
  # Mail from address (webmaster@os2display.dk): webmaster@admin.test-os2display.vm
  # Mail from name (webmaster):
  # Search host (https://search.example.com): 'https://search.test-os2display.vm'
  # Search API key: [Enter search api key]
  # Search index: [Enter search index]
  # Middleware host (https://middleware.example.com): 'https://middleware.test-os2display.vm'
  # Middleware API key: [Enter middleware api key]
  # Zencoder API key: [If you have a Zencoder API key, enter it]
  # Site title (OS2Display example): TestOS2Display

  # Super user name (admin): admin
  # Super user password (admin): admin
  # Super user mail (admin@example.com): [your mail]

  # Name of the normal OS user (root): vagrant

  # Activate search index in the search administration.

  # Make sure cron is set for www-data
  sudo crontab -e -u www-data
  # Insert:
  # */1 * * * * /usr/bin/php /vagrant/htdocs/admin/app/console os2display:core:cron --env=prod
  
  ## Visit and accept false certificates.
  # https://admin.test-os2display.vm/
  # https://middleware.test-os2display.vm/
  # https://search.test-os2display.vm/
  
  # Enable templates: https://admin.test-os2display.vm/#/admin-templates
  # Create one of each type of content.

  # Test that screen works and gets content from backend.
</pre>

## Troubleshooting

Search or middleware give 502. Try to run apps directly from their directories, and see which errors are emitted:
<pre>
  node app.js
</pre>

Make sure search indexes are activated:
See https://github.com/os2display/vagrant/blob/master/scripts/search_activate.sh for script example.

Make sure 1 of each type of content has been created, to initialize search:
See https://github.com/os2display/vagrant/blob/master/scripts/search_initialize.sh for script example.

## Access

* Administation: `https://admin.test-os2display.vm`
* Screen: `https://admin.test-os2display.vm/screen`
* Middleware: `https://middleware.test-os2display.vm`
* Search: `https://search.test-os2display.vm`
