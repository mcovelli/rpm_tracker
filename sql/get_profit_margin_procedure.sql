CREATE PROCEDURE get_profit_margin(p_recipe_id smallint unsigned, p_location_id tinyint unsigned)
	SELECT 
        rc.recipe_id,
        rc.recipe_name,
        rc.num_servings,
        rc.location_id,
        rc.location_name,
        (SUM(total_cost) / num_servings) AS cost_per_serving,
        m.price AS price_per_serving,
        calculate_margin(m.price, (SUM(total_cost) / num_servings)) AS profit_margin
    FROM recipe_to_purchase_conversion rc
    JOIN menu m ON rc.recipe_id = m.recipe_id AND rc.location_id = m.location_id
    WHERE rc.recipe_id = p_recipe_id AND rc.location_id = p_location_id
    GROUP BY rc.recipe_id, rc.recipe_name, rc.location_id, rc.location_id, num_servings, m.price;