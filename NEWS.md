# OS2display News

## 1. April 2020

* Released core-bundle: 2.2.2: https://github.com/os2display/core-bundle/releases/tag/2.2.2
* Released core-bundle 2.2.1: https://github.com/os2display/core-bundle/releases/tag/2.2.1
* Released screen-bundle 1.1.5: https://github.com/os2display/screen-bundle/releases/tag/1.1.5

## 22. March 2020

* Released admin-bundle 2.2.0: https://github.com/os2display/admin-bundle/releases/tag/2.2.0
* Released default-template-bundle 2.1.0: https://github.com/os2display/default-template-bundle/releases/tag/2.1.0
* Released core-bundle 2.2.0: https://github.com/os2display/core-bundle/releases/tag/2.2.0
* Released admin 6.2.0: https://github.com/os2display/admin/releases/tag/6.2.0

These changes make video encoding formats configurable through changes to app/config/config.yml:
```
# app/config/config.yml
os2_display_core:
  zencoder:
    outputs:
      - webm
    remove_original: true
```

## 9. March 2020

* Released admin-bundle 2.1.4: https://github.com/os2display/admin-bundle/releases/tag/2.1.4

## 27. January 2020

* Released exchange-bundle 2.1.0: https://github.com/os2display/exchange-bundle/releases/tag/2.1.0
* Released horizon-template-bundle 2.1.0: https://github.com/os2display/horizon-template-bundle/releases/tag/2.1.0

## 4. December 2019

* Released admin-bundle 2.1.3: https://github.com/os2display/admin-bundle/releases/tag/2.1.3

## 15. November 2019

* Released core-bundle 2.1.3: https://github.com/os2display/core-bundle/releases/tag/2.1.3
* Released admin-bundle 2.1.2: https://github.com/os2display/admin-bundle/releases/tag/2.1.2

## 11. November 2019

* Released admin-bundle 2.1.1: https://github.com/os2display/admin-bundle/releases/tag/2.1.1 
* Released screen-bundle 1.1.4: https://github.com/os2display/screen-bundle/releases/tag/1.1.4

## 25. October 2019

* Released admin 6.1.3: https://github.com/os2display/admin/releases/tag/6.1.3

## 24. October 2019

* Released screen-bundle 1.1.3: https://github.com/os2display/screen-bundle/releases/tag/1.1.3
* Released default-template-bundle 2.0.0: https://github.com/os2display/default-template-bundle/releases/tag/2.0.0
* Released screen-bundle 1.1.2: https://github.com/os2display/screen-bundle/releases/tag/1.1.2
* Released admin 6.1.2: https://github.com/os2display/admin/releases/tag/6.1.2
* Released core-bundle 2.1.2: https://github.com/os2display/core-bundle/releases/tag/2.1.2
* Released screen-bundle 1.1.1: https://github.com/os2display/screen-bundle/releases/tag/1.1.1

## 7. October 2019

* Released middleware 6.0.0: https://github.com/os2display/middleware/releases/tag/6.0.0
* Released admin 6.1.1: https://github.com/os2display/admin/releases/tag/6.1.1
* Released screen-bundle 1.1.0: https://github.com/os2display/screen-bundle/releases/tag/1.1.0
* Released default-template-bundle 1.2.0: https://github.com/os2display/default-template-bundle/releases/tag/1.2.0
* Marked https://github.com/os2display/screen as deprecated, since it has been added to the admin as a bundle in 6.1.0.

## 23. August 2019

* Released core-bundle 2.1.1: https://github.com/os2display/core-bundle/releases/tag/2.1.1

## 20. May 2019

* Released admin 6.1.0: https://github.com/os2display/admin/releases/tag/6.1.0

