-- Grain: one row per Location, Ingredient and Month

CREATE OR REPLACE VIEW inventory_monthly AS
SELECT
    location_id,
    ingredient_id,
    ingredient_category,
    month_start,
    usage_dollars,
    price_after_carry_forward * ending_stock AS ending_stock_value,
    price_is_estimate,
    (CASE
        WHEN usage_dollars IS NULL OR usage_dollars <= 0 THEN NULL
        ELSE (price_after_carry_forward * ending_stock) / usage_dollars
    END) AS months_of_supply,
    (CASE
        WHEN usage_dollars IS NULL THEN NULL
        WHEN usage_dollars < 0 THEN 1
        ELSE 0
    END) AS negative_usage_flag,
    (CASE
        WHEN usage_dollars IS NULL THEN NULL
        WHEN usage_dollars = 0 THEN 1
        ELSE 0
    END) AS zero_usage_flag
FROM ingredient_monthly_cost;