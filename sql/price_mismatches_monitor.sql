-- expect 0 rows back after every data load
-- a row can indicate an old sales price that differs from the current price
CREATE OR REPLACE VIEW price_mismatches AS
SELECT 
	si.location_id,
	si.recipe_id,
	m.price AS menu_price,
    si.price AS sales_price
FROM sales_items si
JOIN menu m ON si.location_id = m.location_id AND si.recipe_id = m.recipe_id
WHERE si.price <> m.price
GROUP BY si.location_id, si.recipe_id, si.price