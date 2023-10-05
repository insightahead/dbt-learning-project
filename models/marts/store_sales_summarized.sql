WITH sales_summarized AS (
    SELECT
        sale_date,
        ss_store_sk,
        sum(ss_sales_price) AS total_sales
    FROM
        {{ ref('int_sales_joined_with_date_time') }}
    WHERE ss_store_sk IS NOT NULL
    GROUP BY
        sale_date, ss_store_sk
)

SELECT * FROM sales_summarized
