--Business problem 3: 
--Which suppliers create the most operational delays?
WITH Base AS 
(
SELECT s.supplier_id,
       s.supplier_name, 
       
      COUNT(rm.material_order_id) AS Total_orders,
      s.reliability_score as Given_reliability_score,
  
      SUM(rm.delay_days) as Total_delay_days, 
      AVG(rm.delay_days) AS Average_delay_days, 
  
      SUM (CASE WHEN rm.delay_days>0 THEN 1 ELSE 0 END) AS Delayed_orders
FROM suppliers s
JOIN raw_material_orders rm
ON s.supplier_id=rm.supplier_id
GROUP BY s.supplier_id, s.supplier_name
  )

Reliability AS
  (
  SELECT *, ROUND(Delayed_orders*100.0/Total_orders, 2) AS Delay_frequency_pct,
  ROUND(100 - (Delayed_orders * 100.0 / Total_orders), 2) AS Actual_reliability_score
  FROM Base
  ),

Ranked AS (
  SELECT *, RANK() OVER( ORDER BY  Delay_frequency_pct DESC, Average_delay_days DESC) AS Rnk
  FROM Reliability)

  SELECT * FROM Ranked 
  where Rnk<=10;
