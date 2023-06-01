-- 1)
GO
CREATE FUNCTION dbo.fibofunction(@n INT)
RETURNS INT
AS
BEGIN
	DECLARE @result INT;
	DECLARE @previous INT;
	DECLARE @temp INT;
	DECLARE @i INT;
	SET @result = 1;
	SET @previous = 0;
	SET @i = 1;

	IF @n=0
	BEGIN
		RETURN 0;
	END;
	ELSE IF @n=1
	BEGIN
		RETURN 1;
	END;
	ELSE
	BEGIN
		WHILE @i < @n
		BEGIN
			SET @temp = @result;
			SET @result = @result + @previous;
			SET @previous = @temp;
			SET @i = @i + 1;
		END;
	END;
	RETURN @result
END;
GO

CREATE PROCEDURE fiboprint @n INT
AS 
BEGIN
	DECLARE @zmienna INT;
	SET @zmienna = dbo.fibofunction(@n);
	PRINT @zmienna;
END;

EXEC fiboprint @n = 6;

-- rekurencja
GO
CREATE FUNCTION dbo.fibofunctionR(@n INT)
RETURNS INT
AS
BEGIN
	DECLARE @result INT;
	DECLARE @previous INT;
	DECLARE @next INT;
	SET @previous = 0;
	SET @next = 1;

	IF @n=0
	BEGIN
		RETURN 0;
	END;

	ELSE IF @n=1
	BEGIN
		RETURN 1;
	END;

	ELSE
	BEGIN
		SET @result =  dbo.fibofunctionR(@n-1) + dbo.fibofunctionR(@n-2);
	END;

	RETURN @result
END;
GO

CREATE PROCEDURE fiboprintR @n INT
AS 
BEGIN
	DECLARE @zmienna INT;
	SET @zmienna = dbo.fibofunctionR(@n);
	PRINT @zmienna;
END;

EXEC fiboprintR @n = 7;


-- 2)
CREATE TRIGGER trg_up_lastname
ON Person.Person
AFTER INSERT
AS
UPDATE Person.Person SET LastName = UPPER(LastName) WHERE BusinessEntityID = (SELECT DISTINCT BusinessEntityID FROM inserted);

--test
INSERT INTO Person.BusinessEntity(rowguid)
VALUES (NEWID());

INSERT INTO Person.Person(BusinessEntityID, FirstName, MiddleName, LastName, PersonType)
VALUES ((SELECT MAX(BusinessEntityID) FROM Person.BusinessEntity), 'Ben', 'Ben', 'Smith', 'SC');

SELECT * FROM Person.Person;

-- 3)

CREATE TRIGGER taxRateMonitoring
ON Sales.SalesTaxRate
AFTER UPDATE
AS
BEGIN
    IF ((SELECT DISTINCT TaxRate FROM inserted) > 30)
	BEGIN
		RAISERROR ('Uwaga! Do kolumny TaxRate wprowadzono wartoœæ wiêksz¹ ni¿ 30!',1,1)
	END
END

-- test
UPDATE Sales.SalesTaxRate 
SET TaxRate = 40
WHERE Sales.SalesTaxRate.SalesTaxRateID = 2 OR Sales.SalesTaxRate.SalesTaxRateID = 3;

SELECT * FROM Sales.SalesTaxRate

