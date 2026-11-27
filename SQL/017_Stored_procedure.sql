
alter procedure myProcedure @name nvarchar(20) as
begin
	if len(@name) < 5 
	begin
		return -1;
	end

	print concat('Hello ', @name, '!');

	-- Detta skulle skickas som result-set till klienten.
	-- select top 5 * from users;

	return len(@name) -- datatyp på returvärde är alltid int.
end

declare @result int;
exec @result = myProcedure 'Fredrik';
print @result;
