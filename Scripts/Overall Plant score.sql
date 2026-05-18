-- To find best performing plants interms of Production efficieny, quality and downtime.
SELECT po.plant_id, sum(po.planned_qty)*100.0/sum(po.produced_qty) as Production_efficiency
       sum(md.downtime_minutes) as Total_downtime
       sum(qc.defects_found) as Total_defects
FROM production_orders po
JOIN machine_downtime md
ON md.machine_id=po.machine_id
JOIN quality_checks qc
ON qc.production_id=po.production_id
GROUP BY plant_id

SELECT *, 
