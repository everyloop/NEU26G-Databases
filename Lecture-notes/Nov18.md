# November 18

**Lecture slides:**  
[Aggregering.pdf](https://github.com/everyloop/NEU26G-Databases/blob/master/Resources/Aggregering.pdf)  
[Datatyper och variabler.pdf](https://github.com/everyloop/NEU26G-Databases/blob/master/Resources/Datatyper%20och%20variabler.pdf)  

**Code-alongs:**  
[004_Aggregering.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/004_Aggregering.sql)  
[005_Format_strings.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/005_Format_strings.sql)  
[006_PrimaryKey_Identifier_GUID.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/006_PrimaryKey_Identifier_GUID.sql)  
[007_Variabler.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/007_Variabler.sql)  
[008_Temptabeller_och_tabellvariabler.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/008_Temptabeller_och_tabellvariabler.sql)  

## Aggregering av data

**Aggregering** innebär att vi sammanställer flera datapunkter till ett eller ett fåtal värden, exempelvis en totalsumma, ett medelvärde eller ett antal.

I en databas kan vi ha miljontals rader med information, men ofta är vi mer intresserade av statistik och sammanställningar än av varje enskild rad. Exempelvis kan vi vilja veta hur många bilar som passerat en bro per timme, snarare än att titta på varje registrerad passage.

SQL har flera **aggregeringsfunktioner** som tar ett antal värden och returnerar ett sammanfattande värde:

- `COUNT()` – antal värden
- `SUM()` – summa
- `AVG()` – medelvärde
- `MIN()` och `MAX()` – minsta respektive största värdet
- `STRING_AGG()` – sammanfogar flera textvärden till en sträng

En viktig skillnad är att `COUNT(*)` räknar alla rader, medan `COUNT(kolumn)` bara räknar de rader där kolumnen inte är `NULL`. Aggregeringsfunktioner som `AVG()` och `SUM()` ignorerar också `NULL`-värden.

`MIN()` och `MAX()` kan även användas på text, och returnerar då första respektive sista värdet enligt sorteringsordningen.

## GROUP BY – aggregering per grupp

Utan gruppering beräknas aggregatet över samtliga rader som ingår i frågan, och vi får normalt en enda rad tillbaka.

Med `GROUP BY` kan vi istället dela upp datan i grupper och beräkna aggregat för varje grupp.

Om vi exempelvis har en tabell med städer kan vi gruppera på land och få ut antalet städer och det totala invånarantalet **per land**, istället för en enda totalsumma för hela tabellen.

När vi använder `GROUP BY` kan vi bara ta ut de kolumner vi grupperat på direkt. Övriga kolumner måste ingå i en aggregeringsfunktion, eftersom varje grupp kan innehålla flera olika värden.

## WHERE och HAVING

Både `WHERE` och `HAVING` används för filtrering, men vid olika tillfällen:

- **WHERE** filtrerar enskilda rader *innan* gruppering och aggregering.
- **HAVING** filtrerar grupperna *efter* aggregeringen.

Vi kan exempelvis först välja ut alla städer med fler än 100 000 invånare (`WHERE`), sedan gruppera dem efter land (`GROUP BY`) och slutligen bara visa länder som har minst fem sådana städer (`HAVING`).

Det är alltså viktigt att förstå i vilken ordning filtreringen och aggregeringen sker.

## Formatering av tal och datum

Vi gjorde en liten avstickare till **.NET format strings**, som vi inte gick igenom i detalj under C#-kursen.

SQL Servers `FORMAT()` använder samma typ av formateringssträngar som exempelvis `ToString()` i C#.

Vi kan bland annat formatera tal med ett visst antal decimaler, som procent, valuta eller hexadecimalt, samt välja hur datum och tider ska presenteras.

Formateringen kan också påverkas av **culture/locale**, exempelvis `sv-SE`, eftersom olika länder använder olika decimaltecken, datumformat och valutor.

Kom ihåg att formatering handlar om **hur ett värde presenteras**, inte om att ändra själva värdet som lagras.

## Datatyper och typkonvertering

Precis som i C# har SQL olika datatyper för olika slags information. När vi skapar en tabell måste vi ange datatyp för varje kolumn.

Några vanliga datatyper i SQL Server är:

- `int` – heltal
- `float` – flyttal (approximativa värden)
- `decimal` – decimaltal med bestämd precision
- `bit` – motsvarigheten till booleska värden
- `datetime2` – datum och tid
- `nvarchar` – text med Unicode-stöd

Vi tittade även på skillnaden mellan `varchar` och `nvarchar`, olika heltalsstorlekar och varför flyttal inte alltid kan representera decimaltal exakt.

Datatyperna i SQL Server liknar ofta dem i C#, men de är inte alltid identiska.

Ibland behöver vi **konvertera mellan datatyper**, exempelvis från text till tal eller från datum till text. Då kan vi använda `CAST()` och `CONVERT()`.

En viktig detalj är att datatypen också påverkar resultatet av beräkningar, exempelvis vid division av heltal eller beräkning av medelvärden.

## Primärnycklar, IDENTITY och GUID

En **primärnyckel (Primary Key)** används för att identifiera varje rad i en tabell unikt. Som tumregel bör alla våra tabeller ha en primärnyckel.

Vi gick igenom tre vanliga sätt att välja primärnyckel:

1. **IDENTITY** – ett heltal som SQL Server automatiskt räknar upp när nya rader skapas.
2. **GUID** – ett 128-bitars identifieringsvärde som i praktiken kan genereras unikt även mellan olika system.
3. **Befintligt unikt värde** – exempelvis ett produktnummer eller ISBN.

`IDENTITY` är enkelt och ger korta, lättlästa ID:n. Däremot garanteras inte att numreringen saknar luckor. Om en rad tas bort återanvänds normalt inte dess ID, och `DELETE` återställer inte räknaren medan `TRUNCATE` normalt gör det.

GUID är längre och mer svårlästa, men har fördelen att de kan genereras oberoende av varandra utan att man behöver en gemensam räknare. Det är exempelvis användbart när data från olika system ska slås ihop.

I SQL Server använder vi datatypen `uniqueidentifier` för GUID och kan generera nya värden med `NEWID()`.

## Variabler i SQL

Precis som i C# kan vi använda **variabler** för att tillfälligt lagra värden och återanvända dem.

I T-SQL deklareras variabler med `DECLARE` och ett namn som börjar med `@`. Varje variabel har en datatyp.

Vi kan ge variabler värden direkt vid deklarationen, med `SET` eller med `SELECT`. Det går även att hämta värden från tabeller och lagra dem i variabler.

Variabler kan sedan användas i SQL-frågor, exempelvis som jämförelsevärden i ett `WHERE`-villkor.

Med `PRINT` kan vi skriva ut ett värde i SSMS meddelandefönster, medan `SELECT` returnerar värdet som ett frågeresultat.

## Temporära tabeller och tabellvariabler

Ibland vill vi spara ett mellanresultat från en SQL-fråga för att kunna använda det flera gånger utan att skapa en permanent tabell i databasen.

Då kan vi använda **temporära tabeller**.

En lokal temporär tabell har ett namn som börjar med `#`, exempelvis `#test`. Den lagras i systemdatabasen `tempdb` och är tillgänglig inom den session där den skapades. När sessionen avslutas tas tabellen automatiskt bort.

Vi kan exempelvis använda `SELECT INTO` för att skapa en temporär tabell utifrån ett frågeresultat.

Vi tittade också på **tabellvariabler**, där vi deklarerar en variabel av typen `TABLE`. Till skillnad från en vanlig variabel kan den innehålla flera rader och kolumner.

Båda alternativen kan användas för tillfälliga mellanresultat, men skiljer sig bland annat åt i livslängd och hur SQL Server hanterar dem.
