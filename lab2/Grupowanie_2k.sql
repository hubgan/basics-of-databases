-- Grupowanie cwiczenia koncowe
-- zad 1.1
select OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) as TotalPrice from [Order Details]
group by OrderID order by TotalPrice desc
-- zad 1.2
select TOP 10 WITH TIES OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) as TotalPrice from [Order Details]
group by OrderID order by TotalPrice desc

-- zad 2.1
select ProductID, SUM(Quantity) as TotalQuantity from [Order Details] where ProductID < 3 group by ProductID
-- zad 2.2
select ProductID, SUM(Quantity) as TotalQuantity from [Order Details] group by ProductID
-- zad 2.3
select OrderID, SUM(UnitPrice * Quantity * (1 - Discount)) as Price, SUM(Quantity) as TotalQuantity
from [Order Details] group by OrderID having SUM(Quantity) > 250

-- zad 3.1
select EmployeeID, COUNT(*) as OrdersNumber from Orders group by EmployeeID
-- zad 3.2
select ShipVia, SUM(Freight) as TotalPrice from Orders group by ShipVia
-- zad 3.3
select ShipVia, SUM(Freight) as TotalPrice from Orders
where YEAR(ShippedDate) in (1997, 1996) group by ShipVia

-- zad 4.1
select EmployeeID, YEAR(OrderDate) as Y, MONTH(OrderDate) as M, COUNT(YEAR(OrderDate)) as HowMany
from Orders group by EmployeeID, YEAR(OrderDate), MONTH(OrderDate)
with ROLLUP order by EmployeeID

-- zad 4.2
select CategoryName, MIN(UnitPrice) as MinPrice, MAX(UnitPrice) as MaxPrice from Products
inner join Categories on Products.CategoryID = Categories.CategoryID group by CategoryName
order by CategoryName