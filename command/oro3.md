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

## Update entities

```bash
bin/console oro:entity-extend:cache:check                     Makes sure that extended entity configs are ready to be processed by other commands. This is an internal command. Please do not run it manually.
bin/console oro:entity-extend:cache:clear                     Clears extended entity cache.
bin/console oro:entity-extend:cache:warmup                    Warms up extended entity cache.
bin/console oro:entity-extend:migration:update-config         Updates extended entities configuration during a database structure migration process. This is an internal command. Please do not run it manually.
bin/console oro:entity-extend:update-config                   Prepare entity config
bin/console oro:entity-extend:update-schema                   Synchronize extended and custom entities metadata with a database schema

```

## Assets
**Install assets**


3.0 (with assetic)
```bash
bin/console oro:asset:install && bin/console assetic:dump
bin/console oro:assets:install -e dev && bin/console assetic:dump -e dev
```

3.1 (with webpack)
```bash
bin/console asset:install && bin/console oro:asset:build
bin/console asset:install --env=dev && bin/console oro:asset:build --env=dev
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

**Data migrations dump**

```bash
bin/console oro:migration:dump
```
more : https://github.com/oroinc/platform/tree/master/src/Oro/Bundle/MigrationBundle

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
