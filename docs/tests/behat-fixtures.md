### Feature Fixtures :

Chaque fois que behat exécute une nouvelle fonctionnalité, l'état de l'application est réinitialisé par défaut :
il n'y a qu'un seul utilisateur administrateur, une organisation, une unité commerciale et des rôles par défaut dans la base de données.

Les tests de fonctionnalités doivent s'appuyer sur les données disponibles dans l'application après l'exécution de la commande oro: install. Dans la plupart des cas, cela ne suffit pas.

Ainsi, vous avez deux façons d'obtenir plus de données dans le système: en utilisant des fixtures de base ou des fixtures alice.

### Fixtures basiques 

Vous pouvez créer un nombre quelconque d'entités dans les tests de fonctionnalités. `FixtureContext` devine la classe d'entité, crée le nombre nécessaire d'objets
et utilise [faker](https://github.com/fzaninotto/faker) pour remplir les champs requis lorsque leur valeur n'a pas été spécifiée explicitement.

Vous utilisez à la fois les références faker et les [ références d'entité](https://doc.oroinc.com/master/backend/automated-tests/behat/#behat-entity-references) dans les appareils en ligne.

````
 Given the following contacts:
   | First Name | Last Name | Email     |
   | Joan       | Anderson  | <email()> |
   | Craig      | Bishop    | <email()> |
   | Jean       | Castillo  | <email()> |
   | Willie     | Chavez    | <email()> |
   | Arthur     | Fisher    | <email()> |
   | Wanda      | Ford      | <email()> |
 And I have 5 Cases
 And there are 5 calls
 And there are two users with their own 7 Accounts
 And there are 3 users with their own 3 Tasks
 And there is user with its own Account
````

### Fixtures Alice


Parfois, vous avez besoin de nombreuses entités différentes avec des relations complexes. Dans de tels cas, vous pouvez utiliser des fixtures Alice.
 Alice est une bibliothèque qui vous permet de créer facilement des fixtures au format yml.

#### NOTE : 
Voir la [documentation d'Alice](https://github.com/nelmio/alice/blob/2.x/README.md) pour plus d'informations.

Les fixtures doivent être situés dans le répertoire {BundleName}/Tests/Behat/Features/Fixtures. Pour charger une fixture avant l'exécution des tests de fonctionnalité,
ajoutez une balise (annotation) qui est construite à l'aide de la convention suivante `@fixture-BundleName:fixture_file_name.yml`, par exemple:

````yaml
 @fixture-OroCRMBundle:mass_action.yml
 Feature: Mass Delete records
````

Il est également possible de charger des fixtures pour tout autre bundle disponible pour l'application.

Par exemple:

```yaml
 @fixture-OroUserBundle:user.yml
 @fixture-OroOrganizationBundle:BusinessUnit.yml
 Feature: Adding attributes for workflow transition
```

De plus, Alice vous permet [d'inclure des fichiers](https://github.com/nelmio/alice/blob/a060587f3c90edd92a65c6c0d163972f49bc4e21/doc/fixtures-refactoring.md#including-files) via l'extension, vous pouvez donc importer des fichiers à partir d'autres bundles:

```yaml
 include:
     - '@OroCustomerBundle/Tests/Behat/Features/Fixtures/CustomerUserAmandaRCole.yml'
```

**Vous devez toujours inclure les fixtures d'autres bundles avec des entités qui ont été déclarées dans ce bundle**

## Références d'entités


Vous pouvez utiliser des références aux entités dans les fixtures de base et [alice](https://github.com/nelmio/alice/blob/2.x/doc/relations-handling.md#handling-relations).

`{Bundle}\Tests\Behat\ReferenceRepositoryInitializer`  est utilisé pour créer des références pour des objets qui existent déjà dans la base de données.


- Il est interdit de modifier ou d'ajouter de nouvelles entités dans le  Initializer.
- Il doit implémenter `ReferenceRepositoryInitializerInterface` et ne doit pas avoir de dépendances.
- Pour afficher toutes les références, utilisez la commande `bin/behat --available-references`.

Les références les plus utilisées sont:

- `@admin `- Utilisateur Admin
- `@adminRole` - Administrator role
- `@organization` - Default organization
- `@business_unit` - Default business unit