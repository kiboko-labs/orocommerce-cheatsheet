### Ecrire une feature

Chaque bundle doit contenir ses propres tests behat pour les fonctionnalités du répertoire `{BundleName}/Tests/Behat/Features/`.
Chaque fonctionnalité est un fichier distinct avec l'extension `.feature` et une syntaxe spécifique.

#### Note : 

Voir la doc de [Cucumber](https://cucumber.io/docs/) pour plus d'infos.

Une fonctionnalité commence par ce qui suit:

- Le mot clé `Feature`: et le nom de la fonctionnalité (ceux-ci doivent rester sur la même ligne),
- Une description facultative (peut être formatée sur plusieurs lignes). Une description significative est fortement recommandée.

Vient ensuite le scénario de fonctionnalité - un exemple spécifique qui illustre une règle métier et se compose d'étapes séquentielles.
En plus d'être une spécification de test et une documentation de test, un scénario définit les étapes de test et sert de spécification exécutable du système.

Normalement, une étape commence par **Given**, **When** ou **Then**.

S'il existe plusieurs étapes Given ou When les unes sous les autres, vous pouvez utiliser **And** ou **But** pour les organiser en groupes logiques.
Cucumber ne fait pas de différence entre les mots clés, mais le choix du bon est important pour la lisibilité du scénario dans son ensemble.


Jetez un œil à la feature login `login.feature` dans [OroUserBundle](https://github.com/oroinc/platform/blob/50047c1d8abc5f811d0db759b501b8d27b0bff65/src/Oro/Bundle/UserBundle/Tests/Behat/Features/login.feature)

````
Feature: User login
   In order to login in application
   As an OroCRM admin
   I need to be able to authenticate

 Scenario: Success login
   Given I am on "/user/login"
   When I fill "Login Form" with:
       | Username | admin |
       | Password | admin |
   And I press "Log in"
   Then I should be on "/"

 Scenario Outline: Fail login
   Given I am on "/user/login"
   When I fill "Login Form" with:
       | Username | <login>    |
       | Password | <password> |
   And I press "Log in"
   Then I should be on "/user/login"
   And I should see "Invalid user name or password."

   Examples:
   | login | password |
   | user  | pass     |
   | user2 | pass2    |
````

1. La ligne `Feature: User login` démarre la fonctionnalité et lui donne un titre.
2. Behat n'analyse pas les trois lignes de texte suivantes: In order to... As an... I need to...
Ces lignes fournissent un contexte lisible par l'homme aux personnes qui réviseront ou modifieront cette fonctionnalité. Ils décrivent la valeur commerciale dérivée de l'inclusion de la fonctionnalité dans le logiciel.
3. La ligne `Scenario: Success login` démarre le scénario et fournit une description.
4. Les six lignes suivantes représentent les étapes du scénario. Chaque étape correspond à une expression régulière définie dans le contexte.
5. La ligne `Scenario Outline: Fail login` démarre le scénario suivant. Dans le plan du scénario, les placeholders sont utilisés à la place des valeurs réelles
et les valeurs pour l'exécution du scénario sont fournies sous la forme d'un ensemble d'exemples sous le plan.
Le scénario vous aide à exécuter ces étapes plusieurs fois, en parcourant les valeurs fournies dans la section `Exemples:` et en testant ainsi le même flux avec des entrées différentes.
Le plan du scénario est un modèle qui n'est jamais exécuté seul.
Au lieu de cela, un scénario qui suit un plan s'exécute une fois pour chaque ligne dans la section `Exemples:` en dessous (à l'exception de la première ligne d'en-tête qui est ignorée).
Considérez un espace réservé comme une variable. Il est remplacé par une valeur réelle depuis `Exemples:`, où le texte entre les crochets d'angle de l'espace réservé (par exemple, <login>) correspond au texte de l'en-tête de la colonne du tableau (par exemple, login).

