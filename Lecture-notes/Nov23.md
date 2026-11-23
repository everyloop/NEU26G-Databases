
# November 23

**Lecture slide:**  
[ACID-Transaktioner.pdf](https://github.com/everyloop/NEU26G-Databases/blob/master/Resources/ACID-Transaktioner.pdf)  

**Code-alongs:** 
[L001_SqlClient](https://github.com/everyloop/NEU26G-Databases/blob/main/Code-alongs/L001_SqlClient/Program.cs)  
[L002_SQL_Injection_Demo](https://github.com/everyloop/NEU26G-Databases/blob/main/Code-alongs/L002_SQL_Injection_Demo/Program.cs)  

## Ansluta till SQL Server från C#

Hittills har vi främst arbetat med databaser genom SQL Server Management Studio (SSMS). Nu börjar vi även använda SQL Server från våra egna **C#-applikationer**.

Precis som SSMS fungerar vår applikation som en **klient** som ansluter till databasservern och skickar SQL-frågor.

Vi använde NuGet-paketet `Microsoft.Data.SqlClient`, som innehåller klasser för att kommunicera med SQL Server. Paketet behöver installeras separat i de projekt där vi vill använda det.

Några centrala klasser är:

- **SqlConnection** – representerar anslutningen till databasen.
- **SqlCommand** – representerar ett SQL-kommando som ska köras.
- **SqlDataReader** – används för att läsa resultatet från en SQL-fråga.

Med dessa kan vi alltså skicka samma SQL-frågor som vi tidigare skrev i SSMS, men nu direkt från C#.

## Connection Strings

För att ansluta till en databas behöver vi en **Connection String**. Det är en sträng med information om hur anslutningen ska upprättas.

Den kan bland annat innehålla:

- Vilken server eller serverinstans vi ska ansluta till.
- Vilken databas vi vill använda.
- Hur vi ska autentisera oss.
- Olika inställningar för anslutningen.

Vi använde **Windows Authentication** (`Trusted_Connection=True`), vilket innebär att anslutningen använder den Windows-identitet som applikationen körs under.

En Connection String är alltså motsvarigheten till de anslutningsuppgifter vi tidigare fyllde i när vi anslöt till SQL Server från SSMS.

## Läsa data med SqlDataReader

När vi skickar en `SELECT`-fråga till SQL Server får vi tillbaka ett resultat som kan innehålla flera rader och kolumner.

Med `ExecuteReader()` kör vi frågan och får tillbaka en `SqlDataReader`.

Den fungerar som en läsare där vi kan gå igenom resultatet **en rad i taget** med `Read()` och hämta värden från de olika kolumnerna.

Vi kan också undersöka resultatets struktur, exempelvis hur många kolumner det innehåller och vad de heter.

Vi använde `using` för att säkerställa att anslutningar, kommandon och läsare stängs och frigör sina resurser när vi är klara med dem.

## SQL Injection

Vi byggde en enkel C#-applikation där användaren kunde söka efter flygplatser i Everyloop-databasen.

Först byggde vi applikationen på ett osäkert sätt, genom att **sätta in användarens söktext direkt i SQL-frågan** med string interpolation.

Problemet är att SQL Server då inte kan skilja på SQL-kod som vi som utvecklare har skrivit och SQL-kod som en användare eventuellt har matat in.

Detta kallas **SQL Injection** och är en allvarlig säkerhetsrisk.

En användare kan exempelvis manipulera en `WHERE`-sats, lägga till egna SQL-uttryck eller försöka komma åt information som applikationen egentligen inte skulle visa.

Vi demonstrerade detta genom att manipulera sökningen så att applikationen kunde användas för att hämta information från en helt annan tabell än den avsedda flygplatstabellen.

**Problemet är alltså att om användarens indata behandlas som körbar SQL-kod, så kan användaren i princip göra allt som ni kan göra från t.ex. SSMS.**

## Parameterized Queries

För att skydda oss mot SQL Injection använder vi **Parameterized Queries**.

Istället för att bygga ihop SQL-koden och användarens indata till en enda sträng skriver vi en SQL-fråga med parametrar.

Parametervärdena skickas sedan separat till SQL Server.

På så sätt kan databashanteraren skilja mellan:

- **SQL-kod** – instruktionerna som utvecklaren har skrivit.
- **Data** – värden som användaren har matat in.

Även om användaren skriver något som ser ut som SQL-kod kommer det då att behandlas som ett vanligt värde, inte som instruktioner som ska köras.

Vi använde `SqlCommand.Parameters` för att skicka in användarens söktext som en parameter.

**Grundregeln är att aldrig bygga SQL-frågor genom att konkatenera in användardata i SQL-koden.** Använd parametrar istället.

## Transaktioner

En **transaktion** är en eller flera databasoperationer som hör ihop och ska behandlas som en enda enhet.

Ett klassiskt exempel är att föra över pengar mellan två bankkonton:

1. Dra bort pengar från det första kontot.
2. Lägg till samma belopp på det andra kontot.

Om bara den första operationen genomförs har pengar försvunnit. Därför behöver vi kunna garantera att **antingen genomförs båda operationerna eller ingen av dem**.

Med `BEGIN TRANSACTION` kan vi starta en transaktion som omfattar flera SQL-kommandon.

- **COMMIT** – avslutar transaktionen och bekräftar ändringarna.
- **ROLLBACK** – avbryter transaktionen och återställer ändringarna.

Det är vi som utvecklare som behöver avgöra vilka operationer som hör ihop och därför ska ingå i samma transaktion.

## ACID

För att transaktioner ska kunna genomföras på ett tillförlitligt sätt brukar man tala om fyra egenskaper, tillsammans kallade **ACID**.

- **Atomicity** – transaktionen är odelbar. Antingen genomförs hela transaktionen eller inget alls.
- **Consistency** – transaktionen ska bevara databasens integritetsregler och lämna databasen i ett giltigt tillstånd.
- **Isolation** – samtidiga transaktioner ska inte störa varandra på ett sätt som leder till felaktiga resultat.
- **Durability** – när en transaktion har genomförts och bekräftats ska ändringarna finnas kvar, även om systemet kraschar.

Databashanteraren ansvarar för att implementera dessa egenskaper, men vi behöver förstå dem när vi utvecklar applikationer och designar databaser.

Vi kopplade särskilt **Isolation** till det vi tidigare pratat om i C# kring parallell programmering, trådar, `lock` och *race conditions*.

## Transaktionsloggen och återställning

SQL Server använder en **transaktionslogg** för att hålla reda på förändringar i databasen.

Loggen gör det möjligt att bland annat:

- Rulla tillbaka transaktioner som avbryts.
- Återställa databasen till ett konsekvent tillstånd efter en krasch.
- Säkerställa att bekräftade transaktioner inte går förlorade vid ett systemfel.

Principen kallas **Write-Ahead Logging**, vilket innebär att förändringar loggas innan motsvarande ändringar skrivs till databasens datafiler.

Detta är en viktig del av hur SQL Server uppfyller ACID-egenskaperna.

Vi kommer att prata mer om backup och återställning längre fram i kursen.

## Lås och blockeringar

När flera klienter arbetar mot samma databas samtidigt kan de försöka läsa eller ändra samma information.

För att skydda datan använder SQL Server bland annat **lås (Locks)**.

Om en transaktion håller ett lås på data som en annan transaktion behöver kan den andra transaktionen behöva vänta tills låset släpps.

Detta kallas **Blocking** och är i sig inget fel. Det är en normal del av hur databashanteraren hanterar samtidiga transaktioner.

Problem kan däremot uppstå om en transaktion håller kvar lås under lång tid, exempelvis om vi startar en transaktion men glömmer att göra `COMMIT` eller `ROLLBACK`.

Vi demonstrerade detta genom att öppna två olika anslutningar i SSMS och försöka uppdatera samma data från båda.

## Activity Monitor

I SSMS finns **Activity Monitor**, som vi kan använda för att övervaka vad som händer på SQL Server.

Det påminner lite om Aktivitetshanteraren i Windows, men visar istället information om bland annat databasanslutningar och pågående SQL-operationer.

Vi kunde exempelvis se:

- Vilka sessioner som var anslutna.
- Vilka SQL-frågor som kördes.
- Om en session blockerades av en annan.
- Vilken session som orsakade blockeringen.

Vi demonstrerade också hur en blockerande session kunde avslutas, så att den väntande frågan kunde fortsätta.

Detta är främst något man arbetar med vid felsökning och databasadministration, men det är bra att känna till varför en SQL-fråga ibland kan verka ha fastnat.

## Deadlocks

En **Deadlock** uppstår när två eller flera transaktioner väntar på resurser som de andra håller låsta, så att ingen av dem kan fortsätta.

Exempelvis:

1. Transaktion A låser en resurs som transaktion B behöver.
2. Transaktion B låser samtidigt en annan resurs som transaktion A behöver.
3. Båda väntar på varandra och ingen kan bli klar.

Till skillnad från vanlig blocking kan detta inte lösas genom att bara vänta.

SQL Server kan upptäcka sådana dödlägen och väljer då att avbryta och rulla tillbaka en av transaktionerna, så att den andra kan fortsätta.

Deadlocks är något vi behöver känna till när vi utvecklar applikationer som arbetar med databaser, särskilt när många användare gör ändringar samtidigt.
