-- Wyświetl produkt, który przyniósł najmniejszy, ale niezerowy, przychód w 1996 roku
use Northwind2
select TOP 1 P.ProductName,
SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) as 'Price' from Products as P
INNER JOIN [Order Details] as OD on OD.ProductID = P.ProductID
INNER JOIN Orders as O on O.OrderID = OD.OrderID
WHERE YEAR(O.OrderDate) = 1996
GROUP BY P.ProductName
HAVING SUM(OD.Quantity * OD.UnitPrice * (1 - OD.Discount)) > 0
ORDER BY 2

-- Wyświetl wszystkich członków biblioteki (imię i nazwisko, adres) 
-- rozróżniając dorosłych i dzieci (dla dorosłych podaj liczbę dzieci),
-- którzy nigdy nie wypożyczyli książki
use library
select
CONCAT(m1.firstname, ' ', m1.lastname) as 'name', a.street,
'Adult', COUNT(j.adult_member_no) as 'kids'
from member as m1
INNER JOIN adult as a on a.member_no = m1.member_no
LEFT JOIN juvenile as j on j.adult_member_no = a.member_no
WHERE m1.member_no NOT IN (select l.member_no from loan as l)
AND m1.member_no NOT IN (select lh.member_no from loanhist as lh)
GROUP BY CONCAT(m1.firstname, ' ', m1.lastname), a.street
UNION
select
CONCAT(m1.firstname, ' ', m1.lastname) as 'name', a.street,
'Kid', NULL
from member as m1
INNER JOIN juvenile as j on j.member_no = m1.member_no
INNER JOIN adult as a on a.member_no = j.adult_member_no
WHERE m1.member_no NOT IN (select l.member_no from loan as l)
AND m1.member_no NOT IN (select lh.member_no from loanhist as lh)
GROUP BY CONCAT(m1.firstname, ' ', m1.lastname), a.street

-- Wyświetl podsumowanie zamówień (całkowita cena + fracht) obsłużonych 
-- przez pracowników w lutym 1997 roku, uwzględnij wszystkich, nawet jeśli suma 
-- wyniosła 0.
use Northwind2
select
E.EmployeeID,
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
ISNULL((select SUM(OD.UnitPrice * OD.Quantity * (1 - OD.Discount)) from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 2 AND O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID) +
(select SUM(O.Freight) from Orders as O
 WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 2 AND O.EmployeeID = E.EmployeeID
 GROUP BY O.EmployeeID), 0) as 'Price'
from Employees as E
ORDER BY 3 DESC

-- Wypisz wszystkich członków biblioteki z adresami i info czy jest dzieckiem czy nie i
-- ilość wypożyczeń w poszczególnych latach i miesiącach
use library
select
m.member_no,
CONCAT(m.firstname, ' ', m.lastname) as 'name',
CONCAT(a.street, ' ', a.city, ' ', a.state, ' ', a.zip) as 'address',
'Adult',
COUNT(MONTH(out_date)) as 'howMany',
MONTH(lh.out_date) as 'Month', YEAR(lh.out_date) as 'Year'
from member as m
INNER JOIN adult as a on a.member_no = m.member_no
LEFT JOIN loanhist as lh on lh.member_no = m.member_no
GROUP BY MONTH(lh.out_date), YEAR(lh.out_date), CONCAT(m.firstname, ' ', m.lastname),
CONCAT(a.street, ' ', a.city, ' ', a.state, ' ', a.zip), m.member_no
UNION
select
m.member_no,
CONCAT(m.firstname, ' ', m.lastname) as 'name',
CONCAT(a.street, ' ', a.city, ' ', a.state, ' ', a.zip) as 'address',
'Kid',
COUNT(MONTH(out_date)) as 'howMany',
MONTH(lh.out_date) as 'Month', YEAR(lh.out_date) as 'Year'
from member as m
INNER JOIN juvenile as j on j.member_no = m.member_no
INNER JOIN adult as a on a.member_no = j.adult_member_no
LEFT JOIN loanhist as lh on lh.member_no = m.member_no
GROUP BY MONTH(lh.out_date), YEAR(lh.out_date), CONCAT(m.firstname, ' ', m.lastname),
CONCAT(a.street, ' ', a.city, ' ', a.state, ' ', a.zip), m.member_no
ORDER BY 1, 6, 7

