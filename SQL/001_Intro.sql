
-- Radkommentar

/*
	Blockkommentar
*/

/*

SQL är case-insensitive. Man kan alltså blanda små och stora bokstäver.

SSMS:
F5			- Execute query
CTRL + N	- New Query
CTRL + R	- Hide results

select * from [server].[database].[schema].[table]

string literal skrivs med 'singel quote', inte "double quote" som i C#.

Projection: Talar om hur datat ska transformeras och vilka kolumner som ska visas i resultet.
Selection: Talar om VILKA rader från tabellen vi vill plocka ut.

I SQL kan man använda jämförelseoperatorerna även på strängar.
T.ex 'Fredrik' < 'Anna' => Ger FALSE

Jämförelse-operatorer:
C#		SQL
==		=
!=		<>   (Gäller ISO-SQL, men T-SQL tillåter också != )
<		<
>		>
<=		<=
>=		>=

Logiska operatorer:
C#		SQL
&&		AND
||		OR
!		NOT

SQL						     C#
NOT country = 'Sweden'		 !(country == "Sweden")
country <> 'Sweden'			 country != "Sweden"

Standarden (ISO-SQL) anger att queries ska avslutas med semikolon (;), men T-SQL behöver inte det.

*/

/*
select top 5
	-- Projection
	ID, 
	UserName, 
	Upper(FirstName) as 'FirstName',
	LastName,
	42 + 5 as '47', 
	FirstName + ' ' + LastName as 'FullName' 
from 
	Users
where
	-- Selection
	ID < '60'
*/

--select * from Users where FirstName in ('Ulla', 'Milla', 'My');

--select * from Users where FirstName like 'a%' and LastName like '%n'

--select * from Users order by LastName asc, FirstName desc

--select distinct firstname as 'Name' from Users

select
	FirstName,
	len(FirstName) as 'Length',
	case
		when len(FirstName) < 5 then 'Short'
		when len(FirstName) > 8 then 'Long'
		else 'Medium'
	end as 'Length of Name'
from
	Users



