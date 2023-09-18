
WITH random_year AS (
    -- SELECT FLOOR(1998 + (2001 - 1998 + 1) * RAND()) AS year
    SELECT 2001 AS year
),

wscs AS (
    -- Selecting from web_sales
    SELECT 
        ws.ws_sold_date_sk AS sold_date_sk,
        ws.ws_ext_sales_price AS sales_price
    FROM {{ ref('stg_tpcds__web_sales') }} AS ws
    UNION ALL
    -- Selecting from catalog_sales
    SELECT 
        cs.cs_sold_date_sk AS sold_date_sk,
        cs.cs_ext_sales_price AS sales_price
    FROM {{ ref('stg_tpcds__catalog_sales') }} AS cs
),

wswscs AS (
    SELECT 
        d.d_week_seq,
        SUM(CASE WHEN (d.d_day_name='Sunday') THEN wscs.sales_price ELSE NULL END) AS sun_sales,
        SUM(CASE WHEN (d.d_day_name='Monday') THEN wscs.sales_price ELSE NULL END) AS mon_sales,
        SUM(CASE WHEN (d.d_day_name='Tuesday') THEN wscs.sales_price ELSE NULL END) AS tue_sales,
        SUM(CASE WHEN (d.d_day_name='Wednesday') THEN wscs.sales_price ELSE NULL END) AS wed_sales,
        SUM(CASE WHEN (d.d_day_name='Thursday') THEN wscs.sales_price ELSE NULL END) AS thu_sales,
        SUM(CASE WHEN (d.d_day_name='Friday') THEN wscs.sales_price ELSE NULL END) AS fri_sales,
        SUM(CASE WHEN (d.d_day_name='Saturday') THEN wscs.sales_price ELSE NULL END) AS sat_sales
    FROM wscs
    JOIN {{ ref('dim_date') }} AS d ON d.d_date_sk = wscs.sold_date_sk
    GROUP BY d.d_week_seq
),

yearly_data AS (
    SELECT 
        wswscs.d_week_seq AS d_week_seq1,
        sun_sales AS sun_sales1,
        mon_sales AS mon_sales1,
        tue_sales AS tue_sales1,
        wed_sales AS wed_sales1,
        thu_sales AS thu_sales1,
        fri_sales AS fri_sales1,
        sat_sales AS sat_sales1
    FROM wswscs
    JOIN {{ ref('dim_date') }} AS d ON d.d_week_seq = wswscs.d_week_seq
    JOIN random_year ry ON d.d_year = ry.year
),

next_year_data AS (
    SELECT 
        wswscs.d_week_seq AS d_week_seq2,
        sun_sales AS sun_sales2,
        mon_sales AS mon_sales2,
        tue_sales AS tue_sales2,
        wed_sales AS wed_sales2,
        thu_sales AS thu_sales2,
        fri_sales AS fri_sales2,
        sat_sales AS sat_sales2
    FROM wswscs
    JOIN {{ ref('dim_date') }} AS d ON d.d_week_seq = wswscs.d_week_seq
    JOIN random_year ry ON d.d_year = ry.year + 1
)

SELECT 
    d_week_seq1,
    ROUND(sun_sales1/sun_sales2, 2) AS sun_sales_ratio,
    ROUND(mon_sales1/mon_sales2, 2) AS mon_sales_ratio,
    ROUND(tue_sales1/tue_sales2, 2) AS tue_sales_ratio,
    ROUND(wed_sales1/wed_sales2, 2) AS wed_sales_ratio,
    ROUND(thu_sales1/thu_sales2, 2) AS thu_sales_ratio,
    ROUND(fri_sales1/fri_sales2, 2) AS fri_sales_ratio,
    ROUND(sat_sales1/sat_sales2, 2) AS sat_sales_ratio
FROM yearly_data y
JOIN next_year_data z ON d_week_seq1 = d_week_seq2 - 53
ORDER BY d_week_seq1
