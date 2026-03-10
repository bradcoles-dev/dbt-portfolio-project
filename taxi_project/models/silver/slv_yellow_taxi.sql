with source as (

    select * from {{ ref('brz_yellow_taxi') }}

),

cleaned as (

    select
        trip_id,
        vendor_id,
        pickup_datetime::timestamp                                                       as pickup_datetime,
        dropoff_datetime::timestamp                                                      as dropoff_datetime,
        passenger_count,
        trip_distance,
        pickup_location_id,
        dropoff_location_id,
        payment_type,
        fare_amount,
        tip_amount,
        total_amount,

        -- derived columns
        datediff('minute', pickup_datetime::timestamp, dropoff_datetime::timestamp)      as trip_duration_minutes

    from source

    where
        fare_amount > 0
        and trip_distance > 0
        and passenger_count > 0

)

select * from cleaned
