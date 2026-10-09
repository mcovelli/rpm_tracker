DELIMITER //

DROP PROCEDURE IF EXISTS get_recipe_cost_as_of_date;

CREATE PROCEDURE get_recipe_cost_as_of_date (
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED,
    IN p_target_date DATE
)
BEGIN
    WITH latest_prices AS (
        -- STEP 1: Find the single most recent purchase price for each ingredient on or before the target date
        SELECT 
            pl.ingredient_id,
            pl.ingredient_unit AS purchase_unit,
            pl.unit_price_actual,
            ROW_NUMBER() OVER (
                PARTITION BY pl.ingredient_id 
                ORDER BY po.purchase_date DESC, pl.list_id DESC
            ) AS rn
        FROM purchase_order po
        JOIN purchase_list pl ON po.order_id = pl.order_id
        WHERE po.location_id = p_location_id 
          AND po.purchase_date <= p_target_date
    )
    -- STEP 2: Join those latest prices to the recipe and sum the total cost
    SELECT 
        p_target_date AS price_as_of_date,
        p_location_id AS location_id,
        l.location_name,
        p_recipe_id AS recipe_id,
        r.recipe_name,
        r.num_servings,
        SUM(total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lp.purchase_unit), lp.unit_price_actual)) AS total_recipe_cost,
        (SUM(total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lp.purchase_unit), lp.unit_price_actual)) / r.num_servings) AS cost_per_serving
    FROM recipe_ingredients ri
    JOIN recipe r ON ri.recipe_id = r.recipe_id
    JOIN location l ON l.location_id = p_location_id
    JOIN latest_prices lp ON ri.ingredient_id = lp.ingredient_id AND lp.rn = 1
    WHERE ri.recipe_id = p_recipe_id
    GROUP BY l.location_name, r.recipe_name, r.num_servings;
END //

DELIMITER ;