-- Zamówienia z Freight większym niż AVG danego roku.
use Northwind2
select O.OrderID, O.Freight from Orders as O
WHERE O.Freight > (select AVG(O2.Freight) from Orders as O2 WHERE O.OrderDate = O2.OrderDate)

-- Klienci, którzy nie zamówili nigdy nic z kategorii 'Seafood' w trzech wersjach.
use Northwind2
select C.CompanyName, C.CustomerID from Customers as C
WHERE C.CustomerID NOT IN
(select O.CustomerID from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as C on C.CategoryID = P.CategoryID
WHERE C.CategoryName = 'Seafood')

select C.CompanyName, C.CustomerID from Customers as C
LEFT JOIN Orders as O on O.CustomerID = C.CustomerID
LEFT JOIN [Order Details] as OD on OD.OrderID = O.OrderID
LEFT JOIN Products as P on P.ProductID = OD.ProductID
LEFT JOIN Categories as CA on CA.CategoryID = P.CategoryID AND CA.CategoryName = 'Seafood'
GROUP BY C.CustomerID, C.CompanyName
HAVING COUNT(CA.CategoryName) = 0

-- Dla każdego klienta najczęściej zamawianą kategorię w dwóch wersjach.
select
C.CompanyName, C.CustomerID,
(select TOP 1 CA.CategoryName from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 INNER JOIN Products as P on P.ProductID = OD.ProductID
 INNER JOIN Categories as CA on CA.CategoryID = P.CategoryID
 WHERE C.CustomerID = O.CustomerID
 GROUP BY CA.CategoryName ORDER BY COUNT(*) DESC) as 'Popular Category'
from Customers as C

-- Podział na company, year month i suma freight
use Northwind2
select C.CompanyName, MONTH(O.OrderDate) as 'Month', YEAR(O.orderDate) as 'Year',
SUM(O.Freight) as 'Suma' from Customers as C
INNER JOIN Orders as O on O.CustomerID = C.CustomerID
GROUP BY C.CompanyName, MONTH(O.OrderDate), YEAR(O.OrderDate)
ORDER BY 1, 2, 3

-- Wypisać wszystkich czytelników, którzy nigdy nie wypożyczyli książki dane
-- adresowe i podział czy ta osoba jest dzieckiem (joiny, in, exists)
use library
select CONCAT(m.firstname, ' ', m.lastname) as 'Name',
CONCAT(a.city, ' ', a.state, ' ', a.street, ' ', a.zip) as 'Address',
'Adult'
from member as m
INNER JOIN adult as a on a.member_no = m.member_no
WHERE a.member_no NOT IN (select l.member_no from loan as l)
AND a.member_no NOT IN (select lh.member_no from loanhist as lh)
GROUP BY m.member_no, m.firstname, m.lastname, a.city, a.state, a.street, a.zip
UNION
select CONCAT(m.firstname, ' ', m.lastname) as 'Name',
CONCAT(a.city, ' ', a.state, ' ', a.street, ' ', a.zip) as 'Address',
'Kid'
from member as m
INNER JOIN juvenile as j on j.member_no = m.member_no
INNER JOIN adult as a on a.member_no = j.adult_member_no
WHERE j.member_no NOT IN (select l.member_no from loan as l)
AND j.member_no NOT IN (select lh.member_no from loanhist as lh)
GROUP BY m.member_no, m.firstname, m.lastname, a.city, a.state, a.street, a.zip

-- Najczęściej wybierana kategoria w 1997 dla każdego klienta
use Northwind2
select
C.CompanyName, C.CustomerID,
(select TOP 1 CA.CategoryName from Orders as O
 INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
 INNER JOIN Products as P on P.ProductID = OD.ProductID
 INNER JOIN Categories as CA on CA.CategoryID = P.CategoryID
 WHERE YEAR(O.OrderDate) = 1997 AND C.CustomerID = O.CustomerID
 GROUP BY CA.CategoryName ORDER BY COUNT(*) DESC)
from Customers as C

