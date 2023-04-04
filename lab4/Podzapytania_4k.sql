use Northwind2
-- Podzapytania
-- zad 1.1
select C.CompanyName, C.Phone from Customers as C
WHERE C.CustomerID IN (select O.CustomerID from Orders as O
INNER JOIN Shippers as S on S.ShipperID = O.ShipVia
WHERE S.CompanyName = 'United Package' and YEAR(O.OrderDate) = 1997)

-- zad 1.2
select C.CompanyName, C.Phone from Customers as C
WHERE C.CustomerID IN 
(select O.CustomerID from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as Cat on Cat.CategoryID = P.CategoryID
WHERE Cat.CategoryName = 'Confections')

-- zad 1.3

select C.CompanyName, C.Phone from Customers as C
WHERE C.CustomerID NOT IN 
(select O.CustomerID from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as Cat on Cat.CategoryID = P.CategoryID
WHERE Cat.CategoryName = 'Confections')

-- zad 2.1
select
P.ProductName,
(select MAX(OD.Quantity) from [Order Details] as OD WHERE OD.ProductID = P.ProductID) as 'Max'
from Products as P

-- zad 2.2
select * from Products as P
WHERE P.UnitPrice < (select AVG(P2.UnitPrice) from Products as P2)

-- zad 2.3
select
*
from Products as P
WHERE P.UnitPrice < (select AVG(P2.UnitPrice) from Products as P2 WHERE P2.CategoryID = P.CategoryID)

-- zad 3.1
select
P.ProductName,
P.UnitPrice,
(select AVG(P2.UnitPrice) from Products as P2),
P.UnitPrice - (select AVG(P2.UnitPrice) from Products as P2)
from Products as P

-- zad 3.2
select
(select C.CategoryName from Categories as C WHERE C.CategoryID = P.CategoryID),
P.ProductName,
P.UnitPrice,
(select AVG(P2.UnitPrice) from Products as P2),
P.UnitPrice - (select AVG(P2.UnitPrice) from Products as P2)
from Products as P

-- zad 4.1
select
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from [Order Details]
as OD WHERE OD.OrderID = O.OrderID)
+
SUM(O.Freight)
from Orders as O
WHERE O.OrderID = 10250
GROUP BY O.OrderID

-- zad 4.2
select
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from [Order Details]
as OD WHERE OD.OrderID = O.OrderID)
+
SUM(O.Freight),
O.OrderID
from Orders as O
GROUP BY O.OrderID

-- zad 4.3
select C.CompanyName, C.Address from Customers as C
WHERE C.CustomerID NOT IN
(select O.CustomerID from Orders as O
WHERE YEAR(O.OrderDate) = 1997)

-- zad 4.4
select  
P.ProductName,
(select COUNT(DISTINCT O.CustomerID) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE P.ProductID = OD.ProductID
 GROUP BY OD.ProductID)
from Products as P
ORDER BY P.ProductName

-- zad 5.1
select
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE E.EmployeeID = O.EmployeeID
 GROUP BY O.EmployeeID)
 +
(select SUM(O.Freight) from Orders as O
 WHERE O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID) as 'price'
from Employees as E

-- zad 5.2
select TOP 1
CONCAT(E.FirstName, ' ', E.LastName) as 'name'
from Employees as E
ORDER BY (select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE E.EmployeeID = O.EmployeeID AND YEAR(O.OrderDate) = 1997
 GROUP BY O.EmployeeID)
 +
(select SUM(O.Freight) from Orders as O
 WHERE O.EmployeeID = E.EmployeeID AND YEAR(O.OrderDate) = 1997
 GROUP BY O.EmployeeID) DESC

-- zad 5.3
-- a
select
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE E.EmployeeID = O.EmployeeID
 GROUP BY O.EmployeeID)
 +
(select SUM(O.Freight) from Orders as O
 WHERE O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID) as 'price'
from Employees as E
WHERE E.EmployeeID IN
(select E2.ReportsTo from Employees as E2
WHERE E2.ReportsTo IS NOT NULL
GROUP BY E2.ReportsTo)

-- b
select
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE E.EmployeeID = O.EmployeeID
 GROUP BY O.EmployeeID)
 +
(select SUM(O.Freight) from Orders as O
 WHERE O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID) as 'price'
from Employees as E
WHERE E.EmployeeID NOT IN
(select E2.ReportsTo from Employees as E2
WHERE E2.ReportsTo IS NOT NULL
GROUP BY E2.ReportsTo)

-- zad 5.4
-- a
select
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE E.EmployeeID = O.EmployeeID
 GROUP BY O.EmployeeID)
 +
(select SUM(O.Freight) from Orders as O
 WHERE O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID) as 'price',
(select TOP 1 O.OrderDate from Orders as O WHERE O.EmployeeID = E.EmployeeID ORDER BY O.OrderDate DESC)
as 'date'
from Employees as E
WHERE E.EmployeeID IN
(select E2.ReportsTo from Employees as E2
WHERE E2.ReportsTo IS NOT NULL
GROUP BY E2.ReportsTo)

-- b
select
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
(select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE E.EmployeeID = O.EmployeeID
 GROUP BY O.EmployeeID)
 +
(select SUM(O.Freight) from Orders as O
 WHERE O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID) as 'price',
(select TOP 1 O.OrderDate from Orders as O WHERE O.EmployeeID = E.EmployeeID ORDER BY O.OrderDate DESC)
as 'date'
from Employees as E
WHERE E.EmployeeID NOT IN
(select E2.ReportsTo from Employees as E2
WHERE E2.ReportsTo IS NOT NULL
GROUP BY E2.ReportsTo)