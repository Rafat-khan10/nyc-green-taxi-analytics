1. How do trip volume, average fare, and average trip revenue differ between CBD and non-CBD zones?

SELECT
   CASE 
     WHEN c.location_id IS NULL THEN 'Non-CBD Zone'
	 ELSE 'CBD Zone'
   END AS zone_category,
   COUNT(*) AS total_trips,
   ROUND(AVG(fare),2) AS avg_fare,
   ROUND(AVG(total_amount),2) AS avg_revenue
FROM green_taxi AS t
LEFT JOIN cbd_zone AS c ON t.dropoff_location = c.location_id
GROUP BY zone_category

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
2. How do average trip duration and fare-per-minute compare between CBD and non-CBD zones?

WITH cte AS (
SELECT
   CASE 
     WHEN c.location_id IS NULL THEN 'Non-CBD Zone'
	 ELSE 'CBD Zone'
   END AS zone_category,
   ROUND(AVG(EXTRACT(EPOCH FROM (t.dropoff_time - t.pickup_time)))/60,2) AS avg_trip_duration,
   ROUND(AVG(fare),2) AS avg_fare
FROM green_taxi AS t
LEFT JOIN cbd_zone AS c ON t.dropoff_location = c.location_id
GROUP BY zone_category
)
SELECT
  *,
  ROUND(avg_fare/avg_trip_duration,2) AS avg_fare_per_minute
FROM cte
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
3. Which CBD zones have the lowest average fare per minute?

WITH cte AS (
    SELECT
        z.zone AS cbd_zone,
        ROUND(
            AVG(EXTRACT(EPOCH FROM (t.dropoff_time - t.pickup_time))) / 60,
            2
        ) AS avg_trip_duration,
        ROUND(AVG(t.fare), 2) AS avg_fare
    FROM green_taxi AS t
    INNER JOIN cbd_zone AS c
        ON t.dropoff_location = c.location_id
    INNER JOIN taxi_zone AS z
        ON c.location_id = z.location_id
    GROUP BY z.zone
),
zone_metrics AS (
    SELECT
        cbd_zone,
        avg_trip_duration,
        avg_fare,
        ROUND(
            avg_fare / NULLIF(avg_trip_duration, 0),
            2
        ) AS avg_fare_per_minute
    FROM cte
)
SELECT *
FROM zone_metrics
ORDER BY avg_fare_per_minute ASC
LIMIT 10;





  
