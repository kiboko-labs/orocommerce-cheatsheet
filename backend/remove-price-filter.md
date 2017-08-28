Remove Price filter and sorter
======================

Description
-----------

To remove Price filter and sorter in `frontend_product_search_datagrid` it is necessary to create a listener to edit the datagrid 
Just make sure it will be loaded after the original listener.

Services
--------

```yml
# src/Kiboko/Bundle/FooBundle/Resources/config/services.yml

services:
  kiboko_foo.event_listener.frontend.product_price_datagrid:
    class: Kiboko\Bundle\CorporateProductBundle\EventListener\FrontendProductRemovePriceDatagridListener
    tags:
      - { name: kernel.event_listener, event: oro_datagrid.datagrid.build.before.frontend-product-search-grid, method: onBuildBefore }
```


Datagrid listener
-----------------


```php
<?php
# src/Kiboko/Bundle/FooBundle/EventListener/FrontendProductRemovePriceDatagridListener.php

namespace Kiboko\Bundle\FooBundle\EventListener;

use Oro\Bundle\DataGridBundle\Event\BuildBefore;
use Oro\Bundle\PricingBundle\EventListener\FrontendProductPriceDatagridListener;

class FrontendProductRemovePriceDatagridListener
{
    /**
     * {@inheritDoc}
     */
    public function onBuildBefore(BuildBefore $event)
    {
        $config = $event->getConfig();

        $config->removeSorter(FrontendProductPriceDatagridListener::COLUMN_MINIMAL_PRICE_SORT);

        $config->removeFilter(FrontendProductPriceDatagridListener::COLUMN_MINIMAL_PRICE);
    }
}
```

[Check other methods to customize DataGrid](https://github.com/oroinc/platform/tree/master/src/Oro/Bundle/DataGridBundle)
 