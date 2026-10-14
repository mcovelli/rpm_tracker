# Recipe Cost & Margin Tracker

*RPM Tracker*

A MySQL database for recipe costing, ingredient pricing, nutritional tracking and menu margin analysis across multiple restaurant locations. On top of the schema sit reporting views that compare what dishes should cost with what each location actually spent and how much stock each location holds. The views feed Tableau dashboards. Built as a portfolio project alongside an application for a Culinary Operations Analyst role at Eataly, it models recipe standardization, RPM (recipe, pricing, margin) tracking, cost-fluctuation monitoring and regulatory compliance.

All data in this project is fictional and was generated for demonstration.

## Project status

| Piece | Status |
|---|---|
| Schema, functions and stored procedures | Built |
| Sample data (8 locations, monthly from January 2025 to early October 2026) | Built |
| Base view: `ingredient_monthly_cost` | Built |
| View 1: `location_monthly_performance` | Built |
| View 2: `order_vs_usage` | Built |
| View 3: `inventory_monthly` | Built |
| View 4: `menu_engineering` | Planned |
| Tableau dashboards | Planned |

## What's in this repo

| File | What it is |
|---|---|
| `schema.sql` | Full `CREATE TABLE` definitions for 19 tables with keys and foreign key constraints, plus custom functions, stored procedures and analytical views |
| `database.sql` | Fictional sample data including locations, suppliers, ingredients, purchase orders, sales, baseline nutritional profiles, allergen mappings and inventory snapshots |
| `README.md` | This file |

## Schema overview

Catalog
- `ingredient`: every ingredient tracked with category
- `unit`: canonical list of measurement units
- `supplier`: vendors Eataly sources from
- `recipe`: dish definitions and serving counts

Conversions
- `unit_conversion`: fixed unit-to-unit rates (tbsp to cup, lb to kg)
- `ingredient_conversion`: ingredient-specific weight-per-volume and count-to-mass rates (so irregular units like "each" or "cup" convert precisely to grams)

Recipes & menus
- `recipe_ingredients`: which ingredients and quantities make up each recipe
- `location`: individual store locations
- `region`: geographic grouping of locations
- `menu`: which recipes are offered at which location and current status

Nutritional & Compliance
- `nutritional_info`: baseline macronutrient data (calories, fat, carbs, protein, sodium, cholesterol) standardized to a 100-gram portion
- `allergens`: lookup table for major FDA allergens
- `ingredient_allergens`: junction table mapping ingredients to allergens, which avoids sparse data and allows any number of categories

Purchasing, Pricing & Sales
- `purchase_order`: one row per order placed with a supplier, tied to a location
- `purchase_list`: the line items within an order with the actual price paid
- `price_quote`: supplier-offered prices by region, used for comparison and cost forecasting
- `inventory`: periodic stock counts per ingredient per location over time
- `sales` and `sales_items`: transaction records mapping sold recipes to specific locations

## Core database logic

The schema includes programmable logic to automate analytical workflows:
- `convert_ingredient()`: A custom function that reads the requested unit, checks the two conversion tables and translates any volume or count into gram weight for nutritional and cost calculations.
- Historical costing: Stored procedures like `get_recipe_cost_historical` use past purchase orders to calculate what a dish cost to produce on a specific date. The results (`recipe_cost_historical`) feed the reporting views below.
- Margin calculation: The `get_profit_margin` procedure compares localized active menu prices against aggregated ingredient purchase costs to output profitability.
- Nutritional aggregation: Views like `recipe_nutritional_info` use the conversion function to scale the 100-gram baselines to actual recipe portions and output per-serving macronutrients.

## Reporting views

Three reporting views read from one shared base view, so the price and usage logic exists in a single place. Create `ingredient_monthly_cost` first, because the other three depend on it.

### `ingredient_monthly_cost` (base view)

One row per location, ingredient and month, with the same row count as the `inventory` table. It holds the quantities and dollars that the other views build on: starting stock, ending stock, quantity purchased, usage, price, usage dollars and purchase dollars.

How usage and price are calculated
1. Usage in a month is starting stock plus purchases minus ending stock. Starting stock is the previous month's inventory count.
2. The price is the average paid in that month: total purchase dollars divided by total quantity bought for that location.
3. When an ingredient was not bought in a month, its last known price at the same location is carried forward.
4. Usage dollars are usage times price, calculated per ingredient.
5. `price_is_estimate` is 1 on rows that use a carried-forward price and 0 otherwise.

### `location_monthly_performance`

One row per location per month. It holds sales, year-over-year change, ticket count, average ticket and three versions of food cost, each with a percent of sales:

