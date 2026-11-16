-- Ta bort tabell
drop table Products;

-- Skapa tabell
create table Products
(
	id int primary key,
	name nvarchar(50) not null
)

