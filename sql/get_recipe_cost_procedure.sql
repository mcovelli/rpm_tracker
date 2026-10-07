DELIMITER //

DROP PROCEDURE IF EXISTS get_recipe_cost;

CREATE PROCEDURE get_recipe_cost (
    IN p_recipe_id SMALLINT UNSIGNED,
    IN p_location_id TINYINT UNSIGNED
)
BEGIN
    SELECT 
        recipe_id,
        recipe_name,
        num_servings,
        location_id,
        location_name,
        SUM(total_cost) AS total_recipe_cost,
        (SUM(total_cost) / num_servings) AS cost_per_serving
    FROM recipe_to_purchase_conversion
    WHERE recipe_id = p_recipe_id AND location_id = p_location_id
    GROUP BY recipe_id, recipe_name, num_servings, location_id, location_name;
END //

DELIMITER ;