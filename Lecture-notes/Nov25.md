
# November 25

**Lecture slide:**  
[Dataintegritet.pdf](https://github.com/everyloop/NEU26G-Databases/blob/main/Resources/Dataintegritet.pdf)  

**Code-alongs:**  
[012_Default_values_&_Check_contraints.sql](https://github.com/everyloop/NEU26G-Databases/blob/main/SQL/012_Default_values_%26_Check_contraints.sql)  

## Dataintegritet

**Dataintegritet** handlar om att informationen i databasen är korrekt, sammanhängande och fri från motsägelser. Vi knöt an till det vi tidigare pratade om kring ACID, framför allt **Consistency**.

Genom att sätta upp integritetsvillkor (**Constraints**) talar vi om för databashanteraren vilka regler som ska gälla för vår data. Databashanteraren ansvarar sedan för att reglerna upprätthålls, oavsett vilken klient som försöker ändra informationen.

Redan valet av datatyp är en begränsning av vilken data som får lagras, men vi kan även sätta upp mer specifika regler.

## Constraints

Vi gick igenom följande integritetsvillkor:

- **NOT NULL** – ett värde får inte saknas.
- **UNIQUE** – värdena måste vara unika.
- **PRIMARY KEY (PK)** – identifierar varje rad unikt och innebär automatiskt att nyckeln är unik och inte får innehålla `NULL`.
- **FOREIGN KEY (FK)** – säkerställer att en referens pekar på en existerande nyckel.
- **CHECK** – anger ett logiskt villkor som data måste uppfylla.

Vi tittade även på **DEFAULT**, som anger vilket värde som ska användas om inget värde anges vid en `INSERT`. Ett defaultvärde kan vara ett konstant värde eller resultatet av en funktion, exempelvis dagens datum.


## Primärnycklar och kompositnycklar

En tabell kan bara ha en primärnyckel, men primärnyckeln kan bestå av flera kolumner. Detta kallas en **kompositnyckel (Composite Key)**.

Det är då kombinationen av kolumnernas värden som måste vara unik, inte varje kolumn för sig.

Ett vanligt användningsområde är kopplingstabeller vid many-to-many-relationer. I en kopplingstabell mellan studenter och kurser kan exempelvis `StudentID` och `CourseID` tillsammans utgöra primärnyckeln. På så sätt förhindrar vi att samma student kopplas till samma kurs flera gånger.

## Foreign Keys och referensintegritet

Vi återkom till vårt tidigare exempel med städer och länder, men satte denna gång upp riktiga PK- och FK-constraints.

Genom att göra `CountryID` i stadstabellen till en Foreign Key säkerställer vi att en stad inte kan referera till ett land som inte finns.

Det är viktigt att skilja på att göra en `JOIN` mellan två tabeller och att faktiskt definiera en relation med en Foreign Key. Vi kan göra en JOIN även utan definierade nycklar, men då finns ingen garanti för att referenserna är giltiga.

När vi lägger till integritetsvillkor i en befintlig tabell kontrollerar SQL Server som standard att även befintlig data uppfyller villkoren. Om så inte är fallet behöver vi först rätta till informationen.

Vi gjorde ändringar både genom designläget i SSMS och med SQL. Med `ALTER TABLE` kan vi ändra strukturen på en befintlig tabell utan att behöva ta bort och återskapa hela tabellen.

## Update Rules och Delete Rules

Vad ska hända med städerna i vår databas om vi tar bort landet som de refererar till? Eller om vi ändrar landets ID?

För en Foreign Key kan vi definiera regler för hur sådana situationer ska hanteras:

- **NO ACTION** – operationen nekas om den skulle bryta mot referensvillkoret. Detta är standardinställningen.
- **CASCADE** – ändringen eller borttagningen sprids automatiskt till de refererande raderna.
- **SET NULL** – referensen sätts till `NULL`, förutsatt att kolumnen tillåter det.
- **SET DEFAULT** – referensen ersätts med sitt defaultvärde, förutsatt att det är giltigt.

Vi kan ange olika regler för `UPDATE` och `DELETE`.

Var särskilt uppmärksam på `CASCADE`, eftersom en enda borttagning kan resultera i att stora mängder data i andra tabeller också tas bort.

## Validering i databasen och applikationen

Vi diskuterade varför det är viktigt att sätta upp integritetsvillkor i själva databasen, även om vi redan validerar användarens indata i vår C#-applikation.

Validering i applikationen kan ge användaren snabbare återkoppling och tydligare felmeddelanden. Men databasen kan användas av flera olika applikationer och klienter.

Genom att även sätta upp regler på databasnivå säkerställer vi att samma grundläggande krav gäller för alla.

## Databasdesign och normalisering

Förutom att sätta upp integritetsvillkor behöver vi strukturera våra tabeller på ett bra sätt.

En bra grundregel är:

**En typ av sak per tabell, och en sådan sak per rad.**

En tabell med böcker bör exempelvis innehålla information om böcker, inte detaljer om författarnas adresser och telefonnummer.

Vi vill framför allt undvika **redundant data**, alltså att samma information lagras på flera ställen. Det största problemet med redundant data är inte nödvändigtvis lagringsutrymmet, utan risken att informationen blir motsägelsefull när den uppdateras på ett ställe men inte på ett annat.

**Normalisering** är processen att strukturera tabeller enligt ett antal regler som kallas normalformer.

## Första normalformen (1NF)

Varje cell ska innehålla ett atomärt värde, alltså ett enskilt värde.

Vi bör exempelvis undvika att lagra flera värden som en kommaseparerad sträng i en kolumn.

Vi tittade på `Airports` i Everyloop-databasen, där stad, region och land ligger i samma textfält. Detta gör det onödigt komplicerat att filtrera, gruppera och aggregera informationen.

Beroende på vilken typ av information det handlar om kan lösningen vara att dela upp informationen i flera kolumner eller att skapa en separat relaterad tabell.

## Funktionellt beroende

För att förstå de högre normalformerna behöver vi förstå begreppet **funktionellt beroende**.

Om värdet på ett attribut A entydigt bestämmer värdet på ett annat attribut B, säger vi att B är funktionellt beroende av A.

A kallas då för en **determinant**.

I vårt bokexempel bestämdes författare och antal sidor av bokens titel, medan priset bestämdes av kombinationen av titel och format (exempelvis pocket eller inbunden).

## Andra normalformen (2NF)

För att uppfylla 2NF behöver tabellen uppfylla 1NF och dessutom sakna partiella beroenden.

Attribut som inte ingår i någon kandidatnyckel ska vara beroende av hela respektive kandidatnyckel, inte bara en del av den.

I bokexemplet hade vi en kompositnyckel bestående av titel och format. Författaren och antalet sidor var dock bara beroende av titeln, medan priset var beroende av både titel och format.

Genom att dela upp informationen i två tabeller kunde vi undvika att upprepa informationen om boken för varje format.

## Tredje normalformen (3NF)

För att uppfylla 3NF behöver tabellen uppfylla 2NF och dessutom undvika transitiva beroenden mellan icke-nyckelattribut.

I vårt exempel hade boktabellen både `GenreID` och `GenreName`. Genrens namn bestäms egentligen av genrens ID, inte direkt av boken.

Genom att bryta ut genrerna till en separat tabell och endast behålla referensen i boktabellen slipper vi lagra samma genrenamn för varje bok.

En bra minnesregel för normalisering är att varje icke-nyckelattribut ska beskriva:

**Nyckeln, hela nyckeln och inget annat än nyckeln.**

Det finns fler normalformer, men i den här kursen fokuserar vi på de tre första.

## ER-diagram

Ett **ER-diagram (Entity Relationship Diagram)** används för att visualisera databasens entiteter och relationerna mellan dem.

Vi tittade på befintliga diagram i Everyloop-databasen och skapade även egna diagram genom **Database Diagrams** i SSMS.

I SSMS representerar nyckelsymbolen one-sidan av en one-to-many-relation, medan oändlighetssymbolen representerar many-sidan.

Vi såg också hur en many-to-many-relation representeras genom en kopplingstabell med två one-to-many-relationer.

Diagrammen kan användas både för att förstå och dokumentera en befintlig databas och som ett grafiskt verktyg för att skapa tabeller, nycklar och relationer. Ändringar som sparas i designverktyget kan alltså påverka själva databasstrukturen.

## Labb 1 – Databasdesign

Vi avslutade dagen med en genomgång av kursens första laboration, där ni ska designa en databas för en bokhandel.

Laborationen knyter samman flera av de koncept vi hittills gått igenom:

- Tabeller, kolumner och lämpliga datatyper.
- One-to-many- och many-to-many-relationer.
- Primary Keys och Foreign Keys.
- Dataintegritet och integritetsvillkor.
- Normalisering enligt 3NF.
- ER-diagram och relevant testdata.

På kommande lektioner går vi även igenom vyer, Stored Procedures och backup, som behövs för att färdigställa laborationen.

Se den separata laborationsbeskrivningen för fullständiga krav och inlämningsinstruktioner.
