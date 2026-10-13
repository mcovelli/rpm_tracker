-- food cost and sales for October 2026 are incomplete

CREATE OR REPLACE VIEW location_monthly_performance AS
WITH quantity AS (
SELECT
	s.location_id,
	si.recipe_id,
    SUM(si.qty) AS total_quantity,
    EXTRACT(YEAR_MONTH FROM s.date_of_trans) AS year_and_month
FROM sales_items si
JOIN sales s ON si.transaction_id = s.transaction_id
GROUP BY s.location_id, si.recipe_id, year_and_month
),

recipe_food_cost_by_location AS (
SELECT 
	location_id,
    recipe_id,
    EXTRACT(YEAR_MONTH FROM purchase_date) AS year_and_month,
    AVG(cost_per_serving) AS cost_per_item
FROM recipe_cost_historical
GROUP BY location_id, recipe_id, year_and_month
 
),

location_sales_by_month AS (
SELECT
    si.location_id,
    EXTRACT(YEAR_MONTH FROM s.date_of_trans) AS year_and_month,
    COUNT(DISTINCT s.transaction_id) AS tickets,
    SUM(total_per_item) AS sales_dollar
FROM sales_items si
JOIN sales s ON si.transaction_id = s.transaction_id
GROUP by si.location_id, year_and_month
),	

purchase AS (
SELECT
	po.location_id,
	EXTRACT(YEAR_MONTH FROM purchase_date) AS year_and_month,
    SUM(unit_price_actual * ingredient_quantity) AS purchased_food_cost_dollars
FROM purchase_list pl
JOIN purchase_order po ON pl.order_id = po.order_id
GROUP by location_id, year_and_month
),

purchases AS (
SELECT
	po.location_id,
    pl.ingredient_id,
    EXTRACT(YEAR_MONTH FROM po.purchase_date) AS purchase_year_and_month,
    SUM(ingredient_quantity) AS purchase_quantity,
    SUM(unit_price_actual * ingredient_quantity) AS total_cost_dollars
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
    (total_cost_dollars / purchase_quantity) AS price,
    total_cost_dollars
FROM purchases
),

current_and_starting_inventory AS (
SELECT
	location_id,
    ingredient_id,
    EXTRACT(YEAR_MONTH FROM inventory_date) AS inventory_year_and_month,
    ingredient_quantity AS ending_stock,
    LAG(ingredient_quantity, 1, NULL) OVER (PARTITION BY location_id, ingredient_id ORDER BY inventory_date) AS starting_stock
FROM inventory
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
    inventory_year_and_month AS year_and_month,
    COUNT(CASE WHEN price IS NULL AND price_after_carry_forward IS NOT NULL THEN 1 END) AS estimated_price_ingredient_count,
	SUM((usage_quantity * price_after_carry_forward)) AS actual_food_cost_dollars
FROM carry_forward
GROUP BY location_id, inventory_year_and_month
),

sales_cost AS (
SELECT
	rfc.location_id,
    rfc.year_and_month,
    SUM(cost_per_item * total_quantity) AS total_sales_cost
FROM recipe_food_cost_by_location rfc 
JOIN quantity q ON rfc.location_id = q.location_id AND rfc.recipe_id = q.recipe_id AND rfc.year_and_month = q.year_and_month
GROUP BY rfc.location_id, rfc.year_and_month
)

SELECT
	sc.location_id,
	l.location_name,
    STR_TO_DATE(CONCAT(sc.year_and_month, '01'), '%Y%m%d') AS month_start,
    
    CAST(sales_dollar AS DECIMAL(8,2)) AS sales_dollars,
    CAST(((sales_dollar / (LAG(sales_dollar, 12, NULL) OVER (PARTITION BY sc.location_id ORDER BY sc.location_id, sc.year_and_month)) - 1) * 100) AS DECIMAL (5,2)) AS year_over_year_change_pct,
    
    tickets,
    CAST(sales_dollar/tickets AS DECIMAL(8,2)) AS average_ticket_count,
    
    CAST(actual_food_cost_dollars - total_sales_cost AS DECIMAL(10,2)) AS actual_cost_gap_dollars,
    CAST(((actual_food_cost_dollars/sales_dollar) * 100) - ((total_sales_cost/sales_dollar) * 100) AS DECIMAL(10,2)) AS actual_cost_gap_pct,
    
	CAST(actual_food_cost_dollars AS DECIMAL(10,2)) AS actual_food_cost_dollars,
    CAST(((actual_food_cost_dollars/sales_dollar) * 100) AS DECIMAL(5,2)) AS actual_food_cost_pct, -- food cost percent based on purchases

    CAST(total_sales_cost AS DECIMAL(10,2)) AS theoretical_food_cost_dollars,
    CAST(((total_sales_cost/sales_dollar) * 100) AS DECIMAL(5,2)) AS theoretical_food_cost_pct,
    
    CAST((purchased_food_cost_dollars) AS DECIMAL(10,2)) AS purchase_food_cost_dollars, -- food cost based on purchases
    CAST(((purchased_food_cost_dollars/sales_dollar) * 100) AS DECIMAL(5,2)) AS purchase_food_cost_pct, -- food cost percent based on purchases
    
	CAST(purchased_food_cost_dollars - total_sales_cost AS DECIMAL(10,2)) AS purchase_cost_gap_dollars,
    CAST(((purchased_food_cost_dollars/sales_dollar) * 100) - ((total_sales_cost/sales_dollar) * 100) AS DECIMAL(10,2)) AS purchase_cost_gap_pct,

    estimated_price_ingredient_count
FROM sales_cost sc
JOIN location_sales_by_month ls ON sc.location_id = ls.location_id AND sc.year_and_month = ls.year_and_month
JOIN location l ON sc.location_id = l.location_id
JOIN purchase p ON sc.location_id = p.location_id AND sc.year_and_month = p.year_and_month
JOIN actual_food_cost afc ON sc.location_id = afc.location_id AND sc.year_and_month = afc.year_and_month