This release adds screen-bundle to os2display (see https://github.com/os2display/screen-bundle). This introduces the [admin_path]/screen route that is an alternative to using screen: https://github.com/os2display/screen. This furthermore, adds preview of channels and screens inside the administration.

NB! To make this bundle work additional nginx settings are required, that will expose the middleware to the admin installation. See https://github.com/os2display/vagrant/commit/2b5f35269f3b1a18ba245e8e894253c4faa743b3#diff-8d60e524ea68140466b5d4631fba2f01 for the required nginx config.

* Released vagrant 7.1.0: https://github.com/os2display/vagrant/releases/tag/7.1.0
* Released campaign-bundle 2.1.0: https://github.com/os2display/campaign-bundle/releases/tag/2.1.0
* Released core-bundle 2.1.0: https://github.com/os2display/core-bundle/releases/tag/2.1.0
* Released admin-bundle 2.1.0: https://github.com/os2display/admin-bundle/releases/tag/2.1.0
* Released screen-bundle 1.0.6: https://github.com/os2display/screen-bundle/releases/tag/1.0.6

## 16. May 2019

* Added all bundles to packagist.org (https://packagist.org/?query=os2display) and enabled auto-update.

## 15. May 2019

* Released youtube-bundle 2.0.1: https://github.com/os2display/youtube-bundle/releases/tag/2.0.1
* Moved horizon-template-bundle from itk-os2display organization to os2display. Version 2.0.0: https://github.com/os2display/horizon-template-bundle/releases/tag/2.0.0
* Moved template-extension-budle from itk-os2display organization to os2display. Version 2.0.1: https://github.com/os2display/template-extension-bundle/releases/tag/2.0.1
* Released exchange-bundle 2.0.2: https://github.com/os2display/exchange-bundle/releases/tag/2.0.2
* Released vimeo-bundle 2.0.2: https://github.com/os2display/vimeo-bundle/releases/tag/2.0.2

## 14. May 2019

* Moved exchange-bundle from itk-os2display organization to os2display. Version 2.0.1: https://github.com/os2display/exchange-bundle/releases/tag/2.0.1

## 13. May 2019

* Moved youtube-bundle from itk-os2display organization to os2display. Version 2.0.0: https://github.com/os2display/youtube-bundle/releases/tag/2.0.0
* Moved vimeo-bundle from itk-os2display organization to os2display. Version 2.0.0: https://github.com/os2display/vimeo-bundle/releases/tag/2.0.0

## 9. May 2019

* Moved screen-bundle from itk-os2display organization to os2display. Version 1.0.4: https://github.com/os2display/screen-bundle/releases/tag/1.0.4

## 21. February 2019

* Released admin 6.0.0: https://github.com/os2display/admin/releases/tag/6.0.0
* Released admin-bundle 2.0.0: https://github.com/os2display/admin-bundle/releases/tag/2.0.0
* Released media-bundle 2.0.0: https://github.com/os2display/media-bundle/releases/tag/2.0.0
* Released campaign-bundle 2.0.0: https://github.com/os2display/campaign-bundle/releases/tag/2.0.0
* Released core-bundle 2.0.0: https://github.com/os2display/core-bundle/releases/tag/2.0.0
* Released vagrant 7.0.0: https://github.com/os2display/vagrant/releases/tag/7.0.0

This release brings OS2display up to running Symfony 3.4 and PHP 7.2.

The installation scripts have NOT been updated yet: https://github.com/os2display/docs/tree/master/installation.

## 19. February 2019

* Released default-template-bundle 1.1.2: https://github.com/os2display/default-template-bundle/releases/tag/1.1.2

## 18. February 2019

* Released admin 5.2.0: https://github.com/os2display/admin/releases/tag/5.2.0
* Released vagrant 6.0.1: https://github.com/os2display/vagrant/releases/tag/6.0.1

## 8. February 2019

* Released screen 5.0.4: https://github.com/os2display/screen/releases/tag/5.0.4
* Released core-bundle 1.2.0: https://github.com/os2display/core-bundle/releases/tag/1.2.0
* Released admin-bundle 1.2.0: https://github.com/os2display/admin-bundle/releases/tag/1.2.0
* Released default-template-bundle 1.1.1: https://github.com/os2display/default-template-bundle/releases/tag/1.1.1

## 7. February 2019

* Released campaign-bundle: https://github.com/os2display/campaign-bundle/releases/tag/1.3.0

## 1. February 2019

* Docs: Updated install script.
* Released admin 5.1.2: https://github.com/os2display/admin/releases/tag/5.1.2

## 23. August 2018

* Released admin 5.1.1: https://github.com/os2display/admin/releases/tag/5.1.1
* Released admin-bundle: https://github.com/os2display/admin-bundle/releases/tag/1.1.1

## 3. June 2018

* Released middleware 5.0.2: https://github.com/os2display/middleware/releases/tag/5.0.2
* Released screen 5.0.3: https://github.com/os2display/screen/releases/tag/5.0.3
* Released admin 5.1.0: https://github.com/os2display/admin/releases/tag/5.1.0
* Released core-bundle 1.1.0: https://github.com/os2display/core-bundle/releases/tag/1.1.0
* Released admin-bundle 1.1.0: https://github.com/os2display/admin-bundle/releases/tag/1.1.0
* Released core-bundle 1.0.11: https://github.com/os2display/core-bundle/releases/tag/1.0.11

## 2. June 2018

* Released new vagrant (6.0.0): https://github.com/os2display/vagrant/releases/tag/6.0.0
* Released default-template-bundle 1.1.0: https://github.com/os2display/default-template-bundle/releases/tag/1.1.0
* Released admin-bundle 1.0.11: https://github.com/os2display/admin-bundle/releases/tag/1.0.11
