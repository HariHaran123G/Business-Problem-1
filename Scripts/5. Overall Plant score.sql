-- To find best performing plants interms of Production efficieny, quality and downtime.
WITH BASE AS(
SELECT po.plant_id, sum(planned_qty) AS Total_planned, sum(produced_qty) as Total_produced,
       ROUND(SUM(Total_produced) * 100.0 / SUM(planned_qty),2 ) AS Production_efficiency
FROM production_orders
GROUP BY plant_id),

Downtime AS (
SELECT po.plant_id, SUM(md.downtime_minutes) AS Total_downtime
FROM production_orders po
JOIN machine_downtime md
ON md.machine_id = po.machine_id
GROUP BY po.plant_id
),

Defects AS (
 SELECT po.plant_id,  SUM(qc.defects_found)  AS Total_defects
 FROM production_orders po
 JOIN quality_checks qc
 ON qc.production_id = po.production_id
 GROUP BY po.plant_id
),

Combined AS (
 SELECT  p.plant_id,   p.Production_efficiency, d.Total_downtime, df.Total_defects
 FROM Production p
    JOIN Downtime d
    ON d.plant_id = p.plant_id
    JOIN Defects df
    ON df.plant_id = p.plant_id
),

Plant_score AS (
    SELECT *, ROUND( Production_efficiency - (Total_downtime / 100.0) - (Total_defects * 2),  2) AS Plant_performance_score
    FROM Combined
),
Ranked AS (
    SELECT *,
    RANK() OVER(ORDER BY Plant_performance_score DESC) AS Rnk
    FROM Plant_score
)
SELECT * FROM Ranked;
