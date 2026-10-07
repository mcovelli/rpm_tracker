DELIMITER //

CREATE FUNCTION calculate_margin(p_recipe_price DECIMAL(6,2), p_recipe_cost DECIMAL(6,2))
RETURNS DECIMAL(6,2)
DETERMINISTIC
BEGIN
	DECLARE profit DECIMAL(6,2);

	SET profit = (p_recipe_price - p_recipe_cost);
    RETURN profit / p_recipe_price;

END;

// DELIMITER ;