CREATE FUNCTION convert_ingredient(ingredient_id smallint unsigned, ingredient_quantity DECIMAL(8,3), from_unit tinyint unsigned, to_unit tinyint unsigned)
RETURNS DECIMAL(8,3)
DETERMINISTIC
BEGIN
	IF (from_unit = to_unit, ingredient_quantity)
    
END