
-- Temporära tabeller börjar med # och lagras i systemdatabasen 'tempdb'
select top 5
	FirstName,
	LastName
into
	#test
from 
	Users


select * from #test;


-- Vi kan också lagra tabelldata i en variabel av datatyp 'table'.

declare @people table(
	name nvarchar(20),
	age int
);

insert into @people values('Kalle', 20);
insert into @people values('Pelle', 21);

select * from @people;
