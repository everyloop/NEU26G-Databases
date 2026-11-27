drop table demoData;

create table demoData
(
	id int primary key identity(1, 1),
	timestamp datetime2 default(getdate())
)

go

-- 39 sekunder, om vi skickar 100.000 separata inserts till servern.
insert into demoData default values;
go 100000

select * from demoData;

go

truncate table demoData;

go

-- 22 sekunder, om vi ber servern köra en loop med 100.000 inserts.
declare @i int = 0;

while @i < 100000
begin
	insert into demoData default values;
	set @i += 1;
end

go

truncate table demoData;

go

-- 0.24 sekunder, om vi ber servern sätta in 100.000 rader i en insert.
insert into demoData(timestamp)
select getdate() from generate_series(1, 100000);

-- table-valued functions = funktioner som genererar tabelldata.
-- ex:
-- select * from generate_series(0, 100, 5)
-- select * from string_split('this is a sample text', ' ')

