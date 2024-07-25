WITH dim_customer__source AS (
SELECT 
  *
FROM `vit-lam-data.wide_world_importers.sales__customers`
)

, dim_customer__rename_column AS (
SELECT
  customer_id AS customer_key
  , customer_category_id AS customer_category_key
  , buying_group_id AS buying_group_key
  , customer_name 
  , is_on_credit_hold AS is_on_credit_hold_boolean
FROM dim_customer__source
)

, dim_customer__cast_type AS (
SELECT
  CAST(customer_key as INTEGER) as customer_key
  , CAST(customer_category_key as INTEGER) as customer_category_key
  , CAST(buying_group_key as INTEGER) as buying_group_key
  , CAST(customer_name AS STRING) as customer_name
  , CAST(is_on_credit_hold_boolean AS BOOLEAN) as is_on_credit_hold_boolean
FROM dim_customer__rename_column
)

, dim_customer__convert_boolean AS (
  SELECT
  *
  , CASE
      WHEN is_on_credit_hold_boolean = TRUE THEN 'On Credit Hold'
      WHEN is_on_credit_hold_boolean = FALSE THEN 'Not On Credit Hold'
      WHEN is_on_credit_hold_boolean IS NULL THEN 'Undefined'
      ELSE 'Invalid'
    END AS is_on_credit_hold
  FROM dim_customer__cast_type
)

SELECT 
  dim_customer.customer_key
  , dim_customer.customer_category_key
  , dim_customer.buying_group_key
  , dim_customer.customer_name
  , COALESCE(dim_customer_category.customer_category_name, "Undefined") AS customer_category_name
  , COALESCE(dim_buying_group.buying_group_name, "Undefined") AS buying_group_name
  , dim_customer.is_on_credit_hold
FROM dim_customer__convert_boolean AS dim_customer
LEFT JOIN {{ ref('stg_dim_sales_customer_category') }} AS dim_customer_category
ON dim_customer_category.customer_category_key = dim_customer.customer_category_key
LEFT JOIN {{ ref('stg_dim_sales_buying_group') }} AS dim_buying_group
ON dim_buying_group.buying_group_key = dim_customer.buying_group_key