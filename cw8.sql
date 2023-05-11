--1. Zbuduj zapytanie, które znajdzie informacje na temat stawki pracownika oraz jego danych i zapisze je do tabeli tymczasowej
use AdventureWorks2019;

WITH aaaa
AS
(
	SELECT pp.BusinessEntityID AS ID, pp.FirstName AS Imie, pp.LastName AS Nazwisko, hr.Rate AS Stawka 
	FROM HumanResources.EmployeePayHistory AS hr
	LEFT JOIN Person.Person AS pp
	ON hr.BusinessEntityID = pp.BusinessEntityID
)
SELECT aaaa.ID, aaaa.Imie, aaaa.Nazwisko, aaaa.Stawka 
INTO TempEmployeeInfo
FROM aaaa;

SELECT * FROM TempEmployeeInfo
ORDER BY ID;
--DROP TABLE TempEmployeeInfo;


--2. Uzyskaj informacje na temat przychodów ze sprzeda¿y wed³ug firmy i kontaktu
use AdventureWorksLT2019;

WITH bbbb
AS
(
	SELECT sc.CompanyName+' ('+sc.FirstName+' '+sc.LastName+')' AS CompanyContact, ssoh.TotalDue AS Revenue
	FROM SalesLT.Customer AS sc
	JOIN SalesLT.SalesOrderHeader AS ssoh
	ON ssoh.CustomerID = sc.CustomerID
)
SELECT bbbb.CompanyContact, bbbb.Revenue
INTO TempSalesInfo
FROM bbbb;

SELECT * FROM TempSalesInfo
ORDER BY CompanyContact;

--DROP TABLE TempSalesInfo;


--3. Napisz zapytanie, które zwróci wartoœæ sprzeda¿y dla poszczególnych kategorii produktów
WITH cccc
AS
(
	SELECT spc.Name AS Category, CAST(SUM(ssod.LineTotal) AS DECIMAL(12, 2)) AS SalesValue
	FROM SalesLT.Product AS sp
	JOIN SalesLT.ProductCategory AS spc
	ON sp.ProductCategoryID = spc.ProductCategoryID
	JOIN SalesLT.SalesOrderDetail AS ssod
	ON ssod.ProductID = sp.ProductID
	GROUP BY spc.Name
)
SELECT cccc.Category, cccc.SalesValue 
INTO TempProductInfo
FROM cccc;

SELECT * FROM TempProductInfo
ORDER BY TempProductInfo.Category;

--DROP TABLE TempProductInfo;