| Measure | How it is calculated |
|---|---|
| Theoretical food cost | Quantity of each recipe sold, multiplied by that recipe's average cost per serving for the same location and month, then summed |
| Purchase food cost | Total dollars on purchase orders placed in the month. This is a proxy, because buying more or less than the kitchen used moves it up or down |
| Actual food cost | Usage dollars from the base view, summed across ingredients to the location-month |

The gap columns show the difference in dollars and in percentage points between the cost measures. A positive gap means the cost measured is higher than theoretical. `estimated_price_count` shows how many ingredients in a location-month used a carried-forward price.

### `order_vs_usage`

One row per location, ingredient and month. It compares quantity purchased with quantity used and also shows ending stock, the ratio of purchases to usage and the difference between them. It is the view for spotting ingredients that are bought faster than they are used. The ratio is NULL when usage is NULL, zero or negative.

### `inventory_monthly`

One row per location, ingredient and month, with the ingredient category as an attribute. It answers which locations and categories hold more stock than they need.

| Column | What it holds |
|---|---|
| `ending_stock_value` | Ending stock times the price in dollars |
| `usage_dollars` | Usage valued in dollars for the month |
| `months_of_supply` | Ending stock value divided by usage dollars. NULL when usage is NULL, zero or negative |
| `negative_usage_flag` | 1 when usage is below zero, NULL when usage is unknown |
| `zero_usage_flag` | 1 when usage is exactly zero, NULL when usage is unknown |
| `price_is_estimate` | 1 when the stock value rests on a carried-forward price |

Ratios do not add up, so months of supply at any level above a single row is the sum of ending stock value divided by the sum of usage dollars. Both dollar columns stay in the view for that reason. The query is the same for a location, a category or both.

## What the data shows

These results use February 2025 through September 2026, which excludes January 2025 (no usage) and the partial October 2026. The data is fictional, so they show what the views can find, not facts about a real business.

- Dallas holds about 0.37 months of supply. The other seven locations run from about 0.20 to 0.26.
- Dallas is higher than the other seven locations combined in all 12 ingredient categories, by 1.3 times (Oil) to 2.2 times (Seafood). The gap is not explained by category mix.
- Dallas also has the largest cost gap: actual food cost runs about 11.1 percent of sales above theoretical. Las Vegas is next at 5.7 percent and the other six run from 2.4 to 4.0 percent.
- Las Vegas has a large cost gap without extra stock, so it needs a different explanation.
- Extra stock and extra unexplained cost are consistent with spoilage, but the data cannot rule out portioning or count error.
- Carried-forward prices make up between 2.0 and 6.3 percent of rows by location. Dallas is 4.0 percent.

## Known limits and assumptions

- Prices are an approximation. The price used for actual food cost and stock value is the average paid in the month, carried forward when nothing was bought. It is not FIFO costing and does not track individual lots, so it will not match what an accounting system would report.
- January 2025 has no actual food cost. The first month has no starting stock, so usage and actual cost are NULL for every location.
- October 2026 is incomplete. The data ends on 2026-10-08, so sales, purchases and costs for that month cover only part of it. The views still include it. Filter it out in Tableau with a data source filter, and read its year-over-year change with care because it compares a partial month with a full one.
- Units are assumed to match. Purchase quantities and inventory counts are assumed to use the same unit for each ingredient. A formal check of this is still on the to-do list.
- Inventory counts carry noise. Small negative usage values appear on 9 of 9,196 rows and zero usage on 40. They pass through to the totals and are flagged in `inventory_monthly`.
- Usage cannot separate waste from consumption. Anything that spoils or is discarded disappears from the shelf and counts as usage. Compare actual food cost with theoretical food cost to see unexplained cost.

## Next steps

1. Check unit consistency. Confirm that `ingredient_unit` in `purchase_list` and `inventory` agrees for every ingredient.
2. Build `menu_engineering`. Menu items by popularity and margin.
3. Build the Tableau dashboards on these views.
   - Location performance: sales, theoretical, purchase and actual food cost over time, with the gaps by location.
   - Ordering versus usage: purchases against usage by ingredient and location.
   - Inventory: months of supply by location and category.
   - Margin trends: historical supplier price changes (for example, a spike in imported olive oil) and which active menu items fall below target margin.
   - Percent and ratio columns are built in Tableau from the dollar and quantity columns as ratios of sums, never averaged.
4. Cost control modeling. Use the data to propose ingredient substitutions or portion changes that restore margins without raising menu prices.
5. Regulatory reporting. Generate formatted nutritional and allergen labels for QSR, Pronto and Fresh Pasta programs from the aggregated views.

## Getting started (viewing the database locally)

Prerequisites: MySQL Server 8+ and a client (MySQL Workbench, DBeaver or the `mysql` CLI)

Command line:
```bash
mysql -u <your_username> -p < schema.sql
mysql -u <your_username> -p restaurant < database.sql
```
