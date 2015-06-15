# Upgrade log.

## 3.1.0

### Admin
 * Symfony 2.6 -> 2.7 upgrade
 * Slide and screen templates can be selected in the UI.

__Steps__

 * composer install
 * app/console cache:clear
 * app/console doctrine:schema:update
 * app/console ik:templates:load
 * app/console cache:clear
 * Login to the site as adminstartor and select the templates that should be available for the site.

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
