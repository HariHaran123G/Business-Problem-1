-- Categorise inventory based on stock level as Low, moderate and high risk for reordering across warehouses.
WITH Base AS(
  SELECT warehouse, Product_id, stock_level, reorder_level,
        ROUND(stock_level*100.0/reorder_level,2) AS Stock_coverage_pct,
        CASE WHEN  stock_level*100.0/ reorder_level < 100 THEN 'High' 
             WHEN  stock_level*100.0/ reorder_level BETWEEN 100 AND 150 THEN 'Moderate' 
             ELSE Low 
        END AS Reorder_category
FROM inventory
),

Warehouse_category AS (
SELECT warehouse , SUM(CASE WHEN Reorder_category IN('High' OR 'Moderate') THEN 1 ELSE 0 END) AS Risky_products
FROM Base 
GROUP BY Warehouse),

Ranked as (
  SELECT *, RANK() OVER( ORDER BY Risky_products DESC) AS Rnk
  FROM Warehouse_category)
  
-- OUTPUT 1:
-- Detailed Product Risk Table

SELECT
    warehouse,
    product_id,
    stock_level,
    reorder_level,
    Stock_coverage_pct,
    Reorder_category
FROM Base
ORDER BY Stock_coverage_pct ASC;

-- OUTPUT 2:
-- Warehouse Risk Ranking

SELECT * FROM Ranked
ORDER BY Rnk;
