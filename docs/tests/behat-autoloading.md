La classe [OroTestFrameworkExtension](https://github.com/oroinc/platform/blob/master/src/Oro/Bundle/TestFrameworkBundle/Behat/ServiceContainer/OroTestFrameworkExtension.php)
est responsable de la génération des suites de test.

Lors de l'initialisation, l'extension crée une suite de tests avec un nom de bundle si un répertoire Tests/Behat/Features
existe dans un bundle. Ainsi, si le bundle n'a pas de répertoire Features - aucune suite de tests ne sera créée ce bundle.

Si vous avez besoin de certaines étapes de fonctionnalité spécifiques pour votre bundle, créez la classe AcmeDemoBundle\Tests\Behat\Context\FeatureContext.
Ce contexte est ajouté à la suite avec les contextes courants.La liste complète du contexte commun est configurée dans le fichier de configuration behat sous la clé `shared_contexts`.

Vous pouvez configurer manuellement la suite de tests pour un bundle dans la configuration de l'application behat:

```yaml
 default: &default
   suites:
     AcmeDemoBundle:
       type: symfony_bundle
       bundle: AcmeDemoBundle
       contexts:
         - Oro\Bundle\TestFrameworkBundle\Tests\Behat\Context\OroMainContext
         - OroDataGridBundle::GridContext
         - AcmeDemoBundle::FeatureContext
       paths:
         - 'vendor/Acme/DemoBundle/Tests/Behat/Features'
```

ou dans une configuration de bundle behat {BundleName}/Tests/Behat/behat.yml :

````yaml
 oro_behat_extension:
   suites:
     AcmeDemoBundle:
       contexts:
         - Oro\Bundle\TestFrameworkBundle\Tests\Behat\Context\OroMainContext
         - OroDataGridBundle::GridContext
         - AcmeDemoBundle::FeatureContext
       paths:
         - '@AcmeDemoBundle/Tests/Behat/Features'
````

Les suites de test configurées manuellement ne sont pas chargées automatiquement par l'extension.