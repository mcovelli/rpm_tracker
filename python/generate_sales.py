import random
import pandas as pd

# Menu prices dictionary mapping (location_id, recipe_id) -> localized price
menu_prices = {
    (1, 1): 27.50, (1, 2): 24.20, (1, 3): 31.90, (1, 4): 20.90, (1, 5): 26.40,
    (1, 6): 28.60, (1, 7): 13.20, (1, 8): 15.40, (1, 9): 49.50, (1, 10): 17.60,
    (1, 11): 26.40, (1, 12): 27.50, (1, 13): 28.60, (1, 14): 35.20, (1, 15): 30.80,
    (1, 16): 11.00, (1, 17): 9.90, (1, 18): 29.70,
    (2, 1): 27.50, (2, 2): 24.20, (2, 3): 31.90, (2, 4): 20.90, (2, 5): 26.40,
    (2, 6): 28.60, (2, 8): 15.40, (2, 10): 17.60, (2, 11): 26.40, (2, 12): 27.50,
    (2, 13): 28.60, (2, 14): 35.20, (2, 15): 30.80, (2, 16): 11.00, (2, 17): 9.90,
    (2, 18): 29.70,
    (3, 1): 26.25, (3, 2): 23.10, (3, 4): 19.95, (3, 6): 27.30, (3, 7): 12.60,
    (3, 9): 47.25, (3, 11): 25.20, (3, 12): 26.25, (3, 13): 27.30, (3, 14): 33.60,
    (3, 15): 29.40, (3, 16): 10.50, (3, 17): 9.45, (3, 18): 28.35,
    (4, 1): 26.25, (4, 2): 23.10, (4, 3): 30.45, (4, 5): 25.20, (4, 6): 27.30,
    (4, 8): 14.70, (4, 9): 47.25, (4, 10): 16.80, (4, 11): 25.20, (4, 12): 26.25,
    (4, 13): 27.30, (4, 14): 33.60, (4, 15): 29.40, (4, 16): 10.50, (4, 17): 9.45,
    (4, 18): 28.35,
    (5, 1): 27.00, (5, 2): 23.76, (5, 3): 31.32, (5, 4): 20.52, (5, 7): 12.96,
    (5, 8): 15.12, (5, 10): 17.28, (5, 11): 25.92, (5, 12): 27.00, (5, 13): 28.08,
    (5, 14): 34.56, (5, 15): 30.24, (5, 16): 10.80, (5, 17): 9.72, (5, 18): 29.16,
    (6, 1): 28.75, (6, 2): 25.30, (6, 3): 33.35, (6, 4): 21.85, (6, 5): 27.60,
    (6, 6): 29.90, (6, 7): 13.80, (6, 8): 16.10, (6, 9): 51.75, (6, 10): 18.40,
    (6, 11): 27.60, (6, 12): 28.75, (6, 13): 29.90, (6, 14): 36.80, (6, 15): 32.20,
    (6, 16): 11.50, (6, 17): 10.35, (6, 18): 31.05,
    (7, 1): 23.75, (7, 2): 20.90, (7, 3): 27.55, (7, 4): 18.05, (7, 5): 22.80,
    (7, 6): 24.70, (7, 7): 11.40, (7, 8): 13.30, (7, 9): 42.75, (7, 10): 15.20,
    (7, 11): 22.80, (7, 12): 23.75, (7, 13): 24.70, (7, 14): 30.40, (7, 15): 26.60,
    (7, 16): 9.50, (7, 17): 8.55, (7, 18): 25.65,
    (8, 1): 27.00, (8, 2): 23.76, (8, 3): 31.32, (8, 4): 20.52, (8, 5): 25.92,
    (8, 6): 28.08, (8, 7): 12.96, (8, 8): 15.12, (8, 9): 48.60, (8, 10): 17.28,
    (8, 11): 25.92, (8, 12): 27.00, (8, 13): 28.08, (8, 14): 34.56, (8, 15): 30.24,
    (8, 16): 10.80, (8, 17): 9.72, (8, 18): 29.16
}

location_recipes = {}
for (loc_id, rec_id) in menu_prices.keys():
    location_recipes.setdefault(loc_id, []).append(rec_id)

random.seed(42)

sales_file = open("sales_inserts.sql", "w")
items_file = open("sales_items_inserts.sql", "w")

t_id = 1
start_date = pd.Timestamp('2025-01-01')
total_transactions = 5000

sales_file.write("START TRANSACTION;\n")
items_file.write("START TRANSACTION;\n")

for _ in range(total_transactions):
    loc_id = random.choice(list(location_recipes.keys()))
    days_offset = random.randint(0, 364)
    hour = random.randint(11, 22)
    minute = random.choice([0, 15, 30, 45])
    trans_date = start_date + pd.Timedelta(days=days_offset, hours=hour, minutes=minute)
    date_str = trans_date.strftime('%Y-%m-%d %H:%M:%S')
    
    sales_file.write(f"INSERT INTO sales (transaction_id, location_id, date_of_trans) VALUES ({t_id}, {loc_id}, '{date_str}');\n")
    
    num_items = random.randint(1, 4)
    chosen_recs = random.sample(location_recipes[loc_id], min(num_items, len(location_recipes[loc_id])))
    
    for rec_id in chosen_recs:
        qty = random.randint(1, 3)
        price = menu_prices[(loc_id, rec_id)]
        items_file.write(f"INSERT INTO sales_items (transaction_id, location_id, recipe_id, qty, price) VALUES ({t_id}, {loc_id}, {rec_id}, {qty}, {price:.2f});\n")
        
    t_id += 1

sales_file.write("COMMIT;\n")
items_file.write("COMMIT;\n")

sales_file.close()
items_file.close()
print("Generated SQL insert files successfully.")