drop table Employees;

create table Employees
(
	id int,
	name nvarchar(20),
	managerId int
)

insert into Employees(id, name) values(1, 'Maria');
insert into Employees values(2, 'Erik', 1);
insert into Employees values(3, 'Anna', 1);
insert into Employees values(4, 'Thomas', 2);
insert into Employees values(5, 'Anders', 2);

select * from Employees

select 
	e.name as 'Employee',
	isnull(m.name, '-') as 'Manager'
from 
	Employees e
	left join Employees m on e.managerId = m.id




