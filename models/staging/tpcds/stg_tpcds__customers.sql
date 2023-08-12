{{ config(meta={'data_quality':'silver'}) }}

with source_data as (

    select * from {{ source('tpcds', 'customer') }}
),

renamed as (
    select
        c_customer_sk,
        c_customer_id,
        c_current_cdemo_sk,
        c_current_hdemo_sk,
        c_current_addr_sk,
        c_first_shipto_date_sk,
        c_first_sales_date_sk,
        c_salutation,
        c_first_name,
        c_last_name,
        c_birth_day,
        c_birth_month,
        c_birth_year,
        c_birth_country,
        c_login,
        c_email_address,
        c_last_review_date,
        concat(c_first_name, ' ', c_last_name) as c_full_name,
        case
            when c_preferred_cust_flag = 'Y' then true
            when c_preferred_cust_flag = 'N' then false
        end as c_is_preferred_customer,
        date(c_birth_year, c_birth_month, c_birth_day) as c_birthdate
    from source_data
)

select * from renamed
