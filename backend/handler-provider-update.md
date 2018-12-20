### Scénario : 

> J'ai des besoins complexes de persitances d'entitées et de réponses à renvoyer à la vue que le  UpdateHandlerFacade ne peut satisfaire

### Le cas simple

 Ceci est l'update de Oro/Bundle/ProductBundle/Controller/BrandController.
Il fonctionne assez simplement :  On passe au update_handler 
- L'entité ($brand)
- Le form
- L'objet request
- Une chaîne de caractère traduite à afficher quand la sauvegarde est faite.

```php
    protected function update(Brand $brand, Request $request)
    {
        return $this->get('oro_form.update_handler')->update(
            $brand,  
            $this->createForm(BrandType::NAME, $brand),   
            $this->get('translator')->trans('oro.product.brand.form.update.messages.saved'), 
            $request,
            null
        );
    }
```

 L'UpdateHandlerFacade s'occupe d'enregistrer la donnée et de construire une réponse qui est renvoyée a la vue.
### Le cas plus compliqué

En utilisant la méthode précedente, on n'a ni la main sur la manière dont Oro persiste notre entitée, ni sur la réponse qu'il va construire et renvoyer à la vue.

### Le Handler
- Le handler permet de délèguer tout le traitement d'un formulaire.

L'utilisation d'un handler à nous :

```php
    protected function update(Brand $brand, Request $request)
    {
        return $this->updateHandler->update(
            $brand,  
            $this->createForm(BrandType::NAME, $brand),   
            $this->translator->trans('oro.product.brand.form.update.messages.saved'), 
            $request,
            new BrandHandler($this->form, $request, $this->entityManager), // Il est là
        );
    }
```

A quoi ça ressemble : 

```php

<?php

namespace Acme\Bundle\FooBundle\Form\Handler;

use Doctrine\Common\Persistence\ObjectManager;

use Oro\Bundle\FormBundle\Form\Handler\FormHandlerInterface;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\HttpFoundation\Request;

use Oro\Bundle\ProductBundle\Entity\Brand;

class BrandHandler implements FormHandlerInterface
{
    /**
     * @var FormInterface
     */
    protected $form;

    /**
     * @var Request
     */
    protected $request;

    /**
     * @var ObjectManager
     */
    protected $manager;

    /**
     * @param FormInterface $form
     * @param Request       $request
     * @param ObjectManager $manager
     */
    public function __construct(FormInterface $form, Request $request, ObjectManager $manager)
    {
        $this->form    = $form;
        $this->request = $request;
        $this->manager = $manager;
    }

    /**
     * {@inheritdoc}
     */
    public function process($data, FormInterface $form, Request $request)
    {
        if (!$data instanceof Brand) {
            throw new \InvalidArgumentException("Si data n'est pas une instance de brand on sort");
        }
        $form->setData($data);  // On set les données dans le formulaire

        if (in_array($request->getMethod(), ['POST', 'PUT'])) {
            $form->submit($request);  // On submit le formulaire

            if ($form->isValid()) {
                $this->onSuccess($data);
                return true;
            }
        }
        return false;
    }

    /**
     * "Success" form handler
     *
     * @param Brand $brand
     */
    protected function onSuccess(Brand $brand)
    {
        $this->manager->persist($brand);
        $this->manager->flush();
    }
}
```
- Concrètement tel qu'il est notre handler ne sert a rien.
- Il fait exactement ce que fait la première portion de code. 
- Mais il nous perment d'avoir la main sur la manière dont est persistée notre entité brand.


### Le Provider

Le provider va permettre d'avoir la main sur la réponse qui être renvoyée a la vue.

```php
    protected function update(Brand $brand, Request $request)
    {
        return $this->updateHandler->update(
            $brand,  
            $this->form,   
            $this->translator->trans('oro.product.brand.form.update.messages.saved'), 
            $request,
            new BrandHandler($this->form, $request, $this->entityManager), 
            new BrandProvider($brand, $this->form, $request) // Il est là
        );
    }

```
On doit implementer FormTemplateDataProviderInterface, et on peut construire notre réponse dans la méthode getData()

```php
<?php

namespace Acme\Bundle\FooBundle\Provider;

use Oro\Bundle\ProductBundle\Entity\Brand;
use Oro\Bundle\FormBundle\Provider\FormTemplateDataProviderInterface;
use Symfony\Component\Form\FormInterface;
use Symfony\Component\HttpFoundation\Request;

class BrandProvider implements FormTemplateDataProviderInterface
{

    /**
    * @var Brand $entity
    */
    private $entity;

    /**
    * @var FormInterface $form
    */
    private $channelRuleGroupType;

    /**
    * @var Request $form
    */
    private $request;



    /**
     *
     * @param Brand         $entity
     * @param FormInterface  $channelRuleGroupType
     * @param Request        $request
     */
    public function __construct(Brand $entity, FormInterface $channelRuleGroupType, Request $request)
    {
        $this->entity = $entity;
        $this->channelRuleGroupType = $channelRuleGroupType;
        $this->request = $request;
    }


    public function getData($entity, FormInterface $form, Request $request)
    {
        return [
            'custom' => 'Je suis un truc dont la vue a besoin',
        ];
    }
}
```
