Nettoyage de la VM
========================

## Documentation

https://docs.docker.com/config/pruning/

## Processus

Pour libérer de l'espace sur VM, on peut lancer plusieurs commandes pour supprimer les images et les volumes qui sont non utilisés :

* `docker image prune`

* `docker volume prune`

* `docker network prune`


_Attention à ne pas supprimer tous ses containers_
