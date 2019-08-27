Le strict nécessaire pour ajouter une mass-action sur la grille produit.

Les mots rigolos (machin, glouglou, torref, avionAréAction et massage-de-pieds) indiquent les alias qui peuvent être changés.

## Resources/oro/config/actions.yml
```
operations:
    glouglou:
        label: mass.age.de.pieds
        datagrids:
            - frontend-product-search-grid
        datagrid_options:
            mass_action:
                type: addproducts
                frontend_type: torref    # c'est le nom de votre JS sans "-action.js"
```

## Resources/public/js/datagrid/action/backend-action-header-cell.js
- piquez `backend-action-header-cell.js` dans les vendor
- ligne 102, ajouter votre action :
```
newMassActions['glougloumass_action'] = $.extend(true, {}, avionAréAction, {
    name: 'glougloumass_action'
});
```
- ligne 30 : définissez votre action :
```
var avionAréAction = {
    icon: 'copy',                                 # une icone FontAwesome sans "fa-"
    frontend_handle: 'ajax',

    label: __('mass.age.de.pieds'),
    type: 'addproducts',
    frontend_type: 'torref',                      # le nom de votre JS sans "-action.js"
    
    route: 'mass_age_de_pieds',                   # la route
    handler: 'app.machin.mass_action.handler',    # là ou vous mettrez vos traitements
};
```
- Ajoutez `var __ = require('orotranslation/js/translator');` vers les requires lignes 4 ou 5.

## Resources/public/js/datagrid/action/torref-action.js
- piquez `add-products-mass-action.js` dans les vendor

## Resources/views/layouts/blank/config/require.js
```
config:
    paths:
        'oro/datagrid/action/torref-action': 'bundles/app/js/datagrid/action/torref-action.js'
        'app/js/datagrid/action/backend-action-header-cell': 'bundles/app/js/datagrid/action/backend-action-header-cell.js'
    map:
        '*':
            'oroproduct/js/app/datagrid/header-cell/backend-action-header-cell': 'app/js/datagrid/action/backend-action-header-cell'
```

## Controller/MachinController.php
```
    /**
     * @Route("/mass-age-de-pieds/", name="mass_age_de_pieds")
     */
    public function massAgeDePieds(Request $request)
    {
        $gridName = $request->get('gridName');
        $actionName = $request->get('actionName');

        /** @var MassActionDispatcher $massActionDispatcher */
        $massActionDispatcher = $this->get('oro_datagrid.mass_action.dispatcher');
        $response = $massActionDispatcher->dispatchByRequest($gridName, $actionName, $request);

        $data = [ 'successful' => $response->isSuccessful(), 'message' => $response->getMessage() ];

        return new JsonResponse(array_merge($data, $response->getOptions()));
    }
```
Dans `routing.yml`, le controller doit avoir `options.expose: true`.

## MassAction/MachinMassActionHandler.php
Là ou vous mettez vos traitements. C'est `$ids` qui vous intéresse.
```
class MachinMassActionHandler implements MassActionHandlerInterface
{
    public function handle(MassActionHandlerArgs $args) {
        $argsParser = new AddProductsMassActionArgsParser($args);
        $ids = $argsParser->getProductIds();
        return new MassActionResponse(true, 'message');
    }
}
```
