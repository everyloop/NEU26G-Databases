
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

*/

--select * from Users;

select 
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
	ID < '60'
	-- Selection


