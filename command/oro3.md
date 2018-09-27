Useful command with Oro 3.x
========================


> Lancer la Consume-list

```bash
bin/console oro:message-queue:consume
 ```

> Avec plus ou moins d'informations

```bash
bin/console oro:message-queue:consume -v
bin/console oro:message-queue:consume -vv
bin/console oro:message-queue:consume -vvv
 ```
   
> Effacer le cache 

```bash
rm -rf var/cache/*
```

> Mot de passe oublié

```bash
bin/console oro:user:update nomUser --user-password=root
```

> Génerer les assets

```bash
bin/console oro:asset:install && bin/console assetic:dump
```

> Faire un symlink (ne marche pas en cas de création de fichier)

```bash
bin/console oro:asset:install --symlink
```

> Lancer les migrations de schema

```bash
bin/console oro:migration:load
```

> Lancer les migrations de data

```bash
bin/console oro:migration:data:load
```

> Creer un token d'accès limité dans le temps

```bash
bin/console oro:user:impersonate user 
```

> Récuperer/Génerer Traductions

```bash
bin/console oro:translation:load
bin/console oro:translation:dump 
```

> Génerer les routes JS (Api/Components)

```bash
bin/console fos:js-routing:dump --target web/js/routes.js 
```