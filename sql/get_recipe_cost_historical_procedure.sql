DELIMITER //

DROP PROCEDURE IF EXISTS get_recipe_cost_historical;

CREATE PROCEDURE get_recipe_cost_historical (
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED,
    IN p_target_date DATE
)
BEGIN
WITH recipe_snapshot_dates AS (
    -- STEP 1: Get every date any ingredient for a recipe was purchased at a location
    SELECT DISTINCT m.location_id, ri.recipe_id, po.purchase_date AS snapshot_date
    FROM menu m
    JOIN recipe_ingredients ri ON m.recipe_id = ri.recipe_id
    JOIN purchase_list pl ON ri.ingredient_id = pl.ingredient_id
    JOIN purchase_order po ON pl.order_id = po.order_id AND m.location_id = po.location_id
    WHERE m.recipe_id = p_recipe_id AND m.location_id = p_location_id AND po.purchase_date <= p_target_date
),
recipe_full_ingredient_list AS (
    -- STEP 2: Create a row for EVERY ingredient in the recipe for EVERY snapshot date
    SELECT 
        rsd.location_id, 
        rsd.recipe_id, 
        rsd.snapshot_date, 
        ri.ingredient_id, 
        ri.ingredient_quantity, 
        ri.ingredient_unit AS recipe_unit
    FROM recipe_snapshot_dates rsd
    JOIN recipe_ingredients ri ON rsd.recipe_id = ri.recipe_id
),
historical_prices AS (
    -- STEP 3: Look backward from the snapshot date to find the most recent price
    SELECT 
        rfi.location_id,
        rfi.recipe_id,
        rfi.snapshot_date,
        rfi.ingredient_id,
        rfi.ingredient_quantity,
        rfi.recipe_unit,
        pl.unit_price_actual,
        pl.ingredient_unit AS purchase_unit,
        ROW_NUMBER() OVER (
            PARTITION BY rfi.snapshot_date, rfi.ingredient_id 
            ORDER BY po.purchase_date DESC, pl.list_id DESC
        ) AS rn
    FROM recipe_full_ingredient_list rfi
    JOIN purchase_order po 
        ON po.location_id = rfi.location_id 
        AND po.purchase_date <= rfi.snapshot_date
    JOIN purchase_list pl 
        ON po.order_id = pl.order_id 
        AND pl.ingredient_id = rfi.ingredient_id
)
-- STEP 4: Sum the full recipe using the effective prices for that specific date
SELECT 
    hp.snapshot_date AS purchase_date,
    hp.location_id,
    l.location_name,
    hp.recipe_id,
    r.recipe_name,
    r.num_servings,
    SUM(total_cost(CONVERT_INGREDIENT(hp.ingredient_id, hp.ingredient_quantity, hp.recipe_unit, hp.purchase_unit), hp.unit_price_actual)) AS total_recipe_cost,
    (SUM(total_cost(CONVERT_INGREDIENT(hp.ingredient_id, hp.ingredient_quantity, hp.recipe_unit, hp.purchase_unit), hp.unit_price_actual)) / r.num_servings) AS cost_per_serving
FROM historical_prices hp
JOIN location l ON hp.location_id = l.location_id
JOIN recipe r ON hp.recipe_id = r.recipe_id
WHERE hp.rn = 1
GROUP BY 
    hp.snapshot_date, 
    hp.location_id, 
    l.location_name, 
    hp.recipe_id, 
    r.recipe_name, 
    r.num_servings
ORDER BY purchase_date DESC;
END //

DELIMITER ;