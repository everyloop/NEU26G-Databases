
select * from Elements

select 
	count(*) as 'TotalNumberOfRows', 
	count(Meltingpoint) as 'NumberOfValuesInMeltingPointColumn', 
	count(Boilingpoint) as 'NumberOfValuesInBoilingPointColumn',
	count(*) - count(Boilingpoint) as 'NumberOfNullsInBoilingPointColumn'
from 
	Elements;


select count(distinct Period) from Elements


select * from Elements where Period = 1 order by Boilingpoint asc


select
	count(*) as 'NumberOfElements',
	min(Boilingpoint) as 'LowestBoilingPoint',
	max(Boilingpoint) as 'HeighestBoilingPoint',
	format(avg(cast(Stableisotopes as float)), 'f2') as 'AverageNumberOfStableIsotopes',
	sum(Valenceel) as 'SumOfValanceElectrons',
	string_agg(Symbol, ', ') as 'Symbols',
	min(Symbol) as 'FirstSymbolInAlphabeticOrder',
	max(Symbol) as 'LastSymbolInAlphabeticOrder'
from
	Elements
where
	Period = 2


select 
	Period, 
	count(*) as 'NumberOfElements',

	-- Vi kan inte plocka ut BoilingPoint rakt av eftersom det finns flera värden i varje grupp
	--Boilingpoint, 
	
	-- Istället måste vi använda en aggregeringsfunktion så att vi får ut minsta, högsta, medel etc.
	min(Boilingpoint) as 'LowestBoilingPoint',
	max(Boilingpoint) as 'HighestBoilingPoint',
	avg(Boilingpoint) as 'AverageBoilingPoint'

from 
	Elements 
group by 
	Period;

select * from Elements order by Period





