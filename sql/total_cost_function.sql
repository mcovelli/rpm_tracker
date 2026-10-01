DELIMITER //

CREATE FUNCTION total_cost (ingredient_quantity decimal(8,3), unit_price decimal(10,2)) 
RETURNS decimal(6,2)
DETERMINISTIC
BEGIN
	RETURN (ingredient_quantity * unit_price);
END

//
DELIMITER ;