-- Dla każdego czytelnika imię nazwisko, suma książek wypożyczony przez tą osobę i
-- jej dzieci, który żyje w Arizona ma mieć więcej niż 2 dzieci lub kto żyje w Kalifornii
-- ma mieć więcej niż 3 dzieci
use library
select
CONCAT(m.firstname, ' ', m.lastname),
(select COUNT(*) from loanhist as lh WHERE m.member_no = lh.member_no) +
(select COUNT(*) from loan as l WHERE m.member_no = l.member_no) +
(select COUNT(*) from loanhist as lh WHERE lh.member_no IN
 (select j.member_no from juvenile as j WHERE m.member_no = j.adult_member_no)) +
(select COUNT(*) from loan as l WHERE l.member_no IN
 (select j.member_no from juvenile as j WHERE m.member_no = j.adult_member_no)) as 'books',
(select a.state from adult as a WHERE a.member_no = m.member_no) as 'state'
from member as m
WHERE (m.member_no IN (select j.adult_member_no from juvenile as j) AND
((m.member_no IN (select a.member_no from adult as a WHERE a.state = 'AZ')) AND
(select COUNT(*) from juvenile as j WHERE m.member_no = j.adult_member_no) > 2)) OR
(m.member_no IN (select j.adult_member_no from juvenile as j) AND
((m.member_no IN (select a.member_no from adult as a WHERE a.state = 'CA')) AND
(select COUNT(*) from juvenile as j WHERE m.member_no = j.adult_member_no) > 3))

-- Jaki był najpopularniejszy autor wśród dzieci w Arizonie w 2001
use library
select TOP 1 t.author from title as t
ORDER BY (select COUNT(*) from loan as l WHERE YEAR(l.out_date) = 2001 AND t.title_no = l.title_no AND
l.member_no IN (select j.member_no from juvenile as j WHERE j.adult_member_no IN
(select a.member_no from adult as a WHERE a.state = 'AZ'))) +
(select COUNT(*) from loanhist as lh WHERE YEAR(lh.out_date) = 2001 AND t.title_no = lh.title_no AND
lh.member_no IN (select j.member_no from juvenile as j WHERE j.adult_member_no IN
(select a.member_no from adult as a WHERE a.state = 'AZ'))) DESC

-- Dla każdego dziecka wybierz jego imię nazwisko, adres, imię i nazwisko rodzica i
-- ilość książek, które oboje przeczytali w 2001
use library
select
(select CONCAT(m.firstname, ' ', m.lastname) from member as m WHERE j.member_no = m.member_no) as 'name',
(select CONCAT(a.city, ' ', a.state, ' ', a.street, ' ', a.zip) from adult as a
WHERE a.member_no = j.adult_member_no) as 'address',
(select CONCAT(a.firstname, ' ', a.lastname) from member as a WHERE a.member_no = j.adult_member_no)
as 'Parent name',
(select COUNT(*) from loan as l WHERE l.member_no = j.member_no AND YEAR(l.due_date) = 2001) +
(select COUNT(*) from loanhist as lh WHERE lh.member_no = j.member_no AND YEAR(lh.due_date) = 2001) +
(select COUNT(*) from loan as l WHERE l.member_no = j.adult_member_no AND YEAR(l.due_date) = 2001) +
(select COUNT(*) from loanhist as lh WHERE lh.member_no = j.adult_member_no AND YEAR(lh.due_date) = 2001)
as 'Quantity'
from juvenile as j

-- Kategorie które w roku 1997 grudzień były obsłużone wyłącznie przez ‘United Package’
use Northwind2
select C.CategoryName from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as C on C.CategoryID = P.CategoryID
INNER JOIN Shippers as S on S.ShipperID = O.ShipVia AND S.CompanyName = 'United Package'
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 12 AND C.CategoryName NOT IN
(select C.CategoryName from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as C on C.CategoryID = P.CategoryID
INNER JOIN Shippers as S on S.ShipperID = O.ShipVia AND S.CompanyName != 'United Package'
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 12 
GROUP BY C.CategoryName)

