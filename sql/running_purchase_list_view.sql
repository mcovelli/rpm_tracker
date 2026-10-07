CREATE OR REPLACE VIEW running_purchase_list AS
WITH latest AS (
    SELECT
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
SELECT * FROM latest
ORDER BY location, supplier_id, purchase_date DESC;