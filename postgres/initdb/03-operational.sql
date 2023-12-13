CREATE SCHEMA IF NOT EXISTS OperationalData;

CREATE TABLE IF NOT EXISTS OperationalData.Restaurants (
    RestaurantID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RestaurantName VARCHAR(255),
    CityID UUID,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (CityID) REFERENCES RefData.Cities(CityID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Products (
    ProductID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ProductName VARCHAR(100),
    CategoryID UUID,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (CategoryID) REFERENCES RefData.ProductCategories(CategoryID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Employees (
    EmployeeID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RestaurantID UUID,
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Position VARCHAR(100),
    HireDate DATE,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (RestaurantID) REFERENCES OperationalData.Restaurants(RestaurantID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Customers (
    CustomerID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    FirstName VARCHAR(100),
    LastName VARCHAR(100),
    Email VARCHAR(100),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    LoyaltyPoints INT
);

CREATE TABLE IF NOT EXISTS OperationalData.Orders (
    OrderID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    CustomerID UUID,
    RestaurantID UUID,
    OrderDate DATE,
    TotalAmount DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (CustomerID) REFERENCES OperationalData.Customers(CustomerID),
    FOREIGN KEY (RestaurantID) REFERENCES OperationalData.Restaurants(RestaurantID)
);

CREATE TABLE IF NOT EXISTS OperationalData.OrderDetails (
    OrderDetailID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    OrderID UUID,
    ProductID UUID,
    Quantity INT,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (OrderID) REFERENCES OperationalData.Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES OperationalData.Products(ProductID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Shifts (
    ShiftID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    EmployeeID UUID,
    ShiftDate DATE,
    StartTime TIME,
    EndTime TIME,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (EmployeeID) REFERENCES OperationalData.Employees(EmployeeID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Suppliers (
    SupplierID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    SupplierName VARCHAR(100),
    ContactName VARCHAR(100),
    ContactEmail VARCHAR(100),
    ContactPhone VARCHAR(50),
    SupplierTypeID UUID,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (SupplierTypeID) REFERENCES RefData.SupplierTypes(SupplierTypeID)
);

CREATE TABLE IF NOT EXISTS OperationalData.SupplyOrders (
    SupplyOrderID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    SupplierID UUID,
    OrderDate DATE,
    ExpectedDeliveryDate DATE,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (SupplierID) REFERENCES OperationalData.Suppliers(SupplierID)
);

CREATE TABLE IF NOT EXISTS OperationalData.SupplyOrderDetails (
    SupplyOrderDetailID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    SupplyOrderID UUID,
    ProductID UUID,
    Quantity INT,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (SupplyOrderID) REFERENCES OperationalData.SupplyOrders(SupplyOrderID),
    FOREIGN KEY (ProductID) REFERENCES OperationalData.Products(ProductID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Inventory (
    InventoryID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ProductID UUID,
    RestaurantID UUID,
    Quantity INT,
    LastUpdated DATE,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (ProductID) REFERENCES OperationalData.Products(ProductID),
    FOREIGN KEY (RestaurantID) REFERENCES OperationalData.Restaurants(RestaurantID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Menu (
    MenuID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    RestaurantID UUID,
    ItemName VARCHAR(255),
    Description TEXT,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (RestaurantID) REFERENCES OperationalData.Restaurants(RestaurantID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Ingredients (
    IngredientID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    Name VARCHAR(255),
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    Description TEXT
);

CREATE TABLE IF NOT EXISTS OperationalData.MenuItemIngredients (
    MenuItemIngredientID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    MenuID UUID,
    IngredientID UUID,
    Quantity INT,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (MenuID) REFERENCES OperationalData.Menu(MenuID),
    FOREIGN KEY (IngredientID) REFERENCES OperationalData.Ingredients(IngredientID)
);

CREATE TABLE IF NOT EXISTS OperationalData.Prices (
    PriceID UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    ProductID UUID,
    SupplierID UUID,
    PricePerUnit DECIMAL(10, 2),
    Date DATE,
    lastupdatedtime TIMESTAMP DEFAULT current_timestamp,
    FOREIGN KEY (ProductID) REFERENCES OperationalData.Products(ProductID),
    FOREIGN KEY (SupplierID) REFERENCES OperationalData.Suppliers(SupplierID)
);
