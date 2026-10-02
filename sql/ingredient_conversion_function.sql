DELIMITER //
CREATE FUNCTION convert_ingredient(p_ingredient_id smallint unsigned, p_ingredient_quantity DECIMAL(8,3), p_from_unit tinyint unsigned, p_to_unit tinyint unsigned)
RETURNS DECIMAL(8,3)
DETERMINISTIC
BEGIN
	DECLARE uc_rate DECIMAL(15,9);
    DECLARE ic_rate DECIMAL(15,9);
    
    if ((p_from_unit = p_to_unit) OR (p_to_unit = p_from_unit)) THEN
    RETURN p_ingredient_quantity;
    END IF;
    
    SELECT rate FROM unit_conversion WHERE p_from_unit = from_unit AND p_to_unit = to_unit INTO uc_rate;
    IF uc_rate IS NOT NULL THEN
    return p_ingredient_quantity * uc_rate;
    END IF;
    
	SELECT rate FROM unit_conversion WHERE p_from_unit = to_unit AND p_to_unit = from_unit INTO uc_rate;
    IF uc_rate IS NOT NULL THEN
    return p_ingredient_quantity * (1/uc_rate);
    END IF;

    SELECT rate FROM ingredient_conversion WHERE ingredient_id = p_ingredient_id AND p_from_unit = from_unit AND p_to_unit = to_unit INTO ic_rate;
    IF ic_rate IS NOT NULL THEN
    return p_ingredient_quantity * ic_rate;
    END IF;
    
	SELECT rate FROM ingredient_conversion WHERE ingredient_id = p_ingredient_id AND p_from_unit = to_unit AND p_to_unit = from_unit INTO ic_rate;
    IF ic_rate IS NOT NULL THEN
    return p_ingredient_quantity * (1/ic_rate);
    END IF;
	
    RETURN NULL;
END
// DELIMITER ;