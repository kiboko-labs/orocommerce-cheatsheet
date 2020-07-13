
Elements est une couche de service dans les tests behat. Ils enveloppent la logique métier complexe. Prenez une minute pour lire la base des [NodeElement Mink](https://github.com/minkphp/Mink/blob/9ea1cebe3dc529ba3861d87c818f045362c40484/src/Element/NodeElement.php)

Il y a de nombreuses méthodes publiques; certains d'entre eux ne s'appliquent qu'à certains éléments. Chaque test Bundle peut contenir un nombre particulier d'éléments.
Tous les éléments doivent être décrits dans {BundleName} {BundleName}/Tests/Behat/behat.yml de la manière suivante:

````yaml
 oro_behat_extension:
   elements:
     Login:
       selector: '#login-form'
       class: Oro\Bundle\TestFrameworkBundle\Behat\Element\Form
       options:
         mapping:
           Username: '_username'
           Password: '_password'
````

ou :

1. `Login` est un nom d'élément qui DOIT être unique. L'élément peut être créé dans un contexte par OroElementFactory par son nom:

````php
$this->elementFactory->createElement('Login');
````

2. selector` définit comment le driver Web doit trouver l'élément sur la page. Par défaut, lorsque le type de sélecteur n'est pas spécifié, le sélecteur css est utilisé.
Le sélecteur XPath est également pris en charge et peut être fourni avec la configuration suivante:

```yaml
 selector:
     type: xpath
     locator: //span[id='mySpan']/ancestor::form/
```
3. Le namespace de l'élément (doit être étendu à partir de Oro\Bundle\TestFrameworkBundle\Behat\Element\Element`).
Lorsqu'elle est omise, la classe `Oro\Bundle\TestFrameworkBundle\Behat\Element\Element` est utilisée par défaut.

4. `options` est un tableau d'options supplémentaires stockées dans la propriété options de la classe Element.
Il est fortement recommandé de fournir une classe avec des options de mappage pour les éléments de formulaire, car cela augmente la vitesse de test et garantit un mappage de champ plus précis.

## Mappage des champs de formulaire

Par défaut, les tests utilisent le [sélecteur de champ nommé](http://mink.behat.org/en/latest/guides/traversing-pages.html#named-selectors)  pour mapper les champs du formulaire.
Le sélecteur de nom de champ a recherché le champ par son identifiant, son nom, son label ou son placeholder.
Vous êtes libre d'utiliser n'importe quel sélecteur pour mapper des champs de formulaire ou encapsuler un élément dans l'élément behat particulier.

```yaml
 oro_behat_extension:
   elements:
     Payment Method Config Type Field:
       class: Oro\Bundle\PaymentBundle\Tests\Behat\Element\PaymentMethodConfigType
     PaymentRuleForm:
       selector: "form[id^='oro_payment_methods_configs_rule']"
       class: Oro\Bundle\TestFrameworkBundle\Behat\Element\Form
       options:
         mapping:
           Method:
             type: 'xpath'
             locator: '//div[@id[starts-with(.,"uniform-oro_payment_methods_configs_rule_method")]]'
             element: Payment Method Config Type Field
```

Vous devez maintenant implémenter la méthode `setValue` de l'élément:

````php
<?php
 namespace Oro\Bundle\PaymentBundle\Tests\Behat\Element;
 use Oro\Bundle\TestFrameworkBundle\Behat\Element\Element;
 class PaymentMethodConfigType extends Element
 {
     /**
      * {@inheritdoc}
      */
     public function setValue($value)
     {
         $values = is_array($value) ? $value : [$value];
         foreach ($values as $item) {
             $parentField = $this->getParent()->getParent()->getParent()->getParent();
             $field = $parentField->find('css', 'select');
             self::assertNotNull($field, 'Select payment method field not found');
             $field->setValue($item);
             $parentField->clickLink('Add');
             $this->getDriver()->waitForAjax();
         }
     }
 }
````

Vous pouvez maintenant l'utiliser dans une étape standard:

```yaml
 Feature: Payment Rules CRUD
   Scenario: Creating Payment Rule
     Given I login as administrator
     And I go to System/ Payment Rules
     And I click "Create Payment Rule"
     When I fill "Payment Rule Form" with:
       | Method | PayPal |
```

### Mappages de formulaires intégrés : 

Parfois, un formulaire apparaît dans l'iframe. Behat peut passer à l'iframe par son identifiant.
Pour remplir correctement le formulaire dans l'iframe, spécifiez l'id iframe dans les options du formulaire:

````yaml
   oro_behat_extension:
     elements:
       MagentoContactUsForm:
         selector: 'div#page'
         class: Oro\Bundle\TestFrameworkBundle\Behat\Element\Form
         options:
           embedded-id: embedded-form
           mapping:
             First name: 'oro_magento_contactus_contact_request[firstName]'
             Last name: 'oro_magento_contactus_contact_request[lastName]'
````

## ELement de page


L'élément Page encapsule la page Web entière avec son URL et son chemin d'accès à la page. Chaque élément Page doit étendre `Oro\Bundle\TestFrameworkBundle\Behat\Element\Page`.

Exemple de Configuration de Page :

```yaml
 oro_behat_extension:
   pages:
     UserProfileView:
       class: Oro\Bundle\UserBundle\Tests\Behat\Page\UserProfileView
       route: 'oro_user_profile_view'
```
Exemple de classe de page:

```php
 namespace Oro\Bundle\UserBundle\Tests\Behat\Page;

 use Oro\Bundle\TestFrameworkBundle\Behat\Element\Page;

 class UserProfileView extends Page
 {
     /**
      * {@inheritdoc}
      */
     public function open(array $parameters = [])
     {
         $userMenu = $this->elementFactory->createElement('UserMenu');
         $userMenu->find('css', '[data-toggle="dropdown"]')->click();

         $userMenu->clickLink('My User');
     }
 }
```
Vous pouvez maintenant utiliser plusieurs étapes significatives:

````yaml
 And I open User Profile View page
 And I should be on User Profile View page
````