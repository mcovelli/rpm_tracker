CREATE OR REPLACE VIEW location_price_variance AS
SELECT 
    l.location_id,
    l.location_name,
    i.ingredient_id,
    i.ingredient_name,
    i.ingredient_category,
    AVG(pl.unit_price_actual) AS avg_purchase_price,
    MAX(pl.unit_price_actual) AS max_purchase_price,
    MIN(pl.unit_price_actual) AS min_purchase_price,
    COUNT(po.order_id) AS total_orders
FROM purchase_order po
JOIN purchase_list pl ON po.order_id = pl.order_id
JOIN location l ON po.location_id = l.location_id
JOIN ingredient i ON pl.ingredient_id = i.ingredient_id
GROUP BY 
    l.location_id,
    l.location_name,
    i.ingredient_id,
    i.ingredient_name,
    i.ingredient_category;