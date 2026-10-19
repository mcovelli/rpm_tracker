SELECT 
	location_id,
    location_name,
    month_start,
    ingredient_id,
    ingredient_name,
    ingredient_category,
    quantity_purchased,
    purchase_dollars,
    avg_price_paid,
    max_purchase_price,
    min_purchase_price,
    total_orders
FROM restaurant.location_price_variance
WHERE month_start >= '2025-02-01' AND month_start < '2026-10-01'
ORDER BY location_id, ingredient_id, month_start;