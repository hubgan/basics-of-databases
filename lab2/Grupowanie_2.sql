use Northwind
-- 2_Grupowanie
-- TOP 5 zwraca 5 wynikow od gory a uzycie with ties powoduje ze jesli istnieja komorki z wartoscia quantity jak
-- ostatnia wybrana przez nas komorka to je tez wyswietla
select TOP 5 WITH TIES OrderID, ProductID, Quantity from [Order Details] order by Quantity desc
-- Count zlicza liczbe komorek pomijajac te w ktorych jest NULL
select COUNT(ReportsTo) from Employees
-- Zsumuj wszystkie wartoœci w kolumnie quantity w tabeli order details (dla
--wierszy w których wartoœæ productid = 1)
select SUM(Quantity) as total_sum from [Order Details] where ProductID = 1
-- strona 6
-- zad 1
select Count(*) as NumberOfProducts from Products where UnitPrice not between 20 and 30
-- zad 2
select TOP 1 UnitPrice from Products where UnitPrice < 20 order by UnitPrice desc
-- zad 3
select MAX(UnitPrice) as MaxPrice, MIN(UnitPrice) as MinPrice, AVG(UnitPrice) as AvgPrice from Products
where QuantityPerUnit like '%bottle%'
-- zad 4
select * from Products where UnitPrice > (select AVG(UnitPrice) from Products)
-- zad 5
select SUM(Quantity * UnitPrice * (1 - Discount)) as TotalSum from [Order Details] where OrderID = 10250

-- group by
-- 'zlaczamy w jedno wszystkie komorki ktore maja te same productid' i liczymy na nich sume 
select ProductID, SUM(Quantity) from orderhist group by ProductID
-- Napisz polecenie, które zwraca informacje o zamówieniach z tablicy order
--details. Zapytanie ma grupowaæ i wyœwietlaæ identyfikator ka¿dego
--produktu a nastêpnie obliczaæ ogóln¹ zamówion¹ iloœæ. Ogólna iloœæ jest
--sumowana funkcj¹ agreguj¹c¹ SUM i wyœwietlana jako jedna wartoœæ dla
--ka¿dego produktu
select * from [Order Details] order by ProductID
select productID, SUM(Quantity) as TotalQuantity from [Order Details] group by ProductID order by ProductID
-- zad 1
select OrderID, MAX(UnitPrice) as MaxPrice from [Order Details] group by OrderID
-- zad 2
select OrderID, MAX(UnitPrice) as MaxPrice from [Order Details] group by OrderID order by MaxPrice
-- zad 3
select OrderID, MAX(UnitPrice) as MaxPrice, MIN(UnitPrice) as MinPrice from [Order Details] group by OrderID
-- zad 4
select SupplierID, COUNT(*) as NumberOfOrders from Products group by SupplierID
-- zad 5
select TOP 1 ShipVia, Count(*) as NumberOfOrders from Orders where YEAR(ShippedDate) = 1997
group by ShipVia order by NumberOfOrders desc

-- HAVING
-- Where nie moze byc uzywane z funkcjami agregujacymi dlatego uzywamy having
-- select ProductID, SUM(Quantity) as TotalQuantity from orderhist group by ProductID where SUM(Quantity) >= 30
-- to daje error
select ProductID, SUM(Quantity) as TotalQuantity from orderhist group by ProductID having SUM(Quantity) >= 30

-- Wyœwietl listê identyfikatorów produktów i iloœæ dla tych produktów,
-- których zamówiono ponad 1200 jednostek
select ProductID, SUM(Quantity) as TotalQuantity from [Order Details]
group by ProductID having SUM(Quantity) > 1200

-- str 13
-- zad 1
select OrderID from [Order Details] group by OrderID having COUNT(*) > 5
-- zad 2
select CustomerID, COUNT(OrderDate) as NumberOfOrders, SUM(Freight) as TotalPrice from Orders
where YEAR(ShippedDate) = 1998 group by CustomerID having COUNT(OrderDate) > 8 order by SUM(Freight) desc

-- Operator ROLL UP i CUBE
select * from orderhist

SELECT productid, orderid, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid, orderid

SELECT productid, orderid, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid, orderid
WITH ROLLUP
ORDER BY productid, orderid

select * from [Order Details]
SELECT orderid, productid, SUM(quantity) AS total_quantity
FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid
ORDER BY orderid, productid

SELECT orderid, productid, SUM(quantity) AS total_quantity
FROM [order details]
WHERE orderid < 10250
GROUP BY orderid, productid
WITH ROLLUP
ORDER BY orderid, productid

SELECT productid, orderid, SUM(quantity) AS total_quantity
FROM orderhist
GROUP BY productid, orderid
WITH CUBE
ORDER BY productid, orderid