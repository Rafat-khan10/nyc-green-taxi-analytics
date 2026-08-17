1. How does total revenue change month over month, and what is the monthly revenue growth rate?

WITH current_month AS (
SELECT
  EXTRACT(YEAR FROM pickup_time) AS year,
  EXTRACT(Month FROM pickup_time) AS month_num,
  TO_CHAR(pickup_time,'Mon') AS month,
  SUM(total_amount) AS current_month_revenue
FROM green_taxi
GROUP BY Year, Month_num, Month
),
prev_month AS (
SELECT
 *,
 LAG(current_month_revenue) OVER(ORDER BY year ASC ,month_num ASC) AS previous_month_revenue
FROM current_month
)
SELECT
  *,
  ROUND((current_month_revenue - previous_month_revenue)*100.0/NULLIF(previous_month_revenue,0),2) mon_growth
FROM prev_month

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
2. What is the average revenue per trip across each quarter of the year?

SELECT
  EXTRACT(YEAR FROM pickup_time) AS year,
  EXTRACT(QUARTER FROM pickup_time) AS quarter,
  ROUND(AVG(total_amount),2) AS avg_revenue
FROM green_taxi
GROUP BY year, quarter
ORDER BY year ASC, quarter ASC
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
3. Which rate code category generates the highest average revenue per trip?

WITH cte AS (
SELECT
  CASE
    WHEN rate_code =1 THEN 'Standard'
	WHEN rate_code =2 THEN 'JFK'
	WHEN rate_code =3 THEN 'Newark'
	WHEN rate_code =4 THEN 'Nassau/Westchester'
	WHEN rate_code =5 THEN 'Negociated'
	WHEN rate_code =6 THEN 'Group'
	WHEN rate_code =99 THEN 'Unknown'
	ELSE 'Other'
  END AS rate_code_category,
  ROUND(AVG(total_amount),2) AS avg_revenue 
FROM green_taxi
GROUP BY rate_code
)
SELECT
 *,
 DENSE_RANK() OVER(ORDER BY avg_revenue DESC) AS rate_code_rank
FROM cte

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
4. Which time-of-day segment generates the highest average revenue per trip?

WITH cte AS (
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
	ROUND(AVG(total_amount),2) AS avg_revenue
FROM green_taxi
GROUP BY time_segment
)
SELECT
  *,
  DENSE_RANK() OVER(ORDER BY avg_revenue DESC) AS time_segment_rank
FROM cte
------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

5. How do weekday and weekend trips compare in terms of trip volume and average revenue?

SELECT
  CASE
    WHEN TO_CHAR(pickup_time, 'D') BETWEEN '2' AND '6' THEN 'weekday'
	ELSE 'weekend'
  END AS weekday_category,
  COUNT(*) AS total_trips,
  ROUND(AVG(total_amount),2) AS avg_revenue
FROM green_taxi 
GROUP BY  weekday_category
ORDER BY avg_revenue DESC 





















