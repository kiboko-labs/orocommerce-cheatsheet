### Scénario :

> J'ai cassé ma VM VirtualBox et je veux la recréer

## Supprimer/Créer une VM pour docker

### On supprime notre machine (default)

> Attention cela supprimera toutes vos images dockers ainsi que leurs contenus

```bash
docker-machine rm default
```

## On recréer la nouvelle

```bash
docker-machine create -d virtualbox --virtualbox-disk-size=20000 default

```

## On la lance

```bash
eval $(docker-machine env default)
```
