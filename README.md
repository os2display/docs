# os2display

## Table of contents

1. [News](#news)
2. [Description](#description)
3. [License](#license)
4. [Custom Bundles](#custom_bundles)
5. [Templates](#templates)
6. [Guidelines](#guidelines)
7. [Links](#links)

<a name="news"></a>
## 1. News

Keep track of changes in the os2display project: [News.md](NEWS.md).

<a name="description"></a>
## 2. Description

__os2display__ is a system for creating and delivering content to screens. 

It consists of the following parts:

* __admin__: the administration website (Symfony / AngularJS)
* __screen__: the client that should run on the screen to display the content created in __admin__ (AngularJS)
* __middleware__: the connection between __admin__ and __screen__. The content is pushed from the admin into the middleware that pushes the content to the relevant screens through websockets (node.js).
* __search-node__: the search engine used by __admin__. See [https://github.com/search-node/search_node](https://github.com/search-node/search_node) (node.js).
* __docs__: the documentation for the project.
* __vagrant__: a vagrant development setup. See [https://www.vagrantup.com/](https://www.vagrantup.com/).

<a name="license"></a>
## 3. License

See [License](LICENSE.txt).

<a name="custom_bundles"></a>
## 4. Custom Bundles

See [custom-bundles-guidelines.md](guidelines/custom-bundles-guidelines.md) for instructions on making custom bundles.

<a name="templates"></a>
## 5. Templates

See [template-guidelines.md](guidelines/template-guidelines.md) for details concerning templates.

<a name="guidelines"></a>
## 6. Guidelines

Guidelines for developing for os2display

* [Code of Conduct](guidelines/code-of-conduct.md)
* [Code standards](guidelines/code-standards.md)
* [GIT guidelines](guidelines/git-guidelines.md)
* [CSS guidelines](guidelines/css-guidelines.md)
* [Javascript guidelines](guidelines/js-guidelines.md)
* [Template guidelines](guidelines/template-guidelines.md)

<a name="links"></a>
## 7. Links

* See [CHANGELOG.md](CHANGELOG.md) for a list of changes to docs. Each part of the project has its own CHANGELOG.
* See [installation guide](installation/Installation%20guide.md) for instructions on how to install os2display.
* See [Release process.md](guidelines/Release%20process.md) for how releases are made.
* See [upgrade.md](guidelines/upgrade.md) for instructions on how to upgrade between versions.
