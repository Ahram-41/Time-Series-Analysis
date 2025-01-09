-- Create the 'time_of_event' table
CREATE TABLE time_of_event AS
WITH months AS (
    -- Generate a list of months from 2021-01 to 2024-10
    SELECT 
        DATE_FORMAT(DATE_ADD('2021-01-01', INTERVAL seq MONTH), '%Y-%m') AS month
    FROM (
        SELECT 0 AS seq UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
        UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9
        UNION ALL SELECT 10 UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14
        UNION ALL SELECT 15 UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19
        UNION ALL SELECT 20 UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24
        UNION ALL SELECT 25 UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29
        UNION ALL SELECT 30 UNION ALL SELECT 31 UNION ALL SELECT 32 UNION ALL SELECT 33 UNION ALL SELECT 34
        UNION ALL SELECT 35 UNION ALL SELECT 36 UNION ALL SELECT 37 UNION ALL SELECT 38 UNION ALL SELECT 39
        UNION ALL SELECT 40 UNION ALL SELECT 41 UNION ALL SELECT 42 UNION ALL SELECT 43 UNION ALL SELECT 44
        UNION ALL SELECT 45 -- Total of 46 months (from 2021-01 to 2024-10)
    ) seq_table
),
filtered_events AS (
    -- Filter events by 'High' impact level
    SELECT 
        event_number, 
        DATE_FORMAT(`from`, '%Y-%m') AS start_month,
        DATE_FORMAT(`to`, '%Y-%m') AS end_month
    FROM event
    WHERE impact_level = 'High'
)
SELECT 
    months.month,
    -- Create dynamic columns for each high-impact event
    GROUP_CONCAT(CASE 
        WHEN months.month BETWEEN filtered_events.start_month AND filtered_events.end_month THEN 1
        ELSE 0 
    END ORDER BY filtered_events.event_number SEPARATOR ',') AS events
FROM months
LEFT JOIN filtered_events
ON months.month BETWEEN filtered_events.start_month AND filtered_events.end_month
GROUP BY months.month
ORDER BY months.month;
