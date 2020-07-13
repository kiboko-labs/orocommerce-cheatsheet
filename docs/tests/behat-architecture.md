Behat est une application console Symfony avec son propre conteneur et ses propres services.
Un conteneur Behat peut être configuré via des extensions en utilisant behat.yml à la racine du répertoire d'application.
Le conteneur d'application peut être utilisé par le noyau injecté dans votre contexte après avoir implémenté KernelAwareContext et utilisé le trait KernelDictionary.

```php
 use Behat\Symfony2Extension\Context\KernelAwareContext;
 use Behat\Symfony2Extension\Context\KernelDictionary;
 use Oro\Bundle\TestFrameworkBundle\Behat\Context\OroFeatureContext;

 class FeatureContext extends OroFeatureContext implements KernelAwareContext
 {
     use KernelDictionary;

     public function useContainer()
     {
         $doctrine = $this->getContainer()->get('doctrine');
     }
 }
```


De plus, vous pouvez injecter des services dans le contexte behat:

````yaml
 oro_behat_extension:
   suites:
     OroCustomerAccountBridgeBundle:
       contexts:
         - OroImportExportBundle::ImportExportContext:
             - '@oro_entity.entity_alias_resolver'
             - '@oro_importexport.processor.registry'
````