#Aroskanalen changelog

#In development

__Screen__

* Added dates to script and css imports
* feature/rss-slide: adds rss slide templates (aarhus/rss-aarhus & default/rss-default)

__Admin__

* feature/ldap-login: implements ldap login (not merged with development branch). NB! Requires app/console doctrine:schema:update --force since the user field on Slide/Channel/Screen is changed from integer to string.
* feature/rss-slide: adds rss slide templates (aarhus/rss-aarhus & default/rss-default)

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
