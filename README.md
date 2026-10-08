# Recipe Cost & Margin Tracker

*RPM Tracker*

A MySQL schema designed for recipe costing, ingredient pricing, nutritional tracking and menu margin analysis across multiple restaurant locations. Built as a portfolio project alongside an application for a Culinary Operations Analyst role at Eataly, modeling recipe standardization, RPM (recipe, pricing, margin) tracking, cost-fluctuation monitoring and regulatory compliance.

## What's in this repo

| File | What it is |
|---|---|
| `schema.sql` | Full `CREATE TABLE` definitions for 19 tables with keys and foreign key constraints, plus custom functions, stored procedures and analytical views |
| `database.sql` | Fictional sample data including locations, suppliers, ingredients, purchase orders, baseline nutritional profiles, allergen mappings and inventory snapshots |
| `README.md` | This file |

## Schema overview

**Catalog**
- `ingredient` — every ingredient tracked with category
- `unit` — canonical list of measurement units
- `supplier` — vendors Eataly sources from
- `recipe` — dish definitions and serving counts

**Conversions**
- `unit_conversion` — fixed unit-to-unit rates (tbsp to cup, lb to kg)
- `ingredient_conversion` — ingredient-specific weight-per-volume and count-to-mass rates (ensuring irregular units like "each" or "cup" can convert precisely to grams)

**Recipes & menus**
- `recipe_ingredients` — which ingredients and quantities make up each recipe
- `location` — individual store locations
- `region` — geographic grouping of locations
- `menu` — which recipes are offered at which location and current status

**Nutritional & Compliance**
- `nutritional_info` — baseline macronutrient data (calories, fat, carbs, protein, sodium, cholesterol) strictly standardized to a 100-gram portion
- `allergens` — lookup table for major FDA allergens
- `ingredient_allergens` — normalized junction table mapping ingredients to allergens to prevent sparse data and allow infinite categorization

**Purchasing, Pricing & Sales**
- `purchase_order` — one row per order placed with a supplier tied to a location
- `purchase_list` — the line items within an order with actual price paid
- `price_quote` — supplier-offered prices by region used for comparison and cost forecasting
- `inventory` — periodic stock counts per ingredient per location over time
- `sales` & `sales_items` — transaction records mapping sold recipes to specific locations

## Core Database Logic

The schema moves beyond basic data storage by incorporating programmable logic to automate analytical workflows:
- **`convert_ingredient()`**: A custom function that evaluates the requested unit, references the dual conversion tables and mathematically translates any volume or count into strict gram weight for accurate nutritional and cost calculations.
- **Historical Costing**: Stored procedures like `get_recipe_cost_historical` audit past purchase orders to calculate exactly what a dish cost to produce on a specific date.
- **Margin Calculation**: The `get_profit_margin` procedure compares localized active menu prices against aggregated ingredient purchase costs to output real-time profitability.
- **Nutritional Aggregation**: Views like `recipe_nutritional_info` utilize the conversion function to scale the 100-gram baselines against actual recipe portions to output per-serving macronutrients.

## Next Steps: Business Intelligence Integration

The data engineering phase of this project is complete. The next phase focuses on transforming this relational data into actionable business intelligence using Tableau.

Upcoming deliverables include:
- **KPI Dashboards**: Connecting the MySQL database to Tableau to visualize regional menu profitability and monitor virtual menu performance.
- **Margin Trend Analysis**: Building charts to track historical supplier pricing fluctuations (e.g., a spike in imported olive oil costs) and identifying which active menu items have dropped below target margins.
- **Cost Control Modeling**: Demonstrating recipe optimization strategies by using the data to propose ingredient substitutions or portion adjustments that restore profit margins without increasing consumer pricing.
- **Regulatory Reporting**: Generating automated, formatted nutritional and allergen labels for QSR, Pronto and Fresh Pasta programs based on the aggregated view data.

## Getting started (viewing the database locally)

**Prerequisites:** MySQL Server 8+ and a client (MySQL Workbench, DBeaver or the `mysql` CLI)

**Command line:**
```bash
mysql -u <your_username> -p < schema.sql
mysql -u <your_username> -p restaurant < database.sql