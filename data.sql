CREATE TABLE IF NOT EXISTS Cars(
	Car_ID INT PRIMARY KEY,
	Year INT,
	Make TEXT,
	Models TEXT,
	Name TEXT,
	Email TEXT
);

CREATE TABLE IF NOT EXISTS Judges(
	Judge_ID INT PRIMARY KEY,
	Judge_Name TEXT

);


CREATE TABLE IF NOT EXISTS Car_Score(
	Car_ID INT PRIMARY KEY,
	Score INT



);
