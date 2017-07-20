# Setting up Codesniffer

__TODO__: Maybe say something about scrutinizer and that it also checks the coding style.
 

This guide will explain the steps needed to setup Code Sniffer with Drupal coding standards and PhpStorm.

__IMPORTANT!__ You need brew to perform this task, http://brew.sh/

## 1. Install code sniffer

  ```Shell
  brew install php-code-sniffer
  ```
  
## 2. Download [Drupal Coder Module](https://drupal.org/project/coder)

  Make sure you are in your home dir

  ```Shell
  cd
  ```

  ```Shell
  wget https://ftp.drupal.org/files/projects/coder-8.x-2.8.tar.gz
  ```

  If you don't have wget install it using _brew install wget_

## 3. Unpack Coder module. I place it in ~/.drupal-coder

  ```Shell
  tar -xzf coder-8.x-2.8.tar.gz
  mv coder .drupal-coder
  rm coder-8.x-2.8.tar.gz
  ```

## 4. Create symlink to Drupals code standards.

  Brew installs Code Sniffer into _/usr/local/Cellar/php-code-sniffer/[VERSION]/_
  We want a symlink pointing at Drupals code standards in _/usr/local/Cellar/php-code-sniffer/[VERSION]/CodeSniffer/Standards/_ for example

  ```Shell
  ln -s ~/.drupal-coder/coder_sniffer/Drupal /usr/local/Cellar/php-code-sniffer/2.6.2/CodeSniffer/Standards/Drupal
  ```

  __Important__ Make sure you change _.drupal-coder_ in the above if you did not install coder in the suggested folder.

## Configure PhpStorm

1. Tell PhpStorm where to find Code Sniffer

  1. Go to Preferences -> PHP -> Code Sniffer

  2. Paste this into PHP Code Sniffer (phpcs) path: **_/usr/local/bin/phpcs_**

  3. Validate and apply

2. Enable Code Sniffer inspection

  1. Go to Preferences -> Inspections -> PHP -> PHP Code Sniffer validation

  2. Enable this

  3. Refresh coding standards, Drupal should pop up

  4. Apply and OK


You should be ready to go. Open a Drupal module and make a coding style error to be sure.
