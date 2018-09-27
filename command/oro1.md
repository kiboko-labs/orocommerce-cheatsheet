Useful command with Oro 1.x
========================


> Lancer la Consume-list

```bash
app/console oro:message-queue:consume
 ```

> Avec plus ou moins d'informations

```bash
app/console oro:message-queue:consume -v
app/console oro:message-queue:consume -vv
app/console oro:message-queue:consume -vvv
 ```
   
> Effacer le cache 

```bash
rm -rf app/cache/*
```

> Mot de passe oublié

```bash
app/console oro:user:update nomUser --user-password=root
```

> Génerer les assets

```bash
app/console oro:asset:install && app/console assetic:dump
```

> Faire un symlink (ne marche pas en cas de création de fichier)

```bash
app/console oro:asset:install --symlink
```

> Lancer les migrations de schema

```bash
app/console oro:migration:load
```

> Lancer les migrations de data

```bash
app/console oro:migration:data:load
```

> Creer un token d'accès limité dans le temps

```bash
app/console oro:user:impersonate user 
```

> Récuperer/Génerer Traductions

```bash
app/console oro:translation:load
app/console oro:translation:dump 
```

> Génerer les routes JS (Api/Components)

```bash
app/console fos:js-routing:dump --target web/js/routes.js 
```