-- Grain: one row per Location, Ingredient and Month

CREATE OR REPLACE VIEW ingredient_monthly_cost AS
WITH current_and_starting_inventory AS (
SELECT
	i.location_id,
    i.ingredient_id,
    ing.ingredient_category,
    EXTRACT(YEAR_MONTH FROM i.inventory_date) AS inventory_year_and_month,
    i.ingredient_quantity AS ending_stock,
    LAG(i.ingredient_quantity, 1, NULL) OVER (PARTITION BY i.location_id, i.ingredient_id ORDER BY i.inventory_date) AS starting_stock
FROM inventory i
JOIN ingredient ing ON i.ingredient_id = ing.ingredient_id
),

purchases AS (
SELECT
	po.location_id,
    pl.ingredient_id,
    EXTRACT(YEAR_MONTH FROM po.purchase_date) AS purchase_year_and_month,
    SUM(ingredient_quantity) AS purchase_quantity,
    SUM(unit_price_actual * ingredient_quantity) AS purchase_dollars
FROM purchase_list pl
JOIN purchase_order po ON pl.order_id = po.order_id
GROUP BY po.location_id, pl.ingredient_id, purchase_year_and_month
),

price AS (
SELECT
	location_id,
    ingredient_id,
    purchase_year_and_month,
    purchase_quantity,
    (purchase_dollars / purchase_quantity) AS price,
    purchase_dollars
FROM purchases
),

cost_per_location_month_ingredient AS (
SELECT
	csi.location_id,
    csi.ingredient_id,
    inventory_year_and_month,
    starting_stock,
    ending_stock,
    ((starting_stock + COALESCE(purchase_quantity, 0)) - ending_stock) AS usage_quantity,
    price,
    ((starting_stock + COALESCE(purchase_quantity, 0)) - ending_stock) * price AS total_price
FROM current_and_starting_inventory csi
LEFT JOIN price p ON csi.location_id = p.location_id AND csi.ingredient_id = p.ingredient_id AND inventory_year_and_month = purchase_year_and_month
),

running_total_cte AS (
SELECT
	location_id,
    ingredient_id,
    inventory_year_and_month,
    usage_quantity,
    price,
    COUNT(price) OVER (PARTITION BY location_id, ingredient_id ORDER BY inventory_year_and_month) AS running_total
FROM cost_per_location_month_ingredient

),

carry_forward AS(
SELECT
	location_id,
    ingredient_id,
    inventory_year_and_month,
    price,
    usage_quantity,
    running_total,
	MAX(price) OVER (PARTITION BY location_id, ingredient_id, running_total) AS price_after_carry_forward
FROM running_total_cte
),

actual_food_cost AS (
SELECT
	location_id,
    ingredient_id,
    inventory_year_and_month AS year_and_month,
    price_after_carry_forward,
    (CASE WHEN price IS NULL AND price_after_carry_forward IS NOT NULL THEN 1 ELSE 0 END) AS price_is_estimate,
    usage_quantity,
	(usage_quantity * price_after_carry_forward) AS usage_dollars
FROM carry_forward
)

SELECT
	csi.location_id,
    l.location_name,
    csi.ingredient_id,
    i.ingredient_name,
    csi.ingredient_category,
    STR_TO_DATE(CONCAT(inventory_year_and_month, '01'), '%Y%m%d') AS month_start,
    
    COALESCE(purchase_quantity, 0) AS quantity_purchased,
    usage_quantity,
    starting_stock,
    ending_stock,
    price_after_carry_forward,
	price_is_estimate,
    usage_dollars,
    COALESCE(purchase_dollars, 0) AS purchase_dollars
FROM current_and_starting_inventory csi
JOIN actual_food_cost afc ON csi.location_id = afc.location_id AND csi.ingredient_id = afc.ingredient_id AND csi.inventory_year_and_month = afc.year_and_month
JOIN location l ON csi.location_id = l.location_id
JOIN ingredient i ON csi.ingredient_id = i.ingredient_id
LEFT JOIN purchases p ON 
	csi.location_id = p.location_id 
	AND csi.ingredient_id = p.ingredient_id 
    AND inventory_year_and_month = purchase_year_and_month
