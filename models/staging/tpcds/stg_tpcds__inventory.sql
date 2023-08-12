

with source as (

    select * from {{ source('tpcds', 'inventory') }}

),

renamed as (

    select
        inv_date_sk,
        inv_item_sk,
        inv_warehouse_sk,
        inv_quantity_on_hand

    from source

)

select * from renamed

