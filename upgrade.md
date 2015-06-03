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


### Middleware
 * Node modules upgrade

__Steps__

  * ./update.sh
  * Restart the supervisor service.


### Search node

 * No updates required-
