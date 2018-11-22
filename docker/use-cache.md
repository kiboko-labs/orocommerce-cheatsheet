# Scénario : 

> Ma stack docker rame parce que je suis sur MacOS 

# Pourquoi?

> Contrairement à Linux, sur Mac et Windows, Docker va lancer une machine virtuelle et installer tout ce qui l'a besoin dessus.
> C'est le transfert entre la VM et l'host qui rend Docker si lent sur les OS autres que Linux.
> Pour pallier à ça on peut utiliser un système de cache qui s'avère très rentable

# Les trois type de cache : 

- delegated : Docker > Local , plus rapide en écriture

- cached : Local > Docker , plus rapide en lecture 

- consistent : Local = Docker, valeur par défault

> Comment le mettre en place :

### Exemple du delegated : 
```yml
  cli:
    build:
      context: .docker/php@7.1/cli
    user: docker:docker
    volumes:
      - ./.docker/php@7.1/cli/config/memory.ini:/usr/local/etc/php/conf.d/memory.ini:ro
      - ./:/var/www/html
```
> On va rajouter cette ligne dans nos volumes : 
```yml
  cli:
    build:
      context: .docker/php@7.1/cli
    user: docker:docker
    volumes:
      - ./.docker/php@7.1/cli/config/memory.ini:/usr/local/etc/php/conf.d/memory.ini:ro
      - ./:/var/www/html
      - ./:/var/www/html:delegated
```
###  Exemple du cached : 
```yml
  http:
    image: nginx:alpine
    volumes:
      - ./:/var/www/html
    restart: on-failure
    ports:
      - 8963:80
```
> Meme logique, on rajoute une ligne :
```yml
  http:
    image: nginx:alpine
    volumes:
      - ./:/var/www/html
      - ./:/var/www/html:cached
    restart: on-failure
    ports:
      - 8963:80
```


