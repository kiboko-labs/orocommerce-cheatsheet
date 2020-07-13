**Configuration de l'application** :

Utilisez la configuration par défaut de l'application installée en mode production. Si aucun serveur de messagerie n'est configuré localement, définissez le paramètre mailer_transport dans parameters.yml sur null.

**Configuration Behat**

La configuration de base se trouve dans behat.yml.dist. Chaque application possède son propre fichier behat.yml.dist à la racine du répertoire de l'application.
Créez votre behat.yml (il est ignoré par git automatiquement et n'est jamais validé dans le référentiel distant), importez la configuration de base et modifiez-la pour l'adapter à votre environnement:

## configuration en local, sans docker
```
yaml
imports:
   - ./behat.yml.dist

 default: &default
     extensions: &default_extensions
         Behat\MinkExtension:
             browser_name: chrome
             base_url: "http://localhost:8010"
```

## configuration avec la stack docker kiboko
```
imports:
    - ./behat.yml.dist

default: &default
    extensions: &default_extensions
        Behat\MinkExtension:
            browser_name: chrome
            base_url: 'http://http'
            default_session: 'first_session'
            sessions:
                second_session:
                    oroSelenium2:
                        wd_host: 'http://localhost:4444/wd/hub'
                        capabilities:
                            browser: chrome
                            extra_capabilities:
                                browser: chrome
                                chromeOptions:
                                    w3c: false
                first_session:
                    oroSelenium2:
                        wd_host: 'http://localhost:4444/wd/hub'
                        capabilities:
                            browser: chrome
                            extra_capabilities:
                                browser: chrome
                                chromeOptions:
                                    w3c: false
                system_session:
                    oroSelenium2:
                        wd_host: 'http://localhost:4444/wd/hub'
                        capabilities:
                            browser: chrome
                            extra_capabilities:
                                browser: chrome
                                chromeOptions:
                                    w3c: false
                320_session:
                    oroSelenium2:
                        wd_host: 'http://localhost:4444/wd/hub'
                        capabilities:
                            extra_capabilities:
                                chromeOptions:
                                    w3c: false
                640_session:
                    oroSelenium2:
                        wd_host: 'http://localhost:4444/wd/hub'
                        capabilities:
                            extra_capabilities:
                                chromeOptions:
                                    w3c: false
```

!!! => Configurer votre parameters.yml avec le search engine en orm et dbal pour les messages

## Installation

### Installation des dépendances de développement :

Si vous avez installé des dépendances avec le paramètre --no-dev plus tôt, supprimez le fichier composer.lock de la racine du répertoire de l'application.

Installez les dépendances dev à l'aide de la commande suivante

`composer install`

### Etat de l'application initiale 

Dans Oro, l'état initial est celui lorsque l'application est installé sans données de démonstration.
Les scénarios qui testent des fonctionnalités doivent s'appuyer sur cet état et doivent créer toutes les données nécessaires à des vérifications supplémentaires.
Les données peuvent être créées par les étapes du scénario ou comme montages.

Installez l'application en anglais, sans données de démonstration en mode production, sans rabbit et elastic à l'aide de la commande suivante:

```
 bin/console oro:install  --drop-database --user-name=admin --user-email=admin@example.com  \
   --application-url=http://localhost:8010 --user-firstname=John --user-lastname=Doe \
   --user-password=admin  --organization-name=ORO --env=prod --sample-data=n --timeout=3000 \
   --formatting-code=en --language=en
```

### Installation des outils de test en local, sans la stack docker :

Pour exécuter des scénarios qui utilisent les fonctionnalités de l'application Oro, exécutez le navigateur WebKit (à l'aide de ChromeDriver). Pour installer ChromeDriver, exécutez les commandes suivantes:

LINUX : 

```
 CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
 mkdir -p "$HOME/chrome" || true
 wget "http://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" -O "$HOME/chrome/chromedriver_linux64_${CHROME_DRIVER_VERSION}.zip"
 unzip "$HOME/chrome/chromedriver_linux64_${CHROME_DRIVER_VERSION}.zip" -d "$HOME/chrome"
 sudo ln -s "$HOME/chrome/chromedriver" /usr/local/bin/chromedriver
```

MAC  : 

`brew cask install chromedriver`

