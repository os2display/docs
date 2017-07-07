# CHANGELOG

## In development

### release/v4.1.0

* Added group based controls to all content.
* Added user admin system.
* Removed SonataUser bundle.
* Updated symfony to 2.8.19.
* Fixed doctrine migrations to be able to run from an empty database.
* Remove files from web/bundles that should have been ignore.
* Fixed form styling.
* Added close functionality when clicking outside panel menu.
* Changed "All/Mine" filter to be stored in localStorage.
* Fixed issue where groups could be unassigned by users that did not have permission.
* Added unavailable groups to ui when selecting groups.

### v4.0.2

* Fixed gulpscript with new template folder names.
* Fixed screen description field being overridden by title.
* Added option "interest_interval" to calendar slide options. This field will make the slide read X days into the future instead of only current day.
* Added doctrine migrations script to add interest_interval=7 for dokk1-coming-events slides.
* Fixed issue with too fast searches in timeline.
* Fixed issue with "ghost channels", where a channel was removed, but still existed in the middleware, and therefore, also on screens.
* Re-added 401 redirects to /login.
* Fixed priorities of cron.
* Fixed issue with Feed service and js where the feed was displayed as empty.

### v4.0.1

* Fixed user creation problems (with Sonata bundles) after Symfony upgrade to 2.8

### v4.0.0

* Introduced Styleguide
* Implemented new design. css/styles-new.css is the styles generated in the style guide. 
  Eventually this will be the only styling for Aroskanalen. 
  In the meantime styles-new exist together with the legacy styling in assets/build/styles.min.css.
* Split the large angular app (ikApp) into smaller apps, communicating through a busService.
  The plan is to move more and more functionality into separate apps and modules.
* Added app/config/apps.yml and app/config/modules.yml to keep track of the angular modules and apps.
* Added: messageApp displaying messages sent through the busService.
* Added: menuApp consisting of three directives that each request and listen for menu items.
* Added new feature: Timeline, showing the scheduling of channels and slides. Based on http://visjs.org/.
* Added DoctrineMigrations
* Removed Instagram support. Added migrations script 20160623082121 to remove Instagram slides and template from an installation.
* Fixed issues with shared-channel where new content was not pushed to the sharing service.
* Removed log out on 401.
* Moved searchService into mainModule, and made it event based.
* Added event based bodyService to control classes applied to the body element.
* Added itk-three-split screen template.
* Readied templates for move out of admin repository.
* Updated search to work with newest version of search_node: https://github.com/search-node.
* Added option to iframe to disable automatic reload of iframe content.
* Fixed issue where channel picker under screen creation display empty paging results.
* Added filters to Dokk1 calendar templates.
* Updated symfony and other bundles regarding security issues.
* Changed ik:cron command to be event based.
* Moved KobaIntegration into separate bundle.
* Removed all templates not default from templates/.
* Renamed web/templates/default => web/templates/default_templates

See [upgrade.md](upgrade.md) for upgrade instructions.

### v3.5.11

* Introduced empty option for background of dokk1 templates.

### v3.5.10

* Re-write zencoder upload/download to use guzzle and job queues

### v3.5.9

* Added event filtering to calendar templates.

### v3.5.8

* Added filter to coming events that hides events with title containing "(usynlig)"

### v3.5.6, v3.5.7

* Fixed zencoder file upload.

### v3.5.5

_Admin_
* Added dokk1-coming-events template
* Fixed bug where slide duration was not editable when slide_type was not set
* Fixed slide duration = 0 issue
* Added extra checks for thumbnail existence for video slides in administrations
* Fixed issue with sorting in manual calendar

_Screen_
* Added $filter to region
* NB! Requires screen reload for changes to apply

### v3.5.4

_Admin_
* Added mso-four-sections screen template.
* Added theme to date component for mso-four-sections template.
* Added break-word to dokk1-instagram template.
* Refactored instagramSlide.js to avoid undefined bug.
* Fixed issues with manual calendar: Dates shown wrong and missing remove button in editor.

_Middleware_
* Changed expire from string to a number in example.apikeys.json. 
* Changed input type for expire input from text to number.

_Vagrant_
* Changed expire from string to a number in apikeys.json.
* Created middleware/logs directory

_Screen_
* Fixed issue with scheduling of channels.
* Added theme to date component for mso-four-sections template.
* NB! Requires screen reload for changes to apply

### v3.5.3

_Admin_
* Added remove screen call to middleware on screen delete in administration
* Made search filter configurable
* NB! requires adding "search_filter_default" parameter to parameters.yml. Available options: "all", "mine"

_Middleware_
* Added missing jwt to DELETE:api/screen/{id}
* Fixed screen "booted" in socket conneciton protection with privat UUID.

