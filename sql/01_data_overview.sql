1. What are the key summary metrics (total revenue, total trips, average fare, and average trip duration) for the entire dataset?

SELECT 'Total Revenue' AS table_name,SUM(total_amount) AS Amount FROM green_taxi
UNION ALL
SELECT 'Total Trips', COUNT(*) FROM green_taxi
UNION ALL
SELECT 'Avg Fare',ROUND(AVG(fare),2) FROM green_taxi
UNION ALL
SELECT 'Avg Trip Duration Minute',ROUND(AVG(EXTRACT(EPOCH FROM (dropoff_time - pickup_time)))/60,2) FROM green_taxi
