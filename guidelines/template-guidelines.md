# Template guidelines

## Content

1. [Description](#description)
2. [Custom templates](#custon-templates)
2. [.json files](#json)


<a name="description"></a>
## 1. Description

__OS2Display__ contains templates for screens and slides. These are used to create content for the screens.

Templates should be placed in a bundle that is required by composer. As an example see [DefaultTemplateBundle](https://github.com/os2display/default-template-bundle).
The bundles should extend Os2DisplayBaseExtension in DependencyInjection/[BUNDLE_NAME]Extension.php, the same as:
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

Templates are located in the `Resources/public/templates` folder.

To load new templates into OS2Display, run the following command:

```Shell
bin/console os2display:core:templates:load
```

<a name="custom-templates"></a>
## 2. Custom templates

A template should consist of

1. a .json file that supplies metadata for the template. This contains the path to all the other files the template consists of.
2. an .html file for the __live__ representation of the template (angular).
3. (if necessary) an .html files for preview and editing of the template. These will often be the same file (angular). 
4. a .css file for the template.
5. an .png icon for template representation in the administration.
6. a .js file for running the slide in __screen__ (not for screen templates) if special code is necessary.

### Naming

It is important that the __id__ in the .json file is unique.
Therefore, it should be prefixed with __[organization]-__ .
Unique naming is important is in the class names in the templates and css.
These should be prefixed with the __id__ of the template.

<a name="json"></a>
## 3. .json files

The .json files are the most important files of the templates since they contain all the metadata for the template.
These are the files the `os2display:core:templates:load` command looks for when adding templates to the system. 

See the .json files in the `DefaultTemplateBundle` folder for examples. 

### JSON configuration file for Slide templates

The JSON file should contain 

```JSON
{
  "id": "[organization]-[template name]",
  "type": "screen",
  "name": "[display name]",
  "icon": "[relative path to icon.png]",
  "paths": {
    "live": "[relative path to live-template.html]",
    "edit": "[relative path to edit-template.html]",
    "css": "[relative path to live-template.css]"
  },
  "orientation": "[landscape or portrait]",
  "tools": {
    "[tool id]": "[relative path to tool]"
  }
}
```


### JSON configuration file for Screen templates

The .json file should contain

```JSON
{
  "id": "[organization]-[template name]",
  "type": "slide",
  "name": "[display name]",
  "icon": "[relative path to icon.png]",
  "paths": {
    "live": "[relative path to live-template.html]",
    "edit": "[relative path to edit-template.html]",
    "preview": "[relative path to preview-template.html]",
    "css": "[relative path to live-template.css]"
    "js": "[relative path to the slide script.js]"
  },
  "orientation": "[landscape or portrait]",
  "slide_type": "[type of the slide: base, video, rss, iframe, calendar]",
  "media_type": "[image or video]",
  "script_id": "[the id for the js script]",
  "ideal_dimensions": {
    "width": "1920",
    "height": "1080"
  },
  "empty_options": {
    [default variables for the slide]
  },
  "tools": [
    {
      "name": "[display name for tool]",
      "id": "[tool id]",
      "path": "[relative path to tool]"
    },
    {
      "name": "[display name for tool]",
      "id": "[tool id]",
      "path": "[relative path to tool]"
    }
  ]
}
```
