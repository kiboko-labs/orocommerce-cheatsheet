### Scénario : 

> Je veux, pour chaque ligne (ORM results) d'une datagrid, faire des trucs.

### Créer l'Event Listener

> Placez-vous dans votre bundle et créez ce fichier :

> Acme/Bundle/FooBundle/Listener/FooDatagridListener.php

```php
<?php

namespace Acme\Bundle\FooBundle\EventListener;

use Oro\Bundle\DataGridBundle\Datasource\ResultRecord;
use Oro\Bundle\DataGridBundle\Event\OrmResultAfter;
use Oro\Bundle\EntityBundle\ORM\DoctrineHelper;
use Acme\Bundle\FooBundle\Entity\Foo;

class FooDatagridListener
{
    /**
     * @param OrmResultAfter $event
     */
    public function onResultAfter(OrmResultAfter $event)
    {
        /** @var ResultRecord[] $records */
        $records = $event->getRecords();  // Nos résultats 

    }
}

```
> Créez le service 

```yml
services:
     acme_foo.event_listener.foo_datagrid:
         class: 'Acme\Bundle\FooBundle\EventListener\FooDatagridListener'
         tags:
             - { name: kernel.event_listener, event: oro_datagrid.orm_datasource.result.after.foo-grid, method: onResultAfter }
```

> foo-grid est le nom de la grid a écouter
  
> On pourrait imaginer que nous ayons besoin de récupérer tous les Ids pour les mettre dans un tableau
 
```php
 
   /**
      * @param OrmResultAfter $event
      */
     public function onResultAfter(OrmResultAfter $event)
     {
          $tableOfIds = [];
          /** @var ResultRecord[] $records */
          $records = $event->getRecords();
          foreach ($records as $record) {
              $tableOfIds[] = $record->getValue('id'); 
          }
 
     }

```