-- 1)
BEGIN TRANSACTION;
UPDATE Production.Product SET ListPrice = ListPrice*1.1
WHERE ProductID = 680;
COMMIT;

-- 2)
BEGIN TRANSACTION;
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
DELETE FROM Production.Product
WHERE ProductID = 707;
ROLLBACK;

EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

-- 3)
BEGIN TRANSACTION;
SET IDENTITY_INSERT Production.Product ON;
INSERT INTO Production.Product(ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate) 
VALUES (1002, 'Produkt taki fajny1', 'GH-B123-45', 0, 0, 100, 999, 1000, 50, 20, '2013-05-30 00:00:00.000');
SET IDENTITY_INSERT Production.Product OFF;
COMMIT;

--BEGIN TRANSACTION;
--SET IDENTITY_INSERT Production.Product ON;
--INSERT INTO Production.Product(ProductID, ) 
--SET IDENTITY_INSERT Production.Product OFF;

-- 4)
BEGIN TRANSACTION;
UPDATE Production.Product SET StandardCost=StandardCost*1.1
IF ((SELECT SUM(StandardCost) FROM Production.Product) < 50000)
	COMMIT;
ELSE
	ROLLBACK

-- 5)
BEGIN TRANSACTION;
IF NOT EXISTS(SELECT ProductNumber FROM Production.Product WHERE ProductNumber='GH-Y643-45')
BEGIN
	SET IDENTITY_INSERT Production.Product ON;
	INSERT INTO Production.Product(ProductID, Name, ProductNumber, MakeFlag, FinishedGoodsFlag, SafetyStockLevel, ReorderPoint, StandardCost, ListPrice, DaysToManufacture, SellStartDate) 
	VALUES (1003, 'Produkt taki fajny 2', 'GH-Y643-45', 0, 0, 100, 999, 1000, 50, 20, '2013-05-30 00:00:00.000');
	SET IDENTITY_INSERT Production.Product OFF;
	COMMIT;
END
ELSE
	ROLLBACK;

SELECT * FROM Production.Product


--6)
--BEGIN TRANSACTION
--UPDATE Sales.SalesOrderDetail SET OrderQty = 10;
--IF (SELECT TOP 1 OrderQty FROM Sales.SalesOrderDetail ORDER BY OrderQty asc) = 10
--	ROLLBACK;
--ELSE
--	COMMIT;


BEGIN TRANSACTION
DECLARE @zm INT = (SELECT TOP 1 OrderQty FROM Sales.SalesOrderDetail ORDER BY OrderQty asc)
UPDATE Sales.SalesOrderDetail SET OrderQty = 10;
IF @zm = 20
	ROLLBACK;
ELSE
	COMMIT;

SELECT * FROM Sales.SalesOrderDetail


-- 7)
BEGIN TRANSACTION;
SET NOCOUNT off ;
EXEC sp_MSforeachtable "ALTER TABLE ? NOCHECK CONSTRAINT all"
DELETE FROM Production.Product WHERE StandardCost > (SELECT AVG(StandardCost) FROM Production.Product)
IF @@ROWCOUNT > 10
	ROLLBACK;
ELSE
	COMMIT;
EXEC sp_MSforeachtable "ALTER TABLE ? WITH CHECK CHECK CONSTRAINT all"

SELECT * FROM Production.Product
