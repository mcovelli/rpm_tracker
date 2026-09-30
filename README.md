# Recipe Cost & Margin Tracker

*RPM Tracker*

A MySQL schema for recipe costing, ingredient pricing, and menu margin tracking across multiple restaurant locations. Built as a portfolio project alongside an application for a Culinary Operations Analyst role, modeling the kind of recipe standardization, RPM (recipe, pricing, margin) tracking, and cost-fluctuation monitoring that role covers.

## What's in this repo

| File | What it is |
|---|---|
| `schema.sql` | Full `CREATE TABLE` definitions for all 14 tables, with keys and foreign key constraints |
| `sample_data.sql` | One year (calendar 2025) of fictional sample data — locations, suppliers, ingredients, recipes, purchase orders, price quotes, and inventory snapshots |
| `.env.example` | Template for local database credentials, only needed if you connect a script to the database later |
| `README.md` | This file |


## Schema overview

**Catalog**
- `ingredient` — every ingredient tracked, with category
- `unit` — canonical list of measurement units
- `supplier` — vendors Eataly sources from
- `recipe` — dish definitions and serving counts

**Conversions**
- `unit_conversion` — fixed unit-to-unit rates (tbsp to cup, etc.), the same for any ingredient
- `ingredient_conversion` — ingredient-specific weight-per-volume rates (a cup of flour weighs differently than a cup of honey)

**Recipes & menus**
- `recipe_ingredients` — which ingredients and quantities make up each recipe
- `location` — individual store locations
- `region` — geographic grouping of locations
- `menu` — which recipes are offered at which location, and current status

**Purchasing & pricing**
- `purchase_order` — one row per order placed with a supplier, tied to a location
- `purchase_list` — the line items within an order, actual price paid
- `price_quote` — supplier-offered prices by region, separate from what was actually purchased, used for comparison and cost forecasting

**Inventory**
- `inventory` — periodic stock counts per ingredient, per location, over time

## Getting started (viewing the database locally)

**Prerequisites:** MySQL Server 8+ and a client (MySQL Workbench, DBeaver, or the `mysql` CLI)

**Command line:**
```
mysql -u <your_username> -p < schema.sql
mysql -u <your_username> -p restaurant < sample_data.sql
```
The first command creates the `restaurant` database and every table. The second loads it with a year of sample data.

**MySQL Workbench:**
1. Server → Data Import → Import from Self-Contained File
2. Select `schema.sql`, run the import
3. Repeat with `sample_data.sql`
4. Open the `restaurant` schema in the Navigator panel to browse tables

No credentials file is needed just to browse the schema in a client. `.env.example` only matters once a script connects to the database programmatically.

## Notes on the sample data

- All supplier, location, and contact names are fictional, created for demonstration purposes, not real business records
- Data spans calendar year 2025 across 5 locations, 3 regions, and 8 suppliers
- Includes a built-in upward price drift on a couple of ingredients so margin and forecasting queries have a real trend to catch
