CREATE OR REPLACE VIEW order_vs_usage AS 

WITH current_and_starting_inventory AS (
SELECT
	location_id,
    ingredient_id,
    EXTRACT(YEAR_MONTH FROM inventory_date) AS inventory_year_and_month,
    ingredient_quantity AS ending_stock,
    LAG(ingredient_quantity, 1, NULL) OVER (PARTITION BY location_id, ingredient_id ORDER BY inventory_date) AS starting_stock
FROM inventory
),

purchases AS (
SELECT
	po.location_id,
    pl.ingredient_id,
    EXTRACT(YEAR_MONTH FROM po.purchase_date) AS purchase_year_and_month,
    SUM(ingredient_quantity) AS purchase_quantity
FROM purchase_list pl
JOIN purchase_order po ON pl.order_id = po.order_id
GROUP BY po.location_id, pl.ingredient_id, purchase_year_and_month

)

SELECT
	csi.location_id,
    csi.ingredient_id,
    STR_TO_DATE(CONCAT(inventory_year_and_month, '01'), '%Y%m%d') AS month_start,
    COALESCE(purchase_quantity, 0) AS quantity_purchased,
    ((starting_stock + COALESCE(purchase_quantity, 0)) - ending_stock) AS usage_quantity,
    ending_stock,
    (COALESCE(purchase_quantity, 0) / ((starting_stock + COALESCE(purchase_quantity, 0)) - ending_stock)) AS purchase_to_usage_ratio,
    (COALESCE(purchase_quantity, 0) - ((starting_stock + COALESCE(purchase_quantity, 0)) - ending_stock)) AS purchase_to_usage_difference
FROM current_and_starting_inventory csi
LEFT JOIN purchases p ON 
	csi.location_id = p.location_id 
	AND csi.ingredient_id = p.ingredient_id 
    AND inventory_year_and_month = purchase_year_and_month
