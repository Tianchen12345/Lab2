
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Judges;
DROP TABLE IF EXISTS Car_Score;



CREATE TABLE Cars(
	Car_ID TEXT PRIMARY KEY,
	Year INT,
	Make TEXT,
	Model TEXT,
	Name TEXT,
	Email TEXT
);

CREATE TABLE Judges(
	Judge_ID TEXT,
	Judge_Name TEXT,
	Timestamp DATETIME

);


CREATE TABLE Car_Score(
	Car_ID TEXT PRIMARY KEY,
	Racer_Turbo INT,
	Racer_Supercharged INT,
	Racer_Performance INT,
	Racer_Horsepower INT,
	Car_Overall INT,
	Engine_Modifications INT,
	Engine_Performance INT,
	Engine_Chrome INT,
	Engine_Detailing INT,
	Engine_Cleanliness INT,
	Body_Frame_Undercarriage INT,
	Body_Frame_Suspension INT,
	Body_Frame_Chrome INT,
	Body_Frame_Detailing INT,
	Body_Frame_Cleanliness INT,
	Mods_Paint INT,
	Mods_Body INT,
	Mods_Wrap INT,
	Mods_Rims INT,
	Mods_Interior INT,
	Mods_Other INT,
	Mods_ICE INT,
	Mods_Aftermarket INT,
	Mods_WIP INT,
	Mods_Overall INT 
);


CREATE TEMP TABLE CSVData(
	Timestamp DATETIME,
	Email TEXT,
	Name TEXT,
	Year INT,
	Make TEXT,
	Model TEXT,
	Car_ID TEXT,
	Judge_ID TEXT,
	Judge_Name TEXT,
	Racer_Turbo INT,
	Racer_Supercharged INT,
	Racer_Performance INT,
	Racer_Horsepower INT,
	Car_Overall INT,
	Engine_Modifications INT,
	Engine_Performance INT,
	Engine_Chrome INT,
	Engine_Detailing INT,
	Engine_Cleanliness INT,
	Body_Frame_Undercarriage INT,
	Body_Frame_Suspension INT,
	Body_Frame_Chrome INT,
	Body_Frame_Detailing INT,
	Body_Frame_Cleanliness INT,
	Mods_Paint INT,
	Mods_Body INT,
	Mods_Wrap INT,
	Mods_Rims INT,
	Mods_Interior INT,
	Mods_Other INT,
	Mods_ICE INT,
	Mods_Aftermarket INT,
	Mods_WIP INT,
	Mods_Overall INT

);

.headers on
.mode csv
.import data_lab2/data.csv CSVData

INSERT INTO Cars(Car_ID,Year,Make,Model,Name,Email) SELECT Car_ID, Year, Make, Model, Name, Email FROM CSVData WHERE 1;

DELETE FROM Cars WHERE Car_ID='Car_ID';

INSERT INTO Judges(Judge_ID,Judge_Name, Timestamp) SELECT Judge_ID, Judge_Name, Timestamp FROM CSVData WHERE 1;

DELETE FROM Judges WHERE Judge_ID='Judge_ID';

INSERT INTO Car_Score(Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body ,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall) SELECT Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body ,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall FROM CSVData WHERE 1;

DELETE FROM Car_Score WHERE Car_ID='Car_ID';



DROP TABLE IF EXISTS Total;

CREATE TABLE Total(
	Car_ID TEXT,
	Year INT,
	Make TEXT,
	Model TEXT,
	Total INT

);

INSERT INTO Total SELECT Car_ID,Year,Make,Model,(Racer_Turbo + Racer_Supercharged + Racer_Performance + Racer_Horsepower + Car_Overall + Engine_Modifications + Engine_Performance + Engine_Chrome + Engine_Detailing + Engine_Cleanliness + Body_Frame_Undercarriage + Body_Frame_Suspension + Body_Frame_Chrome + Body_Frame_Detailing + Body_Frame_Cleanliness + Mods_Paint + Mods_Body + Mods_Wrap + Mods_Rims + Mods_Interior + Mods_Other + Mods_ICE + Mods_Aftermarket + Mods_WIP + Mods_Overall) AS Total FROM CSVData ORDER BY Total DESC;

DELETE FROM Total WHERE Car_ID='Car_ID';

DROP TABLE IF EXISTS Ranking;
CREATE TABLE Ranking(
	Rank INT,
	Car_ID TEXT,
        Year INT,
        Make TEXT,
        Model TEXT,
        Total INT

);
INSERT INTO Ranking(Rank,Car_ID,Year,Make,Model,Total) SELECT rowid, Car_ID, Year, Make, Model, Total FROM Total ORDER BY Total DESC;


DROP TABLE CSVData;

.headers ON
.mode csv
.output extract1.csv
SELECT * FROM Ranking;

DROP TABLE IF EXISTS Top3;
CREATE TABLE Top3(
	Make TEXT,
	Car_ID TEXT,
	Total INT,
	Rank INT
);

INSERT INTO Top3(Make,Car_ID,Total,Rank)SELECT Make,Car_ID,Total,Rank FROM Ranking;
.headers ON
.mode csv
.output extract2.csv
SELECT * FROM Top3;

.headers ON
.mode csv
.output extract3.csv

DROP TABLE IF EXISTS JudgesUpdate;
CREATE TABLE JudgesUpdate(
	Judge_ID TEXT,
	Judge_Name TEXT,
	Num_Cars INT,
	Start DATETIME,
	End DATETIME,
	Duration INT,
	Average INT
	
);
INSERT INTO JudgesUpdate(Judge_ID,Judge_Name,Num_Cars,Start,End,Duration,Average)SELECT 
Judge_ID, 
Judge_Name, 
COUNT(Timestamp) AS Num_Cars, 
MIN(Timestamp) AS Start, 
MAX(Timestamp) AS End,
CAST(strftime('%f','MAX(Timestamp)')-strftime('%f','MIN(Timestamp)') AS INT)*60 AS Duration,
CAST(strftime('%f','MAX(Timestamp)')-strftime('%f','MIN(Timestamp)') AS INT)*60/COUNT(Timestamp) AS Average
FROM Judges GROUP BY Judge_ID;

SELECT * FROM JudgesUpdate;

