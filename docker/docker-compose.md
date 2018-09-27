### Scénario :

> Je veux mettre en place une base de données MySql ou Postgres avec Docker.

### Comment créer un docker-compose.yml pour Postgres ou MySql

> Mettez vous à la racine de votre projet et créez un nouveau fichier docker-compose.yml

#### Pour Postgres

> Copier-coller ce contenu :

```yml
  version: "2.0"
  services:
    postgres:
      image: postgres:9.6-alpine
      container_name: postgres
      environment:
        POSTGRES_PASSWORD: postgres
        POSTGRES_USER: postgres
        POSTGRES_DB: postgres
      ports:
        - "1111:5432"
```

> Le port de gauche est celui avec lequel votre application se connectera, vous pouver donc le changer. L'autre et celui qu'utilise docker en interne, donc ne le changez pas.

#### pour MySql

```yml
version: "2.0"
services:
    mysql:
        image: mysql:5.7
        container_name: mysql
        environment:
          MYSQL_ROOT_PASSWORD: mysql
          MYSQL_USER: mysql
          MYSQL_PASSWORD: mysql
          MYSQL_DATABASE: mysql
        ports:
          - '1111:3306'
```

> Le port de gauche est celui avec lequel votre application Oro/Symfony se connectera, vous pouver donc le changer. L'autre et celui qu'utilise docker en interne, donc ne le changez pas.

> Attention : Pour fonctionner, MySql a besoin par défault d'un mot de passe pour l'utilisateur Root, d'où le paramètre MYSQL_ROOT_PASSWORD.

#### Si vous utilisez Kitematic et que vous voulez voir vos images sur l'interface : 

```console
docker-machine ssh
sudo sysctl -w vm.max_map_count=262144
exit
eval $( docker-machine env ) && docker-compose up
```

#### Si vous ne voulez que voir vos images dans phpStorm : 

```console
cd laracinedevotreprojet
docker-compose up
```

###  Quelques commandes utiles

> Voir vos images

```bash
docker images
```

> Setter vos variables d'environment 

```bash
eval $(docker-machine env default) 
```

> Voir si elles sont bien settées

```bash
env | grep DOCKER
```

> Les "désseter"

```bash
 unset DOCKER_TLS_VERIFY
 unset DOCKER_CERT_PATH
 unset DOCKER_MACHINE_NAME
 unset DOCKER_HOST
 ```
 
> Ou

```bash
 unset ${!DOCKER_*}
```