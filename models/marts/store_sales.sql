WITH sales AS (
    SELECT *
    FROM
        {{ ref('sales_joined_with_date_time') }}
    WHERE
        ss_customer_sk IS NOT NULL
        AND ss_store_sk IS NOT NULL
        AND ss_item_sk IS NOT NULL
        AND sale_timestamp IS NOT NULL
)

SELECT * FROM sales
