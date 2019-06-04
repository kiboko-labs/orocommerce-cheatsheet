# Manipuler des dumps avec docker

On a un dump sql que l'on veut monter sur notre container sql

Imaginons que nous avons notre dump.sql sur notre host.


On peut copier un fichier du local au container :

```bash
docker cp dump.sql mycontainer:/tmp/dump.sql
```
Le fichier dump.sql est maintenant sur le container, dans le dossier /tmp/

L'inverse est possible aussi (copier du container au host:

```bash
docker cp mycontainer:/foo.txt /chemin/foo.txt
```

On lance le batch un bash du container mysql

```bash
docker exec -ti le-container_mysql bash
``````

On lance la commande avec l'option -v ( pour voir le dump avec du "verbose" ):

`mysql` :
```bash
mysql -v —batch -h{host} -u{user} -p nom-de-la-base-de-donnée < /tmp/bdd.sql
``````

`postgresql` :
```bash
 psql -v -hlocalhost -Usevea -W -dsevea_oro_stag < /tmp/latest.sql
 ``````

Short one :)

## Backup

```bash
docker exec CONTAINER /usr/bin/mysqldump -u root --password=root DATABASE > backup.sql
```

## Restore
```bash
cat backup.sql | docker exec -i CONTAINER /usr/bin/mysql -u root --password=root DATABASE
```


