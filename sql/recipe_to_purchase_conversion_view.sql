CREATE OR REPLACE
VIEW recipe_to_purchase_conversion AS
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
        total_cost(CONVERT_INGREDIENT(ri.ingredient_id, ri.ingredient_quantity, ri.ingredient_unit, lpp.unit_id), unit_price) AS total_cost
    FROM
        recipe_ingredients ri
        JOIN latest_purchase_price lpp 
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
    -- GROUP BY m.recipe_id, ri.ingredient_id, lpp.supplier_id, m.location_id, lpp.unit_id, converted_quantity, lpp.unit_price
	ORDER BY m.location_id, r.recipe_id, ri.ingredient_id, s.supplier_id