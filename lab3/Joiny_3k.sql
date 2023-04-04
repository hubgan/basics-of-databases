use Northwind
--Join cwiczenia koncowe
-- strona 1
-- zad 1
select [Order Details].OrderID, SUM(Quantity) as S, CompanyName from [Order Details]
INNER JOIN Orders on Orders.OrderID = [Order Details].OrderID
INNER JOIN Customers on Orders.CustomerID = Customers.CustomerID
GROUP BY [Order Details].OrderID, CompanyName ORDER BY [Order Details].OrderID
-- zad 2
select SUM(Quantity) as S, CompanyName from [Order Details]
INNER JOIN Orders on Orders.OrderID = [Order Details].OrderID
INNER JOIN Customers on Orders.CustomerID = Customers.CustomerID
GROUP BY CompanyName HAVING SUM(Quantity) > 250 ORDER BY CompanyName
-- zad 3
select Orders.OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2, 1) as Price, CompanyName from Orders
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers on Customers.CustomerID = Orders.CustomerID
GROUP BY Orders.OrderID, CompanyName ORDER BY Orders.OrderID
-- zad 4
select Orders.OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2, 1) as Price,
CompanyName, SUM(Quantity) as Quantity from Orders
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers on Customers.CustomerID = Orders.CustomerID
GROUP BY Orders.OrderID, CompanyName HAVING SUM(Quantity) > 250 ORDER BY Orders.OrderID
-- zad 5
select Orders.OrderID, ROUND(SUM(UnitPrice * Quantity * (1 - Discount)), 2, 1) as Price,
CompanyName, SUM(Quantity) as Quantity, CONCAT(FirstName, ' ', LastName) as Name from Orders
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
INNER JOIN Customers on Customers.CustomerID = Orders.CustomerID
INNER JOIN Employees on Orders.EmployeeID = Employees.EmployeeID
GROUP BY Orders.OrderID, CompanyName, FirstName, LastName HAVING SUM(Quantity) > 250 ORDER BY Orders.OrderID

-- strona 2
-- zad 1
select CategoryName, SUM(Quantity) as TotalQuantity from Categories
INNER JOIN Products on Products.CategoryID = Categories.CategoryID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
GROUP BY CategoryName
-- zad 2
select CategoryName, ROUND(SUM(Quantity * [Order Details].UnitPrice * (1 - Discount)), 2, 1) as TotalPrice,
SUM(Quantity) as TotalQuantity from Categories
INNER JOIN Products on Products.CategoryID = Categories.CategoryID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
GROUP BY CategoryName
-- zad 3a
select CategoryName, ROUND(SUM(Quantity * [Order Details].UnitPrice * (1 - Discount)), 2, 1) as TotalPrice,
SUM(Quantity) as TotalQuantity from Categories
INNER JOIN Products on Products.CategoryID = Categories.CategoryID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
GROUP BY CategoryName ORDER BY TotalPrice
-- zad 3b
select CategoryName, ROUND(SUM(Quantity * [Order Details].UnitPrice * (1 - Discount)), 2, 1) as TotalPrice,
SUM(Quantity) as TotalQuantity from Categories
INNER JOIN Products on Products.CategoryID = Categories.CategoryID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
GROUP BY CategoryName ORDER BY TotalQuantity
-- zad 4
select CategoryName, ROUND(SUM(Quantity * [Order Details].UnitPrice * (1 - Discount) + Freight), 2, 1)
as TotalPrice, SUM(Quantity) as TotalQuantity from Categories
INNER JOIN Products on Products.CategoryID = Categories.CategoryID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
INNER JOIN Orders on Orders.OrderID = [Order Details].OrderID
GROUP BY CategoryName ORDER BY TotalPrice

-- strona 3
-- zad 1
select Suppliers.SupplierID, Suppliers.CompanyName, COUNT(*) as howMany from Suppliers
INNER JOIN Products on Products.SupplierID = Suppliers.SupplierID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
INNER JOIN Orders on Orders.OrderID = [Order Details].OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY Suppliers.SupplierID, Suppliers.CompanyName ORDER BY Suppliers.SupplierID

