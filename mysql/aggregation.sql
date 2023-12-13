CREATE PROCEDURE GetSupplyChainAnalysis(IN startdate DATE, IN enddate DATE)
BEGIN
    INSERT INTO agg_data.supplyChainAnalysis (
        Date, 
        SupplierID, 
        RestaurantID, 
        TotalSuppliedItems, 
        TotalSupplyOrderValue, 
        AverageDeliveryTime, 
        TopSuppliedProduct, 
        InventoryReplenishmentRate
    )
    SELECT
        supplyorders.orderdate,
        supplyorders.supplierid,
        inventory.restaurantid,
        SUM(supplyorderdetails.quantity),
        SUM(supplyorderdetails.quantity * productprices.price),
        AVG(DATEDIFF(supplyorders.expecteddeliverydate, supplyorders.orderdate)),
        SUBSTRING_INDEX(GROUP_CONCAT(products.productname ORDER BY supplyorderdetails.quantity DESC SEPARATOR ','), ',', 1) AS TopSuppliedProduct,
        (
            SELECT AVG(inventorychange)
            FROM (
                SELECT (inventory.quantity - LAG(inventory.quantity, 1, inventory.quantity) OVER (PARTITION BY inventory.productid ORDER BY inventory.lastupdated)) AS inventorychange
                FROM target_data.inventory
            ) AS inventorychanges
        ) AS InventoryReplenishmentRate
    FROM target_data.supplyorders
    INNER JOIN target_data.supplyorderdetails ON supplyorders.supplyorderid = supplyorderdetails.supplyorderid
    INNER JOIN target_data.productprices ON supplyorderdetails.productid = productprices.productid
    INNER JOIN target_data.products ON supplyorderdetails.productid = products.productid
    INNER JOIN target_data.inventory ON products.productid = inventory.productid
    WHERE supplyorders.orderdate BETWEEN startdate AND enddate
      AND productprices.effectivedate <= supplyorders.orderdate
      AND (productprices.enddate IS NULL OR productprices.enddate >= supplyorders.orderdate)
    GROUP BY supplyorders.orderdate, supplyorders.supplierid, inventory.restaurantid;
END;
