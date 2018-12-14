# Business Unit migration

## Extending the BusinessUnit entity

Extending the BusinessUnit entity is rather easy. Just create a new class in the `[Bundle]\Migrations\Schema\vx_x` namespace and make it implement the `Oro\Bundle\MigrationBundle\Migration\Migration` interface (and eventually the `Oro\Bundle\AttachmentBundle\Migration\Extension\AttachmentExtensionAwareInterface` if you need to have attachments to your entity, like images or any files).

Below is an example from `kiboko-labs/sevea-orocommerce`:

```php
<?php


namespace Kiboko\Bundle\AppBundle\Migrations\Schema\v1_0;


use Doctrine\DBAL\Schema\Schema;
use Oro\Bundle\AttachmentBundle\Migration\Extension\AttachmentExtension;
use Oro\Bundle\AttachmentBundle\Migration\Extension\AttachmentExtensionAwareInterface;
use Oro\Bundle\EntityExtendBundle\EntityConfig\ExtendScope;
use Oro\Bundle\EntityExtendBundle\Migration\OroOptions;
use Oro\Bundle\MigrationBundle\Migration\Migration;
use Oro\Bundle\MigrationBundle\Migration\QueryBag;

class CustomizeBusinessUnit implements Migration, AttachmentExtensionAwareInterface
{
    const TABLE_NAME = 'oro_business_unit';
    const THUMB_WIDTH = 200;
    const THUMB_HEIGHT = 200;
    const IMAGE_SIZE = 2;

    /** @var AttachmentExtension */
    protected $attachmentExtension;

    /**
     * Sets the AttachmentExtension
     *
     * @param AttachmentExtension $attachmentExtension
     */
    public function setAttachmentExtension(AttachmentExtension $attachmentExtension)
    {
        $this->attachmentExtension = $attachmentExtension;
    }

    /**
     * Modifies the given schema to apply necessary changes of a database
     * The given query bag can be used to apply additional SQL queries before and after schema changes
     *
     * @param Schema $schema
     * @param QueryBag $queries
     * @return void
     * @throws \Doctrine\DBAL\Schema\SchemaException
     */
    public function up(Schema $schema, QueryBag $queries)
    {
        $table = $schema->getTable(self::TABLE_NAME);
        $table->addColumn('address', 'string', [
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM, 'entity' => ['description' => 'The address of the business unit']],
                'view' => ['priority' => 200],
            ],
        ]);
        $table->addColumn('address_details', 'string', [
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 190],
            ],
        ]);
        $table->addColumn('postal_code', 'string', [
            'length' => 5,
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 180],
            ],
        ]);
        $table->addColumn('town', 'string', [
            'length' => 100,
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 170],
            ],
        ]);
        $table->addColumn('longitude', 'float', [
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 160],
            ],
        ]);
        $table->addColumn('latitude', 'float', [
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 150],
            ],
        ]);
        $table->addColumn('type', 'string', [
            'length' => 10,
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 140],
            ],
        ]);
        $table->addColumn('erp_code', 'string', [
            'length' => 20,
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 120],
            ],
        ]);
        $table->addColumn('facebook', 'string', [
            OroOptions::KEY => [
                'extend' => ['owner' => ExtendScope::OWNER_CUSTOM],
                'view' => ['priority' => 110],
            ],
        ]);
        $this->attachmentExtension->addImageRelation(
            $schema,
            self::TABLE_NAME,
            'image',
            [],
            self::IMAGE_SIZE,
            self::THUMB_WIDTH,
            self::THUMB_HEIGHT
        );
    }
}
```
> Be very careful ! If you mistake, it's possible you'll have to run the `oro:install` command again. Oro keeps memory of the previous structure in database (table `oro_entity_config_field`), stored base64 serialized BLOB field. Really difficult to update.

## Extending the BusinessUnitType

You have to write a new type extension in order to add and configure the fields of the form. You may create new fields, and override "parent" field configurations.

