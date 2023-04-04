--joins_3
use Northwind
--Napisz polecenie zwracaj¹ce nazwy produktów i firmy je dostarczaj¹ce (baza northwind) -
--tak aby produkty bez „dostarczycieli” i „dostarczyciele” bez produktów nie pojawiali siê w wyniku.
select * from Products select * from Suppliers
select ProductName, CompanyName from Products INNER JOIN Suppliers
ON Suppliers.SupplierID = Products.SupplierID
-- Napisz polecenie zwracaj¹ce jako wynik nazwy klientów, którzy
-- z³o¿yli zamówienia po 01 marca 1998 (baza northwind)
select * from Customers select * from Orders
select CompanyName, OrderDate from Customers INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID where OrderDate > '3/1/98'
-- Napisz polecenie zwracaj¹ce wszystkich klientów z datami zamówieñ (baza northwind).
select * from Customers select * from Orders
select CompanyName, Customers.CustomerID, OrderDate from Customers INNER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID
select CompanyName, Customers.CustomerID, OrderDate from Customers LEFT OUTER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID

-- strona 14
-- zad 1
select * from Products select * from Suppliers
select ProductName, UnitPrice, Address from Products INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID WHERE UnitPrice between 20 and 30
-- zad 2
select ProductName, UnitsInStock, CompanyName from Products INNER JOIN Suppliers
ON Products.SupplierID = Suppliers.SupplierID WHERE CompanyName like 'Tokyo Traders'
-- zad 3
select CompanyName, Customers.CustomerID, OrderDate, OrderID from Customers LEFT OUTER JOIN Orders
ON Customers.CustomerID = Orders.CustomerID and YEAR(OrderDate) = 1997 WHERE OrderDate is null
-- zad 4
select DISTINCT CompanyName, Phone, Suppliers.SupplierID, UnitsInStock from Suppliers INNER JOIN Products
ON Suppliers.SupplierID = Products.SupplierID and UnitsInStock = 0 order by CompanyName

-- strona 15
use library
-- zad 1
select * from juvenile select * from member
select firstname, lastname, birth_date from member INNER JOIN juvenile
ON member.member_no = juvenile.member_no
-- zad 2
select * from loan select * from title
select DISTINCT title, title.title_no from loan INNER JOIN title
ON loan.title_no = title.title_no
-- zad 3
select * from loanhist select * from title
select loanhist.title_no, fine_assessed, fine_paid, fine_waived, title, DATEDIFF(dd, in_date, due_date) as days
from loanhist INNER JOIN title ON title.title_no = loanhist.title_no and fine_assessed is not NULL
WHERE title like 'Tao Teh King'
-- zad 4
select * from reservation where member_no = 205 order by member_no select * from member
select firstname, lastname, member.member_no, isbn from member INNER JOIN reservation
ON member.member_no = reservation.member_no WHERE lastname = 'Graff' and firstname = 'Stephen'

--Napisz polecenie, wyœwietlaj¹ce CROSS JOIN miêdzy shippers i
--suppliers. u¿yteczne dla listowania wszystkich mo¿liwych
--sposobów w jaki dostawcy mog¹ dostarczaæ swoje produkty
use Northwind
select * from Suppliers select * from Shippers
select suppliers.companyname, shippers.companyname from suppliers CROSS JOIN shippers

-- Napisz polecenie zwracaj¹ce listê produktów zamawianych w dniu 1996-07-08.
select ProductName, OrderDate from [Order Details]
INNER JOIN Orders ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON [Order Details].ProductID = Products.ProductID
WHERE OrderDate = '7/8/96'

-- strona 20
-- zad 1
select ProductName, UnitPrice, CompanyName, Address, CategoryName, Description from Products
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
INNER JOIN Categories ON Products.CategoryID = Categories.CategoryID
WHERE UnitPrice between 20 and 30 and CategoryName like '%Meat/Poultry%'
-- zad 2
select CategoryName, ProductName, UnitPrice, CompanyName from Categories
INNER JOIN Products ON Categories.CategoryID = Products.CategoryID
INNER JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
WHERE CategoryName like '%Confections%'
-- zad 3
select DISTINCT Customers.CompanyName, Orders.CustomerID, Customers.Phone, Shippers.CompanyName from Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN Shippers ON Orders.ShipVia = Shippers.ShipperID
WHERE Shippers.CompanyName = 'United Package' and YEAR(ShippedDate) = 1997
-- zad 4
select DISTINCT Customers.CompanyName, Customers.Phone, Categories.CategoryName from Customers
INNER JOIN Orders ON Customers.CustomerID = Orders.CustomerID
INNER JOIN [Order Details] ON [Order Details].OrderID = Orders.OrderID
INNER JOIN Products ON Products.ProductID = Products.ProductID
INNER JOIN Categories ON Categories.CategoryID = Products.CategoryID
WHERE Categories.CategoryName = 'Confections'

