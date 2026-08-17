1. How do average revenue and fare-per-mile vary across different trip distance buckets?
  
SELECT
  CASE
    WHEN trip_distance <=1 THEN 'Very Short(0-1)'
	WHEN trip_distance <=2 THEN 'Short(1-2)'
	WHEN trip_distance <=4 THEN 'Medium(2-4)'
	WHEN trip_distance <=7 THEN 'Long (4-7)'
	WHEN trip_distance <=15 THEN 'Very Long (7-15)'
	ELSE 'Extreme(15+)' 
  END AS distance_bucket,
	ROUND(AVG(fare),2) AS avg_revenue,
	ROUND(AVG(trip_distance),2) AS avg_trip_distance,
	ROUND(AVG(fare)/AVG(trip_distance)::NUMERIC,2) AS avg_fare_per_mile
FROM green_taxi
WHERE trip_distance > 0 AND trip_distance <=50
GROUP BY distance_bucket
ORDER BY avg_fare_per_mile DESC
