-- Business problem 2- Find which plant and shift that produces highest defects.,

WITH Base AS(
  SELECT p.plant_id, p.shift, COUNT(q.qc_id) AS Total_qc_checks, SUM(CASE WHEN q.qc_status='Fail' then q.defects_found else 0 end) as Total_defects
  FROM production_orders p
  JOIN quality_checks q
  ON q.production_id = p.production_id
  GROUP BY p.plant_id, p.shift
  ),

Ranked AS(
  SELECT *, RANK() OVER( ORDER BY Total_defects DESC) AS Rnk
  FROM Base
  )
SELECT * FROM Ranked
WHERE Rnk<=5;
