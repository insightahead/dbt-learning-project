
{{ config(
    materialized='incremental',
    unique_key=['ss_sold_date_sk','ss_sold_time_sk','ss_store_sk','ss_customer_sk','ss_item_sk']
) }}

WITH sales AS (
    SELECT *
    FROM
        {{ ref('int_sales_joined_with_date_time') }}
    WHERE
        ss_customer_sk IS NOT NULL
        AND ss_store_sk IS NOT NULL
        AND ss_item_sk IS NOT NULL
        AND sale_timestamp IS NOT NULL
)

SELECT * FROM sales

{% if is_incremental() %}

    WHERE ss_ticket_number > (SELECT max(ss_ticket_number) FROM {{ this }})

{% endif %}








