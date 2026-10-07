CREATE OR REPLACE VIEW recipe_cost AS
	SELECT 
        recipe_id,
        recipe_name,
        num_servings,
        location_id,
        location_name,
        SUM(total_cost) AS total_recipe_cost,
        (SUM(total_cost) / num_servings) AS cost_per_serving
    FROM recipe_to_purchase_conversion
    GROUP BY recipe_id, recipe_name, num_servings, location_id, location_name;
