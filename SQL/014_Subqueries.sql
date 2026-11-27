
-- Subqueries - en query inne i en annan query - skrivs inom parantes och kan
-- förekomma t.ex i FROM, WHERE, HAVING eller i enskilda kolumner (projection).

-- I detta exempel selectar vi FROM en subquery, 
-- och har även en subquery i en enskild kolumn.
select 
	UPPER(name),
	Lower(name),
	(select count(*) from users)
from
(
	select
		id,
		concat(FirstName, ' ', LastName) as 'Name',
		Email
	from
		users
) mySubQuery


-- I exemplet ovan är ingen subquery beroende av den yttre
-- (de går att köra helt fristående om ni markerar koden i den innre)

-- Om ni däremot har ett exemepl som nedan, så kan användandet av subqueries
-- bli långsamt (jämför med t.ex en vanlig join) då den inre queryn kommer
-- behöva köras många gånger.

select 
	TrackId,
	Name,
	AlbumId,
	(select top 1 title from music.albums where AlbumId = t.AlbumId)
from music.tracks t




