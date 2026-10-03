DELIMITER //

CREATE PROCEDURE get_recipe_cost (
recipe smallint unsigned,
location tinyint unsigned
)

BEGIN
    SELECT 
		recipe_id,
		recipe_name,
		num_servings,
		location_id,
        location_name,
		SUM(total_cost(converted_quantity, unit_price)) AS total_recipe_cost,
		(SUM(total_cost(converted_quantity, unit_price))/ num_servings) AS cost_per_serving
	FROM recipe_to_purchase_conversion
    WHERE recipe_id = recipe AND location_id = location
	GROUP BY recipe_id, recipe_name, num_servings, location_id;
END;

// 
DELIMITER ;