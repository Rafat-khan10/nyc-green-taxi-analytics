1. Which pickup zones have the highest average trip revenue within each borough?

WITH pickup_zone AS (
SELECT
  z.borough,
  z.zone,
  ROUND(AVG(t.total_amount),2) AS avg_revenue
FROM green_taxi AS t
INNER JOIN taxi_zone AS z
ON t.pickup_location = z.location_id
GROUP BY z.borough,z.zone
),
zone_rank AS (
SELECT
 *,
 DENSE_RANK() OVER(PARTITION BY borough ORDER BY avg_revenue DESC) AS pickup_zone_rank
FROM pickup_zone
)
SELECT
  *
FROM zone_rank
WHERE pickup_zone_rank <=10

2. What is the average revenue per trip and total trip volume for each borough?
WITH cte AS (
SELECT
   CASE
    WHEN z.borough='N/A' THEN 'Outside of NYC'
	ELSE z.borough
   END AS borough,	
   COUNT(*) AS total_trips,
   ROUND(AVG(t.total_amount),2) AS avg_revenue
FROM green_taxi AS t
INNER JOIN taxi_zone AS z
ON t.pickup_location = z.location_id
GROUP BY z.borough
)
SELECT
 *,
 DENSE_RANK() OVER(ORDER BY avg_revenue DESC) AS borough_rank
FROM cte

3. Which time segments generate the highest trip volume within each borough?
WITH cte AS (
SELECT
    CASE
      WHEN z.borough='N/A' THEN 'Outside of NYC'
	  ELSE z.borough
   END AS borough,
   CASE 
     WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 0 AND 3 THEN 'Mid-night(0-3)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 4 AND 6 THEN 'Early-morning(4-6)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 7 AND 9 THEN 'Morning-Rush(7-9)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 10 AND 11 THEN 'Late-morning(10-11)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 12 AND 13 THEN 'Mid-day(12-13)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 14 AND 15 THEN 'Afternoon(14-15)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 16 AND 18 THEN 'Evening-Rush(16-18)'
	 WHEN EXTRACT(HOUR FROM pickup_time) BETWEEN 19 AND 21 THEN 'Evening(19-21)'
	 ELSE 'Night(22-23)' 
	END AS time_segment,
	COUNT(*) AS total_trips
FROM green_taxi AS t
INNER JOIN taxi_zone AS z
ON t.pickup_location = z.location_id
GROUP BY borough,time_segment
)
SELECT
  *,
  DENSE_RANK() OVER(PARTITION BY borough ORDER BY total_trips DESC) AS rank_by_time_segment
FROM cte

4. Which borough-to-borough routes generate the highest average revenue per trip?
  
WITH cte AS (
SELECT
  CASE 
    WHEN p.borough='N/A' THEN 'Outside of NYC'
    ELSE p.borough
  END AS pickup_borough,
  CASE 
    WHEN d.borough='N/A' THEN 'Outside of NYC'
    ELSE d.borough
  END AS dropoff_borough,
  COUNT(*) AS total_trips,
  ROUND(AVG(t.total_amount),2) AS avg_revenue
FROM green_taxi AS t
INNER JOIN taxi_zone AS p
ON t.pickup_location = p.location_id
INNER JOIN taxi_zone AS d
ON t.dropoff_location = d.location_id
GROUP BY p.borough,d.borough
),
cte2 AS (
SELECT
  *,
  DENSE_RANK() OVER(PARTITION BY pickup_borough ORDER BY avg_revenue DESC) AS top_routes_rank
FROM cte
)
SELECT
  *
FROM cte2
WHERE top_routes_rank <=5
  
5. What percentage of total revenue is concentrated in the top-performing boroughs (cumulative revenue distribution)?

WITH cte AS (
SELECT
   CASE
    WHEN z.borough='N/A' THEN 'Outside of NYC'
	ELSE z.borough
   END AS borough,
   ROUND(SUM(t.total_amount),2) AS total_revenue
FROM green_taxi AS t
INNER JOIN taxi_zone AS z
ON t.pickup_location = z.location_id
GROUP BY z.borough
)

SELECT
  *,
  ROUND(SUM(total_revenue) OVER(ORDER BY total_revenue DESC)*100.0/(SELECT SUM(total_revenue) FROM cte),2) AS cum_pct_revenue
FROM cte












