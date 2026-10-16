-- expect 0 rows back after every data load
CREATE OR REPLACE VIEW conversion_gaps AS
SELECT ri.ingredient_id,
       ri.ingredient_unit AS recipe_unit,
       pl.ingredient_unit AS purchase_unit
FROM (SELECT DISTINCT ingredient_id, ingredient_unit FROM recipe_ingredients) ri
JOIN (SELECT DISTINCT ingredient_id, ingredient_unit FROM purchase_list) pl
  ON ri.ingredient_id = pl.ingredient_id

-- unit_conversion, both directions
LEFT JOIN unit_conversion ucf ON ucf.from_unit = pl.ingredient_unit AND ucf.to_unit   = ri.ingredient_unit
LEFT JOIN unit_conversion uct ON uct.from_unit = ri.ingredient_unit AND uct.to_unit   = pl.ingredient_unit

-- ingredient_conversion, both directions
LEFT JOIN ingredient_conversion icf ON icf.ingredient_id = pl.ingredient_id
                                   AND icf.from_unit = pl.ingredient_unit AND icf.to_unit = ri.ingredient_unit
LEFT JOIN ingredient_conversion ict ON ict.ingredient_id = ri.ingredient_id
                                   AND ict.from_unit = ri.ingredient_unit AND ict.to_unit = pl.ingredient_unit

WHERE ri.ingredient_unit <> pl.ingredient_unit      -- skip pairs that need no conversion
  AND ucf.from_unit IS NULL
  AND uct.from_unit IS NULL
  AND icf.from_unit IS NULL
  AND ict.from_unit IS NULL;                        -- all four lookups found nothing