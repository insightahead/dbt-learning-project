{{config(materialized='ephemeral')}}

with source as (
    select * from {{ ref('stg_tpcds__store_sales') }}
),

sales_with_date_and_time as (
    select
        store_sales.*,
        d_dim.d_date as sale_date,
        PARSE_TIMESTAMP(
            '%Y-%m-%d %H:%M:%S',
            CONCAT(
                CAST(d_dim.d_date as STRING), ' ',
                CAST(t_dim.t_hour as STRING), ':',
                CAST(t_dim.t_minute as STRING), ':',
                CAST(t_dim.t_second as STRING)
            )
        ) as sale_timestamp
    from source as store_sales
    inner join {{ ref('stg_tpcds__date_dim') }} as d_dim
        on store_sales.ss_sold_date_sk = d_dim.d_date_sk
    left outer join {{ ref('stg_tpcds__time_dim') }} as t_dim
        on store_sales.ss_sold_time_sk = t_dim.t_time_sk
)

select * from sales_with_date_and_time

-- https://docs.getdbt.com/guides/best-practices/how-we-structure/3-intermediate
