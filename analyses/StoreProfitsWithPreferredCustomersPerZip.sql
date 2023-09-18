
-- This code provides a list of store names, 
-- their zip codes, and their total net profits. 
-- Additionally, it provides insights about a specific set of customers, 
-- namely the preferred customers who reside in certain zip code. 

with
preferred_customers_by_zipcode as (
    select
        substr(ca_zip, 1, 5) as ca_zip
        ,count(*) as cnt
    from {{ ref("customers") }} as customers

    where c_is_preferred_customer = true and customers.ca_zip = '35709' 
    group by customers.ca_zip
)
select 
    stores.s_store_name
    ,stores.s_zip
    ,sum(store_sales.ss_net_profit) as store_total_net_profit
from {{ ref("store_sales") }}
inner join
    {{ ref("dim_date") }} as dates
    on dates.d_date_sk = store_sales.ss_sold_date_sk
inner join
    {{ ref("dim_store") }} as stores
    on stores.s_store_sk = store_sales.ss_store_sk

group by stores.s_store_name,stores.s_zip
order by stores.s_zip,stores.s_store_name