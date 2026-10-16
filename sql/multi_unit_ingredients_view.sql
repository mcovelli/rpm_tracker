-- expect 0 rows back after every data load
-- an ingredient with more than one unit in the named table
CREATE OR REPLACE VIEW multi_unit_ingredients AS

WITH purchase_units AS (
SELECT ingredient_id,
       COUNT(DISTINCT ingredient_unit) AS unit_count
FROM purchase_list
GROUP BY ingredient_id
HAVING COUNT(DISTINCT ingredient_unit) > 1

),


inventory_units AS (
SELECT ingredient_id,
       COUNT(DISTINCT ingredient_unit) AS unit_count
FROM inventory
GROUP BY ingredient_id
HAVING COUNT(DISTINCT ingredient_unit) > 1
)

SELECT 
	'inventory' AS `source_table`,
	inv.ingredient_id,
	unit_count
FROM inventory_units inv
UNION ALL
SELECT 
	'purchase_list' AS `source_table`,
	pu.ingredient_id,
	unit_count
FROM purchase_units pu