Creating an enum
================

Schema installer/updater class
------------------------------

In addition to what you have read in the [the introduction](introduction.md#schema-manipulation), this migration class must also implement `Oro\Bundle\EntityExtendBundle\Migration\Extension\ExtendExtensionAwareInterface`

Then in your `up()` method, add the enum declaration as shown in the following snippet:

```php
<?php
    /**
     * {@inheritdoc}
     */
    public function up(Schema $schema, QueryBag $queries)
    {
        $enumCode = 'foo_bar';
        
        $this->extendExtension->addEnumField(
            $schema,
            $schema->getTable('marello_order_order'),
            $enumCode,
            ExtendHelper::buildEnumCode($enumCode),
            false,
            false,
            [
                'extend'    => [
                    'is_extend'  => true,
                    'owner' => ExtendScope::OWNER_CUSTOM
                ],
                'datagrid'  => [
                    'is_visible' => false
                ],
                'dataaudit' => [
                    'auditable' => false
                ],
                'merge'     => [
                    'display' => true
                ],
            ]
        );
    }
```

Data fixtures installer/updater class
-------------------------------------

After reading [the introduction](introduction.md#data-fixtures-manipulation) about data fixtures, add the enum values as shown in the following snippet: 

```php
<?php

use Doctrine\Common\DataFixtures\AbstractFixture;
use Doctrine\Common\Persistence\ObjectManager;
use Gedmo\Translatable\Entity\Repository\TranslationRepository;
use Oro\Bundle\EntityExtendBundle\Entity\Repository\EnumValueRepository;
use Oro\Bundle\EntityExtendBundle\Tools\ExtendHelper;

class LoadLabelData extends AbstractFixture
{
    /** @var array */
    private $data = [
        [
            'label'    => [
                'en' => 'Lorem ipsum',
                'fr' => 'Dolor sit',
            ],
            'priority' => 1,
            'default'  => true
        ],
        [
            'label'    => [
                'en' => 'Amet consecutir',
                'fr' => 'Doloes sit amet',
            ],
            'priority' => 2,
            'default'  => false
        ],
    ];
    
    private $translations = ['fr'];

    /**
     * @param ObjectManager $manager
     */
    public function load(ObjectManager $manager)
    {
        $enumCode = 'foo_bar';
        
        /** @var TranslationRepository $translationRepository */
        $translationRepository = $manager->getRepository('OroEntityExtendBundle:EnumValueTranslation');
        $className = ExtendHelper::buildEnumValueClassName($enumCode);

        /** @var EnumValueRepository $enumRepo */
        $enumRepo = $manager->getRepository($className);

        foreach ($this->data as $option) {
            // Save english value
            $enumOption = $enumRepo->createEnumValue(
                $option['label']['en'],
                $option['priority'],
                $option['default']
            );
            $manager->persist($enumOption);

            foreach ($this->translations as $locale) {
                if (!isset($option['label'][$locale])) {
                    continue;
                }
                
                $translationRepository->translate(
                    $enumOption, 
                    'name', 
                    $locale,
                    $option['label'][$locale]
                );
            }
        }

        $manager->flush();
    }
}

```
