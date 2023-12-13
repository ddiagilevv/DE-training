import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta

conn = psycopg2.connect(
    dbname="TastePoint_source001",
    user="danila",
    password="mypass",
    host="localhost",
    port="5432"
)

cur = conn.cursor()
fake = Faker()

currencies = [
    (fake.uuid4(), fake.unique.random_element(elements=('USD', 'EUR', 'GBP')), fake.currency_name()) for _ in range(3)
]

regions = [
    (fake.uuid4(), fake.unique.random_element(elements=('North', 'South', 'East', 'West')), fake.timezone()) for _ in range(4)
]

countries = [
    (fake.uuid4(), fake.country(), random.choice(regions)[0], random.choice(currencies)[0]) for _ in range(10)
]

cities = [
    (fake.uuid4(), fake.city(), random.choice(countries)[0]) for _ in range(20)
]

holidays = [
    (fake.uuid4(), fake.word(), fake.date_between(start_date='-30d', end_date='+30d'), random.choice(countries)[0])
    for _ in range(50)
]

product_categories = [
    (fake.uuid4(), fake.word()) for _ in range(5)
]

supplier_types = [
    (fake.uuid4(), fake.word()) for _ in range(3)
]

restaurants = [
    (fake.uuid4(), fake.company(), random.choice(cities)[0]) for _ in range(10)
]

products = [
    (fake.uuid4(), fake.word(), random.choice(product_categories)[0]) for _ in range(50)
]

employees = [
    (fake.uuid4(), random.choice(restaurants)[0], fake.first_name(), fake.last_name(),
     fake.job(), fake.date_of_birth(minimum_age=18, maximum_age=65)) for _ in range(100)
]

customers = [
    (fake.uuid4(), fake.first_name(), fake.last_name(), fake.email(), random.randint(0, 1000))
    for _ in range(200)
]

orders = [
    (fake.uuid4(), random.choice(customers)[0], random.choice(restaurants)[0],
     fake.date_between(start_date='-30d', end_date='today'), round(random.uniform(10, 1000), 2),
     fake.random_element(elements=('Cash', 'Credit Card', 'PayPal'))) for _ in range(500)
]

order_details = [
    (fake.uuid4(), random.choice(orders)[0], random.choice(products)[0], random.randint(1, 10))
    for _ in range(1000)
]

shifts = [
    (fake.uuid4(), random.choice(employees)[0], fake.date_between(start_date='-30d', end_date='today'),
     fake.time(pattern='%H:%M:%S', end_datetime=datetime.now() + timedelta(hours=1)),
     fake.time(pattern='%H:%M:%S', end_datetime=datetime.now() + timedelta(hours=9))) for _ in range(500)
]

suppliers = [
    (fake.uuid4(), fake.company(), fake.name(), fake.email(), fake.phone_number(),
     random.choice(supplier_types)[0]) for _ in range(20)
]

supply_orders = [
    (fake.uuid4(), random.choice(suppliers)[0], fake.date_between(start_date='-30d', end_date='today'),
     fake.date_between(start_date='today', end_date='+30d')) for _ in range(50)
]

supply_order_details = [
    (fake.uuid4(), random.choice(supply_orders)[0], random.choice(products)[0], random.randint(10, 100))
    for _ in range(100)
]

inventory = [
    (fake.uuid4(), random.choice(products)[0], random.choice(restaurants)[0], random.randint(0, 1000),
     fake.date_between(start_date='-30d', end_date='today')) for _ in range(200)
]

menu = [
    (fake.uuid4(), random.choice(restaurants)[0], fake.word(), fake.text()) for _ in range(50)
]

ingredients = [
    (fake.uuid4(), fake.word(), fake.text()) for _ in range(20)
]

menu_item_ingredients = [
    (fake.uuid4(), random.choice(menu)[0], random.choice(ingredients)[0], random.randint(1, 5))
    for _ in range(100)
]

prices = [
    (fake.uuid4(), random.choice(products)[0], random.choice(suppliers)[0],
     round(random.uniform(1, 10), 2), fake.date_between(start_date='-30d', end_date='today')) for _ in range(200)
]

