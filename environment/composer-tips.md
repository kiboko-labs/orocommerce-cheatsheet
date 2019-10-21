Compose tips
=====================================

https://getcomposer.org/doc/

# Install

`composer install`

`composer install --prefer-dist --no-dev`

# Require

Add new component :

`composer require knplabs/gaufrette`

If the package is not on https://packagist.org/, simply add repository in json file like this :


    (...)
    'repositories": {
    
     friendsoforo/oro-slider-bundle": {
       "type": "vcs",
       "url": "git@github.com:FriendsOfOro/OroSliderBundle.git"
     }
    (...)


And after you can execute this:

    composer require friendsoforo/oro-slider-bundle


#### Specific requirement

Specific branch :

`composer require friendsoforo/oro-slider-bundle:dev-staging`

Specific commit :

`composer require friendsoforo/oro-slider-bundle:dev-master#d7c1fd6b46e1679835ce4167042847a2fc7c7643`

# Update

Update all components 

`composer update` /!\ always in local

Update one component:

`composer update knplabs/gaufrette:dev-master`
