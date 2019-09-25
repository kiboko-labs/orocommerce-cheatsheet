### Scénario : 

> Je veux avoir Xdebug activé que pour certaine commandes

### Prérequis :

> Avoir installer Xdebug


### Explication :

> On va faire en sorte d'avoir l'extension Xdebug activée à la demande


### Solution

 Partons du principe que vous avez la config de xdebug dans votre fichier /usr/local/etc/php/7.2/php.ini``
 comme ceci : 
```
                  ;zend_extension="/usr/local/Cellar/php@7.2/7.2.15/pecl/20170718/xdebug.so"
                  
                  xdebug.remote_enable=1
                  xdebug.remote_host=localhost
                  xdebug.remote_port=9001
                  xdebug.remote_log="xdebug.log"
                  xdebug.idekey=PHPSTORM
                  xdebug.remote_autostart=1
```

- On duplique ce fichier dans le dossier en renommant la copie `php.iniv2`

- Dans cette copie on décommente la ligne zend_extension en enlevant le point-virgule

- On édite le fichier des alias, dans mon cas : `nano ~/.bash_profile`

- On ajoute un alias comme ceci : `alias phpx="php -c /usr/local/etc/php/7.2/php.iniv2"`

- Et on recharge notre fichier d'alias : `source ~/.bash_profile`

- Et voila !!! : 
```julien@MBP-de-Julien:~/PhpstormProjects/orocommerce-cheatsheet$ php -v 
    PHP 7.2.15 (cli) (built: Mar 12 2019 09:36:43) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Zend OPcache v7.2.15, Copyright (c) 1999-2018, by Zend Technologies
        
    julien@MBP-de-Julien:~/PhpstormProjects/orocommerce-cheatsheet$ phpx -v
    PHP 7.2.15 (cli) (built: Mar 12 2019 09:36:43) ( NTS )
    Copyright (c) 1997-2018 The PHP Group
    Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
        with Xdebug v2.7.0, Copyright (c) 2002-2019, by Derick Rethans
        with Zend OPcache v7.2.15, Copyright (c) 1999-2018, by Zend Technologies
```
- Petit alias bien pratique pour les utilisateurs du framework Symfony/Oro ... : 
`alias sfx="php -c /usr/local/etc/php/7.2/php.iniv2 bin/console"`


