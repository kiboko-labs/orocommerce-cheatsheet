### Scénario : 

> Je veux installer Xdebug pour php7.1 sur MacOs pour débugger du ORO

### Installer et configurer Xdebug 

> Placez-vous dans un terminal

 
> La méthode la plus propre est d'ajouter ce respository, Il va nous permettre d'avoir facilement accès à toute les extensions dont on a besoin
```bash
brew tap kyslik/homebrew-php
```
>On cherche celles pour notre version (php7.1)

```bash
brew search php71
```
> Vous aurez un truc qui ressemble à ça :

|   |   | 
|---|---|
| kyslik/php/php71-amqp | kyslik/php/php71-apcu | 
| kyslik/php/php71-amqp | kyslik/php/php71-intl |  
| kyslik/php/php71-apcu-bc |  kyslik/php/php71-mcrypt |   
| kyslik/php/php71-xdebug | kyslik/php/php71-mongodb |   

> Dans l'immédiat on a besoin que de xdebug, on l'installe :

```bash
brew install kyslik/php/php71-xdebug
```
> On vérifie :
```bash
php -v
```
> Vous devriez avoir Xdebug qui est apparut : 

```bash
PHP 7.1.14 (cli) (built: Feb  2 2018 08:42:59) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.1.0, Copyright (c) 1998-2018 Zend Technologies
    with Xdebug v2.6.0, Copyright (c) 2002-2018, by Derick Rethans
    with Zend OPcache v7.1.14, Copyright (c) 1999-2018, by Zend Technologies
```
> HomeBrew a du génerer un .ini pour configurer xdebug :
```bash
php --ini
```

```bash
Configuration File (php.ini) Path: /usr/local/etc/php/7.1
Loaded Configuration File:         /usr/local/etc/php/7.1/php.ini
Scan for additional .ini files in: /usr/local/etc/php/7.1/conf.d
Additional .ini files parsed:      /usr/local/etc/php/7.1/conf.d/ext-intl.ini,
/usr/local/etc/php/7.1/conf.d/ext-mcrypt.ini,
/usr/local/etc/php/7.1/conf.d/ext-opcache.ini,
/usr/local/etc/php/7.1/conf.d/ext-xdebug.ini
```
> On l'ouvre : 

```bash
vim /usr/local/etc/php/7.1/conf.d/ext-xdebug.ini
```

> Copiez-collez cette config : 

```bash
[xdebug]
zend_extension="/usr/local/opt/php71-xdebug/xdebug.so" 

xdebug.remote_enable=1
xdebug.remote_host= 127.0.0.1
xdebug.remote_port=9001
xdebug.remote_log ="/usr/local/etc/php/7.1/conf.d/ext-xdebug.log"
xdebug.idekey = PHPSTORM
```

> zend_extension : Chemin de l'extension (automatique)   
> xdebug.remote_host : Le serveur que vous voulez écouter    
> xdebug.remote_port : Le port que va utiliser xdebug, vérifiez bien qu'il n'est pas utilisé    
> xdebug.remote_log : On peut logger les erreurs, très pratique pour débugger, vous pouvez mettre le ficher que vous voulez.   
> xdebug.idekey = PHPSTORM (optionnel avec notre méthode)

### Configurer PHPStorm

![](Assets/images/xebugWebPage.png)


 


