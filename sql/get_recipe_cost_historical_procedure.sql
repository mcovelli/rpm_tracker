DELIMITER //

DROP PROCEDURE IF EXISTS get_recipe_cost_historical;

CREATE PROCEDURE get_recipe_cost_historical (
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED,
    IN p_target_date DATE
)
BEGIN
    WITH purchase_record_rn AS (
        SELECT
            ROW_NUMBER() OVER (
                PARTITION BY ri.ingredient_id, m.location_id, po.supplier_id 
                -- ADDED TIE-BREAKER: list_id forces deterministic sorting on same-day purchases
                ORDER BY po.purchase_date DESC, pl.list_id DESC
            ) AS rn,
            po.purchase_date,
            pl.ingredient_id,
            po.supplier_id,
            m.location_id,
            m.recipe_id,
            ri.ingredient_quantity,
            ri.ingredient_unit AS recipe_unit,
            pl.ingredient_unit AS purchase_unit,
            pl.unit_price_actual
        FROM purchase_list pl
        JOIN purchase_order po ON pl.order_id = po.order_id
        JOIN recipe_ingredients ri ON pl.ingredient_id = ri.ingredient_id
        JOIN menu m 
            ON ri.recipe_id = m.recipe_id 
            AND po.location_id = m.location_id
        WHERE m.recipe_id = p_recipe_id 
          AND m.location_id = p_location_id
          AND m.recipe_status = 'ACTIVE' -- Parity restored with the original view
          AND po.purchase_date <= p_target_date
    )
    SELECT 
        pr.recipe_id,
        r.recipe_name,
        r.num_servings,
        pr.location_id,
        l.location_name,
        p_target_date AS evaluated_date,
        SUM(total_cost(CONVERT_INGREDIENT(pr.ingredient_id, pr.ingredient_quantity, pr.recipe_unit, pr.purchase_unit), pr.unit_price_actual)) AS total_recipe_cost,
        (SUM(total_cost(CONVERT_INGREDIENT(pr.ingredient_id, pr.ingredient_quantity, pr.recipe_unit, pr.purchase_unit), pr.unit_price_actual)) / r.num_servings) AS cost_per_serving
    FROM purchase_record_rn pr
    JOIN recipe r ON pr.recipe_id = r.recipe_id
    JOIN location l ON pr.location_id = l.location_id
    WHERE pr.rn = 1
    GROUP BY 
        pr.recipe_id, 
        r.recipe_name, 
        r.num_servings, 
        pr.location_id, 
        l.location_name, 
        p_target_date;
END //

DELIMITER ;