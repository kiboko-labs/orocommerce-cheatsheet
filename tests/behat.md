# Test Behat

## Concepts

Les informations ci-dessous résume les concepts et les outils qui sont importants pour la compréhension et l’utilisation
du framework de test inclus dans OroBehatExtension.

**Behavior-driven development (BDD)** est un processus de développement logiciel issu du développement axé sur les tests (TDD).
Le BDD combine les techniques générales et les principes de TDD avec des idées de conception axée sur le domaine et
l'analyse d'objet et du design pour fournir aux équipes de développement et de gestion de logiciels des outils partagés et 
un processus partagé de collaboration pour le développement de logiciels.

1. [Behat](https://docs.behat.org/en/v3.0/) est un framework de développement basé sur le comportement pour PHP.
Cet outil permet de décrire le comportement de l'application voulue en utilisant Php et [Gherking](https://docs.behat.org/en/latest/user_guide/gherkin.html)
Vous pouvez utiliser Behat pour décrire tout ce que vous pouvez décrire dans la logique métier.
Outils, applications GUI, applications Web, etc. La partie la plus intéressante est les applications Web.

2. [Mink](http://mink.behat.org/en/latest/) est une extension de Behat qui vas permettre de controller un navigateur durant les tests en utilisant PHP.
Il vas utiliser des emulateurs de navigateurs , l'avantage d'utiliser Mink c'est qu'il supprime les différences entres les 
différents emulateurs de navigateur et leurs drivers.

3. [OroElementFactory](https://github.com/oroinc/platform/blob/master/src/Oro/Bundle/TestFrameworkBundle/Behat/Element/OroElementFactory.php) est une classe qui permet de manipuler des éléments sur la page.

4. [Symfony2Extension](https://github.com/Behat/Symfony2Extension/blob/master/doc/index.rst) qui ajoute une intégration pour Symfony avec Behat.

5. [OroTestFrameworkExtension](https://github.com/oroinc/platform/blob/master/src/Oro/Bundle/TestFrameworkBundle/Behat/ServiceContainer/OroTestFrameworkExtension.php) vas permettre de charger différents outils pour la liaison Oro/Behat

6. [MinkSelenium2Driver](https://github.com/minkphp/MinkSelenium2Driver) vas faire le lien entre Mink vers Selenium en utilisant le protocole WebDriver

7. [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) est un outil pour automatiser les tests dans Goodle Chrome


## Conventions

Cette section résume les limitations et accords importants pour la maintenance et l'utilisation des tests partagés.

Utilisez le mapping de formulaire au lieu de sélecteurs dans vos scénarios pour les garder clairs et compréhensibles pour les personnes du monde technique et non technique.

### Example 

Ne pas:

```
I fill in "oro_workflow_definition_form[label]" with "User Workflow Test"
I fill in "oro_workflow_definition_form[related_entity]" with "User"
```

Mais plutot :

```
 And I fill "Workflow Edit Form" with:
   | Name                  | User Workflow Test |
   | Related Entity        | User               |
```

avec la description des éléments indépendament :

```
 Workflow Edit Form:
   selector: 'form[name="oro_workflow_definition_form"]'
   class: Oro\Bundle\TestFrameworkBundle\Behat\Element\Form
   options:
     mapping:
       Name: 'oro_workflow_definition_form[label]'
       Related Entity: 'oro_workflow_definition_form[related_entity]'
```

Utilisez des menu et des liens pour obtenir les bonnes pages au lieu de l'URL de la page directe

Faire :

```
And I open User Index page
```

Et non pas :

```
And I go to "/users"
```

Évitez la redondance des scénarios (par exemple, en répétant la même séquence d'étapes, comme la connexion, dans plusieurs scénarios).

Couvrez la fonctionnalité avec les scénarios séquentiels où chaque scénario suivant réutilise les résultats (les états et les données) préparés par leurs prédécesseurs. Cette méthode a été choisie en raison des avantages suivants:

- Exécution de scénario plus rapide grâce à la session utilisateur partagée et à la préparation intelligente des données. L'action de connexion dans le scénario initial ouvre la session qui est réutilisable par les scénarios suivants. Les scénarios préliminaires (par exemple, créer) préparent des données pour les scénarios suivants (par exemple, supprimer).
- L'isolation au niveau des fonctionnalités augmente la vitesse d'exécution, en particulier dans les environnements de test lents.
- Actions de développement de routine minimisées (par exemple, vous n'avez pas à charger les fixtures pour chaque scénario; au lieu de cela, vous réutilisez les résultats disponibles des scénarios précédents).
- Gestion aisée des états d'application difficiles à émuler uniquement avec des fixtures (par exemple, lors de l'ajout de nouveaux champs d'entité dans l'interface utilisateur).


En couplant les scénarios, la facilité de débogage et de localisation des bogues est réduite. Il est difficile de déboguer les fonctionnalités de l'interface utilisateur
et les scénarios qui se produisent après plusieurs scénarios préliminaires. Plus la ligne est longue, plus il est difficile d'isoler le problème.

- **Utiliser des fixtures yml sémantiques**

Utilisez uniquement les entités qui se trouvent dans le bundle que vous testez. Toutes les autres entités doivent être incluses via une importation. Voir les [Fixtures Alince](https://github.com/nelmio/alice) pour plus d'informations.

- **Nommer les éléments dans le style camelCase sans espaces**

Vous pouvez toujours vous y référer en utilisant le style camelCase avec des espaces dans les scénarios behat.
Par exemple, un élément nommé OroProductForm peut être mentionné dans l'étape du scénario comme «Oro Product From»:

- **Use Scenario: Feature Background instead of the Background step**

## Introduction

### Configuration

**Configuration de l'application** :

Utilisez la configuration par défaut de l'application installée en mode production. Si aucun serveur de messagerie n'est configuré localement, définissez le paramètre mailer_transport dans parameters.yml sur null.

**Configuration Behat**

La configuration de base se trouve dans behat.yml.dist. Chaque application possède son propre fichier behat.yml.dist à la racine du répertoire de l'application.
Créez votre behat.yml (il est ignoré par git automatiquement et n'est jamais validé dans le référentiel distant), importez la configuration de base et modifiez-la pour l'adapter à votre environnement:

```yaml
imports:
   - ./behat.yml.dist

 default: &default
     extensions: &default_extensions
         Behat\MinkExtension:
             browser_name: chrome
             base_url: "http://your-domain.local"
```

## Installation

### Installation des dépendances de développement :


Si vous avez installé des dépendances avec le paramètre --no-dev plus tôt, supprimez le fichier composer.lock de la racine du répertoire de l'application.


Installez les dépendances dev à l'aide de la commande suivante

`composer install`

### Etat de l'application initiale 

Dans Oro, l'état initial est celui lorsque l'application est installé sans données de démonstration.
Les scénarios qui testent des fonctionnalités doivent s'appuyer sur cet état et doivent créer toutes les données nécessaires à des vérifications supplémentaires.
Les données peuvent être créées par les étapes du scénario ou comme montages.



Installez l'application sans données de démonstration en mode production à l'aide de la commande suivante:

```
 bin/console oro:install  --drop-database --user-name=admin --user-email=admin@example.com  \
   --application-url=http://dev-crm.local --user-firstname=John --user-lastname=Doe \
   --user-password=admin  --organization-name=ORO --env=prod --sample-data=n --timeout=3000
```

### Install Test Automation Tools

Pour exécuter des scénarios qui utilisent les fonctionnalités de l'application Oro, exécutez le navigateur WebKit (à l'aide de ChromeDriver). Pour installer ChromeDriver, exécutez les commandes suivantes:

```
 CHROME_DRIVER_VERSION=$(curl -sS chromedriver.storage.googleapis.com/LATEST_RELEASE)
 mkdir -p "$HOME/chrome" || true
 wget "http://chromedriver.storage.googleapis.com/${CHROME_DRIVER_VERSION}/chromedriver_linux64.zip" -O "$HOME/chrome/chromedriver_linux64_${CHROME_DRIVER_VERSION}.zip"
 unzip "$HOME/chrome/chromedriver_linux64_${CHROME_DRIVER_VERSION}.zip" -d "$HOME/chrome"
 sudo ln -s "$HOME/chrome/chromedriver" /usr/local/bin/chromedriver
```

### Note :

Ces commandes créent un sous-répertoire pour Chrome dans votre répertoire personnel, télécharge ChromeDriver dans le répertoire créer,décompresse les fichiers et créér un lien symbolique.


Une fois l'exécution de la commande terminée, vous pouvez utiliser `chromedriver dans le terminal.`

### Exécution des tests

Conditions préalables

Exécutez ChromeDriver:

`chromedriver --url-base=wd/hub --port=4444 > /tmp/driver.log 2>&1`

Pour exécuter ChromeDriver en arrière-plan, ajoutez le symbole esperluette (&) à la fin de la ligne, comme dans les exemples suivants:

`chromedriver --url-base=wd/hub --port=4444 > /tmp/driver.log 2>&1 &`


Avant de commencer, il est fortement recommandé de vous familiariser avec les arguments et les options de Behat. Exécutez bin / behat --help pour une description détaillée.

Lorsque l'application Oro est installée sans données de démonstration et est en cours d'exécution, et que ChromeDriver est en cours d'exécution, vous pouvez commencer à exécuter les tests behat par fonctionnalité à partir de la racine de l'application.

Vous pouvez utiliser l'une des commandes suivantes.

Exécutez le scénario de test des fonctionnalités:

`bin/behat vendor/oro/platform/src/Oro/Bundle/UserBundle/Tests/Behat/Features/login.feature -vvv`

Aperçu de toutes les étapes de fonctionnalité disponibles:

`bin/behat -dl -s OroUserBundle`

Voir les étapes avec une description complète et des exemples:

`bin/behat -di -s OroUserBundle`


Chaque bundle a sa suite de tests dédiée qui peut être exécutée séparément:

`bin/behat -s OroUserBundle`

## Architecture

## Container

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


De plus, vous pouvez injecter des services d'application dans le contexte behat:

````yaml
 oro_behat_extension:
   suites:
     OroCustomerAccountBridgeBundle:
       contexts:
         - OroImportExportBundle::ImportExportContext:
             - '@oro_entity.entity_alias_resolver'
             - '@oro_importexport.processor.registry'
````
