

with source as (

    select * from {{ source('tpcds', 'ship_mode') }}

),

renamed as (

    select
        sm_ship_mode_sk,
        sm_ship_mode_id,
        sm_type,
        sm_code,
        sm_carrier,
        sm_contract

    from source

)

select * from renamed

