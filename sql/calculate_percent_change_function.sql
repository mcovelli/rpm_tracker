DELIMITER //
CREATE FUNCTION calculate_percent_change(prev_amnt decimal(6,2), curr_amnt decimal(6,2))
RETURNS DECIMAL(10,3)
DETERMINISTIC
BEGIN
	DECLARE pct_change DECIMAL(10, 5);
    
	SET pct_change = ((curr_amnt - prev_amnt) / prev_amnt) * 100;
    RETURN pct_change;

END;

// DELIMITER ;