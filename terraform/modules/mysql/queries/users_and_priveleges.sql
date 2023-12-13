CREATE USER 'readonlyuser'@'%' IDENTIFIED BY 'readonlyuserpassword';

CREATE VIEW target_data.view_for_readonlyuser AS
SELECT
    'MASKED' AS customer_firstname,  
    'MASKED' AS customer_lastname,   
    customers.email AS customer_email,
    
    'MASKED' AS employee_firstname,  
    'MASKED' AS employee_lastname,   
    
    suppliers.suppliername AS supplier_name,
    'MASKED' AS supplier_contactname,   
    'MASKED' AS supplier_contactemail
FROM 
    target_data.customers,
    target_data.employees,
    target_data.suppliers;

GRANT SELECT, SHOW VIEW ON target_data.view_for_readonlyuser TO 'readonlyuser'@'%';
FLUSH PRIVILEGES;