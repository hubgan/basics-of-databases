use Northwind
-- 1_podstawy
-- strona 29
-- zad 1
select CompanyName, Address from Customers
-- zad 2
select LastName, HomePhone from Employees
-- zad 3
select ProductName, UnitPrice from Products
-- zad 4
select CategoryName, Description from Categories
-- zad 5
select CompanyName, HomePage from Suppliers

-- strona 33
select OrderID, CustomerID, OrderDate from Orders where OrderDate < '1996-08-01'

-- strona 34
-- zad 1
select CompanyName, Address from Customers where City = 'London'
-- zad 2
select CompanyName, Address from Customers where Country in ('Spain', 'France')
-- zad 3
select ProductName, UnitPrice from Products where UnitPrice between 20 and 30
-- zad 4
select ProductName, UnitPrice from Products inner join Categories
on Products.CategoryID = Categories.CategoryID
where Description like '%meat%'
-- zad 5
select ProductName, UnitsInStock, Companyname from Products inner join Suppliers
on Products.SupplierID = Suppliers.SupplierID
where CompanyName like '%Tokyo Traders%'
-- zad 6
select ProductName from Products where UnitsInStock = 0

-- strona 38
-- zad 1
select * from Products where QuantityPerUnit like '%bottles%'
-- zad 2
select Title from Employees where LastName like '[B-L]%'
-- zad 3
select Title from Employees where LastName like '[BL]%'
-- zad 4
select CategoryName from Categories where Description like '%,%'
-- zad 5
select * from Customers where CompanyName like '%Store%'

-- strona 43
-- zad 1
select * from Products where UnitPrice not between 20 and 30
-- zad 2
select * from Products where UnitPrice >= 20 and UnitPrice <= 30

-- strona 44
-- zad 1
select CompanyName, Country from Customers where Country in ('Japan', 'Italy')

-- strona 46
select OrderID, OrderDate, CustomerID from Orders
where ShipCountry = 'Argentina' and (ShippedDate is null or ShippedDate > GETDATE())

-- strona 51
-- zad 1
select CompanyName, Country from Customers order by Country, CompanyName
-- zad 2
select ProductName, CategoryID, UnitPrice from Products order by CategoryID, UnitPrice desc
-- zad 3
select CompanyName, Country from Customers where Country in ('UK', 'Italy') order by Country, Companyname