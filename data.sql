
DROP TABLE IF EXISTS Cars;
DROP TABLE IF EXISTS Judges;
DROP TABLE IF EXISTS Car_Score;


-- create Cars Table
CREATE TABLE Cars(
	Car_ID TEXT PRIMARY KEY,
	Year INT,
	Make TEXT,
	Model TEXT,
	Name TEXT,
	Email TEXT
);
-- Create Judges Table
CREATE TABLE Judges(
	Judge_ID TEXT,
	Judge_Name TEXT,
	Timestamp DATETIME

);

-- Create Car_Score Table to find Total
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

--Create table to hold all info in data.csv
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
--import data from csv file to CSVData Table
.headers on
.mode csv
.import data_lab2/data.csv CSVData

--Insert data into tables
INSERT INTO Cars(Car_ID,Year,Make,Model,Name,Email) SELECT Car_ID, Year, Make, Model, Name, Email FROM CSVData WHERE 1;

--Deleting headers on the first row
DELETE FROM Cars WHERE Car_ID='Car_ID';

INSERT INTO Judges(Judge_ID,Judge_Name,Timestamp) SELECT Judge_ID, Judge_Name,Timestamp FROM CSVData WHERE 1;

--Fixing Timestamp format for julianday()
UPDATE Judges SET Timestamp = REPLACE(Timestamp,"/","-");
UPDATE Judges SET Timestamp = substr(Timestamp,5,4)||"-0"||substr(Timestamp,1,2)||-0||substr(Timestamp,3,1)|| " "|| substr(Timestamp,10,5);

  
DELETE FROM Judges WHERE Judge_ID='Judge_ID';

INSERT INTO Car_Score(Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body ,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall) SELECT Car_ID,Racer_Turbo,Racer_Supercharged,Racer_Performance,Racer_Horsepower,Car_Overall,Engine_Modifications,Engine_Performance,Engine_Chrome,Engine_Detailing,Engine_Cleanliness,Body_Frame_Undercarriage,Body_Frame_Suspension,Body_Frame_Chrome,Body_Frame_Detailing,Body_Frame_Cleanliness,Mods_Paint,Mods_Body ,Mods_Wrap,Mods_Rims,Mods_Interior,Mods_Other,Mods_ICE,Mods_Aftermarket,Mods_WIP,Mods_Overall FROM CSVData WHERE 1;

DELETE FROM Car_Score WHERE Car_ID='Car_ID';


--Create Table for Total
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

--Create table for Ranking
DROP TABLE IF EXISTS Ranking;
CREATE TABLE Ranking(
	Rank INT,
	Car_ID TEXT,
        Year INT,
        Make TEXT,
        Model TEXT,
        Total INT

);

--Total sorted descend and rowid for ranking
INSERT INTO Ranking(Rank,Car_ID,Year,Make,Model,Total) SELECT rowid, Car_ID, Year, Make, Model, Total FROM Total ORDER BY Total DESC;

--Dropping table no longer used
DROP TABLE CSVData;
DROP TABLE Total;

--output from Ranking table to extract1.csv
.headers ON
.mode csv
.output extract1.csv
SELECT * FROM Ranking;


--Create Top3 Table
DROP TABLE IF EXISTS Top3;
CREATE TABLE Top3(
	Make TEXT,
	Car_ID TEXT,
	Total INT,
	Rank INT
);

--Create Top3Unsorted table to hold info
DROP TABLE IF EXISTS Top3Unsorted;
CREATE TABLE Top3Unsorted(
	Make TEXT,
	Car_ID TEXT,
	Total INT,
	Rank INT

);

--Inserting the top rank of each Car_Make into Top3Unsorted
INSERT INTO Top3Unsorted(Make, Car_ID, Total,Rank ) SELECT Make, Car_ID ,Total, MIN(Rank)AS Rank FROM Ranking GROUP BY Make ORDER BY Make,Total DESC;

--Deleting the top rank car in Ranking Table
DELETE FROM Ranking WHERE EXISTS (SELECT * FROM Top3Unsorted  WHERE Top3Unsorted.Rank=Ranking.Rank);

--Repeat until top3 rank car of each Make group is in Top3Unsorted
INSERT INTO Top3Unsorted(Make, Car_ID, Total,Rank ) SELECT Make, Car_ID ,Total, MIN(Rank)AS Rank FROM Ranking GROUP BY Make ORDER BY Make,Total DESC;

DELETE FROM Ranking WHERE EXISTS (SELECT * FROM Top3Unsorted  WHERE Top3Unsorted.Rank=Ranking.Rank);

INSERT INTO Top3Unsorted(Make, Car_ID, Total,Rank ) SELECT Make, Car_ID ,Total, MIN(Rank)AS Rank FROM Ranking GROUP BY Make ORDER BY Make,Total DESC;

DELETE FROM Ranking WHERE EXISTS (SELECT * FROM Top3Unsorted  WHERE Top3Unsorted.Rank=Ranking.Rank);

--Insert into Top3 from Top3Unsorted in ASC Order of Make and Rank
INSERT INTO Top3(Make, Car_ID, Total,Rank) SELECT Make,Car_ID,Total,Rank FROM Top3Unsorted ORDER BY Make,Rank ASC;

--Top3 table output to extract2.csv
.headers ON
.mode csv
.output extract2.csv
SELECT * FROM Top3;


--Create Updated Judges Table
DROP TABLE IF EXISTS JudgesUpdate;
CREATE TABLE JudgesUpdate(
	Judge_ID TEXT,
	Judge_Name TEXT,
	Num_Cars INT,
	Start DATETIME,
	End DATETIME,
	Duration FLOAT,
	Average FLOAT
	
);

--Inserting data into JudgesUpdate

INSERT INTO JudgesUpdate(Judge_ID,Judge_Name,Num_Cars,Start,End,Duration,Average)SELECT 
Judge_ID, 
Judge_Name, 
COUNT(Judge_ID) AS Num_Cars, 
MIN(Timestamp) AS Start, 
MAX(Timestamp) AS End,
ROUND(CAST((julianday(MAX(Timestamp)) -julianday (MIN(Timestamp)))*24  AS FLOAT),2) AS Duration,
ROUND(CAST(((julianday (MAX(Timestamp)) -julianday (MIN(Timestamp)))*24*60) AS FLOAT) / COUNT(Timestamp),2) AS  Average
FROM Judges GROUP BY Judge_ID;

--JudgesUpdate Table output to extract3.csv
.headers ON
.mode csv
.output extract3.csv
SELECT * FROM JudgesUpdate;