```php
<?php


namespace Kiboko\Bundle\AppBundle\Form\Extension;


use Oro\Bundle\AttachmentBundle\Form\Type\ImageType;
use Oro\Bundle\OrganizationBundle\Form\Type\BusinessUnitType;
use Symfony\Component\Form\AbstractTypeExtension;
use Symfony\Component\Form\Extension\Core\Type\ChoiceType;
use Symfony\Component\Form\FormBuilderInterface;

class BusinessUnitExtension extends AbstractTypeExtension
{
    const TYPE_VENDOR = 'vendor';
    const TYPE_VITRINE = 'vitrine';
    const TYPE_EXTERNAL = 'external';

    /**
     * Returns the name of the type being extended.
     *
     * @return string The name of the type being extended
     */
    public function getExtendedType()
    {
        return BusinessUnitType::class;
    }

    /**
     * @param FormBuilderInterface $builder
     * @param array $options
     */
    public function buildForm(FormBuilderInterface $builder, array $options)
    {
        $builder
            ->add('image', ImageType::class)
            ->add('type', ChoiceType::class, [
                'label' => $this->getTranslationKey('type'),
                'choices' => [
                    $this->getTranslationKey('type.choices.vendor') => self::TYPE_VENDOR,
                    $this->getTranslationKey('type.choices.vitrine') => self::TYPE_VITRINE,
                    $this->getTranslationKey('type.choices.external') => self::TYPE_EXTERNAL,
                ]
            ])
        ;
    }

    private function getTranslationKey(string $key) : string
    {
        return sprintf('oro.organization.businessunit.%s.label', $key);
    }
}
```
## Creating the form listener
New fields declared in the type extension above won't be added automatically on the form view.
In order to add those fields on the form view, we need to hook into the form prerender event `Oro\Bundle\UIBundle\Event\Events::BEFORE_UPDATE_FORM_RENDER`.
```php
<?php


namespace Kiboko\Bundle\AppBundle\EventListener;


use Oro\Bundle\UIBundle\Event\BeforeFormRenderEvent;
use Oro\Bundle\UIBundle\Event\Events;
use Oro\Bundle\UIBundle\View\ScrollData;
use Symfony\Component\EventDispatcher\EventSubscriberInterface;
use Symfony\Component\Form\FormView;

class BusinessUnitFormListener implements EventSubscriberInterface
{
    const FORM_NAME = 'oro_business_unit_form';

    /**
     * @return array The event names to listen to
     */
    public static function getSubscribedEvents()
    {
        return [
            Events::BEFORE_UPDATE_FORM_RENDER => 'onBusinessUnitEdit',
        ];
    }

    public function onBusinessUnitEdit(BeforeFormRenderEvent $event)
    {
        $form = $event->getForm();
        if (!$this->supports($form)) {
            return;
        }

        $template = $event->getTwigEnvironment()->render(
            '@KibokoApp/Form/file_widget.html.twig',
            ['form' => $form->children['image']]
        );

        $scrollData = new ScrollData($event->getFormData());
        $scrollData->addSubBlockData(1, 0, $template, 'image');

        $event->setFormData($scrollData->getData());
    }

    /**
     * @param FormView $formView
     * @return bool
     */
    protected function supports(FormView $formView)
    {
        return $formView->vars['name'] === self::FORM_NAME;
    }
}
```
> Be careful, as each form rendering will trigger this event. Be sure to filter the forms with a `supports` method as above, for example

The form data can be found via the `BeforeFormRenderEvent`. It's just a flat array, that is easier to manipulate wrapped into a `Oro\Bundle\UIBundle\View\ScrollData` object.

The goal is to generate the HTML for each added form field:
```php
$template = $event->getTwigEnvironment()->render(
    '@KibokoApp/Form/file_widget.html.twig',
    ['form' => $form->children['image']]
);
```
and to place it at the required place in the form data:
```php
$scrollData->addSubBlockData(1, 0, $template, 'image');
```
You'll have to create the template file yourself. In the above example (`file_widget.html.twig`), it's just a one-line template:
```twig
{{ form_row(form) }}
```
