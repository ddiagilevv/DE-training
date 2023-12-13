ALTER TABLE customers ADD INDEX idx_customerid (customerid);
ALTER TABLE restaurants ADD INDEX idx_restaurantid (restaurantid);
ALTER TABLE employees ADD INDEX idx_employeeid (employeeid);
ALTER TABLE products ADD INDEX idx_productid (productid);
ALTER TABLE orders ADD INDEX idx_orderid (orderid);
ALTER TABLE suppliers ADD INDEX idx_supplierid (supplierid);
ALTER TABLE supplyorders ADD INDEX idx_supplyorderid (supplyorderid);

ALTER TABLE employees
ADD CONSTRAINT fk_employees_restaurant
FOREIGN KEY (restaurantid) REFERENCES restaurants(restaurantid);

ALTER TABLE productprices
ADD CONSTRAINT fk_productprices_product
FOREIGN KEY (productid) REFERENCES products(productid);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (customerid) REFERENCES customers(customerid),
ADD CONSTRAINT fk_orders_restaurant
FOREIGN KEY (restaurantid) REFERENCES restaurants(restaurantid);

ALTER TABLE orderdetails
ADD CONSTRAINT fk_orderdetails_order
FOREIGN KEY (orderid) REFERENCES orders(orderid),
ADD CONSTRAINT fk_orderdetails_product
FOREIGN KEY (productid) REFERENCES products(productid);

ALTER TABLE shifts
ADD CONSTRAINT fk_shifts_employee
FOREIGN KEY (employeeid) REFERENCES employees(employeeid);

ALTER TABLE supplyorders
ADD CONSTRAINT fk_supplyorders_supplier
FOREIGN KEY (supplierid) REFERENCES suppliers(supplierid);

ALTER TABLE supplyorderdetails
ADD CONSTRAINT fk_supplyorderdetails_supplyorder
FOREIGN KEY (supplyorderid) REFERENCES supplyorders(supplyorderid),
ADD CONSTRAINT fk_supplyorderdetails_product
FOREIGN KEY (productid) REFERENCES products(productid);

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_product
FOREIGN KEY (productid) REFERENCES products(productid),
ADD CONSTRAINT fk_inventory_restaurant
FOREIGN KEY (restaurantid) REFERENCES restaurants(restaurantid);
