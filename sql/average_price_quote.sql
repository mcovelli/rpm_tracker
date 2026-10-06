SELECT
	supplier_id,
	ingredient_id,
	CAST(AVG(unit_price_quote) AS DECIMAL(10, 2)) AS avg_price,
    ingredient_unit
FROM price_quote
GROUP BY ingredient_id, ingredient_unit, supplier_id
ORDER BY supplier_id, ingredient_id