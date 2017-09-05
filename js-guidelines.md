# Javacript guidelines

## Content

1. [File structure](#file-structure)
2. [Comments](#comments)

<a name="file-structure"></a>
## 1. File structure

### Admin
To extend the __admin__ create a new Angular module or app and place it in web/apps/.

Enable the module or app by adding them to app/config/modules.yml or app/config/apps.yml. Each file that should be loaded should be added to these files.  

<a name="comments"></a>
## 2. Comments

Inline documentation for source files should follow the <a href="https://drupal.org/node/1354">Doxygen formatting conventions</a>.

Non-documentation comments are strongly encouraged. A general rule of thumb is that if you look at a section of code and think "Wow, I don't want to try and describe that", you need to comment it before you forget how it works. Comments can be removed by JS compression utilities later, so they don't negatively impact on the file download size.

Non-documentation comments should use capitalized sentences with punctuation. All caps are used in comments only when referencing constants, e.g., TRUE. Comments should be on a separate line immediately before the code line or block they reference

```code
// Unselect all other checkboxes.
```

