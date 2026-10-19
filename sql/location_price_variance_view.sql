-- Grain: One row per location, ingredient and month
-- October 2026 is incomplete and January 2025 is included
-- Both get filtered during export.

CREATE OR REPLACE VIEW location_price_variance AS
SELECT 
    l.location_id,
    l.location_name,
    STR_TO_DATE(CONCAT(EXTRACT(year_month FROM po.purchase_date), '01'), '%Y%m%d') AS month_start,
    i.ingredient_id,
    i.ingredient_name,
    i.ingredient_category,
    SUM(ingredient_quantity) AS quantity_purchased, -- quantity relies on each ingredient having one purchase a month
    SUM(unit_price_actual * ingredient_quantity) AS purchase_dollars,
    (SUM(unit_price_actual * ingredient_quantity))/SUM(ingredient_quantity) AS avg_price_paid,
    MAX(pl.unit_price_actual) AS max_purchase_price,
    MIN(pl.unit_price_actual) AS min_purchase_price,
    COUNT(DISTINCT po.order_id) AS total_orders
FROM purchase_order po
JOIN purchase_list pl ON po.order_id = pl.order_id
JOIN location l ON po.location_id = l.location_id
JOIN ingredient i ON pl.ingredient_id = i.ingredient_id
GROUP BY 
    l.location_id,
    i.ingredient_id,
    month_start;