#Aroskanalen CHANGELOG


#In development feature branches

__feature/ldap-login__

_Admin_

* Implemented ldap login (not merged with development branch). 
* NB! Requires app/console doctrine:schema:update --force since the user field on Slide/Channel/Screen is changed from integer to string.

#v3.5.1

_Admin_
* Fixed screens/default/three-columns template

_Middleware_
* Fixed race condition between screens connecting at the same time

#v3.5.0

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
* NB! Update version number in parameters.yml
* NB! Requires composer install
* NB! Requires app/console doctrine:schema:update --force since SlideTemplates has added some fields
* NB! Requires app/console ik:templates:load
* NB! Clear cache
* NB! app/console ik:push --force

_Screen_

* Added gulp tasks to compile js and sass
* Moved slide js setup/run functions into the admin
* Updated angular from 1.2.16 to 1.4.6
* Changed mouse hiding to only apply when the mouse is inactive
* NB! Update version number in app/config.js
* NB! Requires screen reload for changes to apply

_Middleware_
* Fixed channel remove function,
* Fixed bug where to screen with same ID could be online at the same time.
* Fixed connection event issue in socket.io (more than on connect event on re-connect).
* Added cron jobs to clean up screens from cache (14 days).
* Added logic to remove screens that have never been connected.
* Fixed log out
* NB! Requires update.sh to be executed.

#v3.4.2

* Reverted "Changed label in dokk1 template"

#v3.4.1

__Admin__

* Added cache to user fetch.
* Updated default search to use "mine" tab in UI.
* Resolved issue with non-existing resources for calendar slides.
* Fixed MBU templates issues.
* Changed label in dokk1 template.

#v3.4.0

__Admin__

* Fixed pager to show a max of 10 results
* Fixed channel that could not be removed from a region of a screen
* Added MBU three split, MBU header, MBU footer templates

__Search node__

* Updated to elasticsearch 1.7.1
* NB! Requires server update of elasticsearch
* Update mappings with "raw": false for all fields

__Middleware__

* New logger (run ./update.sh and update config.json)

__Search node__

 * Updated to elasticsearch 1.7.1

__Middelware__
 
 * New logger (run ./update.sh and update config.json) 

#v3.3.0

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

#v3.2.1 (hotfix)

__Admin__

* Fixed bug where content was added between newly created slides
* Fixed bug where screen template was not loaded correctly when creating a screen

#v3.2.0

__Admin__

* Added alias to KOBA calendar templates
* Fixed bug with search factory event handlers being registered more than once

__Screen__

* Keyboard logout changed to ctrl+i

#v3.1.0

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

#v3.0.0

__Admin__

* Added dynamic calendar (Exchange data)
* 5 split screen template
* Dokk1 wayfinding templates
* Updated screen interface

__Middleware__

* Added screen overview with heartbeat and reload
* Added channel overview

#v1.0.0

* Release 1
* Video
* Manual calendar

#v0.0.3

* Added video
* Fixed text-input areas in slide creation
* Fixed empty channel preview in channel overview
