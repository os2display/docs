#os2display



##Content

1. [Description](#description)
2. [License](#license)
3. [Status](#status)
4. [Templates](#templates)
5. [Guidelines](#guidelines)
6. [Todos](#todo)
7. [Links](#links)



<a name="description"></a>
##1. Description

__os2display__ is a system for creating and delivering content to screens. 

It consists of the following parts:

* __admin__: the administration website (Symfony / AngularJS)
* __screen__: the client that should run on the screen to display the content created in __admin__ (AngularJS)
* __middleware__: the connection between __admin__ and __screen__. The content is pushed from the admin into the middleware that pushes the content to the relevant screens through websockets (node.js).
* __search-node__: the search engine used by __admin__. See [https://github.com/search-node/search_node](https://github.com/search-node/search_node) (node.js).
* __docs__: the documentation for the project.
* __styleguide__: a display of the available UI elements in __admin__.
* __vagrant__: a vagrant development setup. See [https://www.vagrantup.com/](https://www.vagrantup.com/).



<a name="license"></a>
##2. License

See [License](LICENSE.txt).



<a name="status"></a>
##3. Status

The __admin__ (as of v4.0.0) is in a state of change. The angular code for the admin is moving from a monolithic angular app into seperate apps each concerned with a small part of the administration. The apps each communicate through a bus (busService) where events are emitted and received. This is a change that will be ongoing until all the functionality from the legacy app has been moved into seperate apps.

This change has been introduced to make the code pluggable and more readable. But while the legacy app still exists making changes to the system will be harder. 

On the styling front the __styleguide__ has been introduced. The goal is to have all elements that are used in __admin__ exist in the styleguide. The styling from the styleguide is copied to the admin. This means that if new elements are introduced they should be implemented in the styleguide first and then compiled and copied to the __admin__.

At the moment we have a lot of legacy sass in the web/sass/ folder of the __admin__. 



<a name="templates"></a>
##4. Templates

It is possible to extend os2display with new templates. These should be placed in the _web/templates/[organization]/_ folder. See [template-guidelines.md](template-guidelines.md) for details concerning templates.



<a name="guidelines"></a>
##5. Guidelines

Guidelines for developing for os2display

* [Code of Conduct](code-of-conduct.md)
* [Code standards](code-standards.md)
* [GIT guidelines](git-guidelines.md)
* [CSS guidelines](css-guidelines.md)
* [Javascript guidelines](js-guidelines.md)
* [Template guidelines](template-guidelines.md)


<a name="todo"></a>
##6. TODOs

See [todo.md](todo.md) for a list of todos and feature requests.


<a name="links"></a>
##7. Links

* See [CHANGELOG.md](CHANGELOG.md) for a list of changes.
* See [installation guide](Installation%20guide.md) for instructions on how to install os2display.
* See [Release process.md](Release%20process.md) for how releases are made.
* See [upgrade.md](upgrade.md) for instructions on how to upgrade between versions.
