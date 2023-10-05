{{ config(materialized="table", tags=["marketing"], meta={"data_quality":"gold"}) }}

select
    c.c_customer_sk,
    c.c_customer_id,
    c.c_current_cdemo_sk,
    c.c_current_hdemo_sk,
    c.c_current_addr_sk,
    c.c_first_shipto_date_sk,
    c.c_first_sales_date_sk,
    c.c_salutation,
    c.c_first_name,
    c.c_last_name,
    c.c_full_name,
    c.c_is_preferred_customer,
    c.c_birthdate,
    -- customer demographics
    cd.cd_demo_sk,
    cd.cd_gender,
    cd.cd_marital_status,
    cd.cd_education_status,
    cd.cd_purchase_estimate,
    cd.cd_credit_rating,
    cd.cd_dep_count,
    cd.cd_dep_employed_count,
    cd.cd_dep_college_count,
    -- household demographics
    hd_demo_sk,
    hd_income_band_sk,
    hd_buy_potential,
    hd_dep_count,
    hd_vehicle_count,
    -- income Band
    ib_income_band_sk,
    ib_lower_bound,
    ib_upper_bound,
    -- Address
    ca_address_sk,
    ca_address_id,
    ca_street_number,
    ca_street_name,
    ca_street_type,
    ca_suite_number,
    ca_city,
    ca_county,
    ca_state,
    ca_zip,
    ca_country,
    ca_gmt_offset,
    ca_location_type,
    -- date_dim
    d.d_date as c_first_shipto_date,
    d2.d_date as c_first_sales_date

from {{ ref("stg_tpcds__customers") }} as c
left join
    {{ ref("stg_tpcds__customer_demographics") }} as cd
    on c.c_current_cdemo_sk = cd.cd_demo_sk
left join
    {{ ref("stg_tpcds__household_demographics") }} as hd
    on c.c_current_hdemo_sk = hd.hd_demo_sk
left join
    {{ ref("stg_tpcds__income_band") }} as ib
    on hd.hd_income_band_sk = ib.ib_income_band_sk
left join
    {{ ref("stg_tpcds__customer_address") }} as ca
    on c.c_current_addr_sk = ca.ca_address_sk
left join
    {{ ref("stg_tpcds__date_dim") }} as d
    on d.d_date_sk = c.c_first_shipto_date_sk
left join
    {{ ref("stg_tpcds__date_dim") }} as d2
    on d2.d_date_sk = c.c_first_sales_date_sk
