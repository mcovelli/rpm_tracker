SELECT DISTINCT r.recipe_name, i.ingredient_name, ri.ingredient_quantity, u.unit_name, r.num_servings
FROM recipe_ingredients ri
JOIN recipe r ON ri.recipe_id = r.recipe_id
JOIN unit u ON ri.ingredient_unit = u.unit_id
JOIN ingredient i ON ri.ingredient_id = i.ingredient_id