cur.executemany("INSERT INTO RefData.Currencies (CurrencyID, CurrencyCode, CurrencyName) VALUES (%s, %s, %s)", currencies)
cur.executemany("INSERT INTO RefData.Regions (RegionID, RegionName, TimeZone) VALUES (%s, %s, %s)", regions)
cur.executemany("INSERT INTO RefData.Countries (CountryID, CountryName, RegionID, CurrencyID) VALUES (%s, %s, %s, %s)",
                countries)
cur.executemany("INSERT INTO RefData.Cities (CityID, CityName, CountryID) VALUES (%s, %s, %s)", cities)
cur.executemany("INSERT INTO RefData.Holidays (HolidayID, HolidayName, Date, CountryID) VALUES (%s, %s, %s, %s)",
                holidays)
cur.executemany("INSERT INTO RefData.ProductCategories (CategoryID, CategoryName) VALUES (%s, %s)", product_categories)
cur.executemany("INSERT INTO RefData.SupplierTypes (SupplierTypeID, TypeName) VALUES (%s, %s)", supplier_types)
cur.executemany("INSERT INTO OperationalData.Restaurants (RestaurantID, RestaurantName, CityID) VALUES (%s, %s, %s)",
                restaurants)
cur.executemany("INSERT INTO OperationalData.Products (ProductID, ProductName, CategoryID) VALUES (%s, %s, %s)",
                products)
cur.executemany("INSERT INTO OperationalData.Employees (EmployeeID, RestaurantID, FirstName, LastName, Position, HireDate) VALUES (%s, %s, %s, %s, %s, %s)",
                employees)
cur.executemany("INSERT INTO OperationalData.Customers (CustomerID, FirstName, LastName, Email, LoyaltyPoints) VALUES (%s, %s, %s, %s, %s)",
                customers)
cur.executemany("INSERT INTO OperationalData.Orders (OrderID, CustomerID, RestaurantID, OrderDate, TotalAmount, PaymentMethod) VALUES (%s, %s, %s, %s, %s, %s)",
                orders)
cur.executemany("INSERT INTO OperationalData.OrderDetails (OrderDetailID, OrderID, ProductID, Quantity) VALUES (%s, %s, %s, %s)",
                order_details)
cur.executemany("INSERT INTO OperationalData.Shifts (ShiftID, EmployeeID, ShiftDate, StartTime, EndTime) VALUES (%s, %s, %s, %s, %s)",
                shifts)
cur.executemany("INSERT INTO OperationalData.Suppliers (SupplierID, SupplierName, ContactName, ContactEmail, ContactPhone, SupplierTypeID) VALUES (%s, %s, %s, %s, %s, %s)",
                suppliers)
cur.executemany("INSERT INTO OperationalData.SupplyOrders (SupplyOrderID, SupplierID, OrderDate, ExpectedDeliveryDate) VALUES (%s, %s, %s, %s)",
                supply_orders)
cur.executemany("INSERT INTO OperationalData.SupplyOrderDetails (SupplyOrderDetailID, SupplyOrderID, ProductID, Quantity) VALUES (%s, %s, %s, %s)",
                supply_order_details)
cur.executemany("INSERT INTO OperationalData.Inventory (InventoryID, ProductID, RestaurantID, Quantity, LastUpdated) VALUES (%s, %s, %s, %s, %s)",
                inventory)
cur.executemany("INSERT INTO OperationalData.Menu (MenuID, RestaurantID, ItemName, Description) VALUES (%s, %s, %s, %s)",
                menu)
cur.executemany("INSERT INTO OperationalData.Ingredients (IngredientID, Name, Description) VALUES (%s, %s, %s)",
                ingredients)
cur.executemany("INSERT INTO OperationalData.MenuItemIngredients (MenuItemIngredientID, MenuID, IngredientID, Quantity) VALUES (%s, %s, %s, %s)",
                menu_item_ingredients)
cur.executemany("INSERT INTO OperationalData.Prices (PriceID, ProductID, SupplierID, PricePerUnit, Date) VALUES (%s, %s, %s, %s, %s)",
                prices)

conn.commit()
conn.close()
