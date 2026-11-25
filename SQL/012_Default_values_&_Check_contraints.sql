drop table products

create table products
(
	id int primary key identity(1, 1),
	name nvarchar(20) default('myProduct'),
	productNumber uniqueidentifier default(newid()),
	createdAt datetime2 default(getdate()),
	price float default(10) check(price > 0)
)

insert into products default values;

insert into products (price) values(0);


select * from products;

