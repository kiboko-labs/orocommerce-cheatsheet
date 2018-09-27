
### Scénario

> Je veux installer Sylius en Local

### Recupérer Sylius

> On récupère le Repository

```bash
git clone https://github.com/Sylius/Sylius.git
 ```
 
> On se place dans le projet

```bash
cd Sylius
 ```
 
> Verifiez que vous avez php 7.2

```bash
php -v
```

### Passer en PHP 7.2

> Si vous ne l'avez pas 

```
brew install php@7.2

```
> On va maintenant utiliser notre nouvelle version :   
> Il y a plusieurs manières de faire, moi j'utilise le .bash_profile pour switcher rapidement de versions suivant les projets    
> On commence par voir quel executable on utilise :

```bash
which php
```

> C'est visiblement pas le bon :

```bash
/usr/local/opt/php@7.1/bin/php
```

> Ouvrez votre .bash_profile ou créez le si il n'existe pas

```bash
vim /Users/votreUser/.bash_profile
```

> Avec Vim, à l'ancienne:   
> Pour insérer du texte, on appuie sur i   
> On met nos nouveaux paths (chemins de nos executables)    
> Corrigez les chemins des liens si ils ne correspondent pas a l'endroit ou brew a installé votre PhP

```bash
export PATH="/usr/local/Cellar/php/7.2.9_2/bin:$PATH"
export PATH="/usr/local/Cellar/php/7.2.9_2/sbin:$PATH"
```

> On quitte le mode insertion, la touche Echap   
> On sauvegarde et on quitte, ZZ

> Pour voir si notre modification a marché , on oublie pas de changer de console, et on refait :

```bash
which php
```
> Si tout c'est bien passé : 

```bash
/usr/local/Cellar/php/7.2.9_2/bin/php
```

> On vérifie enfin avec un php -v : 

```bash
PHP 7.2.9 (cli) (built: Aug 23 2018 02:08:27) ( NTS )
Copyright (c) 1997-2018 The PHP Group
Zend Engine v3.2.0, Copyright (c) 1998-2018 Zend Technologies
    with Zend OPcache v7.2.9, Copyright (c) 1999-2018, by Zend Technologies

```
> Jusquà là, on est bon.


### Installer nos dépendances 

> On se place a la racine de notre projet Sylius :

```bash
composer install
```

> Si vous n'avez pas composer

https://getcomposer.org

### Connecter notre futur sylius à une base :


> la connection se fait dans le .env a la racine de notre projet :

```bash
DATABASE_URL=mysql://notreUser:sonMotDePasse@ipDelaBase:1111/sylius_${APP_ENV}
```
> Sylius un système pour avoir une base par environnement    
> Le sylius_${APP_ENV} signifie juste que notre base s'appelera sylius_dev
 
> Le plus simple, si vous utiliser docker   
> Creez un ficher docker-compose.yml à la racine de votre projet

```bash
version: "2.0"
services:
    mysql:
        image: mysql:5.7
        container_name: sylius
        environment:
          MYSQL_ROOT_PASSWORD: root
          MYSQL_USER: notreUser
          MYSQL_PASSWORD: sonMotDePasse
          MYSQL_DATABASE: sylius_dev
        ports:
          - '1111:3306'
```

> Pour monter tout ça

 ```bash
docker-compose up
 ```
 

### Si tout c'est bien passé 

> On peut installer Sylius

```bash
php bin/console sylius:install
```
> En cas de problèmes d'extensions, dans mon cas c'était le timezone qui n'allait pas :   
> On trouve son php.ini   

```bash
php --ini
```

> Il peut y en avoir plusieurs suivant votre configuration

```bash
Configuration File (php.ini) Path: /usr/local/etc/php/7.2
Loaded Configuration File:         /usr/local/etc/php/7.2/php.ini
Scan for additional .ini files in: /usr/local/etc/php/7.2/conf.d
Additional .ini files parsed:      /usr/local/etc/php/7.2/conf.d/ext-opcache.ini
```

> On ouvre celui de base : 

```bash
vim /usr/local/etc/php/7.2/php.ini
```

> Pour faire une recherche avec vim : 

```bash
?date.timezone
```
> On met notre valeur et on oublie pas de décommenter la ligne : 

```bash
date.timezone = Europe/Warsaw

```
> On sauvegarde et on quitte

> Je ne sais plus si la config se met à jour toute seule, dans le doute  : 

```bash
brew services restart php@7.2
```


### Les assets :

 ```bash
yarn install 
yarn build
```


### On lance le serveur et c'est parti

 ```bash
php bin/console server:start --docroot=web 127.0.0.1:8000
```
 