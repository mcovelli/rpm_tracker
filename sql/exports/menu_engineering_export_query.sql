SELECT 
	month_start,
	location_id,
    location_name,
    recipe_id,
    recipe_name,
    revenue_dollars,
    quantity_sold,
    cost_per_item,
    cost_dollars,
    gross_profit_dollars,
    has_unconverted_ingredient
FROM restaurant.menu_engineering
WHERE month_start >= '2025-02-01' AND month_start < '2026-10-01'
ORDER BY location_id, month_start;