WITH supplier__source AS (
SELECT 
  *
FROM `vit-lam-data.wide_world_importers.purchasing__suppliers`
)

, supplier__rename_column AS (
SELECT
  supplier_id AS supplier_key
  , supplier_name AS supplier_name
FROM supplier__source
)

, supplier__cast_type AS (
SELECT
  CAST(supplier_key AS INTEGER) AS supplier_key
  , CAST(supplier_name AS STRING) AS supplier_name
FROM supplier__rename_column
)

SELECT
  supplier_key
  , supplier_name
FROM supplier__cast_type
