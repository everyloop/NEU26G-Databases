
/*
Best practice: alla dina tabeller ska ha en primary key.

Primary key bör vara något av följande:
1) Löpnummer (identity) som automatiskt räknas upp
2) GUID (Globaly Unique IDentifier)
3) Något som redan är unikt i datat, t.ex personnummer, ISBN, produktnummer.
*/


-- 1) Exempel med Identity som PK:
drop table Products

create table Products
(
	id int primary key identity(1, 1),
	name nvarchar(20)
)

insert into Products values('MyProduct');
select * from Products;

-- Det kan fortfarande uppstå luckor i id-numreringen om vi t.ex:
delete from Products where id = 4;

-- Delete nollställer heller inte identity-räknaren till skillnad från:
truncate table Products




-- 2) Exempel med GUID som PK:
drop table Products

create table Products
(
	id uniqueidentifier primary key default(newid()),
	name nvarchar(20)
)

insert into Products(name) values('MyProduct');
select * from Products;

