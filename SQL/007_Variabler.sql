

-- Variabler måste deklareras med en datatyp innan använding.
declare @myInt int = 42;

print @myInt;

-- För att ändra värdet finns keyword Set
set @myInt = 32;

print @myInt;

-- ... alternativ kan man göra det med select.
select @myInt = 22;

print @myInt;

-- Vi kan även selecta ett värde från en tabell och stoppa in i en variabel:
select top 1 @myInt = len(firstName) from Users

select @myInt;

-- Ytterligare exempel på variabler ...
declare @firstName nvarchar(20);
declare @lastName nvarchar(20);

-- ... och hur vi kan sätta flera variabler samtidigt med select (data från tabell)
select top 1 @firstName = FirstName, @lastName = LastName from Users;

print concat(@firstName, ' ', @lastName);

select * from Users where FirstName = @firstName;
