with trips as (

    select * from {{ ref('slv_yellow_taxi') }}

),

aggregated as (

    select
        pickup_datetime::date            as trip_date,
        count(*)                         as total_trips,
        sum(passenger_count)             as total_passengers,
        round(sum(trip_distance), 2)     as total_distance_miles,
        round(avg(trip_duration_minutes), 1) as avg_duration_minutes,
        round(sum(fare_amount), 2)       as total_fare,
        round(sum(tip_amount), 2)        as total_tips,
        round(sum(total_amount), 2)      as total_revenue,
        round(avg(total_amount), 2)      as avg_revenue_per_trip

    from trips

    group by 1
    order by 1

)

select * from aggregated
