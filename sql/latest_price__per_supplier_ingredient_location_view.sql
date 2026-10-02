CREATE OR REPLACE VIEW latest_purchase_price AS
WITH latest AS (
    SELECT
		ROW_NUMBER() OVER (PARTITION BY po.supplier_id, pl.ingredient_id, l.location_id ORDER BY po.purchase_date DESC) AS rn,
        po.order_id,
        po.purchase_date,
        po.supplier_id,
        s.supplier_name AS supplier,
        pl.ingredient_id,
        i.ingredient_name,
        pl.unit_price_actual AS unit_price,
        pl.ingredient_quantity AS quantity,
        pl.ingredient_unit AS unit_id,
        u.unit_name AS unit,
        po.location_id,
        l.location_name AS location,
        total_cost(pl.ingredient_quantity, pl.unit_price_actual) AS `total ($)`
    FROM purchase_order po
    JOIN purchase_list pl ON po.order_id = pl.order_id
    JOIN supplier s ON po.supplier_id = s.supplier_id
    JOIN ingredient i ON pl.ingredient_id = i.ingredient_id
    JOIN unit u ON pl.ingredient_unit = u.unit_id
    JOIN location l ON po.location_id = l.location_id
)
SELECT * FROM latest WHERE rn = 1