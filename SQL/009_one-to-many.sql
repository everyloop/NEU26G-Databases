drop table Countries;

create table Countries
(
	id int,
	name nvarchar(20)
)

insert into Countries values(1, 'Sweden');
insert into Countries values(2, 'Norway');
insert into Countries values(3, 'Denmark');
insert into Countries values(4, 'Finland');


drop table Cities;

create table Cities
(
	id int,
	name nvarchar(20),
	countryId int
)

insert into Cities values(1, 'Stockholm', 1);
insert into Cities values(2, 'Göteborg', 1);
insert into Cities values(3, 'Malmö', 1);
insert into Cities values(4, 'Oslo', 2);
insert into Cities values(5, 'Bergen', 2);
insert into Cities values(6, 'Copenhagen', 3);
insert into Cities values(7, 'London', 5);


select * from Countries;
select * from Cities;

-- Exempel på join
select 
	ci.id,
	ci.name as 'city',
	co.name as 'country'
from 
	Countries co
	right join Cities ci on co.id = ci.countryId




-- Exempel på join och group by/aggeregering
select 
	co.name,
	count(ci.id) as 'Number of cities'
from 
	Countries co
	left join Cities ci on co.id = ci.countryId
group by
	co.name


-- Äldre syntax (join-keyword infördes på 90-talet) - ANVÄND INTE
select
	*
from
	Countries co, Cities ci
where
	co.id = ci.id

