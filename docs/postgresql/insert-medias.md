Insert product medias in the database
=====================================

Data preparation
----------------

You must prepare your data as a PostgreSQL `VALUES` query, either built from a CSV input or whatever you will find the most useful.

Then paste it as the first sub-query in the following query.

Insertion query
---------------

```sql
WITH input_data (sku, filename, mime_type, extension) AS (
  VALUES
    (TEXT 'SKU123', TEXT 'product-image-one.jpg',   TEXT 'image/jpeg', TEXT 'jpg'),
    (TEXT 'SKU124', TEXT 'product-image-two.jpg',   TEXT 'image/jpeg', TEXT 'jpg'),
    (TEXT 'SKU125', TEXT 'product-image-three.jpg', TEXT 'image/jpeg', TEXT 'jpg'),
    (TEXT 'SKU126', TEXT 'product-image-four.jpg',  TEXT 'image/jpeg', TEXT 'jpg'),
    (TEXT 'SKU127', TEXT 'product-image-five.jpg',  TEXT 'image/jpeg', TEXT 'jpg'),
    (TEXT 'SKU128', TEXT 'product-image-six.jpg',   TEXT 'image/jpeg', TEXT 'jpg'),
    (TEXT 'SKU129', TEXT 'product-image-seven.jpg', TEXT 'image/jpeg', TEXT 'jpg')
  ),
  temporary_data AS (
    SELECT
        nextval('oro_attachment_file_id_seq') as attachment_id,
        nextval('oro_product_image_id_seq') as product_image_id,
        nextval('oro_product_image_type_id_seq') as product_image_type_main_id,
        nextval('oro_product_image_type_id_seq') as product_image_type_listing_id,
        i.filename AS filename,
        af.original_filename AS existing_filename,
        i.extension AS extension,
        i.mime_type AS mime_type,
        i.filename AS original_filename,
        NOW() as created_at,
        NOW() as updated_at,
        p.id AS product_id,
        im.image_id,
        itm.type AS main_type,
        itl.type AS listing_type,
        im.id as existing_image_id,
        af.id AS existing_attachment_id,
        itm.id AS existing_image_type_main_id,
        itl.id AS existing_image_type_listing_id
    FROM input_data AS i
      INNER JOIN oro_product AS p
        ON p.sku = i.sku
      LEFT JOIN oro_product_image AS im
        ON p.id=im.product_id
      LEFT JOIN oro_attachment_file as af
        ON im.image_id=af.id
        AND af.original_filename!=i.filename
      LEFT JOIN oro_product_image_type AS itm
        ON im.id=itm.product_image_id
        AND itm.type='main'
      LEFT JOIN oro_product_image_type AS itl
        ON im.id=itl.product_image_id
        AND itl.type='listing'
  ),
  inserted_attachment AS (
    INSERT INTO oro_attachment_file
      SELECT
        attachment_id     AS id,
        filename          AS filename,
        extension         AS extension,
        mime_type         AS mime_type,
        NULL              AS file_size,
        original_filename AS original_filename,
        created_at        AS created_at,
        updated_at        AS updated_at,
        NULL              AS owner_user_id,
        'Tjs='            AS serialized_data
      FROM temporary_data AS tl
    ON CONFLICT DO NOTHING
  ),
  inserted_product_image AS (
    INSERT INTO oro_product_image
      SELECT
        tl.product_image_id AS id,
        tl.product_id       AS product_id,
        tl.attachment_id    AS image_id,
        NOW()               AS updated_at,
        'Tjs='              AS serialized_data
      FROM temporary_data AS tl
  ),
  inserted_product_image_main AS (
    INSERT INTO oro_product_image_type
      SELECT
        tl.product_image_type_main_id AS id,
        tl.product_image_id      AS product_image_id,
        'main'                   AS type
      FROM temporary_data AS tl
      WHERE tl.main_type IS NULL
  ),
  inserted_product_image_listing AS (
    INSERT INTO oro_product_image_type
      SELECT
        tl.product_image_type_listing_id AS id,
        tl.product_image_id          AS product_image_id,
        'listing'                    AS type
      FROM temporary_data AS tl
      WHERE tl.main_type IS NULL
  )
SELECT *
FROM temporary_data AS t;
```
