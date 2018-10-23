### Scénario : 

> Je supprimer une entité proprement 

### Comment supprimer une entitté
php app/console cache:clear -e dev
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