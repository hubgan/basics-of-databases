use library
-- zad 1.1
select title, title_no from title
-- zad 1.2
select title from title where title_no = 10
-- zad 1.3
select member_no, fine_assessed from loanhist where fine_assessed between 8 and 9
-- zad 1.4
select title_no, author from title where author in ('Charles Dickens', 'Jane Austen')
-- zad 1.5
select title_no, title from title where title like '%adventures%'
-- zad 1.6
select member_no, fine_assessed, fine_paid, fine_waived from loanhist
where isnull(fine_assessed, 0) - isnull(fine_waived, 0) > isnull(fine_paid, 0)
-- zad 1.7
select distinct city, state from adult
-- zad 2.1
select title from title order by title
-- zad 2.2
select member_no, isbn, fine_assessed, fine_assessed * 2 as 'double fine' from loanhist
where isnull(fine_assessed, 0) > 0
-- zad 2.3
select lower(firstname + middleinitial + substring(lastname, 1, 2)) as 'email_name' from member
where lastname = 'Anderson'
-- zad 2.4
select 'The title: ' + title + ', title number ' + cast(title_no as varchar(50)) from title