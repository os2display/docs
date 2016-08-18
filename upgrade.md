# Upgrade log.

## 3.5.11 => 4.0.0

Templates not in default_templates should be added to the web/templates/ folder af pulling __admin__.

<pre>
composer install
app/console doctrine:migrations:migrate
app/console ik:templates:load
</pre>

Update the version tag in app/config/parameters.yml.

<pre>
app/console cache:clear --env=prod
</pre>

Upgrade search-node to latest version.



## 3.2.1 => 3.3.0

__Steps__

* Change release versions in configs (admin/app/config/parameters.yml and screen/app/config.js).

### Admin

 * app/console ik:templates:load (To get the latest version of the templates to the screens).

### Screen

 * Add parameter to screen/app/config.js:

 <pre>
  "fallback_image": null
 </pre>

 * If need for other fallback_image, add a fallback image to screen/assets/images/fallback_override.png and set the parameter above to:

 <pre>
   "fallback_image": "assets/images/fallback_override.png"
 </pre>

## 3.2.0 => 3.2.1

__Steps__

 * Change release versions in configs (admin/app/config/parameters.yml and screen/app/config.js).

## 3.1.0 => 3.2.0

__Steps__

 * Change version in configs (admin/app/config/parameters.yml and screen/app/config.js).
 * app/console ik:templates:load (To get the latest version of the templates to the screens).

## 3.1.0

### Admin
 * Symfony 2.6 -> 2.7 upgrade
 * Slide and screen templates can be selected in the UI.

__Steps__

 * Copy the list with templates from parameters.yml
 * composer install
 * app/console cache:clear
 * app/console doctrine:schema:update --force
 * app/console ik:templates:load
 * app/console cache:clear
 * Login to the site as administrator and select the templates that should be available for the site.
 * Update parameters.yml with the following lines

  <pre>
    version: [RELEASE_VERSION]
    
    itk_log_version: 1
    itk_log_error_callback: /api/error
    itk_log_log_to_console: false
    itk_log_log_level: all
  </pre>

### Screen

* Update app/config.js needs to have the new log lines added
<pre>
  "version": "[RELEASE_VERSION]",
  "itkLog": {
    "version": "1",
    "errorCallback": "https://admin-[client name].aroskanalen.dk/api/error",
    "logToConsole": false,
    "logLevel": "error"
  }
</pre>

### Middleware
 * Node modules upgrade (update.sh)

__Steps__

  * ./update.sh
  * redis-cli -> select [DB] -> FLUSHALL
  * Restart the supervisor service.
  * Push content in admin app/console ik:push --force


### Search node

 * No updates required-
