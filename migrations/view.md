# View

## Ordering the fields on the different views (full, create, update)

By default, the order the fields are displayed on the views is
determined by the system, and can change each time the cache is cleared.
To avoid that and force the ordering of the fields, you need to set the `oro_options` as follows:

```php
public function up(Schema $schema, QueryBag $queries)
{
    $table = $schema->getTable(self::TABLE_NAME);
    $table->addColumn('address', 'string', [
        'oro_options' => [
            'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
            'view' => ['priority' => 199],
        ],
    ]);
    $table->addColumn('address_details', 'string', [
        'oro_options' => [
            'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
            'view' => ['priority' => 198],
        ],
    ]);
    $table->addColumn('postal_code', 'string', [
        'length' => 5,
        'oro_options' => [
            'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
            'view' => ['priority' => 197],
        ],
    ]);
    $table->addColumn('town', 'string', [
        'length' => 100,
        'oro_options' => [
            'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
            'view' => ['priority' => 196],
        ],
    ]);
}
```
The value of `'owner' => ExtendScope::OWNER_CUSTOM` tells the system to handle almost everything, so that you do not have to write a new form type for instance.
The option `'view' => ['priority' => 199]` allows developers to force the ordering of the fields in the view. The higher the value, the higher in the view.
