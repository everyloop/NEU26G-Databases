# November 16

**Lecture slides:**  
[Introduktion till SQL.pdf](https://github.com/everyloop/NEU26G-Databases/blob/master/Resources/Introduktion%20till%20SQL.pdf)  
[Grundläggande CRUD-operationer.pdf](https://github.com/everyloop/NEU26G-Databases/blob/master/Resources/Grundl%C3%A4ggande%20CRUD-operationer.pdf)

**Code-alongs:**  
[001_Intro.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/001_Intro.sql)  
[002_CRUD.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/002_CRUD.sql)  
[003_Skapa_och_ta_bort_tabell.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/003_Skapa_och_ta_bort_tabell.sql)  

## Databaser och relationsdatabaser

En **databas** är organiserad information som vi kan söka i och förändra. En **databashanterare** (DBMS) är programvaran som sköter detta. Nu i början av kursen arbetar vi med **relationsdatabaser**, där data lagras i tabeller med rader och kolumner. Senare kommer vi även kolla på andra typer, exempelvis dokumentdatabaser.

En liten begreppsdetalj från lektionen: *relation* är i den matematiska bakgrunden till relationsdatabaser ungefär en tabell. Kopplingar mellan tabeller kallas på engelska *relationships*. Namnet ”relationsdatabas” kommer alltså inte från att tabeller kan kopplas ihop, även om sådana kopplingar är viktiga.

## SQL, SQL Server och SSMS

**SQL** (*Structured Query Language*) är språket vi använder för att kommunicera med en relationsdatabas: läsa, lägga till, ändra och ta bort data, men även skapa databasobjekt. SQL är standardiserat, men olika databashanterare har egna dialekter. Microsoft SQL Server använder **T-SQL**.

**SQL Server** är själva databashanteraren och körs som en tjänst. **SQL Server Management Studio (SSMS)** är en **klient** som ansluter till servern och skickar SQL-frågor. Även när vi klickar i SSMS menyer genererar klienten SQL i bakgrunden. Om SQL Server-tjänsten stoppas kan SSMS inte längre arbeta mot den instansen.

Under övningarna finns server och klient på samma dator (`localhost`). I ett vanligt system kan många klienter ansluta till en server över nätverket. En C#-applikation som använder databasen är också en klient – SSMS är bara ett av flera sätt att ansluta.

## Anslutning, rättigheter och rätt databas

En SQL Server-instans kan innehålla flera databaser, och SSMS kan ha flera serveranslutningar öppna samtidigt. **Kontrollera alltid vilken server, databas och användaridentitet du arbetar med innan du kör en fråga**, särskilt en fråga som ändrar eller tar bort data.

Ett objektnamn kan anges med flera delar:

```sql
[server].[database].[schema].[table]
```

Ofta räcker ett kortare namn, eftersom aktuell anslutning, vald databas och standardschema (vanligen `dbo`) används. Men det gör också att samma SQL-fråga kan påverka olika data beroende på var den körs.

Med **Windows Authentication** används din Windows-identitet vid anslutningen. Behörigheter styr vad användaren får göra. SQL Server-tjänsten kör dessutom under en egen identitet: när servern ska läsa en backupfil behöver **tjänsten**, inte bara du i Windows, ha åtkomst till filen.

## Tabeller, nycklar och NULL

En tabell har kolumner med namn och datatyper. En **primärnyckel** identifierar varje rad unikt och får inte vara `NULL`. `NULL` betyder att ett värde saknas eller är okänt; det är inte samma sak som noll eller en tom sträng. Med `NOT NULL` kräver vi att kolumnen har ett värde.

Vi skapade tabeller både via SSMS gränssnitt och med `CREATE TABLE`. När en tabell skapas eller tas bort via SQL kan objektlistan i SSMS behöva **Refresh**: klienten har inte automatiskt hämtat en ny lista från servern.

## SELECT – vilka kolumner och vilka rader?

Med `SELECT` hämtar vi data. Två användbara begrepp är:

- **Projection:** vilka kolumner eller beräknade uttryck som ska finnas i resultatet.
- **Selection:** vilka rader som ska ingå, exempelvis med `WHERE`.

Vi använde bland annat `TOP`, `IN`, `BETWEEN`, `LIKE`, `ORDER BY`, `DISTINCT`, alias och `CASE` för att begränsa, sortera och forma resultat. Kom ihåg att `TOP` utan en relevant `ORDER BY` inte garanterar *vilka* rader som kommer med.

SQL skiljer sig på vissa punkter från C#: exempelvis används `'enkla citattecken'` för strängar, `=` för jämförelse och `AND`/`OR`/`NOT` för logiska villkor. Se slides och code-along för syntaxen.

## CRUD och ändringar i data

**CRUD** sammanfattar de fyra grundoperationerna: **Create** (`INSERT`), **Read** (`SELECT`), **Update** (`UPDATE`) och **Delete** (`DELETE`). `SELECT INTO` kan skapa en ny tabell av ett frågeresultat, medan `INSERT INTO ... SELECT` kan lägga resultatet i en befintlig tabell.

**Var extra försiktig med `UPDATE` och `DELETE`: utan `WHERE` kan alla rader påverkas.** Ett bra arbetssätt är att först köra en `SELECT` med samma villkor och kontrollera resultatet. Säkerställ också att du arbetar mot rätt databas och har en återställningsmöjlighet. Transaktioner med `COMMIT` eller `ROLLBACK` är ytterligare ett skydd som vi kommer att återkomma till.

Skilj på att ta bort **rader** (`DELETE`), tömma en tabell på alla rader (`TRUNCATE TABLE`) och ta bort **själva tabellen** (`DROP TABLE`).
