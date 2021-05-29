DROP DATABASE IF EXISTS TransaccionsExercici2; 
CREATE DATABASE IF NOT EXISTS TransaccionsExercici2; 
USE TransaccionsExercici2;

CREATE TABLE IF NOT EXISTS Alumne (
    DNI CHAR(9) PRIMARY KEY,
    nom VARCHAR(20),
    qttGermans TINYINT
)  ENGINE=INNODB;

CREATE TABLE CicleFormatiu (
    codi CHAR(5) PRIMARY KEY,
    categoria VARCHAR(20),
    hores INT
)  ENGINE=MYISAM;

SET AUTOCOMMIT =0; 
INSERT INTO Alumne VALUES ('DNI1','Maria Fernandez',3); 
INSERT INTO Alumne VALUES ('DNI2','David Pérez',1); 
INSERT INTO CicleFormatiu VALUES ('SMX','Informàtica',2000); 
INSERT INTO Alumne VALUES ('DNI3','Anastasia González',3); 
ROLLBACK; 
-- ***************** TRAM 1 ***************** 
SELECT * FROM Alumne; 
SELECT * FROM CicleFormatiu; 
-- *******************************************

SET AUTOCOMMIT = 1; 
INSERT INTO CicleFormatiu VALUES ('GA','Finances',2000); 
INSERT INTO CicleFormatiu VALUES ('AIF','Finances',2000); 
INSERT INTO Alumne VALUES ('DNI4','Santiago Libero',NULL); 
ROLLBACK; 

-- ***************** TRAM 2 ***************** 
SELECT * FROM Alumne; 
SELECT * FROM CicleFormatiu WHERE categoria='Finances'; 
-- *******************************************

BEGIN;
INSERT INTO Alumne VALUES ('DNI5','Gemma Jimenez',2); 
SAVEPOINT A; 
INSERT INTO Alumne VALUES ('DNI6','Daniel Trevio',1); 
INSERT INTO CicleFormatiu VALUES ('DAM','Informàtica',2000); 
INSERT INTO CicleFormatiu VALUES ('FAR','Medicina',2000); 
ROLLBACK TO SAVEPOINT A; 
COMMIT; 
INSERT INTO Alumne VALUES ('DNI7','Gustavo Sanchez',0); 
ROLLBACK; 

-- ***************** TRAM 3 ***************** 
SELECT * FROM Alumne; 
SELECT * FROM CicleFormatiu; 
-- ******************************************* 

INSERT INTO Alumne VALUES ('DNI8','Agustín Junco',9); 
INSERT INTO Alumne VALUES ('DNI9','Francisco López',4); 
ROLLBACK; 

-- ***************** TRAM 4 ***************** 
SELECT * FROM Alumne; 
SELECT * FROM CicleFormatiu; 
-- *******************************************