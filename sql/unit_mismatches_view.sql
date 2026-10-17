-- expect 0 rows back after every data load
-- ingredients whose unit in inventory differs from their unit in purchase_list
CREATE OR REPLACE VIEW unit_mismatches AS
SELECT inv.ingredient_id,
       inv.ingredient_unit AS inventory_units,
       pl.ingredient_unit AS purchase_unit
FROM (SELECT DISTINCT ingredient_id, ingredient_unit FROM inventory) inv
JOIN (SELECT DISTINCT ingredient_id, ingredient_unit FROM purchase_list) pl
  ON inv.ingredient_id = pl.ingredient_id


WHERE inv.ingredient_unit <> pl.ingredient_unit
