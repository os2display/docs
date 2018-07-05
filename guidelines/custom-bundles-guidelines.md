# Custom Bundles

## Description

To introduce custom code to OS2Display you have to create a bundle to contain
your code. This ensures that the core OS2Display bundles can be updated without
conflicting with custom code added for a given installation.

The best approach to create custom extensions to OS2Display is to examine the
existing bundles, and how they do it.

## To extend the angular backend

The bundle should extend Os2DisplayBaseExtension in
DependencyInjection/[BUNDLE_NAME]Extension.php, the same as:
<pre>
class Os2DisplayDefaultTemplateExtension extends Os2DisplayBaseExtension
{
    /**
     * {@inheritdoc}
     */
    public function load(array $configs, ContainerBuilder $container)
    {
        $this->dir = __DIR__;

        parent::load($configs, $container);
    }
}
</pre>

This loads the `angular.yml` file from the bundle's `Resources/config/` folder.
This file allows the bundle to extend the admin angular app.

## angular.yml structure

Examples from AdminBundle angular.yml file.

<pre>
# Assets that should be loaded.
assets:
  # js files for dev environment
  js:
    - bundles/os2displayadmin/assets/libs/jquery.min.js
  # css files
  css:
    - bundles/os2displayadmin/css/colorpicker.css
  # js assets files for production, minified.
  js_prod_assets:
    - bundles/os2displayadmin/assets/build/assets.min.js
  # js main files for production, minified.
  js_prod:
    - bundles/os2displayadmin/assets/build/os2displayadmin.min.js

# Modules and services that should be bootstrapped.
bootstrap:
  modules:
    - logModule
    - mainModule
  services:
    - apiService
    - logService
    - userService
    - searchService
    - menuItemService
    - bodyService
    - authHttpResponseInterceptor

# Modules that should be loaded without frontend rendering.
modules:
  busModule:
    # Files that should be included.
    files:
      - bundles/os2displayadmin/apps/busModule/busModule.js

# Angular apps that are rendered in the DOM.
apps:
  menuApp:
    # Should the app be contained in the div.view-container element. When set to 
    # true the app gets a data-ng-view element which it can change the content
    # of through angular routes. If set to false the app is rendered before the
    # div.view-container element in the DOM.
    container: false
    # Class the is set on the app DOM element.
    class: menu-app
    # Files that should be included.
    files:
      - bundles/os2displayadmin/apps/menuApp/directive/mainMenuDirective.js
      - bundles/os2displayadmin/apps/menuApp/directive/hamburgerMenuDirective.js
      - bundles/os2displayadmin/apps/menuApp/directive/subMenuDirective.js
    # An optional file that can be rendered with ng-include for the app DOM
    # element.
    template: /bundles/os2displayadmin/apps/menuApp/menu.html
    # Module dependencies. Will be injected in the angular app. To use other
    # modules from the Angular app they need to be injected here.
    dependencies:
      - busModule
      - mainModule
</pre>
