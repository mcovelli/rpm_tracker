DELIMITER //

CREATE FUNCTION calculate_margin(p_recipe_price DECIMAL(15,9), p_recipe_cost DECIMAL(15,9))
RETURNS DECIMAL(15,9)
DETERMINISTIC
BEGIN
	DECLARE profit DECIMAL(15,9);

	SET profit = (p_recipe_price - p_recipe_cost);
    RETURN profit / p_recipe_price;

END;

// DELIMITER ;