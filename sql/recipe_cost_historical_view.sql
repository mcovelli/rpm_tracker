-- Rebuilt by realism_update.py (divides recipe quantities by ingredient.yield_pct). Needs the yield_pct column.
CREATE OR REPLACE VIEW recipe_cost_historical AS
WITH last_line_per_day AS (
    SELECT po.location_id, pl.ingredient_id, po.purchase_date,
           pl.unit_price_actual, pl.ingredient_unit,
           ROW_NUMBER() OVER (PARTITION BY po.location_id, pl.ingredient_id, po.purchase_date
                              ORDER BY pl.list_id DESC) AS rn_day
    FROM purchase_order po
    JOIN purchase_list pl ON pl.order_id = po.order_id
),
price_events AS (
    SELECT location_id, ingredient_id, purchase_date, unit_price_actual, ingredient_unit
    FROM last_line_per_day
    WHERE rn_day = 1
),
converted AS (
    SELECT DISTINCT ri.recipe_id, ri.ingredient_id, pu.ingredient_unit AS purchase_unit,
           convert_ingredient(ri.ingredient_id, ri.ingredient_quantity / (i.yield_pct / 100),
                              ri.ingredient_unit, pu.ingredient_unit) AS qty
    FROM recipe_ingredients ri
    JOIN ingredient i ON i.ingredient_id = ri.ingredient_id
    JOIN (SELECT DISTINCT ingredient_id, ingredient_unit FROM purchase_list) pu
      ON pu.ingredient_id = ri.ingredient_id
),
line_cost AS (
    SELECT pe.location_id, ri.recipe_id, ri.ingredient_id, pe.purchase_date,
           ROUND(cv.qty * pe.unit_price_actual, 2) AS line_cost
    FROM price_events pe
    JOIN recipe_ingredients ri ON ri.ingredient_id = pe.ingredient_id
    JOIN menu m ON m.location_id = pe.location_id AND m.recipe_id = ri.recipe_id
    JOIN converted cv ON cv.recipe_id = ri.recipe_id AND cv.ingredient_id = ri.ingredient_id
                     AND cv.purchase_unit = pe.ingredient_unit
),
moves AS (
    SELECT location_id, recipe_id, purchase_date,
           COALESCE(line_cost, 0)
             - COALESCE(LAG(line_cost) OVER (PARTITION BY location_id, recipe_id, ingredient_id
                                             ORDER BY purchase_date), 0) AS move,
           CASE WHEN LAG(line_cost) OVER (PARTITION BY location_id, recipe_id, ingredient_id
                                          ORDER BY purchase_date) IS NULL THEN 1 ELSE 0 END AS first_buy
    FROM line_cost
),
per_day AS (
    SELECT location_id, recipe_id, purchase_date, SUM(move) AS move, SUM(first_buy) AS first_buys
    FROM moves
    GROUP BY location_id, recipe_id, purchase_date
),
running AS (
    SELECT location_id, recipe_id, purchase_date,
           SUM(move) OVER (PARTITION BY location_id, recipe_id ORDER BY purchase_date) AS total_recipe_cost,
           SUM(first_buys) OVER (PARTITION BY location_id, recipe_id ORDER BY purchase_date) AS ingredients_priced
    FROM per_day
),
recipe_size AS (
    SELECT recipe_id, COUNT(DISTINCT ingredient_id) AS n_ingredients
    FROM recipe_ingredients
    GROUP BY recipe_id
)
SELECT c.purchase_date, c.location_id, l.location_name, c.recipe_id, r.recipe_name,
       r.num_servings, c.total_recipe_cost, c.total_recipe_cost / r.num_servings AS cost_per_serving
FROM running c
JOIN recipe_size rs ON rs.recipe_id = c.recipe_id AND c.ingredients_priced = rs.n_ingredients
JOIN location l ON l.location_id = c.location_id
JOIN recipe r ON r.recipe_id = c.recipe_id;
