
WITH customer_total_return AS (
    SELECT
        sr_customer_sk AS ctr_customer_sk,
        sr_store_sk AS ctr_store_sk,
        SUM(SR_RETURN_AMT) AS ctr_total_return
    FROM {{ ref('stg_tpcds__store_returns') }}
    JOIN {{ ref('dim_date') }} ON sr_returned_date_sk = d_date_sk
    WHERE d_year = CAST(FLOOR(1998 + (2002 - 1998 + 1) * RAND()) AS INT64)
    GROUP BY sr_customer_sk, sr_store_sk
)

SELECT
    c_customer_id as customer_id,
    c_full_name as full_name,
    c_is_preferred_customer as preferred_customer,
    hd_buy_potential as buying_potential,
    cd_purchase_estimate as purchase_estimate,
    cd_credit_rating as credit_rating,
    ctr_total_return as total_return
FROM customer_total_return ctr1
JOIN {{ ref('dim_store') }} ON s_store_sk = ctr1.ctr_store_sk
JOIN {{ ref('customers') }} ON ctr1.ctr_customer_sk = c_customer_sk
WHERE ctr1.ctr_total_return > (
    SELECT AVG(ctr_total_return) * 1.2
    FROM customer_total_return ctr2
    WHERE ctr1.ctr_store_sk = ctr2.ctr_store_sk
)
AND s_state = 'TN'
ORDER BY c_customer_id
