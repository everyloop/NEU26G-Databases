using Microsoft.Data.SqlClient;

string connectionString = @"Server=localhost\MSSQLSERVER01;Database=everyloop;Trusted_Connection=True;TrustServerCertificate=True;";


using (var connection = new SqlConnection(connectionString))
{
    connection.Open();

    string searchString = string.Empty;

    while(true)
    {
        Console.Write("Enter new search string: ");

        searchString = Console.ReadLine() ?? string.Empty;

        if (searchString == string.Empty) break;

        Console.Clear();

        Console.ForegroundColor = ConsoleColor.DarkGray;
        Console.Write("Search string: ");
        Console.ForegroundColor = ConsoleColor.Yellow;
        Console.WriteLine(searchString);
        Console.ResetColor();

        SearchAirports(connection, searchString);
    }
}

static void SearchAirports(SqlConnection connection, string searchString)
{
    // SQL-INJECTION!!!

    // Följande kod konkatenerar användardata in i en interpoliation string som sedan skickas till SQL Server.
    // Servern kan därmed inte göra skillnad på kod som utvecklaren skrivit och eventuell injecerad kod som användaren skrivit.

    // Ett exempel är om användaren t.ex skriver in följande kod som input:
    // ' and 1 = 0 union select top 10 username, email, id from users; --

    // Raw literal value
    string insecure_query = $"""
                            select top 10
                                [IATA],
                                [Airport name],
                                [Location served]
                            from 
                                Airports
                            where
                                [Location served] like '%{searchString}%';
                            """;

    // PARAMETERIZED QUERY

    // För att skydda sig mot SQL-injection får man ALDRIG konkatenera användardata och SQL-kod innan denna skickas till SQL-servern.
    // Använd istället parameterized queries, som skickar användardata skilt från query, så SQL Server vet vilket som är vilket.
    // Sedan kan SQL Server själv, på sin sida, konkatenera dem.

    // Query bör ALLTID vara en statisk sträng.

    string query = """
                    select top 10
                    	[IATA],
                    	[Airport name],
                    	[Location served]
                    from 
                    	Airports
                    where
                    	[Location served] like concat('%', @searchText, '%');
                    """;
    using (var command = new SqlCommand(query, connection))
    {
        // Den statiska strängen ovan använder sig av en parameter @searchText, som vi kan definera som:
        command.Parameters.AddWithValue("@searchText", searchString);

        try
        {
            using (var reader = command.ExecuteReader())
            {
                Console.ForegroundColor = ConsoleColor.White;
                Console.WriteLine();
                Console.Write($"{reader.GetName(0).ToUpper(),-10}");
                Console.Write($"{reader.GetName(1).ToUpper(),-50}");
                Console.Write($"{reader.GetName(2).ToUpper()}");
                Console.WriteLine("\n");

                while (reader.Read())
                {
                    Console.WriteLine($"{reader.GetValue(0),-10}{reader.GetValue(1),-50}{reader.GetValue(2)}");
                }

                Console.ResetColor();
            }
        }
        catch (Exception ex)
        {
            Console.WriteLine();
            Console.ForegroundColor = ConsoleColor.Red;
            Console.WriteLine(ex.Message);
            Console.ResetColor();
        }
    }

    Console.WriteLine();
    Console.ForegroundColor = ConsoleColor.Blue;
    Console.WriteLine(query);
    Console.ResetColor();
    Console.WriteLine();
}

