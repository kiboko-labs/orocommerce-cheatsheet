# Create a frontend form
1. Create a form
2. Create the frontend controller and declare it in `Resource\config\oro\routing.yml` like this:
```
my_entity_frontend:
    resource: '@MyBundle/Controller/Frontend/MyEntityController.php'
    type: annotation
    prefix: /myentity
    options:
        frontend: true
```
3. Create a FormProvider in `Layout\DataProvider`:
```
use Oro\Bundle\LayoutBundle\Layout\DataProvider\AbstractFormProvider;

class MyEntityFormProvider extends AbstractFormProvider
{
    /**
     * @param MyEntity $myEntity
     * @return FormView
     */
    public function getMyFormView(MyEntity $myEntity)
    {
        return $this->getFormView(MyEntityType::class, $myEntity);
    }
}
```
3. Declare it in the services:
```
my.frontend.form.provider:
    class: MyBundle\Layout\DataProvider\MyEntityFormProvider
    arguments:
        - '@form.factory'
        - '@router'
    tags:
        - { name: layout.data_provider, alias: my_provider_alias }
```
3. Create a `layout.yml` in `Resources\views\layouts\the theme you use\layouts\the name of your page`
```
layout:
    actions:
        - '@setBlockTheme':
            themes: 'MyBundle:layouts:default/my_page/my_page.html.twig'
        - '@addTree':
            items:
                container:
                    blockType: container
                form_start:
                    blockType: form_start
                    options:
                        form: '=data["my_provider_alias"].getMyFormView(data["entity"])'
                form_fields:
                    blockType: form_fields
                    options:
                        form: '=data["my_provider_alias"].getMyFormView(data["entity"])'
                form_end:
                    blockType: form_end
                    options:
                        form: '=data["my_provider_alias"].getMyFormView(data["entity"])'
                form_confirm:
                    blockType: button
                    options:
                        action: submit
                        text: oro.customer.form.action.save.label
                        style: auto
                        attr:
                            'class': ' btn--large btn--full-in-mobile'
            tree:
                page_content:
                    container:
                        form_start: ~
                        form_fields: ~
                        form_confirm: ~
                        form_end: ~
```
You can now customize how fields are rendered with a twig:
```
{%  block _form_fields_widget %}
    <div class="grid__column grid__column--12"> {{ form_row(form.afield) }} </div>
    <div class="grid__column grid__column--6"> {{ form_row(form.anotherfield) }} </div>
{% endblock %}

{% block _container_widget %}
    <div class="login-form"> {{ block_widget(block) }} </div>
{%  endblock %}
```
