### Scénario : 

> Je veux modifer la structure d'une datagrid à la volée

### Comment créer un EventListener pour modifier une DataGrid

> Placez-vous dans votre bundle et créez ce fichier :

> YourName/Bundle/YourBundle/Listener/OnGridBuildAfterListener.php

```php
<?php
  
namespace YourName\Bundle\YourBundle\Listener;
  
use Oro\Bundle\DataGridBundle\Event\BuildAfter;
  
class OnGridBuildAfterListener 
{
   public function onBuildAfter(BuildAfter $event)
   {
       $config = $event->getDatagrid()->getConfig();
   }
} 
```
> Créez le service pour que la classe soit reconnue

```yml
services:
   yourname_yourbundle.grid.after.listener:
       class: YourName\Bundle\TestBundle\Listener\OnGridBuildAfterListener
       tags:
           - { name: kernel.event_listener, event: oro_datagrid.datagrid.build.after.le-nom-de-votre-datagrid, method: onBuildAfter }
```


> L'objet $config contient toute la configuration de votre datagrid

> On accede aux propriétés grace a cette methode 

```php
$config->offsetGetByPath();
```

> Imaginons que notre datagrid contient une colonne avec le nom "name" et que nous voulons changer son label

```php

<?php

namespace YourName\Bundle\YourBundle\Listener;
   
use Oro\Bundle\DataGridBundle\Event\BuildAfter;
   
class OnGridBuildAfterListener
{
   public function onBuildAfter(BuildAfter $event)
   {
       $config = $event->getDatagrid()->getConfig();
          
       $newNameLabel = $config->offsetGetByPath("[columns][name]");
           
       $newNameLabel['label'] = 'Le nouveau label de la colonne name';
          
       $config->offsetAddToArrayByPath("[columns][name]", $newNameLabel);
            
       return; 
   }
}

```
> Maintenant le label de la colonne name est 'Le nouveau label de la colonne name'

> L'objet $config contient toute notre config, nous avons choisi de modifier une colonne, mais nous aurions pu modifier autre chose: Une action, un Filtre, etc..

  