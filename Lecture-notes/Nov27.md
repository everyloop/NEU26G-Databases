
# November 27

**Lecture slide:**  
[Set-based programming.pdf](https://github.com/everyloop/NEU26G-Databases/blob/main/Resources/Set-based%20programming.pdf)  

**Code-alongs:**  
[013_Cursors.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/013_Cursors.sql)  
[014_Subqueries.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/014_Subqueries.sql)  
[015_View.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/015_View.sql)  
[016_Procedural_vs_Set-based_inserts.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/016_Procedural_vs_Set-based_inserts.sql)  
[017_Stored_procedure.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/017_Stored_procedure.sql)  
[018_Stored_procedure_demo-random.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/018_Stored_procedure_demo-random.sql)  


## Procedural Programming och Set-based Programming

Vi återkom till skillnaden mellan imperativ och deklarativ programmering, och tittade närmare på två olika sätt att lösa problem.

- **Procedural Programming** – vi beskriver steg för steg hur en uppgift ska utföras, exempelvis med instruktioner, loopar och villkor. Det är så vi ofta arbetar i C#.
- **Set-based Programming** – vi beskriver vad vi vill åstadkomma med en hel mängd data, och låter databashanteraren avgöra hur uppgiften ska utföras.

SQL är i grunden ett set-baserat språk. När vi skickar en query till SQL Server tar databashanteraren fram en **exekveringsplan (Execution Plan)** och försöker välja de mest effektiva algoritmerna för att utföra uppgiften.

När vi exempelvis gör en `JOIN` behöver vi inte själva implementera en algoritm för att matcha raderna mellan tabellerna. Det sköter databashanteraren åt oss.

En viktig omställning när man kommer från C# är därför att lära sig tänka i hela datamängder istället för enskilda element.

## Flödeskontroll i T-SQL

Även om SQL i grunden är set-baserat finns det stöd för flera av de konstruktioner för flödeskontroll som vi känner igen från C#:

- `IF` / `ELSE` – villkorlig exekvering.
- `WHILE` – loopar.
- `TRY` / `CATCH` – felhantering.

I T-SQL använder vi `BEGIN` och `END` för att avgränsa kodblock, istället för måsvingar som i C#.

Vi tittade även på `EXISTS`, som används för att kontrollera om en query returnerar några rader. Vilka värden frågan returnerar är oväsentligt – vi är bara intresserade av om det finns minst en matchande rad.

Genom att kombinera `IF` och `EXISTS` kan vi exempelvis implementera en **upsert**, där vi uppdaterar en befintlig rad om den finns, och annars lägger till en ny.

Flödeskontroll är användbart när vi behöver fatta beslut om vilka operationer som ska utföras, men vi bör undvika att använda loopar för datamanipulation som kan lösas set-baserat.

## Cursors

En **Cursor** gör det möjligt att iterera genom resultatet av en `SELECT`-sats rad för rad på serversidan.

Vi jämförde detta med hur vi tidigare använde `SqlDataReader` i C# för att läsa en rad i taget.

Med `FETCH NEXT` hämtar vi nästa rad och lagrar kolumnernas värden i variabler, som vi sedan kan använda i en loop.

Cursors kan vara användbara vid exempelvis databasadministration, där vi vill utföra en separat operation för varje databas, eller när vi vill skicka ett mejl till varje användare som uppfyller vissa villkor.

För vanliga CRUD-operationer finns det däremot nästan alltid en bättre set-baserad lösning.

Vi behöver känna till vad cursors är, men kommer inte att fördjupa oss i dem under kursen.

## Prestanda – loopar kontra set-baserade lösningar

För att demonstrera skillnaden i prestanda satte vi in 100 000 rader i en tabell på tre olika sätt.

| Metod | Tid |
| --- | ---: |
| 100 000 separata INSERT-kommandon från klienten | 39 sekunder |
| En WHILE-loop på servern med 100 000 INSERT-operationer | 22 sekunder |
| En set-baserad INSERT som sätter in alla rader på en gång | 0,24 sekunder |

Genom att flytta loopen till serversidan slapp vi skicka ett separat kommando från klienten för varje rad. Den riktigt stora prestandavinsten kom dock när vi helt tog bort loopen.

Den set-baserade lösningen var i detta exempel över 90 gånger snabbare än loopen på serversidan.

Vi pratade också om konceptet **Tally Table**, en tabell som innehåller en serie heltal och som kan användas för att lösa uppgifter där vi annars hade använt en loop.

I demonstrationen använde vi `GENERATE_SERIES()` för att generera motsvarande datamängd.

**Försök i första hand hitta en set-baserad lösning när du arbetar med data i SQL.**

## Subqueries

En **Subquery** är en query inuti en annan query. Den skrivs inom parentes och kan bland annat användas i `FROM`, `WHERE`, `HAVING` eller som ett uttryck i en kolumn i resultatet.

Subqueries kan exempelvis användas för att beräkna ett värde som sedan används i den yttre frågan.

I en av övningsuppgifterna ville vi beräkna hur stor andel av företagets produkter som hade levererats till en viss kund. Istället för att hårdkoda det totala antalet produkter kan vi använda en subquery som räknar dem. Då fungerar frågan även om produktkatalogen förändras.

En viktig skillnad är om den inre frågan är beroende av den yttre:

- En fristående subquery kan köras oberoende av den yttre frågan.
- En korrelerad subquery använder värden från den yttre frågan och kan därför behöva utvärderas för varje rad.

Det senare kan leda till dålig prestanda vid stora datamängder. Vi demonstrerade detta genom att hämta albumnamn för varje låt i musikdatabasen med en subquery, där en vanlig `JOIN` är ett naturligare alternativ.

Ett enkelt sätt att identifiera skillnaden är att testa om den inre frågan går att köra helt fristående.

## Views (vyer)

En **View** är en virtuell tabell som bygger på en sparad query.

En vanlig vy innehåller ingen egen lagrad data, utan hämtar information från bakomliggande tabeller när vi använder den.

Vi kan använda en vy på ungefär samma sätt som en tabell, exempelvis för att filtrera, gruppera, aggregera och göra JOIN.

Vyer är särskilt användbara tillsammans med normaliserade databaser. Vi vill lagra informationen uppdelad i flera tabeller för att undvika redundant data, men vill ofta presentera den i ett mer lättbegripligt format.

Vi kan exempelvis skapa en vy som kombinerar genre, artist, album och låt från musikdatabasens olika tabeller. Därefter kan vi enkelt ställa frågor mot vyn utan att behöva skriva om alla JOIN-operationer varje gång.

**Vi skiljer alltså på hur informationen lagras och hur den presenteras.**

Vyer skapas med `CREATE VIEW` och ändras med `ALTER VIEW`. Vi tittade även på befintliga systemvyer som ger oss information om databasens tabeller, kolumner och andra objekt.

En vy är inte nödvändigtvis skrivskyddad. Under vissa förutsättningar kan vi även göra `INSERT`, `UPDATE` och `DELETE` genom en vy, vilket då påverkar den bakomliggande tabellen.

## Schemabinding

Eftersom en vy är beroende av andra databasobjekt kan den sluta fungera om vi tar bort eller förändrar någon av de bakomliggande tabellerna.

Med `WITH SCHEMABINDING` kan vi förhindra strukturella förändringar som skulle göra vyn ogiltig.

Det betyder inte att tabellerna blir låsta för ändringar i själva datan. Vi kan fortfarande lägga till, ändra och ta bort rader, men vi får exempelvis inte ta bort en kolumn som vyn använder.

När vi använder schemabinding behöver vi också ange schemanamnet för de tabeller vi refererar till, exempelvis `dbo.Users`.

## Table-Valued Functions

En **Table-Valued Function (TVF)** är en funktion som ger oss tabelldata istället för ett enskilt värde.

Vi tittade på två inbyggda funktioner:

- `GENERATE_SERIES()` – genererar en serie numeriska värden.
- `STRING_SPLIT()` – delar upp en sträng i flera rader utifrån ett skiljetecken.

Eftersom funktionerna ger oss tabelldata kan vi använda dem i en `FROM`-sats, ungefär som en vanlig tabell eller vy.

Det går även att skapa egna funktioner i SQL Server, men det ingår inte i den här kursen.

## Stored Procedures

En **Stored Procedure** är återanvändbar kod som sparas i databasen och exekveras på serversidan.

Vi kan jämföra den med en metod i C#, men istället för att den tillhör vår C#-applikation finns den lagrad i databasen och kan anropas från olika SQL-script och klientapplikationer.

En Stored Procedure kan bland annat innehålla:

- Parametrar och defaultvärden.
- Lokala variabler och tabellvariabler.
- Villkor och loopar.
- SQL-frågor och CRUD-operationer.
- Transaktioner.

Vi använder `CREATE PROCEDURE` för att skapa en procedur, `ALTER PROCEDURE` för att ändra den och `EXEC` för att anropa den.

Kom ihåg att när vi ändrar koden i SSMS måste vi faktiskt exekvera vårt `ALTER PROCEDURE`-kommando för att uppdatera den sparade proceduren på servern.

## Returvärden, Output-parametrar och Result Sets

Till skillnad från metoder i C# kan vi inte själva välja datatyp för returvärdet från en Stored Procedure.

Det finns tre olika sätt att få tillbaka information:

- **RETURN** – returnerar alltid ett heltal (`int`) och används vanligtvis som status- eller felkod.
- **OUTPUT-parametrar** – gör det möjligt att skicka tillbaka värden av andra datatyper, ungefär som `out`-parametrar i C#.
- **Result Sets** – genom att använda `SELECT` inuti proceduren kan vi skicka tillbaka hela frågeresultat till klienten.

Det är viktigt att skilja på dessa. Ett frågeresultat som skickas till klienten är inte samma sak som procedurens returvärde.

Vi skapade en procedur som genererade ett valfritt antal slumpmässiga värden med `RAND()`. Värdena lagrades i en tabellvariabel och skickades tillbaka till klienten med `SELECT`, samtidigt som summan av värdena skickades tillbaka genom en OUTPUT-parameter.

## Kopplingen till laborationen

I laborationen ska ni bland annat skapa vyer som presenterar information från er normaliserade bokhandelsdatabas på ett användbart sätt.

För VG-delen ska ni även skapa en Stored Procedure som flyttar böcker mellan olika butikers lagersaldon.

Här behöver ni kombinera flera koncept från kursen:

- Parametrar för att ange vad som ska flyttas och mellan vilka butiker.
- Validering av de värden som skickas in.
- Villkor för att avgöra om operationen kan genomföras.
- Transaktioner för att säkerställa att hela flytten genomförs eller att inga ändringar görs.

Fundera särskilt på vilka situationer som kan uppstå om proceduren anropas med ogiltiga argument, och hur ni kan säkerställa att dataintegriteten bevaras.

Se slides och code-alongs för de fullständiga kodexemplen.
