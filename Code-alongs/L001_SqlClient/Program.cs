using Microsoft.Data.SqlClient;

string connectionString = @"Server=localhost\MSSQLSERVER01;Database=everyloop;Trusted_Connection=True;TrustServerCertificate=True;";

string query = "select * from users";

using (var connection = new SqlConnection(connectionString))
using (var command = new SqlCommand(query, connection))
{
    connection.Open();

    using (var reader = command.ExecuteReader())
    {
        for (int i = 0; i < reader.FieldCount; i++)
        {
            Console.Write($"{GetFirstNCharacters(reader.GetName(i), 15), -17}");
        }

        Console.WriteLine();

        while (reader.Read())
        {
            for (int i = 0; i < reader.FieldCount; i++)
            {
                Console.Write($"{GetFirstNCharacters(reader.GetValue(i), 15), -17}");
            }

            Console.WriteLine();
        }
    }
}

static string GetFirstNCharacters(object o, int n)
{
    string? s = o.ToString() ?? string.Empty;

    if (s.Length <= n) return s;

    return s.Substring(0, n);
}