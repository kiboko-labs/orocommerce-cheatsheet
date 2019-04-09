Useful command with Oro 3.x
========================

## Generic

**Install**

```bash
composer install --prefer-dist --no-dev
bin/console oro:install --timeout=0
 ```

**Start message queue consume**

```bash
bin/console oro:message-queue:consume
 ```

with less or more informations

```bash
bin/console oro:message-queue:consume -v
bin/console oro:message-queue:consume -vv
bin/console oro:message-queue:consume -vvv
 ```
   
**Remove cache**

```bash
rm -rf var/cache/*
```


## Indexation

**Search**

```bash
bin/console oro:search:index
bin/console oro:search:reindex
```

**Website**

```bash
bin/console oro:website-search:reindex
bin/console oro:website-search:reindex --website-id=2
```


## Assets
**Install assets**

```bash
bin/console oro:asset:install && bin/console assetic:dump
bin/console oro:assets:install -e dev && bin/console assetic:dump -e dev
```

with symlink (without new file creation)

```bash
bin/console oro:asset:install --symlink
```


## Migrations
**Schema migrations**

```bash
bin/console oro:migration:load
```

**Data migrations**

```bash
bin/console oro:migration:data:load
```

## Users

**Password changing**

```bash
bin/console oro:user:update nomUser --user-password=root
```

**Create a limited access token over time**

```bash
bin/console oro:user:impersonate user 
```

## ElasticSearch

En cas d'erreur d'indexation :
```bash
bin/console oro:website-elasticsearch:create-website-indexes
```

## Others

**Translations**

```bash
bin/console oro:translation:load
bin/console oro:translation:dump 
```

```bash
bin/console oro:translation:dump && bin/console oro:localization:dump
```

Load with parameters :
```bash
bin/console oro:translation:load --languages=en --languages=fr --rebuild-cache
```

**Gerate JS routing (Api/Components)**

```bash
bin/console fos:js-routing:dump --target web/js/routes.js 
```

## And more
If you need Bruce's power : https://github.com/kiboko-labs/KibokoArmageddonBundle
