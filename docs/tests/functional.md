# Tests fonctionnels

Les tests fonctionnels permettent de vérifier l’intégration des différentes couches d’une application.

Dans cet article, vous apprendrez comment vous pouvez améliorer l’expérience de la rédaction de tests fonctionnels avec
Oroplatform. Il est recommandé de lire la [Doc Symfony](https://symfony.com/doc/4.4/testing.html#functional-tests)
concernant les tests avant de continuer. Vous devriez également connaître [PhpUnit](https://phpunit.de/getting-started/phpunit-9.html)

## Quand rédiger les tests fonctionnels

Les tests fonctionnels sont généralement rédigés pour les :

Contrôleurs
Commandes
Dépôts
Autres services

L’objectif des tests fonctionnels n’est pas de tester des classes séparées (tests unitaires), mais de tester
l’intégration des différentes parties d’une application.

Ajouter des tests fonctionnels pour compléter les tests unitaires pour les raisons suivantes :

- Vous pouvez tester le système multi-composants et vous assurer qu’il fonctionne comme un tout.
- Vous pouvez éviter la simulation(mocking) de l’interface compliquée ou de la couche de manipulation de données
(comme les classes de doctrine pour construire une requête).
Les tests unitaires peuvent réussir même si les fonctionnalités ne fonctionnent pas correctement.

## Environnement de test
### Initialisation du client et avertissement quand aux chargement des fixtures

Pour améliorer la performance de l’exécution du test, l’initialisation d’un client n’est effectuée qu’une seule fois par
cas de test par défaut. Cela signifie que le noyau de l’application Symfony sera démarré une fois par cas de test.
Les fixtures sont également chargés une seule fois par cas de test par défaut. D’une part, initialiser et charger
des fixtures une fois par cas de test augmente la performance de l’exécution de test mais peut aussi causer des bugs
car  l’état des fixtures et du noyau (et par conséquent, le conteneur de service) sera partagé par défaut entre les
méthodes de test de cas de test séparés. Assurez-vous de réinitialiser cet état si nécessaire.

### Configuration d'un environnement de test

Vous devez configurer les paramètres suivants pour l’environnement de test :

1. Créer une base de données distincte pour les tests (p. ex., ajouter le suffixe « _test ») :

2. Configurez les paramètres hôte, port et authentification pour la base de données, le serveur de messagerie et le
 serveur de socket web dans le fichier parameters_test.yml :

Par exemple :

```yaml
# config/parameters_test.yml
parameters:
    database_host: 127.0.0.1
    database_port: null
    database_name: crm_test
    database_user: root
    database_password: null
    mailer_transport: smtp
    mailer_host: 127.0.0.1
    mailer_port: null
    mailer_encryption: null
    mailer_user: null
    mailer_password: null
    session_handler: null
    locale: en
    secret: ThisTokenIsNotSoSecretChangeIt
    installed: false
```
3. Installez l'application dans un environnement de test

```
bin/console oro:install \
 --env=test  \
 --organization-name=Oro \
 --user-name=admin \
 --user-email=admin@example.com \
 --user-firstname=John \
 --user-lastname=Doe \
 --user-password=admin \
 --sample-data=n \
 --application-url=http://localhost
```

Lors de l’installation, la structure de la base de données est configurée et les fixtures standard sont chargés.

4. Exécuter les tests en utilisant phpunit avec l’option –testsuite appropriée (unit ou functionnal).

ATTENTION
Actuellement, l’exécution de différents types de tests automatisés ensemble n’est pas prise en charge.
Il est donc fortement déconseillé d’exécuter des tests unitaires et des tests fonctionnels côte à côte en une seule exécution, car cela produit des erreurs.
Les tests unitaires créent des objets fictifs qui interfèrent ultérieurement avec l’exécution des tests fonctionnels 
et créent une ambiguïté inutile. Il est possible de désactiver les tests unitaires au démarrage du test à l’aide de l’option testsuite :

$ php bin/phpunit -c . / --testsuite=functional
$ php bin/phpunit -c . / --testsuite=unit

## Database Isolation
L'annotation @dbIsolationPerTest ajoute une transaction qui sera effectuée avant le début d’un test et qui est annulée lorsqu’un test se termine.

```php
// src/Oro/Bundle/FooBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

/**
 * @dbIsolationPerTest
 */
class FooBarTest extends WebTestCase
{
    // ...
}
```

## Chargement des data fixtures :

Utilisez la méthode loadFixtures() pour charger des données dans un test :

````php
// src/Oro/Bundle/FooBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class FooBarTest extends WebTestCase
{
    protected function setUp()
    {
        $this->initClient(); // must be called before!

        // loading fixtures will be executed once, use the second parameter
        // $force = true to force the loading
        $this->loadFixtures([
            'Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures\LoadFooData',
            '@OroFooBarBundle/Tests/Functional/DataFixtures/bar_data.yml',
        ]);
    }

    // ...
}
````

Un fixture doit être soit un nom de classe qui implémente Doctrine\Common\DataFixtures\FixtureInterface , soit un chemin vers le fichier nelmio/alice.

Un exemple de fixture :

```php
// src/Oro/Bundle/FooBarBundle/Tests/Functional/DataFixtures/LoadFooData.php
namespace Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures;

use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\Persistence\ObjectManager;
use Oro\Bundle\FooBarBundle\Entity\FooEntity;

class LoadFooData extends AbstractFixture
{
    public function load(ObjectManager $manager)
    {
        $entity = new FooEntity();
        $manager->persist($entity);
        $manager->flush();
    }
}
```

````yaml
    # src/Oro/Bundle/FooBarBundle/Tests/Functional/DataFixtures/bar_data.yml
    Oro\Bundle\FooBarBundle\Entity\BarEntity:
        bar:
            name: test
````

Vous pouvez également implémenter l’interfaceDoctrine\Common\DataFixtures\DependentFixtureInterface qui permet de charger des fixtures en fonction des autres fixtures déjà chargées :

````php
// src/Oro/Bundle/FooBarBundle/Tests/Functional/DataFixtures/LoadFooData.php
namespace Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures;

use Doctrine\Common\DataFixtures\DependentFixtureInterface;
use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\Persistence\ObjectManager;

class LoadFooData extends AbstractFixture implements DependentFixtureInterface
{
    public function load(ObjectManager $manager)
    {
        // load fixtures
    }

    public function getDependencies()
    {
        return ['Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures\LoadBarData'];
    }
}
````

De plus, vous pouvez utiliser des entités spécifiques aux références à partir de fixtures, par exemple :

```php
namespace Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures;

use Doctrine\Common\Persistence\ObjectManager;
use Doctrine\Common\DataFixtures\DependentFixtureInterface;
use Doctrine\Common\DataFixtures\AbstractFixture;

use Oro\Bundle\FooBarBundle\Entity\FooEntity;

class LoadFooData extends AbstractFixture implements DependentFixtureInterface
{
    public function load(ObjectManager $manager)
    {
        $entity = new FooEntity();
        $manager->persist($entity);
        $manager->flush();

        $this->addReference('my_entity', $entity);
    }

    public function getDependencies()
    {
        return ['Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures\LoadBarData'];
    }
}
```

Maintenant, vous pouvez référencer le fixture par le nom configuré dans votre test :

````php
// src/Oro/Bundle/FooBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class FooBarTest extends WebTestCase
{
    protected $entity;

    protected function setUp()
    {
        $this->initClient();
        $this->loadFixtures('Oro\Bundle\FooBarBundle\Tests\Functional\DataFixtures\LoadFooData');
        $this->entity = $this->getReference('my_entity');
    }

    // ...
}
````

### NOTES : 
1. Par défaut, le gestionnaire d’entités est effacé après le chargement de chaque fixture. Pour éviter le nettoyage une fixture peut implémenterOro\Bundle\TestFrameworkBundle\Test\DataFixtures\InitialFixtureInterface.
2. Parfois, vous avez besoin d’une référence à l’Organization, d'un User ou d'une BusinessUnit. Les fixtures suivants peuvent être utilisés pour les charger :
- Oro\Bundle\TestFrameworkBundle\Tests\Functional\DataFixtures\LoadOrganization
- Oro\Bundle\TestFrameworkBundle\Tests\Functional\DataFixtures\LoadUser
- Oro\Bundle\TestFrameworkBundle\Tests\Functional\DataFixtures\LoadBusinessUnit

## Ecrire des test fonctionnel :

Pour créer un test fonctionel :

1. Etendez la classe WebTestCase
2. Préparez une instance de la classe Client
3. Préparez vos fixtures ( Optionnel)
4. Préparez le container
5. Appelez les fonctionnalitées du test
6 Vérifiez le résultat

### Tests fonctionnel pour les controlleurs : 

Un test fonctionnel pour un contrôleur se compose de quelques étapes:

1. Faire une requete
2. Tester la réponse
3. Cliquez sur un lien ou soumettez un formulaire
4. Test the response
5. Nettoyer et répéter

### Exemples de prépraration du client :

L’initialisation simple fonctionne pour tester les commandes et les services lorsque l’authentification n’est pas nécessaire.

````php
// src/Oro/Bundle/FooBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class FooBarTest extends WebTestCase
{
    protected function setUp()
    {
        $this->initClient(); // initialization occurres only once per test class
        // now varialbe $this->client is available
    }
    // ...
}
````

Initialisation avec les options Appkernel personnalisées :

````php
// src/Oro/Bundle/FooBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class FooBarTest extends WebTestCase
{
    protected function setUp()
    {
        // first array is Kernel options
        $this->initClient(['debug' => false]);
    }
    // ...
}
````

Initialisation avec authentification :

```php
// src/Oro/Bundle/FooBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class FooBarTest extends WebTestCase
{
    protected function setUp()
    {
        // second array is service options
        // this example will create client with server options ['PHP_AUTH_USER' => 'admin@example.com', 'PHP_AUTH_PW' => 'admin']
        // make sure you loaded fixture with test user
        // bin/console doctrine:fixture:load --no-debug --append --no-interaction --env=test --fixtures src/Oro/src/Oro/Bundle/TestFrameworkBundle/Fixtures
        $this->initClient([], $this->generateBasicAuthHeader());

        // init client with custom username and password
        $this->initClient([], $this->generateBasicAuthHeader('custom_username', 'custom_password'));
    }
    // ...
}
```

## Types de tests fonctionnels

### Tester les controllers

```php
// src/OroCRM/Bundle/TaskBundle/Tests/Functional/Controller/TaskControllersTest.php
namespace Oro\Bundle\TaskBundle\Tests\Functional\Controller;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

/**
 * @outputBuffering enabled
 */
class TaskControllersTest extends WebTestCase
{
    protected function setUp()
    {
        $this->initClient([], $this->generateBasicAuthHeader());
    }

    public function testCreate()
    {
        $crawler = $this->client->request('GET', $this->getUrl('orocrm_task_create'));

        $form = $crawler->selectButton('Save and Close')->form();
        $form['orocrm_task[subject]'] = 'New task';
        $form['orocrm_task[description]'] = 'New description';
        $form['orocrm_task[dueDate]'] = '2014-03-04T20:00:00+0000';
        $form['orocrm_task[owner]'] = '1';
        $form['orocrm_task[reporter]'] = '1';

        $this->client->followRedirects(true);
        $crawler = $this->client->submit($form);
        $result = $this->client->getResponse();
        $this->assertHtmlResponseStatusCodeEquals($result, 200);
        $this->assertContains('Task saved', $crawler->html());
    }

    /**
     * @depends testCreate
     */
    public function testUpdate()
    {
        $response = $this->client->requestGrid(
            'tasks-grid',
            ['tasks-grid[_filter][reporterName][value]' => 'John Doe']
        );

        $result = $this->getJsonResponseContent($response, 200);
        $result = reset($result['data']);

        $crawler = $this->client->request(
            'GET',
            $this->getUrl('orocrm_task_update', ['id' => $result['id']])
        );

        $form = $crawler->selectButton('Save and Close')->form();
        $form['orocrm_task[subject]'] = 'Task updated';
        $form['orocrm_task[description]'] = 'Description updated';

        $this->client->followRedirects(true);
        $crawler = $this->client->submit($form);
        $result = $this->client->getResponse();

        $this->assertHtmlResponseStatusCodeEquals($result, 200);
        $this->assertContains('Task saved', $crawler->html());
    }

    /**
     * @depends testUpdate
     */
    public function testView()
    {
        $response = $this->client->requestGrid(
            'tasks-grid',
            ['tasks-grid[_filter][reporterName][value]' => 'John Doe']
        );

        $result = $this->getJsonResponseContent($response, 200);
        $result = reset($result['data']);

        $this->client->request(
            'GET',
            $this->getUrl('orocrm_task_view', ['id' => $result['id']])
        );
        $result = $this->client->getResponse();

        $this->assertHtmlResponseStatusCodeEquals($result, 200);
        $this->assertContains('Task updated - Tasks - Activities', $result->getContent());
    }

    /**
     * @depends testUpdate
     */
    public function testIndex()
    {
        $this->client->request('GET', $this->getUrl('orocrm_task_index'));
        $result = $this->client->getResponse();
        $this->assertHtmlResponseStatusCodeEquals($result, 200);
        $this->assertContains('Task updated', $result->getContent());
    }
}
```

### Tester les ACLs dans les controlleurs :

Dans cet exemple, un utilisateur sans autorisations suffisantes essaie d’accéder à une action du contrôleur. La méthode assertHtmlResponseStatusCodeEquals()
est utilisée pour s’assurer que l’accès à la ressource demandée est refusé à l’utilisateur :

````php
namespace Oro\Bundle\UserBundle\Tests\Functional;

use Oro\Bundle\UserBundle\Tests\Functional\DataFixtures\LoadUserData;
use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

/**
 * @outputBuffering enabled
 */
class UsersTest extends WebTestCase
{
    protected function setUp()
    {
        $this->initClient();
        $this->loadFixtures(['Oro\Bundle\UserBundle\Tests\Functional\API\DataFixtures\LoadUserData']);
    }

    public function testUsersIndex()
    {
        $this->client->request(
            'GET',
            $this->getUrl('oro_user_index'),
            [],
            [],
            $this->generateBasicAuthHeader(LoadUserData::USER_NAME, LoadUserData::USER_PASSWORD)
        );
        $result = $this->client->getResponse();
        $this->assertHtmlResponseStatusCodeEquals($result, 403);
    }

    public function testGetUsersAPI()
    {
        $this->client->request(
            'GET',
            $this->getUrl('oro_api_get_users'),
            ['limit' => 100],
            [],
            $this->generateWsseAuthHeader(LoadUserData::USER_NAME, LoadUserData::USER_API_KEY)
        );
        $result = $this->client->getResponse();
        $this->assertJsonResponseStatusCodeEquals($result, 403);
    }
}
````

Voici un exemple de fixture qui ajoute un utilisateur sans permission :

```php
/ src/Oro/Bundle/UserBundle/Tests/Functional/DataFixtures/LoadUserData.php
namespace Oro\Bundle\UserBundle\Tests\Functional\DataFixtures;

use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\Persistence\ObjectManager;

use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

use Oro\Bundle\UserBundle\Entity\Role;
use Oro\Bundle\UserBundle\Entity\UserApi;

class LoadUserData extends AbstractFixture implements ContainerAwareInterface
{
    const USER_NAME     = 'user_wo_permissions';
    const USER_API_KEY  = 'user_api_key';
    const USER_PASSWORD = 'user_password';

    private $container;

    public function setContainer(ContainerInterface $container = null)
    {
        $this->container = $container;
    }

    public function load(ObjectManager $manager)
    {
        /** @var \Oro\Bundle\UserBundle\Entity\UserManager $userManager */
        $userManager = $this->container->get('oro_user.manager');

        // Find role for user to able to authenticate in test.
        // You can use any available role that you want dependently on test logic.
        $role = $manager->getRepository(Role::class)
            ->findOneBy(['role' => 'IS_AUTHENTICATED_ANONYMOUSLY']);

        // Creating new user
        $user = $userManager->createUser();

        // Creating API entity for user, we will reference it in testGetUsersAPI method,
        // if you are not going to test API you can skip it
        $api = new UserApi();
        $api->setApiKey(self::USER_API_KEY)
            ->setUser($user);

        // Creating user
        $user
            ->setUsername(self::USER_NAME)
            ->setPlainPassword(self::USER_PASSWORD) // This value is referenced in testUsersIndex method
            ->setFirstName('Simple')
            ->setLastName('User')
            ->addRole($role)
            ->setEmail('test@example.com')
            ->setApi($api)
            ->setSalt('');

        // Handle password encoding
        $userManager->updatePassword($user);

        $manager->persist($user);
        $manager->flush();
    }
}
```

### Tester les commandes :

Lorsque Oroplatform est installé, vous pouvez tester les commandes en utilisant la méthode runCommand()
de la classe WebTestCase. Cette méthode exécute une commande avec des paramètres donnés et retourne sa sortie
sous forme de chaîne. Par exemple, voyez à quoi ressemble le test pour la classe UpdateSchemaDoctrineListener du SearchBundle :

````php
namespace Oro\Bundle\SearchBundle\Tests\Functional\EventListener;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class UpdateSchemaListenerTest extends WebTestCase
{
    protected function setUp()
    {
        $this->initClient();
    }

    /**
     * @dataProvider commandOptionsProvider
     */
    public function testCommand($commandName, array $params, $expectedContent)
    {
        $result = $this->runCommand($commandName, $params);
        $this->assertContains($expectedContent, $result);
    }

    public function commandOptionsProvider()
    {
        return [
            'otherCommand' => [
                'commandName'     => 'doctrine:mapping:info',
                'params'          => [],
                'expectedContent' => 'OK'
            ],
            'commandWithoutOption' => [
                'commandName'     => 'doctrine:schema:update',
                'params'          => [],
                'expectedContent' => 'Please run the operation by passing one - or both - of the following options:'
            ],
            'commandWithAnotherOption' => [
                'commandName'     => 'doctrine:schema:update',
                'params'          => ['--dump-sql' => true],
                'expectedContent' => 'ALTER TABLE'
            ],
            'commandWithForceOption' => [
                'commandName'     => 'doctrine:schema:update',
                'params'          => ['--force' => true],
                'expectedContent' => 'Schema update and create index completed'
            ]
        ];
    }
}
````

### VOIR AUSSI
Lisez les [Test des commandes](https://symfony.com/doc/master/components/console/introduction.html#testing-commands)
dans la documentation officielle pour plus d’informations sur la façon de tester les commandes dans une application Symfony.

### Tester les services ou les Repositories

Pour tester des services ou des dépôts, vous pouvez accéder au conteneur de service via la méthode getContainer() :


````php
// src/Oro/Bundle/FooBarBundle/Tests/Functional/FooBarTest.php
namespace Oro\Bundle\FooBarBundle\Tests\Functional;

use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class FooBarTest extends WebTestCase
{
    protected $repositoryOrService;

    protected function setUp()
    {
        $this->initClient();
        $this->loadFixtures(['Oro\Bundle\FooBarBundle\Tests\Functional\API\DataFixtures\LoadFooBarData']);
        $this->repositoryOrService = $this->getContainer()->get('repository_or_service_id');
    }

    public function testMethod($commandName, array $params, $expectedContent)
    {
        $expected = 'test';
        $this->assertEquals($expected, $this->repositoryOrService->callTestMethod());
    }
````

## Example de test fonctionnel :

Ceci est un exemple de la façon dont vous pouvez écrire un test d’intégration pour une classe qui utilise l’ORM de doctrine
sans moquer ses classes et en utilisant de vrais services de Doctrine :

```php
namespace Oro\Bundle\BatchBundle\Tests\Functional\ORM\QueryBuilder;

use Doctrine\ORM\Query\Expr\Join;
use Doctrine\ORM\QueryBuilder;
use Doctrine\ORM\EntityManager;
use Oro\Bundle\BatchBundle\ORM\QueryBuilder\CountQueryBuilderOptimizer;
use Oro\Bundle\TestFrameworkBundle\Test\WebTestCase;

class CountQueryBuilderOptimizerTest extends WebTestCase
{
    /**
     * @dataProvider getCountQueryBuilderDataProvider
     * @param QueryBuilder $queryBuilder
     * @param string $expectedDql
     */
    public function testGetCountQueryBuilder(QueryBuilder $queryBuilder, $expectedDql)
    {
        $optimizer = new CountQueryBuilderOptimizer();
        $countQb = $optimizer->getCountQueryBuilder($queryBuilder);
        $this->assertInstanceOf('Doctrine\ORM\QueryBuilder', $countQb);
        // Check for expected DQL
        $this->assertEquals($expectedDql, $countQb->getQuery()->getDQL());
        // Check that Optimized DQL can be converted to SQL
        $this->assertNotEmpty($countQb->getQuery()->getSQL());
    }

    /**
     * @return array
     */
    public function getCountQueryBuilderDataProvider()
    {
        self::initClient();
        $em = self::getContainer()->get('doctrine.orm.entity_manager');

        return [
            'simple' => [
                'queryBuilder' => self::createQueryBuilder($em)
                    ->from('OroUserBundle:User', 'u')
                    ->select(['u.id', 'u.username']),
                'expectedDQL' => 'SELECT u.id FROM OroUserBundle:User u'
            ],
            'group_test' => [
                'queryBuilder' => self::createQueryBuilder($em)
                    ->from('OroUserBundle:User', 'u')
                    ->select(['u.id', 'u.username as uName'])
                    ->groupBy('uName'),
                'expectedDQL' => 'SELECT u.id, u.username as uName FROM OroUserBundle:User u GROUP BY uName'
            ]
        );
    }

    /**
     * @param EntityManager $entityManager
     * @return QueryBuilder
     */
    public static function createQueryBuilder(EntityManager $entityManager)
    {
        return new QueryBuilder($entityManager);
    }
}
```

### Attention 

Si votre classe est responsable de la récupération des données, il est préférable de charger les fixtures et de les récupérer
en utilisant une classe de test, puis d’affirmer que les résultats sont valides. Vérifier le DQL suffit dans ce cas car c’est la seule responsabilité de cette classe de modifier la requête.