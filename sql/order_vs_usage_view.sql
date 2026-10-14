CREATE OR REPLACE VIEW order_vs_usage AS 

SELECT
	location_id,
    ingredient_id,
    month_start,
    quantity_purchased,
    usage_quantity,
    ending_stock,
    (CASE
        WHEN usage_quantity IS NULL OR usage_quantity <= 0 THEN NULL
        ELSE (quantity_purchased / usage_quantity)
    END) AS purchase_to_usage_ratio,
    (quantity_purchased - usage_quantity) AS purchase_to_usage_difference
FROM ingredient_monthly_cost
