DELIMITER //

CREATE FUNCTION total_cost (ingredient_quantity decimal(15,9), unit_price decimal(15,9)) 
RETURNS decimal(15,9)
DETERMINISTIC
BEGIN
	RETURN (ingredient_quantity * unit_price);
END

//
DELIMITER ;