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

}