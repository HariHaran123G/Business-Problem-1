-- Business problem 1: To find which machines have the highest operational loss?
WITH BASE AS(
SELECT machine_id, count(*) as Downtime_events, sum(downtime_minutes) AS Total_downtime, avg(downtime_minutes) as Average_downtime ,
FROM machine_downtime
GROUP BY machine_id
),

Production as (
  SELECT machine_id,  sum(planned_qty) as Total_planned, sum(p.produced_qty) as Actual_qty, 
  sum(p.planned_qty-p.produced_qty) as Difference_in_production
  FROM Production_orders
  GROUP BY machine_id
)
Combined AS (
 SELECT
        p.machine_id,
        d.Downtime_events,
        d.Total_downtime,
        d.Average_downtime,
        p.Total_planned,
        p.Actual_qty,
        p.Difference_in_production,

        ROUND(
            p.Actual_qty * 100.0
            / p.Total_planned,
            2
        ) AS Production_efficiency

    FROM Production p
    JOIN Downtime d
    ON d.machine_id = p.machine_id
),

Ranked AS (
    SELECT *,
    RANK() OVER(
        ORDER BY
            Total_downtime DESC,
            Difference_in_production DESC
    ) AS Rnk
    FROM Combined
)
SELECT * FROM Ranked
WHERE Rnk <= 10;
