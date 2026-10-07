CREATE VIEW recipe_nutritional_info AS
SELECT
	ri.recipe_id,
    r.recipe_name,
    CAST(SUM(
		(ni.calories * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100)
			/ r.num_servings)) AS UNSIGNED) AS calories_per_serving,
    CAST(SUM(
		(ni.total_fat_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS fat_per_serving,
	CAST(SUM(
		(ni.saturated_fat_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS saturated_fat_per_serving,
	CAST(SUM(
		(ni.trans_fat_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS tans_fat_per_serving,
	CAST(SUM(
		(ni.cholesterol_mg * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS cholesterol_per_serving,
	CAST(SUM(
		(ni.sodium_mg * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS sodium_per_serving,
	CAST(SUM(
		(ni.total_carbs_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS carbs_per_serving,
	CAST(SUM(
		(ni.sugars_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS sugars_per_serving,
	CAST(SUM(
		(ni.fiber_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS fiber_per_serving,
	CAST(SUM(
		(ni.protein_g * (convert_ingredient(ni.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, 3) / 100) 
			/ r.num_servings)) AS DECIMAL(5,1)) AS protein_per_serving
FROM nutritional_info ni
JOIN recipe_ingredients ri ON ni.ingredient_id = ri.ingredient_id
JOIN recipe r ON ri.recipe_id = r.recipe_id
JOIN ingredient i ON ni.ingredient_id = i.ingredient_id
JOIN unit u ON ri.ingredient_unit = u.unit_id
GROUP BY ri.recipe_id, r.recipe_name, num_servings