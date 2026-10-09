CREATE OR REPLACE VIEW menu_profitability_by_location AS 
SELECT 
    m.location_id,
    l.location_name,
    r.recipe_id,
    r.recipe_name,
    m.recipe_status,
    m.price AS menu_price,
    rc.cost_per_serving,
    (m.price - rc.cost_per_serving) AS gross_profit_per_unit,
    ((m.price - rc.cost_per_serving) / m.price) * 100 AS profit_margin_pct,
    SUM(si.qty) AS total_units_sold,
    SUM(si.qty) * (m.price - rc.cost_per_serving) AS total_gross_profit_dollars
FROM menu m
JOIN recipe r ON m.recipe_id = r.recipe_id
JOIN location l ON m.location_id = l.location_id
JOIN recipe_cost rc ON m.recipe_id = rc.recipe_id AND m.location_id = rc.location_id
JOIN sales_items si ON m.recipe_id = si.recipe_id AND m.location_id = si.location_id
WHERE m.recipe_status = 'ACTIVE'
GROUP BY 
    m.location_id,
    l.location_name,
    r.recipe_id,
    r.recipe_name,
    m.price,
    rc.cost_per_serving;