-- strona 21
use library
-- zad 1
select firstname, lastname, birth_date, street, city, state from juvenile
INNER JOIN member ON member.member_no = juvenile.member_no
INNER JOIN adult ON adult.member_no = juvenile.adult_member_no
-- zad 2
select ju.firstname, ju.lastname, birth_date, street, city, state, ad.firstname, ad.lastname from juvenile
INNER JOIN member ju ON ju.member_no = juvenile.member_no
INNER JOIN adult ON adult.member_no = juvenile.adult_member_no
INNER JOIN member ad ON ad.member_no = adult.member_no 

--self join
use joindb
SELECT a.buyer_id AS buyer1, a.prod_id
,b.buyer_id AS buyer2
FROM sales AS a
JOIN sales AS b
ON a.prod_id = b.prod_id
WHERE a.buyer_id > b.buyer_id

-- Napisz polecenie, które wyœwietla listê wszystkich kupuj¹cych te same produkty.
select * from sales
select a.buyer_id as buyer1, a.prod_id, b.buyer_id as buyer2 from sales as a
INNER JOIN sales as b
ON a.prod_id = b.prod_id
-- Zmodyfikuj poprzedni przyk³ad, tak aby zlikwidowaæ duplikaty
select a.buyer_id as buyer1, a.prod_id, b.buyer_id as buyer2 from sales as a
INNER JOIN sales as b
ON a.prod_id = b.prod_id WHERE a.buyer_id < b.buyer_id
-- Napisz polecenie, które pokazuje pary pracowników zajmuj¹cych to samo stanowisko.
use Northwind
select a.EmployeeID, a.LastName as name, a.title as title, b.EmployeeID, b.LastName as name, b.title as title
from Employees as a INNER JOIN Employees as b ON a.Title = b.Title where a.EmployeeID < b.EmployeeID

-- strona 26
-- zad 1
select EmployeeID, ReportsTo from Employees
--select a.FirstName, a.LastName,
--b.FirstName, b.LastName
--from Employees as a INNER JOIN Employees as b ON a.ReportsTo = b.EmployeeID
select a.EmployeeID, a.LastName, a.ReportsTo as supervisor,
b.EmployeeID, b.LastName, b.ReportsTo as supervisor
from Employees as a LEFT JOIN Employees as b ON a.ReportsTo = b.EmployeeID
-- zad 2
select a.FirstName, a.LastName, a.ReportsTo as supervisor,
b.FirstName, b.LastName, b.ReportsTo as supervisor
from Employees as a LEFT JOIN Employees as b ON a.ReportsTo = b.EmployeeID
WHERE a.ReportsTo is NULL
-- zad 3
use library
select DISTINCT adult.member_no, street, city, state, zip from adult
INNER JOIN juvenile ON juvenile.adult_member_no = adult.member_no
WHERE birth_date < '01/01/96'
-- zad 4
select DISTINCT adult.member_no, street, city, state, zip, loan.member_no, loan.due_date from adult
INNER JOIN juvenile ON juvenile.adult_member_no = adult.member_no
LEFT JOIN loan ON adult.member_no = loan.member_no
WHERE birth_date < '01/01/96' and (loan.member_no is null or due_date > GETDATE())
-- Union
use Northwind
SELECT (firstname + ' ' + lastname) AS name, city, postalcode FROM employees
SELECT companyname, city, postalcode FROM customers
SELECT (firstname + ' ' + lastname) AS name
,city, postalcode
FROM employees
UNION
SELECT companyname, city, postalcode
FROM customers

-- strona 28
-- zad 1
use library
select * from adult select * from member
select firstname + ' ' + lastname as name, street + ' ' + city + ' ' + state + ' ' + zip as address from adult
INNER JOIN member on adult.member_no = member.member_no
-- zad 2
select copy.isbn, copy.copy_no, copy.on_loan, copy.title_no, title.title, item.cover, item.translation from copy
INNER JOIN title ON copy.title_no = title.title_no
INNER JOIN item ON copy.title_no = item.title_no
WHERE copy.isbn in (1, 500, 1000) ORDER BY copy.isbn
-- zad 3
select member.member_no, member.firstname, member.lastname, reservation.isbn, reservation.log_date from member
INNER JOIN reservation ON member.member_no = reservation.member_no WHERE member.member_no in (250, 342, 1675)
-- zad 4
--select * from juvenile WHERE adult_member_no = 531
select adult.member_no, COUNT(*) as kidsNumber from adult
INNER JOIN juvenile ON adult.member_no = juvenile.adult_member_no
WHERE state = 'AZ' GROUP BY adult.member_no HAVING COUNT(*) > 2

-- strona 29
-- zad 1
--select * from juvenile WHERE adult_member_no = 463
select adult.member_no, state, COUNT(*) as kidsNumber from adult
INNER JOIN juvenile ON adult.member_no = juvenile.adult_member_no
WHERE state = 'AZ' GROUP BY adult.member_no, state HAVING COUNT(*) > 2
UNION
select adult.member_no, state, COUNT(*) as kidsNumber from adult
INNER JOIN juvenile ON adult.member_no = juvenile.adult_member_no
WHERE state = 'CA' GROUP BY adult.member_no, state HAVING COUNT(*) > 3

