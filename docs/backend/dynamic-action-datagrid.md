### Scénario : 

> L'affichage ou non d'une action doit être générée a la volée suivant les données de la ligne

### Gérer dynamiquement des actions dans une datagrid

> Dans datagrid.yml 

```yml
properties:
    link_1:
        type: url
        route: route_1
        params: [id]
    link_2:
        type: url
        route: route_2
        params: [id]

actions:
    action_1:
        type:          navigate
        label:         edit
        link:          link_1
        icon:          edit
        rowAction:     true
    action_2:
        type:          navigate
        label:         edit
        link:          link_2
        icon:          edit
        rowAction:     true
action_configuration: ['@acme_test.datagrid.entity.action_permission_provider', 'getActionPermissions']
```

> On fait le service du provider :

```yml
    acme_test.datagrid.entity.action_permission_provider:
        class: Acme\Bundle\TestBundle\Datagrid\EntityActionPermissionProvider
```

> La classe qui va avec :

>  $record contient nos données pour chaque ligne de la datagrid

```php
<?php

namespace Acme\Bundle\TestBundle\Datagrid;

use Marello\Bundle\DataGridBundle\Action\ActionPermissionInterface;
use Oro\Bundle\DataGridBundle\Datasource\ResultRecordInterface;

class EntityActionPermissionProvider implements ActionPermissionInterface
{
    /**
     * {@inheritdoc}
     */
    public function getActionPermissions(ResultRecordInterface $record)
    {
       
        // Votre traitement qui va permettre de décider les actions qu'on affiche 
        // false => pas affiché 
        // true => affiché

        return [
            'action_1' => true,
            'action_2' => false
        ];
    }
}
```
