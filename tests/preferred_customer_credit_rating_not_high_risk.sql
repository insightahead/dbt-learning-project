{{config(severity='warn',store_failures = true)}}

select
    c.c_customer_sk,
    cd.cd_credit_rating,
    c.c_is_preferred_customer
from
{{ref("stg_tpcds__customers")}} as c
    inner join{{ref(
        "stg_tpcds__customer_demographics"
    )}} as cd on c.c_current_cdemo_sk = cd.cd_demo_sk
where
    cd.cd_credit_rating = 'High Risk'

    and c.c_is_preferred_customer = true
