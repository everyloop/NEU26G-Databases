alter view myView with schemabinding as
select
	FirstName,
	Email
from 
	dbo.users3
where
	FirstName like '[a-d]%'

select * from myView where name like 'a%'

drop table users3







