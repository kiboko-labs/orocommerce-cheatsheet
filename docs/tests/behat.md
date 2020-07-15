# Concepts

Les informations ci-dessous résume les concepts et les outils qui sont importants pour la compréhension et l’utilisation
du framework de test inclus dans OroBehatExtension.

**Behavior-driven development (BDD)** est un processus de développement logiciel issu du développement axé sur les tests (TDD).
Le BDD combine les techniques générales et les principes de TDD avec des idées de conception axée sur le domaine et
l'analyse d'objet et du design pour fournir aux équipes de développement et de gestion de logiciels des outils partagés et 
un processus partagé de collaboration pour le développement de logiciels.

1. [Behat](https://docs.behat.org/en/v3.0/) est un framework de développement basé sur le comportement pour PHP.
Cet outil permet de décrire le comportement de l'application voulue en utilisant Php et [Gherking](https://docs.behat.org/en/latest/user_guide/gherkin.html)
Vous pouvez utiliser Behat pour décrire tout ce que vous pouvez décrire dans la logique métier.
Outils, applications GUI, applications Web, etc.

2. [Mink](http://mink.behat.org/en/latest/) est une extension de Behat qui vas permettre de controller un navigateur durant les tests en utilisant PHP.
Il vas utiliser des emulateurs de navigateurs , l'avantage d'utiliser Mink c'est qu'il supprime les différences entres les 
différents emulateurs de navigateur et leurs drivers.

3. [WebDriver](https://www.w3.org/TR/webdriver/) est un protocole qui permet de controller des navigateurs en JSON.

4. [MinkSelenium2Driver](https://github.com/minkphp/MinkSelenium2Driver) vas faire le lien entre Mink vers Selenium en utilisant le protocole WebDriver, c'est un driver universel.

5. [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/) est un driver comme Selenium2Driver mais ne fonctionne que pour chrome et a la particularité de fonctionner sans Selenium ce qui rend les tests plus rapides sur chrome.

6. [Selenium](https://www.selenium.dev/) est un framework de test informatique développé en Java qui est composé de 3 grandes briques :
    - Selenium WebDriver : Framework de test fonctionnel permettant l’écriture de scripts de test automatisés en differents language.Il met a disposition une API pour controller tout les navigateurs.
    - Selenium IDE : qui permet de créer des script , sous forme d'extension chrome our firefox, pour controller des navigateurs.
    - Selenium Grid : Qui se compose d'un hub et de nodes, permet de lancer des test sur plusieurs navigateurs en même temps.

7. [Symfony2Extension](https://github.com/Behat/Symfony2Extension/blob/master/doc/index.rst) qui ajoute une intégration pour Symfony avec Behat.

8. [OroTestFrameworkExtension](https://github.com/oroinc/platform/blob/master/src/Oro/Bundle/TestFrameworkBundle/Behat/ServiceContainer/OroTestFrameworkExtension.php) est une extension de behat pour intégrer Oro, il ajoute des features tel que :
    - l'autoloading des contextes, permet de construire des suites de tests spécifiques.
    - la possibilité de déclarer des 'Elements' facilement dans le fichier de config behat.yml
    - Mapper facilement des champs de formulaires
    
9. [OroElementFactory](https://github.com/oroinc/platform/blob/master/src/Oro/Bundle/TestFrameworkBundle/Behat/Element/OroElementFactory.php) est une classe qui permet de manipuler des éléments sur la page: 
    -  ``hasElement($name)``
    - ``createElement($name, NodeElement $context = null)``
    - ``guessElement($name)``
    - ``findElementContains($name, $text, Element $context = null)``
    - ``findElementContainsByCss($name, $text, Element $context = null)``
    - ``findElementContainsByXPath($name, $text, $useChildren = true, Element $context = null)``
    - ``findAllElements($name, NodeElement $context = null)``
    - ``getPage()``
    - ``findElement($name, $selectorCallback, Element $context = null)``
    - et d'autre fonctions ....

10. Le **contexte** : Chaque phrase en Gherkin est associée à une méthode PHP grâce aux classes de contexte.La phrase est située dans une
annotation au-dessus de la fonction à appeler. L’annotation peut contenir une expression rationnelle ou une phrase avec
des placeholders commençant par deux points. Chaque parenthèse de capture de l’expression rationnelle ou placeholder
sera un argument de la méthode PHP appelée pour exécuter la phrase du test.

# Architecture :

![](images/Behat.png)

# Conventions :

[Conventions](behat-conventions.md)

# Configuration

[Configuration](behat-configuration.md)

# Injection de dépendances

[Architecture](behat-symfony.md)

# Autoload Suites

[Autoloading](behat-autoloading.md)

# Feature Isolation

[Isolation](behat-isolation.md)

# Elements et formulaires

[Elements et formulaire](behat-elements-form.md)

# Fixtures :

[Fixtures](behat-fixtures.md)

# Ecriture des tests

[Exemples d'un test behat](behat-exemples.md)

# Autres :

[Tips,tricks,bugfix](behat-tips.md)

# Docs relatives

 - [Behat](https://docs.behat.org/en/latest/guides.html)
 - [Gherkin](https://cucumber.io/docs/gherkin/)
 - [Mink](http://mink.behat.org/en/latest/)
 - [WebDriver](https://www.w3.org/TR/webdriver/)
 - [MinkSelenium2Driver](https://github.com/minkphp/MinkSelenium2Driver)
 - [ChromeDriver](https://sites.google.com/a/chromium.org/chromedriver/)
 - [Selenium](https://www.selenium.dev/)
 - [Symfony2Extension](https://github.com/Behat/Symfony2Extension/blob/master/doc/index.rst)