### Installation des outils de test avec la stack docker :
```
version: '2.2'

services:
  mailcatcher:
    image: schickling/mailcatcher:latest
    ports:
      - ${MAILCATCHER_PORT}:1080

  sql:
    image: postgres:9.6-alpine
    ports:
      - ${SQL_PORT}:5432
    environment:
      - POSTGRES_USER
      - POSTGRES_DB
      - POSTGRES_PASSWORD
      - POSTGRES_ROOT_PASSWORD
    volumes:
      - ./.docker/postgres@9.6/sql/uuid-ossp.sql:/docker-entrypoint-initdb.d/00-uuid-ossp.sql:ro
      - ./.docker/postgres@9.6/custom-sql/:/docker-entrypoint-initdb.d/custom-sql/
      - database:/var/lib/postgresql/data
    restart: on-failure

  http:
    image: nginx:alpine
    volumes:
      - ./.docker/nginx@1.15/config/options.conf:/etc/nginx/conf.d/000-options.conf
      - ./.docker/nginx@1.15/config/reverse-proxy.conf:/etc/nginx/conf.d/default.conf
      - ./:/var/www/html
      - cache:/var/www/html/var/cache:ro
      - assets:/var/www/html/public/bundles:ro
    restart: on-failure
    ports:
      - ${HTTP_PORT}:80
    depends_on:
      - http-worker-prod
      - http-worker-dev
      - http-worker-xdebug

  http-worker-prod:
    image: nginx:alpine
    volumes:
      - ./.docker/nginx@1.15/config/options.conf:/etc/nginx/conf.d/000-options.conf
      - ./.docker/nginx@1.15/config/vhost-prod.conf:/etc/nginx/conf.d/default.conf
      - ./:/var/www/html
      - cache:/var/www/html/var/cache:delegated
      - assets:/var/www/html/public/bundles:delegated
    restart: on-failure
    depends_on:
      - fpm

  http-worker-dev:
    image: nginx:alpine
    volumes:
      - ./.docker/nginx@1.15/config/options.conf:/etc/nginx/conf.d/000-options.conf
      - ./.docker/nginx@1.15/config/vhost-dev.conf:/etc/nginx/conf.d/default.conf
      - ./:/var/www/html
      - cache:/var/www/html/var/cache:ro
      - assets:/var/www/html/public/bundles:ro
    restart: on-failure
    depends_on:
      - fpm

  http-worker-xdebug:
    image: nginx:alpine
    volumes:
      - ./.docker/nginx@1.15/config/options.conf:/etc/nginx/conf.d/000-options.conf
      - ./.docker/nginx@1.15/config/vhost-xdebug.conf:/etc/nginx/conf.d/default.conf
      - ./:/var/www/html
      - cache:/var/www/html/var/cache:ro
      - assets:/var/www/html/public/bundles:ro
    restart: on-failure
    depends_on:
      - fpm-xdebug

  fpm:
    image: kiboko/php:7.2-fpm-blackfire-orocommerce-ee-3.1-postgresql
    user: docker:docker
    volumes:
      - ./:/var/www/html
      - cache:/var/www/html/var/cache
      - assets:/var/www/html/public/bundles
    environment:
      - "I_AM_DEVELOPER_DISABLE_INDEX_IP_CHECK="
      - BLACKFIRE_CLIENT_ID
      - BLACKFIRE_CLIENT_TOKEN
    restart: on-failure

  fpm-xdebug:
    image: kiboko/php:7.2-fpm-xdebug-orocommerce-ee-3.1-postgresql
    user: docker:docker
    volumes:
      - ./:/var/www/html
      - cache:/var/www/html/var/cache
      - assets:/var/www/html/public/bundles
    environment:
      - "I_AM_DEVELOPER_DISABLE_INDEX_IP_CHECK="
    restart: on-failure

  blackfire:
    image: blackfire/blackfire
    environment:
      - BLACKFIRE_SERVER_ID
      - BLACKFIRE_SERVER_TOKEN

  sh:
    build:
      context: .docker/sh@7.2/
    user: docker:docker
    volumes:
      - $HOME/.ssh:/opt/docker/.ssh:cached
      - ./:/var/www/html
      - cache:/var/www/html/var/cache
      - assets:/var/www/html/public/bundles
      - composer:/opt/docker/.composer/:cached
    environment:
      - COMPOSER_AUTH
      - COMPOSER_PROCESS_TIMEOUT
      - BLACKFIRE_CLIENT_ID
      - BLACKFIRE_CLIENT_TOKEN
      - HOME=/var/www/html
    command: [ "sleep", "31536000" ]
    restart: "always"

  sh-xdebug:
    image: kiboko/php:7.2-cli-xdebug-orocommerce-ee-3.1-postgresql
    user: docker:docker
    volumes:
      - $HOME/.ssh:/opt/docker/.ssh:cached
      - ./:/var/www/html
      - cache:/var/www/html/var/cache
      - assets:/var/www/html/public/bundles
      - composer:/opt/docker/.composer/
    environment:
      - COMPOSER_AUTH
      - COMPOSER_PROCESS_TIMEOUT
    command: [ "sleep", "31536000" ]
    restart: "always"

  mq:
    image: kiboko/php:7.2-cli-blackfire-orocommerce-ee-3.1-postgresql
    user: docker:docker
    volumes:
      - ./:/var/www/html
      - cache:/var/www/html/var/cache
      - assets:/var/www/html/public/bundles
    command: [ "bin/console", "oro:message-queue:consume", "--env=prod", "-vv" ]
    restart: "always"

  ws:
    image: kiboko/php:7.2-cli-blackfire-orocommerce-ee-3.1-postgresql
    user: docker:docker
    volumes:
      - ./:/var/www/html
      - cache:/var/www/html/var/cache
      - assets:/var/www/html/public/bundles
    command: [ "bin/console", "gos:websocket:server", "--env=prod", "-vv" ]
    ports:
      - ${WEBSOCKET_PORT}:8080
    restart: "always"

  elasticsearch:
    image: 'docker.elastic.co/elasticsearch/elasticsearch-oss:6.5.4'
    environment:
      - cluster.name=docker-cluster
      - bootstrap.memory_lock=true
      - "ES_JAVA_OPTS=-Xms512m -Xmx512m"
      - discovery.type=single-node
      - http.port=9200
      - http.cors.allow-origin=http://localhost:${DEJAVU_PORT},http://127.0.0.1:${DEJAVU_PORT},http://192.168.64.4:${DEJAVU_PORT},http://dejavu:${DEJAVU_PORT},http://host.docker.internal:${DEJAVU_PORT}
      - http.cors.enabled=true
      - http.cors.allow-headers=X-Requested-With,X-Auth-Token,Content-Type,Content-Length,Authorization
      - http.cors.allow-credentials=true
    ports:
      - ${ELASTICSEARCH_PORT}:9200
    volumes:
      - elasticsearch:/usr/share/elasticsearch/data
      - ./.docker/elasticsearch/elasticsearch.yml:/usr/share/elasticsearch/config/elasticsearch.yml
    restart: on-failure

  dejavu:
    image: appbaseio/dejavu
    ports:
      - ${DEJAVU_PORT}:1358

  amqp:
    build:
      context: .docker/rabbitmq@3.6
    ports:
      - ${RABBITMQ_AMQP_PORT}:5672
      - ${RABBITMQ_MANAGER_PORT}:15672
    environment:
      - RABBITMQ_DEFAULT_USER=${RABBITMQ_USER}
      - RABBITMQ_DEFAULT_PASS=${RABBITMQ_PASSWORD}
    restart: on-failure

  redis:
    build:
      context: .docker/redis@5/
    restart: on-failure
    ports:
      - ${REDIS_PORT}:6379

  chrome:
      image: selenium/node-chrome:3.141.59-oxygen
      volumes:
          - /dev/shm:/dev/shm
      depends_on:
          - hub
      environment:
          HUB_HOST: hub

  firefox:
      image: selenium/node-firefox:3.141.59-20200525
      volumes:
          - /dev/shm:/dev/shm
      depends_on:
          - hub
      environment:
          HUB_HOST: hub

  opera:
      image: selenium/node-opera:3.141.59-20200525
      volumes:
          - /dev/shm:/dev/shm
      depends_on:
          - hub
      environment:
          HUB_HOST: hub

  hub:
      image: selenium/hub:3.141.59-20200525
      ports:
          - ${HUB_PORT}::4444
volumes:
  database:
    driver: local
  elasticsearch:
    driver: local
  composer:
    driver: local
    driver_opts:
      type: tmpfs
      device: tmpfs
      o: "size=2048m,uid=1001,gid=1002"
  assets:
    driver: local
    driver_opts:
      type: tmpfs
      device: tmpfs
      o: "size=2048m,uid=1001,gid=1002"
  cache:
    driver: local
    driver_opts:
      type: tmpfs
      device: tmpfs
      o: "size=2048m,uid=1001,gid=1002"

```

