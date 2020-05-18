How to handle Migrations
========================

Schema manipulation
-------------------

### Schema installer

Declare a migration class in your bundle (eg. `FooBundle/Migrations/Schema/`)

This class must implement `Oro\Bundle\MigrationBundle\Migration\Installation`

### Schema updater

Declare a migration class in your bundle (eg. `FooBundle/Migrations/Schema/v1_6`), where `v1_6` is your version number

This class must implement `Oro\Bundle\MigrationBundle\Migration\Migration`
 
Data fixtures manipulation
--------------------------
 
### Data fixtures installer 

Declare a migration class in your bundle (eg. `FooBundle/Migrations/Data/ORM/`)

This class must extend `Doctrine\Common\DataFixtures\AbstractFixture` and implement `Oro\Bundle\MigrationBundle\Fixture\VersionedFixtureInterface`

### Data fixtures updater

Declare a migration class in your bundle (eg. `FooBundle/Migrations/Data/ORM/v1_6/`), where `v1_6` is your version number

This class must extend `Doctrine\Common\DataFixtures\AbstractFixture`

Going further
-------------

[How-To: create an Enum](enum.md)
