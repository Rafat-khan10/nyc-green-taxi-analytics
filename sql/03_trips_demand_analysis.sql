1. How does trip volume vary by day of the week within each month, and which day ranks highest?

WITH cte AS (
SELECT
   EXTRACT(YEAR FROM pickup_time) AS year,
   EXTRACT(MONTH FROM pickup_time) AS month_num,
   TO_CHAR(pickup_time,'Mon') AS month,
   TO_CHAR(pickup_time,'Day') AS day,
   COUNT(*) AS total_trips
FROM green_taxi
GROUP BY year,month_num,month,day
)
SELECT
  *,
  DENSE_RANK() OVER(PARTITION BY year,month_num ORDER BY total_trips DESC) AS day_of_week_rank
FROM cte

2. Which time-of-day segment has the highest trip volume?

WITH time_segment AS (
SELECT
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
FROM green_taxi
GROUP BY time_segment
ORDER BY total_trips DESC
)
SELECT
  *,
  DENSE_RANK() OVER(ORDER BY total_trips DESC) AS time_segment_rank
FROM time_segment 

3. Which 10 hours of the day record the highest trip volumes?

SELECT
 EXTRACT(HOUR FROM pickup_time) AS hour,
 COUNT(*) AS total_trips
FROM green_taxi
GROUP BY hour
ORDER BY total_trips DESC
LIMIT 10




