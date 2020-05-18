### Scénario : 

> Je supprimer une entité proprement 

### Comment supprimer une entitté

> Vider le cache
```bash
php app/console cache:clear -e dev
```

> Enlever les données liées à l'entité en base
```bash
app/console oro:entity-config:debug "Acme\Bundle\YourBundle\Entity\YourEntity" --attr="state" --scope="extend" --set --val="Deleted"
```
> Enlever les donnéee de l'entité propriétaire
```bash
app/console oro:entity-config:debug "Acme\Bundle\YourBundle\Entity\YourEntity" --scope ownership --remove
```
> Mettre à jour la config de l'entité
```bash
app/console oro:entity-config:update
```

> Mettre à jour la config de l'entité étendu
```bash
app/console oro:entity-extend:update-config
```
> Mettre à jour le schema 
```bash
app/console oro:entity-extend:update-schema
```


### Un bash qui fait tout ça :

```bash
echo -e "bin / app"
read SF
echo -e "Chemin relatif de l'entité à supprimer : "
echo -e "Ex: Acme\Bundle\YourBundle\Entity\YourEntity"
read CHEMIN
echo -e "php "$SF"/console cache:clear -e dev"
    $SF/console cache:clear -e dev
echo -e "oro:entity-config:debug "$CHEMIN" --attr='state' --scope='extend' --set --val='Deleted'"
    $SF/console oro:entity-config:debug $CHEMIN --attr="state" --scope="extend" --set --val="Deleted"
echo -e "oro:entity-config:debug "$CHEMIN" --scope ownership --remove"
    $SF/console oro:entity-config:debug $CHEMIN --scope ownership --remove
echo -e "oro:entity-config:update"
    $SF/console oro:entity-config:update
echo -e "oro:entity-extend:update-config"
    $SF/console oro:entity-extend:update-config
echo -e "oro:entity-extend:update-schema"
    $SF/console oro:entity-extend:update-schema
```
