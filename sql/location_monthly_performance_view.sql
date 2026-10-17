-- food cost and sales for October 2026 are incomplete
-- Grain: one row per location and month 

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
		AVG(cost_per_serving) AS cost_per_item,
        MAX(unconverted_ingredient_count) AS unconverted_ingredient_count
	FROM recipe_cost_historical
	GROUP BY location_id, recipe_id, year_and_month
	 
	),

	location_sales_by_month AS (
	SELECT
		si.location_id,
		STR_TO_DATE(CONCAT(EXTRACT(YEAR_MONTH FROM s.date_of_trans), '01'), '%Y%m%d') AS year_and_month,
		COUNT(DISTINCT s.transaction_id) AS tickets,
		SUM(total_per_item) AS sales_dollar
	FROM sales_items si
	JOIN sales s ON si.transaction_id = s.transaction_id
	GROUP by si.location_id, year_and_month
	),	

	sales_cost AS (
	SELECT
		rfc.location_id,
		STR_TO_DATE(CONCAT(rfc.year_and_month, '01'), '%Y%m%d') AS year_and_month,
		SUM(cost_per_item * total_quantity) AS total_sales_cost,
        SUM(CASE WHEN unconverted_ingredient_count > 0 THEN 1 ELSE 0 END) AS unconverted_recipe_count
	FROM recipe_food_cost_by_location rfc 
	JOIN quantity q ON rfc.location_id = q.location_id AND rfc.recipe_id = q.recipe_id AND rfc.year_and_month = q.year_and_month
	GROUP BY rfc.location_id, rfc.year_and_month
	),
    
    
    -- Grain: One row per location and month
    ingredient_monthly_cost_location_month AS (
    SELECT
		location_id,
		month_start,
		SUM(price_is_estimate) AS estimated_price_ingredient_count,
        SUM(usage_dollars) AS total_usage_dollars,
		SUM(purchase_dollars) AS total_purchase_dollars
	FROM ingredient_monthly_cost
    GROUP BY location_id, month_start
    )

	SELECT
		imc.location_id,
		l.location_name,
		month_start,
		
		CAST(sales_dollar AS DECIMAL(8,2)) AS sales_dollars,
		CAST(((sales_dollar / (LAG(sales_dollar, 12, NULL) OVER (PARTITION BY sc.location_id ORDER BY sc.location_id, sc.year_and_month)) - 1) * 100) AS DECIMAL (5,2)) AS year_over_year_change_pct,
		
		tickets,
		CAST(sales_dollar/tickets AS DECIMAL(8,2)) AS average_ticket_dollars,
				
		CAST(total_usage_dollars AS DECIMAL(10,2)) AS actual_food_cost_dollars,
		CAST(((total_usage_dollars/sales_dollar) * 100) AS DECIMAL(5,2)) AS actual_food_cost_pct,

		CAST(total_sales_cost AS DECIMAL(10,2)) AS theoretical_food_cost_dollars,
		CAST(((total_sales_cost/sales_dollar) * 100) AS DECIMAL(5,2)) AS theoretical_food_cost_pct,
		
		CAST((total_purchase_dollars) AS DECIMAL(10,2)) AS purchase_food_cost_dollars, -- food cost based on purchases
		CAST(((total_purchase_dollars/sales_dollar) * 100) AS DECIMAL(5,2)) AS purchase_food_cost_pct, -- food cost percent based on purchases
		
		CAST(total_purchase_dollars - total_sales_cost AS DECIMAL(10,2)) AS purchase_cost_gap_dollars,
		CAST(((total_purchase_dollars/sales_dollar) * 100) - ((total_sales_cost/sales_dollar) * 100) AS DECIMAL(10,2)) AS purchase_cost_gap_pct,
		
		CAST(total_usage_dollars - total_sales_cost AS DECIMAL(10,2)) AS actual_cost_gap_dollars,
		CAST(((total_usage_dollars/sales_dollar) * 100) - ((total_sales_cost/sales_dollar) * 100) AS DECIMAL(10,2)) AS actual_cost_gap_pct,

        
		estimated_price_ingredient_count,
        unconverted_recipe_count
	FROM ingredient_monthly_cost_location_month imc
	JOIN sales_cost sc ON imc.location_id = sc.location_id AND imc.month_start = sc.year_and_month
	JOIN location_sales_by_month ls ON sc.location_id = ls.location_id AND sc.year_and_month = ls.year_and_month
	JOIN location l ON sc.location_id = l.location_id
