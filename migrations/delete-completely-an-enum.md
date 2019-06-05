```php
<?php

namespace Test\Bundle\ProductBundle\Migrations\Schema\v1_1;

use Doctrine\DBAL\Schema\ForeignKeyConstraint;
use Doctrine\DBAL\Schema\Index;
use Doctrine\DBAL\Schema\Schema;
use Doctrine\DBAL\Schema\Table;
use Marello\Bundle\ProductBundle\Entity\Product;
use Marello\Bundle\SalesBundle\Entity\SalesChannel;
use Oro\Bundle\EntityConfigBundle\Migration as ConfigMigration;
use Oro\Bundle\EntityExtendBundle\Migration\Extension\ExtendExtensionAwareInterface;
use Oro\Bundle\MigrationBundle\Migration\Migration;
use Oro\Bundle\MigrationBundle\Migration\QueryBag;
use Oro\Bundle\EntityExtendBundle\Migration\Extension\ExtendExtension;
use Test\Bundle\OrderBundle\Migration\Extensions\EntityMetadataExtension;
use Test\Bundle\OrderBundle\Migration\Extensions\EntityMetadataExtensionAwareInterface;
use Test\Bundle\SalesBundle\Entity\CosmeticChannelConstraint;

class RemoveEnumMigrations implements
    Migration,
    ExtendExtensionAwareInterface,
    EntityMetadataExtensionAwareInterface
{
    /** @var ExtendExtension */
    protected $extendExtension;

    /** @var EntityMetadataExtension */
    protected $entityMetadataExtension;

    /**
     * Sets the ExtendExtension
     *
     * @param ExtendExtension $extendExtension
     */
    public function setExtendExtension(ExtendExtension $extendExtension)
    {
        $this->extendExtension = $extendExtension;
    }

    /**
     * Sets the EntityMetadataExtension
     *
     * @param EntityMetadataExtension $entityMetadataExtension
     */
    public function setEntityMetadataExtension(EntityMetadataExtension $entityMetadataExtension)
    {
        $this->entityMetadataExtension = $entityMetadataExtension;
    }

       /**
     * {@inheritdoc}
     */
    public function up(Schema $schema, QueryBag $queries)
    {
        $this->removeConfiguration($queries);
        $this->cleanMarelloProductTable($schema);
        $this->removeFakeEnumTable($schema);
    }

    /**
     * @param Schema $schema
     * @throws \Doctrine\DBAL\Schema\SchemaException
     */
    public function cleanMarelloProductTable(Schema $schema)
    {
        $table = $schema->getTable('marello_product_product');
        if ($table->hasColumn('fake_attribute_id')) {
            foreach ($this->getForeignKeys($table, ['fake_attribute_id']) as $foreignKey) {
                $table->removeForeignKey($foreignKey->getName());
            }
            foreach ($this->getColumnIndexes($table, ['fake_attribute_id']) as $index) {
                $table->dropIndex($index->getName());
            }
            $table->dropColumn('fake_attribute_id');
        }
    }

    /**
     * @param Schema $schema
     */
    public function removeFakeEnumTable(Schema $schema)
    {
        if (!$schema->hasTable('oro_enum_marello_product_fake')) {
            return;
        }
        $schema->dropTable('oro_enum_marello_product_fake');
    }

    /**
     * @param QueryBag $queries
     */
    public function removeConfiguration(QueryBag $queries)
    {
        $queries->addQuery(
            new ConfigMigration\RemoveEnumFieldQuery(
                Product::class,
                'fake'
            )
        );
    }

    /**
     * @param Table $table
     * @param array $columnNames
     * @return Index[]
     */
    private function getColumnIndexes(Table $table, array $columnNames)
    {
        return array_filter($table->getIndexes(), function (Index $index) use ($columnNames) {
            return count(array_diff($columnNames, $index->getColumns())) === 0
                && count(array_diff($index->getColumns(), $columnNames)) === 0;
        });
    }

    /**
     * @param Table $table
     * @param array $columnNames
     * @return ForeignKeyConstraint[]
     */
    private function getForeignKeys(Table $table, array $columnNames)
    {
        return array_filter($table->getForeignKeys(), function (ForeignKeyConstraint $foreignKey) use ($columnNames) {
            return count(array_diff($columnNames, $foreignKey->getColumns())) === 0
                && count(array_diff($foreignKey->getColumns(), $columnNames)) === 0;
        });
    }
}
```
