# November 20

**Lecture slide:**  
[Joins.pdf](https://github.com/everyloop/NEU26G-Databases/blob/master/Resources/Joins.pdf)  

**Code-alongs:**  
[009_one-to-many.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/009_one-to-many.sql)  
[010_many-to-many.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/010_many-to-many.sql)  
[011_self-referencing-relationship.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/011_self-referencing-relationship.sql)  

## Relationer mellan tabeller

Hittills har vi främst arbetat med data från en tabell åt gången. I en relationsdatabas är det däremot vanligt att informationen är uppdelad i flera tabeller som har **kopplingar (relationships)** till varandra.

Anledningen till att vi delar upp informationen är framför allt att undvika **redundant data**, alltså att samma information lagras på flera ställen.

Om vi exempelvis lagrar böcker och författare i samma tabell behöver vi upprepa författarens uppgifter för varje bok. Det skapar flera problem:

- Vi lagrar samma information flera gånger.
- Om en uppgift ändras måste vi uppdatera den på flera ställen, annars riskerar vi motsägelsefull information.
- Om vi tar bort alla böcker av en författare riskerar vi också att förlora informationen om författaren.

Istället delar vi upp informationen så att olika **entiteter**, exempelvis böcker och författare, får egna tabeller.

## Primary Key och Foreign Key

För att koppla ihop informationen använder vi ofta **primärnycklar (Primary Keys)** och **främmande nycklar (Foreign Keys)**.

- **Primary Key (PK)** identifierar varje rad i en tabell unikt.
- **Foreign Key (FK)** refererar till en nyckel i en annan tabell (eller samma tabell).

En främmande nyckel behöver inte vara unik. Flera böcker kan exempelvis referera till samma författare.

Det viktiga är att förstå att dessa nycklar inte bara hjälper oss att identifiera kopplingar. De fungerar också som **constraints**, alltså regler som databashanteraren upprätthåller.

En Primary Key garanterar att varje rad har en unik identifierare, medan en Foreign Key säkerställer att referensen pekar på ett värde som faktiskt finns i den refererade tabellen.

Vi behöver däremot inte ha definierat PK och FK för att kunna använda `JOIN`. Det räcker att det finns värden som går att koppla samman.

## JOIN – kombinera data från flera tabeller

Med `JOIN` kan vi kombinera information från flera tabeller när vi hämtar data.

Vi lagrar alltså informationen uppdelad för att undvika redundans, men kan sedan presentera den som ett gemensamt resultat.

Vi gick igenom fem olika typer av JOIN:

- **CROSS JOIN** – ger alla möjliga kombinationer av rader från båda tabellerna.
- **INNER JOIN** – tar bara med rader där det finns en matchning mellan tabellerna.
- **LEFT JOIN** – tar med alla rader från den vänstra tabellen, även om det saknas en matchning i den högra.
- **RIGHT JOIN** – motsvarande LEFT JOIN, men utgår från den högra tabellen.
- **FULL OUTER JOIN** – tar med alla rader från båda tabellerna, oavsett om de har någon matchning.

När en rad saknar matchning fylls kolumnerna från den andra tabellen med `NULL`.

**INNER JOIN är den vanligaste typen**, medan CROSS JOIN är betydligt mer ovanlig.

Med `ON` anger vi vilka kolumner som ska användas för att matcha raderna. Om vi bara skriver `JOIN` betyder det samma sak som `INNER JOIN`.

Vi använder ofta **alias** för tabellerna för att göra frågorna kortare och tydligare. Om flera tabeller har kolumner med samma namn behöver vi också ange vilken tabell vi syftar på.

## One-to-Many

En **One-to-Many-relation (1:N)** innebär att en rad i en tabell kan vara kopplad till flera rader i en annan tabell, men inte tvärtom.

Exempelvis:

- Ett land kan ha många städer.
- Varje stad tillhör bara ett land.

Detta kan representeras genom att stadstabellen har en kolumn med `countryId` som refererar till landet.

Vi använde tabellerna `Countries` och `Cities` för att demonstrera detta.

## Many-to-Many och Junction Tables

En **Many-to-Many-relation (N:M)** innebär att flera rader i den ena tabellen kan vara kopplade till flera rader i den andra.

Exempelvis:

- En student kan läsa flera kurser.
- En kurs kan ha flera studenter.

För att representera detta använder vi en tredje tabell, en **Junction Table** (kopplingstabell).

I vårt exempel hade vi:

- `Students` – information om studenter.
- `Courses` – information om kurser.
- `StudentsCourses` – kopplingarna mellan studenter och kurser.

Kopplingstabellen innehåller studentens ID och kursens ID. Varje rad representerar att en viss student läser en viss kurs.

För att hämta studenternas namn tillsammans med deras kurser behöver vi då göra JOIN mellan alla tre tabellerna.

Samma princip kan exempelvis användas om en bok ska kunna ha flera författare. Det är därför viktigt att fundera på **vilka relationer som faktiskt ska vara möjliga** när vi designar en databas.

## One-to-One

En **One-to-One-relation (1:1)** innebär att en rad i en tabell kan vara kopplad till högst en rad i en annan tabell, och vice versa.

Ett exempel kan vara anställda och deras aktiva passerkort, där varje anställd får ha högst ett kort och varje kort tillhör högst en anställd.

Den här typen av relation är mindre vanlig än One-to-Many och Many-to-Many.

För att upprätthålla en sådan relation behöver vi säkerställa att kopplingen är unik på båda sidor.

## Self-Referencing Relationships

En **Self-Referencing Relationship** innebär att en tabell har en koppling till sig själv.

Det är användbart för exempelvis hierarkier och trädstrukturer.

Vi skapade en tabell med anställda där varje anställd hade:

- Ett eget ID.
- Ett namn.
- Ett `managerId` som refererar till en annan anställd i samma tabell.

På så sätt kan vi representera vem som är chef över vem, utan att behöva en separat tabell för chefer.

Vi kan sedan göra en JOIN mellan tabellen och sig själv för att få ut exempelvis varje anställds namn tillsammans med chefens namn.

Här är **tabellalias särskilt viktiga**, eftersom vi behöver skilja mellan de två roller som samma tabell har i frågan.

Vi använde `LEFT JOIN` för att även få med anställda som inte har någon chef, exempelvis personen högst upp i hierarkin.

## JOIN tillsammans med aggregering

Vi kombinerade även JOIN med `GROUP BY` och aggregeringsfunktioner från förra lektionen.

Exempelvis kan vi först koppla ihop länder och städer och sedan räkna hur många städer varje land har.

En viktig detalj är skillnaden mellan `COUNT(*)` och `COUNT(kolumn)` när vi använder `LEFT JOIN`.

Om ett land saknar städer får vi fortfarande en rad för landet, men stadens kolumner innehåller `NULL`.

- `COUNT(*)` räknar även den raden.
- `COUNT(cityId)` räknar bara rader där `cityId` inte är `NULL`.

För att få resultatet **0 städer** för länder utan städer behöver vi därför räkna en kolumn från stadstabellen som inte är `NULL` för en faktisk stad.

## Databasdesign och fortsatt övning

Nästa vecka börjar vi arbeta mer med databasdesign, där ni själva ska fundera på vilka entiteter som behövs och hur de ska relateras till varandra.

En viktig del av arbetet är att identifiera om en koppling ska vara One-to-Many, Many-to-Many eller någon annan typ av relation.

Ni har också fått övningar där ni ska kombinera data från flera tabeller i Everyloop-databasen, bland annat från `company` och `Music`.

Där blir utmaningen inte bara att skriva rätt SQL-syntax, utan framför allt att **förstå hur tabellerna hänger ihop och översätta en fråga till en SQL-query** som hämtar rätt information.

Se slides och code-alongs för de fullständiga exemplen på JOIN och de olika relationstyperna.
