-- Grain: one row per location, recipe and month
CREATE OR REPLACE VIEW menu_engineering AS
WITH recipe_food_cost_by_location AS (
SELECT 
	location_id,
	recipe_id,
	EXTRACT(YEAR_MONTH FROM purchase_date) AS year_and_month,
	AVG(cost_per_serving) AS cost_per_item,
	MAX(unconverted_ingredient_count) AS unconverted_ingredient_count
FROM recipe_cost_historical
GROUP BY location_id, recipe_id, year_and_month
	 
),
    
sales_per_location_per_recipe AS (
SELECT 
	si.location_id,
	si.recipe_id,
	EXTRACT(YEAR_MONTH FROM date_of_trans) AS year_and_month,
    SUM(qty) AS quantity_sold,
	SUM(si.total_per_item) AS revenue_dollars
FROM sales_items si
JOIN sales s ON si.transaction_id = s.transaction_id
GROUP BY si.location_id, si.recipe_id, year_and_month

)

SELECT
	STR_TO_DATE(CONCAT(si.year_and_month, '01'), '%Y%m%d') AS month_start,
	si.location_id,
    l.location_name,
    si.recipe_id,
    recipe_name,
	revenue_dollars,
    quantity_sold,
    cost_per_item,
   (quantity_sold * cost_per_item) AS cost_dollars,
   (revenue_dollars) - (quantity_sold * cost_per_item) AS gross_profit_dollars,
   (CASE WHEN unconverted_ingredient_count > 0 THEN 1 ELSE 0 END) AS has_unconverted_ingredient
FROM sales_per_location_per_recipe si
JOIN recipe_food_cost_by_location rch ON si.recipe_id = rch.recipe_id AND si.location_id = rch.location_id AND si.year_and_month = rch.year_and_month
JOIN location l ON si.location_id = l.location_id
JOIN recipe r ON si.recipe_id = r.recipe_id
