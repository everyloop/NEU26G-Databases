-- Med cursors kan vi be servern loopa igenom resultat av en
-- select-sats  en rad i taget, och göra olika operationer.

-- Detta kan vara användbart i vissa fall, t.ex för databasadministration.
-- Ex. vi vill köra ett backupscript för varje databas, eller vi vill
--     skicka ut ett mejl till varje användare som matchar vissa vilkor

-- OBS! Om vi däremot vill göra rena datamanipulationer (CRUD) så finns det
--      i princip alltid en set-baserad lösning som är MYCKET snabbare.

declare @id varchar(100); 
declare @name varchar(100);

declare myCursor CURSOR FAST_FORWARD for 
	select id, FirstName from users;

open myCursor; 

fetch next from myCursor into @id, @name;

while @@FETCH_STATUS = 0
begin
	print convert(varchar, @id) + ' = ' + @name; 
	fetch next from myCursor into @id, @name; 
end;

close myCursor; 
deallocate myCursor;