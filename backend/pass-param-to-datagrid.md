### Scénario : 

> Je faire passer un paramètre à ma datagrid

### Comment créer passer un paramètre à ma datagrid

> Placez-vous dans votre datagrid :


```yml
# src/Acme/Bundle/YourBundle/Resources/config/oro/datagrids.yml
datagrids:
    # ...
    acme-test-grid:
        # ...
        source:
            query:
                where:
                    and:
                    - test.relation = :param
            bind_parameters:
                - param
        # ...
    # ...

```
> Dans votre twig

```twig
{# src/Acme/Bundle/YourBundle/Resources/views/Test/test.html.twig #}
{% import 'OroDataGridBundle::macros.html.twig' as dataGrid %}

<div class="widget-content">
    {{ dataGrid.renderGrid('acme-test-grid', {param: yourparam}) }}
</div>
```
  