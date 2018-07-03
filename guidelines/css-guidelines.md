# CSS guidelines (SCSS)

These are *guidelines*, and if you think it's necessary to deviate feel free to do so, **but** please [be sensible](http://csswizardry.com/2010/08/semantics-and-sensibility/) and do this only because it's necessary.

* Be familiar with [SCSS](http://sass-lang.com/)
* Read [this](http://www.jakobloekkemadsen.com/2013/07/css-abstractions-done-right/)
* Read [this](http://www.jakobloekkemadsen.com/2012/09/tdcss-js/)
* Use [SCSS](http://sass-lang.com), but only [nest one level](#exceptions-and-deviations)
* [Be sensible](http://csswizardry.com/2010/08/semantics-and-sensibility/)
* [Don't break the windows](http://www.rtuin.nl/2012/08/software-development-and-the-broken-windows-theory/)
* [DRY](http://en.wikipedia.org/wiki/Don%27t_repeat_yourself)
* Use [single-direction margin declarations](http://csswizardry.com/2012/06/single-direction-margin-declarations/)

## Content

1. [Comments](#comments)
2. [File structure](#file-structure)
3. [Naming and states](#naming-states)
4. [Declaration order](#declaration-order)
5. [Media queries](#media-queries)
6. [Javascript](#javascript)
7. [Exceptions and deviations](#exceptions-and-deviations)

<a name="comments"></a>
## 1. Comments

* Place inline comments on a new line above the subject

```css
/**
 * File name
 *
 * Optional description
 *
 * @author author name
 */


/* Section comment
 *
 * Optional description
 *
 * ========================================================================== */


/* This is an inline CSS comment (use this in css files) */

// This is an inline SCSS comment (use this in scss files)
```

<a name="file-structure"></a>
## 2. File structure

- Files that contains multiple words are separated with dashes e.g. <code>_my-module.scss</code>

__Example__
```code
sass/
  base/
    _base.scss
  base_modules
    _base-button.scss
    _base-list.scss
  layout/
    _layout.scss
  modules/
    _my-module.scss
    _search.scss
    _form.scss
  patterns/
    _patterns.scss
    _search-patterns.scss
  theme/
    _theme-vars.scss
    _buttons.scss
  styles.scss
```

<a name="naming-states"></a>
## 3. Naming and states

### Naming

Naming are based (very) loosely on BEM. Module elements is separated with two dashes, and the module name itself can have single dashes if needed.

```css
.module-name {
}

.module-name--element-1 {
}

.module-name--element-2 {
}

.search {
}

.search--button {
}

.search--field {
}
```

### Structue
Structure the sass modules as logical patterns.

#### Folders
   
   - Base: default base styles. Should be included in every project to set som reasonable defaults sitewide.
   - Base-module: folder holding the default/fallback styles for all components in the project (and across projects).
     This folder can be used as reference for developers, and should be very well documented on flow and usage.
     This folder could be part of the boilerplate.
   - Layout: Holds classes for the general page layout, often including the selectors that extend grid styles.
   - Modules: Site specific styles extending patterns and adding custom code. Each module should have a logical and isolated usage.
   - Pattern: Components should hold mostly if not only silent classes (%list, %list--item, %list--link etc.)
   - Theme: For site specific default variables, mixins and global silent classes

### States
If states are needed prefix it with <code>.is-</code>, <code>.has-</code> etc., also check out the [javascript guidelines](js-guidelines.md).

```html
<a href="http://example.com" class="button">This is a link button</a>

<a href="http://example.com" class="button is-active">This is a link button</a>
```


```css
.button {
  background-color: $gray;

  &.is-active {
    background-color: $green;
  }
}
```

<a name="declaration-order"></a>
## 4. Declaration order

* One selector per line
* Add a single space after the colon of the declaration
* <code>@extend</code> goes in the top so we know if the ruleset inherits another
* Normal rules goes next
* <code>@include</code> goes last

```css
.class {
  @extend %placeholder();

  /* Positioning */
  position: absolute;
  z-index: 10;
  top: 0;
  right: 0;
  bottom: 0;
  left: 0;


  /* Display & Box Model */
  display: inline-block;
  overflow: hidden;
  width: 100px;
  height: 100px;
  padding: 10px;
  border: 10px solid #333;
  margin: 10px;

  /* Other */
  background: $color;
  color: $white;
  font-family: $font-family;
  font-size: $font-size;
  text-align: right;

  @include mixin();
}
```

<a name="media-queries"></a>
## 5. Media queries

* Add media query <code>@includes</code> after other <code>@includes</code> and <code>@extends</code>

```css
.class {
  background-color: $blue;

  @include breakpoint(10em) {
  	background-color: $red;
  }

  @include breakpoint(20em) {
  	background-color: $green;
  }

  @include breakpoint($breakpoint) {
  	background-color: $white;
  }
}
```

<a name="javascript"></a>
## 6. Javascript

* Don't use <code>.js-</code> for styling

[See javascript guidelines](js-guidelines.md)

<a name="exceptions-and-deviations"></a>
## 7. Exceptions and deviations

* You can nest two levels when using pseudo classes
* You can nest two levels when using media queries mixins
* If you have to deviate from the one limit nesting rule (except mentioned in this section), explain why in an inline comment
