
-- Sätta in enskilda rader med givna värden:
insert into Students values (8, 'Ann', 'Karlsson');
insert into Students values (9, 'Anne', 'Andersson');
--select * from Students;

-- Exempel på Select Into (skapa en ny tabell utifrån resultatet av en select-sats)
select
	FirstName,
	len(FirstName) as 'Length',
	case
		when len(FirstName) < 5 then 'Short'
		when len(FirstName) > 8 then 'Long'
		else 'Medium'
	end as 'Length of Name'
into
	Users
from
	everyloop.dbo.Users
where
	FirstName like '[a-o]%'


-- Sätta in värden (från resultat) i befintlig tabell (insert into select from) 
insert into Users
select left(Title, 20), EpisodeInSeason, left([Directed by], 6) from everyloop.dbo.GameOfThrones where Season = 1


-- Exempel på update:
update Users set FirstName = 'hej', [Length of Name] = 'hopp', [Length] = 0 where [Length] = 5

--select * from Users;

-- Exempel på delete:
delete from Users where [Length of Name] = 'Short'


