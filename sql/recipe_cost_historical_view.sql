CREATE OR REPLACE VIEW recipe_cost_historical AS 
WITH purchase_record_rn AS (
	SELECT
		ROW_NUMBER() OVER (PARTITION BY ri.ingredient_id, m.location_id, po.supplier_id ORDER BY purchase_date DESC) AS rn,
        po.purchase_date,
        pl.ingredient_id,
        po.supplier_id AS supplier_id,
        m.location_id AS location_id,
        m.recipe_id,
        ri.ingredient_quantity,
        ri.ingredient_unit as recipe_unit,
        pl.ingredient_unit as purchase_unit,
        pl.unit_price_actual
	FROM purchase_list pl
    JOIN purchase_order po ON pl.order_id = po.order_id
    JOIN recipe_ingredients ri ON pl.ingredient_id = ri.ingredient_id
    JOIN menu m 
		ON ri.recipe_id = m.recipe_id 
		AND po.location_id = m.location_id
	ORDER BY m.location_id, m.recipe_id, purchase_date
)

SELECT 
		rn,
        pr.purchase_date,
        pr.supplier_id AS supplier_id,
        s.supplier_name AS supplier_name,
        pr.location_id AS location_id,
        l.location_name AS location_name,
        pr.recipe_id AS recipe_id,
        r.recipe_name AS recipe_name,
        r.num_servings,
        pr.ingredient_id AS ingredient_id,
        i.ingredient_name AS ingredient_name,
        pr.ingredient_quantity AS ingredient_quantity,
        pr.recipe_unit AS recipe_unit,
        ru.unit_name AS recipe_unit_name,
        CONVERT_INGREDIENT(pr.ingredient_id, pr.ingredient_quantity, pr.recipe_unit, pr.purchase_unit) AS converted_quantity,
        pr.purchase_unit AS purchase_unit,
        pu.unit_name AS purchase_unit_name,
        pr.unit_price_actual,
        total_cost(CONVERT_INGREDIENT(pr.ingredient_id, pr.ingredient_quantity, pr.recipe_unit, pr.purchase_unit), unit_price_actual) AS total_cost
    FROM
        purchase_record_rn pr
        JOIN unit ru 
			ON pr.recipe_unit = ru.unit_id
        JOIN unit pu 
			ON pr.purchase_unit = pu.unit_id
        JOIN recipe r 
			ON pr.recipe_id = r.recipe_id
        JOIN supplier s 
			ON pr.supplier_id = s.supplier_id
        JOIN location l 
			ON pr.location_id = l.location_id
        JOIN ingredient i 
			ON pr.ingredient_id = i.ingredient_id
	 GROUP BY pr.recipe_id, pr.ingredient_id, pr.supplier_id, pr.location_id, pr.purchase_unit, pr.recipe_unit, pr.unit_price_actual, pr.purchase_date
    -- ORDER BY pr.purchase_date, pr.location_id, r.recipe_id, pr.ingredient_id, s.supplier_id;