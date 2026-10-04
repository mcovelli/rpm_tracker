CREATE VIEW price_pct_change AS (

	WITH prev_price AS (
		SELECT
			quote_id,
			quote_date,
			region_id,
			supplier_id,
			ingredient_id,
			unit_price_quote,
			ingredient_unit,
			lag(unit_price_quote, 1, NULL) OVER (PARTITION BY supplier_id, ingredient_id, region_id ORDER BY quote_date ASC) AS prev_price
		FROM price_quote
		GROUP BY ingredient_id, supplier_id, region_id, quote_id

	)

	SELECT
		*,
		calculate_percent_change(prev_price, unit_price_quote) AS pct_change
	FROM prev_price
)