_Screen_
* Added UUID cookie to identify a given screen.

### v3.5.2

_Admin_
* Fixed instagram template not restarting

### v3.5.1

_Admin_
* Fixed screens/default/three-columns template

_Middleware_
* Fixed race condition between screens connecting at the same time

### v3.5.0

_Admin_
* Added gulp tasks to compile js and sass
* Changed how icons are used (Removed sprites)
* Moved editor icons out of edit slide templates
* Split the rendering of sass for the templates from admin sass
* Fixed minor styling issues
* Only load all javascripts in dev environment, use compiled js for prod
* Updated angular from 1.2.16 to 1.4.6
* Moved slide js setup/run functions into the admin
* Added debounce to text searches, so when the text is entered the search is only completed when there has not been a new key press within 500 ms. This is to avoid race condition between searches.
* Moved RSS reader into backend
* Added Dokk1 Instagram template
* Moved Instagram reader into backend
* NB! Add instagram_client_id key to parameters.yml
* NB! Requires composer install
* NB! Requires app/console doctrine:schema:update --force since SlideTemplates has added some fields

_Screen_

* Added gulp tasks to compile js and sass
* Moved slide js setup/run functions into the admin
* Updated angular from 1.2.16 to 1.4.6
* Changed mouse hiding to only apply when the mouse is inactive
* NB! Requires screen reload for changes to apply

_Middleware_
* Fixed channel remove function,
* Fixed bug where to screen with same ID could be online at the same time.
* Fixed connection event issue in socket.io (more than on connect event on re-connect).
* Added cron jobs to clean up screens from cache (14 days).
* Added logic to remove screens that have never been connected.
* Fixed log out
* NB! Requires update.sh to be executed.

### v3.4.2

* Reverted "Changed label in dokk1 template"

### v3.4.1

__Admin__

* Added cache to user fetch.
* Updated default search to use "mine" tab in UI.
* Resolved issue with non-existing resources for calendar slides.
* Fixed MBU templates issues.
* Changed label in dokk1 template.

### v3.4.0

__Admin__

* Fixed pager to show a max of 10 results
* Fixed channel that could not be removed from a region of a screen
* Added MBU three split, MBU header, MBU footer templates

__Search node__

* Updated to elasticsearch 1.7.1
* Update mappings with "raw": false for all fields
* NB! Requires server update of elasticsearch

__Middleware__

* New logger (run ./update.sh and update config.json)

__Search node__

 * Updated to elasticsearch 1.7.1

__Middelware__
 
 * New logger (run ./update.sh and update config.json) 

### v3.3.0

__Screen__

* Added dates to script and css imports
* Added rss slide templates (aarhus/rss-aarhus & default/rss-default)
* Added a fallback image to the screen
* Changed page title to Aroskanalen

__Admin__

* Added rss slide templates (aarhus/rss-aarhus & default/rss-default)
* Fixed how overview items are aligned
* Added reload button to screens, only available to admins
* Changed is_admin to be ROLE_ADMIN and ROLE_SUPER_ADMIN, instead of only ROLE_SUPER_ADMIN
* Fixed positioning bug in dokk1_single_calendar template

### v3.2.1 (hotfix)

__Admin__

* Fixed bug where content was added between newly created slides
* Fixed bug where screen template was not loaded correctly when creating a screen

### v3.2.0

__Admin__

* Added alias to KOBA calendar templates
* Fixed bug with search factory event handlers being registered more than once

__Screen__

* Keyboard logout changed to ctrl+i

### v3.1.0

__Admin__

* Added new screen templates (two and three regions vertical)
* Added configuration for activating screen and slide templates
* Added check if trying to activate a screen that is already activated
* Added schedueling for channels
* Added Dokk1 multiple calendar template (available in Dokk1 installations)
* Added Dokk1 single calendar template (available in Dokk1 installations)
* Added MSO template with header and footer regions (available in MSO installations)
* Fixed an error in the 7 split wayfinding template (region had wrong id)
* Added version parameter when getting files, to avoid caching issue with new releases
* Added configuration of logging module to parameters

__Screen__

* Removed logout.html and replaced it with keyboard shortcut CTRL + L
* Added version parameter when getting files, to avoid caching issue with new releases
* Added configuration of logging module to parameters

__Middleware__

* Fixed screen overview with heartbeat and reload
* Fixed channel overview

### v3.0.0

__Admin__

* Added dynamic calendar (Exchange data)
* 5 split screen template
* Dokk1 wayfinding templates
* Updated screen interface

__Middleware__

* Added screen overview with heartbeat and reload
* Added channel overview

### v1.0.0

* Release 1
* Video
* Manual calendar

### v0.0.3

* Added video
* Fixed text-input areas in slide creation
* Fixed empty channel preview in channel overview
