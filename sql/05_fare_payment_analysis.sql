1. How does average fare vary across different payment types?
SELECT
 CASE
   WHEN payment_type = 1 THEN 'Credit card'
   WHEN payment_type = 2 THEN 'Cash'
   WHEN payment_type = 3 THEN 'No charge'
   WHEN payment_type = 4 THEN 'Dispute'
   WHEN payment_type = 5 THEN 'Unknown'
   ELSE 'Not Reported'
  END AS payment_category,
 ROUND(AVG(fare),2) AS avg_fare
FROM green_taxi 
GROUP BY payment_category
ORDER BY avg_fare DESC

2. How does average fare differ between street-hail and dispatch (app/call) trips?

SELECT
  CASE
    WHEN trip_type =1 THEN 'Street-hail'
	WHEN trip_type =2 THEN 'Dispatch(App/Call)'
	ELSE 'Not Reported'
  END AS trip_category,
  ROUND(AVG(fare),2) AS avg_fare
FROM green_taxi
GROUP BY trip_category 
ORDER BY avg_fare DESC
