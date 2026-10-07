DELIMITER //

DROP PROCEDURE IF EXISTS get_recipe_cost_historical;

CREATE PROCEDURE get_recipe_cost_historical (
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED,
    IN p_target_date DATE
)
BEGIN
    -- STEP 1: Exactly mirrors 'latest_purchase_price' view
    WITH latest AS (
        SELECT
            ROW_NUMBER() OVER (
                PARTITION BY po.supplier_id, pl.ingredient_id, po.location_id 
                ORDER BY po.purchase_date DESC, pl.list_id DESC 
            ) AS rn,
            po.order_id,
            po.purchase_date,
            po.supplier_id,
            s.supplier_name AS supplier,
            pl.ingredient_id,
            i.ingredient_name,
            pl.unit_price_actual AS unit_price,
            pl.ingredient_quantity AS quantity,
            pl.ingredient_unit AS unit_id,
            u.unit_name AS unit,
            po.location_id,
            l.location_name AS location,
            total_cost(pl.ingredient_quantity, pl.unit_price_actual) AS `total ($)`
        FROM purchase_order po
        JOIN purchase_list pl ON po.order_id = pl.order_id
        JOIN supplier s ON po.supplier_id = s.supplier_id
        JOIN ingredient i ON pl.ingredient_id = i.ingredient_id
        JOIN unit u ON pl.ingredient_unit = u.unit_id
        JOIN location l ON po.location_id = l.location_id
        WHERE po.purchase_date <= p_target_date
    ),
    latest_purchase_price_cte AS (
        SELECT * FROM latest WHERE rn = 1
    ),
    -- STEP 2: Exactly mirrors 'recipe_to_purchase_conversion' view
    recipe_to_purchase_conversion_cte AS (
        SELECT 
            lpp.supplier_id AS supplier_id,
            s.supplier_name AS supplier_name,
            m.location_id AS location_id,
            l.location_name AS location_name,
            ri.recipe_id AS recipe_id,
            r.recipe_name AS recipe_name,
            r.num_servings,
            ri.ingredient_id AS ingredient_id,
            i.ingredient_name AS ingredient_name,
            ri.ingredient_quantity AS ingredient_quantity,
            ri.ingredient_unit AS recipe_unit,
            ru.unit_name AS recipe_unit_name,
            CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lpp.unit_id) AS converted_quantity,
            lpp.unit_id AS purchase_unit,
            pu.unit_name AS purchase_unit_name,
            lpp.unit_price,
            total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lpp.unit_id), lpp.unit_price) AS total_cost
        FROM
            recipe_ingredients ri
            JOIN latest_purchase_price_cte lpp 
                ON ri.ingredient_id = lpp.ingredient_id
            JOIN menu m 
                ON ri.recipe_id = m.recipe_id 
                AND lpp.location_id = m.location_id
            JOIN unit ru 
                ON ri.ingredient_unit = ru.unit_id
            JOIN unit pu 
                ON lpp.unit_id = pu.unit_id
            JOIN recipe r 
                ON ri.recipe_id = r.recipe_id
            JOIN supplier s 
                ON lpp.supplier_id = s.supplier_id
            JOIN location l 
                ON lpp.location_id = l.location_id
            JOIN ingredient i 
                ON ri.ingredient_id = i.ingredient_id
        WHERE m.recipe_status = 'ACTIVE'
    )
    -- STEP 3: Exactly mirrors your 'get_recipe_cost' standard procedure
    SELECT 
        recipe_id,
        recipe_name,
        num_servings,
        location_id,
        location_name,
        p_target_date AS price_as_of_date,
        SUM(total_cost(converted_quantity, unit_price)) AS total_recipe_cost,
        (SUM(total_cost(converted_quantity, unit_price))/ num_servings) AS cost_per_serving
    FROM recipe_to_purchase_conversion_cte
    WHERE recipe_id = p_recipe_id AND location_id = p_location_id
    GROUP BY recipe_id, recipe_name, num_servings, location_id, location_name, p_target_date;
END //

DELIMITER ;