## Products list

Products at front office are rendered in multiple places.

1) Main product grid (product listing, PLP etc) – renders grid of products that has pagination, filters and sorters. Datagrid used to render it is called frontend-product-search-grid and defined here: https://github.com/oroinc/orocommerce/blob/3.1.0-rc/src/Oro/Bundle/ProductBundle/Resources/config/oro/datagrids.yml#L736-L796 . This grid is extended by multiple listeners that adds additional filters, additional sorters, prices, shopping lists etc. This grid is usually rendered using oro_product_frontend_product_index route from this controller: https://github.com/oroinc/orocommerce/blob/3.1.0-rc/src/Oro/Bundle/ProductBundle/Controller/Frontend/ProductController.php#L18-L37 . This page is also used to render global search results.

2) Product view page (product information page, PDP etc) – renders information about one specific product. It is rendered using oro_product_frontend_product_view route from this controller: https://github.com/oroinc/orocommerce/blob/3.1.0-rc/src/Oro/Bundle/ProductBundle/Controller/Frontend/ProductController.php#L39-L103

3) Simplified product listing (e.g. Featured products at the root page) – renders short list of products without ability to paginate, sort of filter them. It is rendered using oro_product_list layout import. Here you may see how it is done: https://github.com/oroinc/orocommerce/blob/3.1.0-rc/src/Oro/Bundle/ProductBundle/Resources/views/layouts/blank/oro_frontend_root/featured_products.yml

Of course there are other places where products are rendered, but they are handled from other bundles. You may find them by checking an appropriate route and associated layout updates.
