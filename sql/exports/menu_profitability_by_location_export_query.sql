SELECT
	location_id,
    location_name,
    recipe_id,
    recipe_name,
    recipe_status,
    menu_price,
    cost_per_serving,
    gross_profit_per_unit,
    profit_margin_pct,
    total_units_sold,
    total_gross_profit_dollars
FROM menu_profitability_by_location
WHERE recipe_status = 'ACTIVE'