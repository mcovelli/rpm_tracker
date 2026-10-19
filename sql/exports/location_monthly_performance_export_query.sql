SELECT 
	location_id,
    location_name,
    month_start,
    sales_dollars,
    year_over_year_change_pct,
    tickets,
    average_ticket_dollars,
    actual_food_cost_dollars,
    actual_food_cost_pct,
    theoretical_food_cost_dollars,
    theoretical_food_cost_pct,
    purchase_food_cost_dollars,
    purchase_food_cost_pct,
    purchase_cost_gap_dollars,
    purchase_cost_gap_pct,
    actual_cost_gap_dollars,
    actual_cost_gap_pct,
    estimated_price_ingredient_count,
    unconverted_recipe_count
FROM location_monthly_performance
WHERE month_start >= '2025-02-01' AND month_start < '2026-10-01'
ORDER BY location_id, month_start