select ShipVia, COUNT(*) as howMany from Orders
INNER JOIN Shippers on Shippers.ShipperID = Orders.ShipVia
WHERE YEAR(OrderDate) = 1997
GROUP BY ShipVia ORDER BY ShipVia
-- zad 2
select TOP 1 Suppliers.SupplierID, Suppliers.CompanyName, COUNT(*) as howMany from Suppliers
INNER JOIN Products on Products.SupplierID = Suppliers.SupplierID
INNER JOIN [Order Details] on [Order Details].ProductID = Products.ProductID
INNER JOIN Orders on Orders.OrderID = [Order Details].OrderID
WHERE YEAR(OrderDate) = 1997
GROUP BY Suppliers.SupplierID, Suppliers.CompanyName ORDER BY COUNT(*) DESC

select TOP 1 CompanyName, COUNT(*) as howMany from Orders
INNER JOIN Shippers on Shippers.ShipperID = Orders.ShipVia
WHERE YEAR(OrderDate) = 1997
GROUP BY CompanyName ORDER BY COUNT(*) DESC

-- zad 3
select Employees.EmployeeID, FirstName, LastName,
SUM(UnitPrice * Quantity * (1 - Discount)) as Price from Employees
INNER JOIN Orders on Orders.EmployeeID = Employees.EmployeeID
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
GROUP BY Employees.EmployeeID, FirstName, LastName ORDER BY Employees.EmployeeID

-- zad 4
select TOP 1 FirstName, LastName, COUNT(*) as howMany from Employees
INNER JOIN Orders on Orders.EmployeeID = Employees.EmployeeID
WHERE YEAR(OrderDate) = 1997
GROUP BY FirstName, LastName ORDER BY COUNT(*) DESC

-- zad 5
select TOP 1 Orders.OrderID, FirstName, LastName, SUM(UnitPrice * Quantity * (1 - DISCOUNT)) as Price
from Orders
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
INNER JOIN Employees on Employees.EmployeeID = Orders.EmployeeID
WHERE YEAR(OrderDate) = 1997
GROUP BY Orders.OrderID, FirstName, LastName ORDER BY Price DESC

-- strona 4
-- zad 1
-- a
select M.FirstName, M.LastName, SUM(UnitPrice * Quantity * (1 - Discount)) as Price
from Employees as M
INNER JOIN Employees as S on M.EmployeeID = S.ReportsTo 
INNER JOIN Orders on Orders.EmployeeID = M.EmployeeID
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
GROUP BY M.FirstName, M.LastName

SELECT M.FirstName, M.LastName, SUM(UnitPrice * Quantity * (1 - Discount)) as Price
FROM Employees as M
INNER JOIN Orders on M.employeeid = orders.employeeid 
INNER JOIN [Order Details] on Orders.OrderID = [Order Details].OrderID
WHERE M.employeeid IN (SELECT ReportsTo FROM Employees)
GROUP BY M.firstname, M.lastname

-- b
select M.FirstName, M.LastName, SUM(UnitPrice * Quantity * (1 - Discount)) as Price
from Employees as M
LEFT JOIN Employees as S on M.EmployeeID = S.ReportsTo
INNER JOIN Orders on Orders.EmployeeID = M.EmployeeID
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
WHERE S.ReportsTo IS NULL
GROUP BY M.FirstName, M.LastName

------------------------------------------
select M.FirstName, M.LastName, M.ReportsTo,
S.FirstName, S.LastName, S.ReportsTo,
[Order Details].OrderID, UnitPrice * Quantity * (1 - Discount) as Price
from Employees as M
INNER JOIN Employees as S on M.EmployeeID = S.ReportsTo
INNER JOIN Orders on Orders.EmployeeID = M.EmployeeID
INNER JOIN [Order Details] on [Order Details].OrderID = Orders.OrderID
