WITH recipe_purchase AS (
	SELECT ri.ingredient_id, pl.ingredient_unit AS purchase_unit, ri.ingredient_unit AS recipe_unit
	FROM recipe_ingredients ri
	JOIN purchase_list pl ON ri.ingredient_id = pl.ingredient_id
	GROUP BY ri.ingredient_id, purchase_unit, recipe_unit
    HAVING recipe_unit != purchase_unit
    ORDER BY ri.ingredient_id ASC
)

SELECT *
FROM recipe_purchase rp
LEFT JOIN unit_conversion uc ON uc.from_unit = rp.purchase_unit AND uc.to_unit = rp.recipe_unit
LEFT JOIN ingredient_conversion ic ON ic.from_unit = rp.purchase_unit AND ic.to_unit = rp.recipe_unit AND ic.ingredient_id = rp.ingredient_id