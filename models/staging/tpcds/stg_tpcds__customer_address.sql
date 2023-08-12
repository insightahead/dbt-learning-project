

with source as (

    select * from {{ source('tpcds', 'customer_address') }}

),

renamed as (

    select
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
        ca_location_type

    from source

)

select * from renamed