### Lancement des outils de tests en local, sans docker

Conditions préalables

- Exécutez ChromeDriver:

`chromedriver --url-base=wd/hub --port=4444 > /tmp/driver.log 2>&1`

Pour exécuter ChromeDriver en arrière-plan, ajoutez le symbole esperluette (&) à la fin de la ligne, comme dans les exemples suivants:

`chromedriver --url-base=wd/hub --port=4444 > /tmp/driver.log 2>&1 &`

- Lancer un serveur sur le port spécifié pour l'installation (ici 8010 ), avec apache, nginx, ou juste le serveur symfony de base


### Execution des tests

Avant de commencer, il est fortement recommandé de vous familiariser avec les arguments et les options de Behat. Exécutez `bin/behat --help` pour une description détaillée.

Lorsque l'application Oro est installée sans données de démonstration et est en cours d'exécution, et que ChromeDriver 
est en cours d'exécution, vous pouvez commencer à exécuter les tests behat par fonctionnalité à partir de la racine de l'application.

Vous pouvez utiliser l'une des commandes suivantes.

Exécutez le scénario de test des fonctionnalités:

`bin/behat vendor/oro/platform/src/Oro/Bundle/UserBundle/Tests/Behat/Features/login.feature -vvv`

Aperçu de toutes les étapes de fonctionnalité disponibles:

`bin/behat -dl -s OroUserBundle`

Voir les étapes avec une description complète et des exemples:

`bin/behat -di -s OroUserBundle`


Chaque bundle a sa suite de tests dédiée qui peut être exécutée séparément:

`bin/behat -s OroUserBundle`