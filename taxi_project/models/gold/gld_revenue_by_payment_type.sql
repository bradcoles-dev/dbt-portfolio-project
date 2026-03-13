with trips as (

    select * from {{ ref('slv_yellow_taxi') }}

),

aggregated as (

    select
        payment_type,
        count(*)                         as total_trips,
        round(avg(trip_distance), 2)     as avg_distance_miles,
        round(avg(trip_duration_minutes), 1) as avg_duration_minutes,
        round(avg(fare_amount), 2)       as avg_fare,
        round(avg(tip_amount), 2)        as avg_tip,
        round(sum(total_amount), 2)      as total_revenue,
        round(avg(total_amount), 2)      as avg_revenue_per_trip

    from trips

    group by 1
    order by total_revenue desc

)

select * from aggregated
