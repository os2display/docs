TODO / Feature requests
==========

* Renaming from Indholdskanalen/Aroskanalen to os2display.
* Include a test suite.
* Cleanup branches.
* Finish the move of functionality from the legacy app into separate apps in the __admin__ to remove the legacy web/app.
* Delete old content - if a media is not used by a slide it should be removed.
* Finish the implementation of UI elements in the styleguide to remove the legacy web/sass/ code.
* Rename development branch to develop to comply with gitflow guidelines.
* Add translation support (All strings are in danish atm).
* Video support in templates is dependant on Zencoder. Supply different method for using video files __[perhaps direct upload?]__.
* Should custom templates have their own directory to make clear what is included in the base installation?
* Slides should consist of components instead of templates. Templates should just be a set of predefined components for a given slide. This will increase the flexibility of the system, but require some very well-defined components.
* Slides should be possible to insert directly into screens without first being included in a channel.
* A refactoring of the __admin__ API to be less handheld.
* Refactor vagrant to use ansible.
* Make screens more flexible so they consist of components same as slides. A component could be a region that can display an array of channels or slides.
* Find way to move js from web/ into bundles. See below.
* Make __admin__ completely extendable, so new angular apps can be added through the enabling of Symfony bundles. This requires that the js can be included from the bundles instead of web/ folder.
* Apply guidelines to existing code.
* Minification of the new apps - refactor gulp usage. Use only minified files in production.
* Refactor "gulp js" to compile each app separately.
* Refactor "gulp sassTemplates" to iterate the folders in web/templates and look for sass files to compile.
* Cleanup the templates folder, so it only contains templates. Move js/ and editors/. js/ should go into the web/templates/default_templates/ folder. The editors should be distributed to where they belong in templates/. 
* Refactor the js for templates so slides become directives that are injected in __screen__.
* Rethink/Refactor how slides and screens are displayed in the administration.
* Templates: tools[i].path should be required for all slide templates, move tools from web/templates/editors/ folder.
* .json for templates: the way tools are referenced for slide and screen templates should be streamlined.
* Batching of middleware pushes to avoid congestation.
* Make sure only one cron job is running at the time.
* Develop a set of responsive templates as default templates.
* Supply a new version of video support that does not rely on ZenCoder.



Proposed new structure for os2display admin
===========

To make os2display modular so different installations can offer different features, the following structure is proposed.

To get started quickly a "os2display - Standard edition" should be developed, that is a full working installation. To make an os2display installation require os2displayCore, os2displayBase, os2displayMiddleware and any other bundles. 

## os2displayCore
Contains the minimum required to set up an os2display __admin__ installation.

This contains the basic AngularJS 1 modules and apps:

1. busModule
2. mainModule
3. menuApp
4. messageApp

Furthermore it contains the styleguide css, that supplies the UI styling for basic os2display elements.

Commands:

1. update command, that invokes the updateEvent in subscribers.

## os2displayBase
Contains slides, channels, screens, media entities and API. 

Contains slide/screen template functionality.

Contain the following AngularJS modules and apps:

1. slideApp
   - slide overview directive
   - slide creation directive
2. channelApp
   - ...
3. screenApp
   - ...
4. mediaApp
   - ...

## os2displayMiddleware
Contains the services that push content to the __middleware__. 

## os2displayDefaultTemplates
Contains basic templates and js.

## os2displayVideoZencoder
Contains video support through Zencoder.

Contains the video template.

## os2displayRss
Contains support for RSS feeds in slides.

## os2displayTimeline
Contains the timeline functionality for channels and screens.

## os2displaySearch
Contains integration with search-node.

## dokk1Templates
Constains templates related to Dokk1

## aarhusTemplates
Contains templates related to Aarhus
MSO, MBU, aarhus

## itkTemplates
Contains templates for ITK

...



## Plan to achieve this

1. We have to start using:
<pre>
app/console assets:install --symlink
</pre>
This should be run each time a new bundle is added. It creates a symlink from src/[Bundle]/Resources/public/ => web/bundles/[bundle shortname]/. Add a postupdate cmd to to this to AppKernel.
2. Change all web/-relative paths in web/ to this /bundle/[bundle shortname]/[path].
3. Figure out a way to load the js when distributed across multiple bundle folders.
4. Extend the template update function to look in each bundle for templates.
5. Versions tag after js, css imports should be added by asset, see [http://symfony.com/doc/current/reference/configuration/framework.html#version](http://symfony.com/doc/current/reference/configuration/framework.html#version).
6. Ensure that 
<pre>
  location /templates/ {
    add_header 'Access-Control-Allow-Origin' "*";
  }
</pre>
in the nginx configuration can be moved to /bundles/\*/templates/\*.
7. Each bundle should have a composer.json file describing its dependencies.
8. Make each bundle "composer require"-able (Packagist ?).