-- Wybierz klientów, którzy kupili przedmioty wyłącznie z jednej kategorii w marcu 
-- 1997 i wypisz nazwę tej kategorii
select C.CustomerID,
(select TOP 1 CA.CategoryName from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as CA on CA.CategoryID = P.CategoryID
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 3 AND O.CustomerID = C.CustomerID) as 'Category'
from Customers as C
WHERE (select COUNT(DISTINCT CA.CategoryName) from Orders as O
INNER JOIN [Order Details] as OD on OD.OrderID = O.OrderID
INNER JOIN Products as P on P.ProductID = OD.ProductID
INNER JOIN Categories as CA on CA.CategoryID = P.CategoryID
WHERE YEAR(O.OrderDate) = 1997 AND MONTH(O.OrderDate) = 3 AND O.CustomerID = C.CustomerID) = 1

-- Wybierz dzieci wraz z adresem, które nie wypożyczyły książek w lipcu 2001 autorstwa ‘Jane Austin’
use library
select
(select CONCAT(m.firstname, ' ', m.lastname) from member as m WHERE m.member_no = j.member_no) as 'name',
(select CONCAT(a.city, ' ', a.state, ' ', a.street, ' ', a.zip) from adult as a 
WHERE a.member_no = j.adult_member_no) as 'Address'
from juvenile as j WHERE j.member_no NOT IN
(select l.member_no from loan as l WHERE YEAR(l.out_date) = 2001 AND MONTH(l.out_date) = 7 AND
l.title_no IN (select t.title_no from title as t WHERE t.author = 'Jane Austin'))
 AND j.member_no NOT IN
(select lh.member_no from loanhist as lh WHERE YEAR(lh.out_date) = 2001 AND MONTH(lh.out_date) = 7 AND
lh.title_no IN (select t.title_no from title as t WHERE t.author = 'Jane Austin'))

-- Wybierz kategorię, która w danym roku 1997 najwięcej zarobiła, podział na miesiące
use Northwind2
SELECT Ca.CategoryID, Ca.CategoryName, MONTH(O.OrderDate), SUM((1 - OD.Discount) * OD.UnitPrice * OD.Quantity) FROM Categories AS Ca
INNER JOIN Products AS P ON Ca.CategoryID = P.CategoryID
INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
INNER JOIN Orders AS O ON OD.OrderID = O.OrderID AND YEAR(O.OrderDate) = 1997
WHERE Ca.CategoryID IN 
	(SELECT TOP 1 Ca2.CategoryID FROM Categories AS Ca2
	INNER JOIN Products AS P ON Ca2.CategoryID = P.CategoryID
	INNER JOIN [Order Details] AS OD ON P.ProductID = OD.ProductID
	INNER JOIN Orders AS O ON OD.OrderID = O.OrderID AND YEAR(O.OrderDate) = 1997
	GROUP BY Ca2.CategoryID
	ORDER BY SUM((1 - OD.Discount) * OD.UnitPrice * OD.Quantity) DESC)
GROUP BY Ca.CategoryID, Ca.CategoryName, MONTH(O.OrderDate)

-- Dane pracownika i najczęstszy dostawca pracowników bez podwładnych
select 
CONCAT(E.FirstName, ' ', E.LastName) as 'name',
(select S.CompanyName from Shippers as S WHERE S.ShipperID = 
(select TOP 1 O.ShipVia from Orders as O WHERE O.EmployeeID = E.EmployeeID
 GROUP BY O.ShipVia ORDER BY COUNT(O.OrderID) DESC)) as 'Shipper'
from Employees as E
WHERE E.EmployeeID NOT IN
(select E2.ReportsTo from Employees as E2 WHERE E.EmployeeID = E2.ReportsTo)

-- Wybierz tytuły książek, gdzie ilość wypożyczeń książki jest większa od średniej ilości
-- wypożyczeń książek tego samego autora
use library
select t.title from title as t
WHERE ((select COUNT(*) from loan as l WHERE l.title_no = t.title_no) + 
(select COUNT(*) from loanhist as lh WHERE lh.title_no = t.title_no)) > 
((select COUNT(*) from loan as l WHERE l.title_no IN
(select t2.title_no from title as t2 WHERE t2.author = t.author)) +
(select COUNT(*) from loanhist as lh WHERE lh.title_no IN
(select t2.title_no from title as t2 WHERE t2.author = t.author))) / 
(select COUNT(t2.title_no) from title as t2 WHERE t2.author = t.author)