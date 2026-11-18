
-- .NET format string

-- Standard numeric format strings:
select format(123.4567, 'f2');
select format(123.4567, 'c', 'sv-SE');
select format(255, 'X4');
select format(55, 'b8');
select format(0.57, 'p1');

-- Custom numeric format strings:
select format(123.4567, '0.000000');
select format(123.4567, '#.######');

-- Standard datetime format strings:
select format(getdate(), 'd', 'sv-SE')
select format(getdate(), 'D', 'zh')

-- Custom datetime format strings:
select format(getdate(), 'yyyy-MM-dd HH:mm')
select format(getdate(), 'yyyy/dd/MM hh:mm')


-- https://learn.microsoft.com/en-us/dotnet/standard/base-types/formatting-types


