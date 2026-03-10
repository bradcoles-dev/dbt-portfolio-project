with source as (

    select * from {{ ref('raw_yellow_taxi') }}

)

select * from source
