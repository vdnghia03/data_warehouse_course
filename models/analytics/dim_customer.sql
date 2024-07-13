
WITH dim_customer__source AS (
SELECT 
  *
FROM `vit-lam-data.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS (
SELECT
  customer_id AS customer_key
  , customer_name 
FROM dim_customer__source
)

, dim_customer__cast_type AS (
SELECT
  CAST(customer_key as INTEGER) as customer_key
  , CAST(customer_name AS STRING) as customer_name
FROM dim_customer__rename_column
)

SELECT 
  customer_key
  , customer_name
FROM dim_customer__cast_type