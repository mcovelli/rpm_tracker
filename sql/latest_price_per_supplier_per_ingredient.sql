WITH latest AS (
    SELECT
        po.supplier_id,
        po.order_id,
        po.purchase_date,
        ROW_NUMBER() OVER (PARTITION BY po.supplier_id, pl.ingredient_id ORDER BY po.purchase_date DESC) AS rn,
        pl.ingredient_id,
        pl.unit_price_actual
    FROM purchase_order po
    JOIN purchase_list pl ON po.order_id = pl.order_id
)
SELECT * FROM latest WHERE rn = 1