# Configuring the platform via migrations

The `oro:migration:data:load` command may also be used to set up a default configuration for the platform.

This configuration can be changed programatically thanks to the `Oro\Bundle\ConfigBundle\Config\ConfigManager`. Here's an example of implementation:
```php
// AppBundle/Migrations/Data/ORM/Configuration.php

<?php


namespace Kiboko\Bundle\AppBundle\Migrations\Data\ORM;


use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\Persistence\ObjectManager;
use Oro\Bundle\ConfigBundle\Config\ConfigManager;
use Oro\Bundle\MigrationBundle\Fixture\VersionedFixtureInterface;
use Symfony\Component\DependencyInjection\ContainerAwareInterface;
use Symfony\Component\DependencyInjection\ContainerInterface;

abstract class Configuration extends AbstractFixture implements ContainerAwareInterface, VersionedFixtureInterface
{
    /** @var ConfigManager */
    protected $configManager;

    abstract protected function configure();

    /**
     * Sets the container.
     * @param ContainerInterface|null $container
     */
    public function setContainer(ContainerInterface $container = null)
    {
        $this->configManager = $container->get('oro_config.global');
    }

    /** @var ObjectManager */
    public function load(ObjectManager $manager)
    {
        $this->configure();

        $this->configManager->flush();
    }
}

```

```php
// AppBundle/Migrations/Data/ORM/GuestAccessConfiguration.php

<?php


namespace Kiboko\Bundle\AppBundle\Migrations\Data\ORM;


class GuestAccessConfiguration extends Configuration
{
    const VERSION = '1.0';

    /**
     * @return string
     */
    public function getVersion()
    {
        return self::VERSION;
    }

    protected function configure()
    {
        // Allow website access to guest users
        $this->configManager->set('oro_frontend.guest_access_enabled', true);
        // Enable guest checkout
        $this->configManager->set('oro_checkout.guest_checkout', true);
        // Enable guest shopping list
        $this->configManager->set('oro_shopping_list.availability_for_guests', true);
        // Disable quick order form for guest users
        $this->configManager->set('oro_product.guest_quick_order_form', false);
        // Disable guest RFQ
        $this->configManager->set('oro_rfp.guest_rfp', false);
    }
}
```
The `set` method of `$this->configManager` allows to change the value of the specified setting. The setting code is passed as first argument, and the value to be set as second argument. The setting code is formatted according to the following pattern: `<section>.<name>`.

The table below lists a few settings that may be changed with the configuration manager service:

section|name|type|description
---|---|---|---
oro_checkout|guest_checkout|boolean|Enable/disable guest checkout
oro_frontend|guest_access_enabled|boolean|Enable/disable guest access
oro_frontend|frontend_theme|string|Set the theme for the frontend
oro_shopping_list|availability_for_guests|boolean|Enable/disable guest shopping list  
oro_product|guest_quick_order_form|boolean|Enable/disable quick order form for guests
oro_product|single_unit_mode|boolean|Enable/disable Product Single Unit Mode
oro_product|single_unit_mode_show_code|boolean|Show/hide the product unit code
oro_rfp|guest_rfp|boolean|Enable/disable guest rfp
oro_currency|default_currency|string|Sets the default platform currency  
oro_multi_currency|allowed_currencies|string[]|Sets the allowed currencies

> This list is obviously non exhaustive.

> TIP: To find out the code of a setting we want to change, we can change it with the UI and then query the `oro_config_value` table: `select * from oro_config_value order by id desc`. The section code and the name of the setting are displayed in the result columns.
