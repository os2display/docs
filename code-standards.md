Code standards
==========

This document is a guideline for writing good standardized and readable code when working with os2display.

These are *guidelines*, and if you think its necessary to deviate feel free to do so, **but** please be sensible and only do this when necessary and make sure you don't break it for everyone else. And if you do, be sure to leave a comment with your reason so it won't stay inside your head only.

The guidelines should help achieve:

* A stable, secure and high quality foundation for building and maintaining websites
* Consistency across multiple developers participating in the project
* The best possible conditions for sharing modules between sites
* The best possible conditions for the individual website to customize configuration and appearance

Contributions to the core project will be reviewed by members of the core team. These guidelines should inform contributors about what to expect in such a review. If a review comment cannot be traced back to one of these guidelines it indicates that the guidelines should be updated to ensure transparency.

### Be familiar with

* [Drupal Coding Standards](https://drupal.org/coding-standards)
* and [PHP codesniffer](http://pear.php.net/manual/en/package.php.php-codesniffer.php)

__TODO:__ There must be som AngularJS and Symfony links needed here to?

Content
----------

1. [Coding Standards](#coding_standards)
2. [Naming](#naming)
3. [Platform support](#platform_support)



<a name="coding_standards"></a>
1. Coding Standards
----------

### PHP

__TODO:__ Should we go for PHP7 compatability, so we can slowly get there?

Code must be compatible with PHP 5.6. Compatability can be checked using PHP_Codesniffer.

Code must conform to the [Drupal Coding Standards](https://drupal.org/coding-standards). We know that this is not the standard for Symfony projects. 

See the [codesniffer](codesniffer.md) documenet for information about setting up code sniffer.

### JavaScript

It is recommended that JavaScript code is checked by JSHint with options:

* debug
* forin
* qnull
* noarg
* noempty
* eqeqeq
* boss
* loopfunc
* evil
* laxbreak
* bitwise
* strict
* undef
* nonew
* browser
* jquery

### AngularJS

The os2display __admin__ and __screen__ frontends are built with [AngularJS 1.5.x](https://angularjs.org/).

Guidelines for writing AngularJS code: [https://github.com/johnpapa/angular-styleguide/blob/master/a1/README.md](https://github.com/johnpapa/angular-styleguide/blob/master/a1/README.md).

The js for the administration is located in web/.

The legacy app is located in web/app/. New additions to the administration frontend should define seperate apps (located in web/apps/) instead of extending the legacy app. The goal is to move all functionality into seperate apps and modules in apps/ and completely remove the legacy app in app/.

The legacy js is compiled with gulp

```Shell
gulp js
```

And the js assets in assets/ are compiled with gulp

```Shell
gulp assets
```

#### New module or app

The difference between modules and apps is that modules are not bound in the DOM. The apps are included in the DOM and each have a ng-view bound to it. 

To add a angular module or app:

1. Add a folder to web/apps/ suffixed by App or Module.

2. Add to app/config/apps.yml or app/config/modules.yml configuration for the module/app.

### Sass/css

See [CSS guidelines](css-guidelines.md).

The sass for the legacy app is located in web/sass/ and is compiled with gulp:

```Shell
gulp sass
```

New additions should be implemented in the __styleguide__.

When the __styleguide__ css has been compiled (also with gulp) it should be copied to __admin__ in place of admin/web/css/styles-new.css.

## Styleguide

To build the sass:

```Shell
gulp sass
```

To watch for changes in the scss (__[@TODO: Consistency wise, should this be scss or sass which it is called in _admin_?]__) folder:

```Shell
gulp watch
```

__[@TODO: Include gulp-help gulp file]__

### Documentation

**README:** All modules/bundles must contain a README.md file containing the following where applicable:

* A brief description of the module/bundle
* Configuration options
* Installation procedure
* Hidden variables
* Other requirements and how to obtain these such as API urls, versions, keys, library system and trimmings
* Any code which does not comply with these guidelines and a brief argument why

**LICENSE.txt:** All repositories must contain a LICENSE.txt file containing the licens for the project: [license.txt](license.txt).

### Templates

See the [templates-guidelines](templates-guidelines.md) document.

### Vagrant

Development should be conducted in the vagrant environment __[vagrant link]__ to ensure consistency.



<a name="naming"></a>
2. Naming
----------

### General

All naming must be in English.

### Bundles

All bundles must be prefixed with the organization that supplies the bundle. Eg. OS2/Display/MainBundle

### Repositories

Repositories should be named after the bundle contained within. 



<a name="platform_support"></a>
3. Platform support
----------

Os2display is developed for newer browsers (Chrome, Firefox, IE > 9). 

