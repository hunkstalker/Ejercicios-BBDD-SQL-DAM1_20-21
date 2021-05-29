DROP DATABASE IF EXISTS TransaccionsExercici1;
CREATE DATABASE IF NOT EXISTS TransaccionsExercici1;
USE TransaccionsExercici1; 

CREATE TABLE IF NOT EXISTS CicleFormatiu (
    codi CHAR(5) PRIMARY KEY,
    categoria VARCHAR(20),
    hores INT
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Alumne (
    DNI CHAR(9) PRIMARY KEY,
    nom VARCHAR(20),
    qttGermans TINYINT
)  ENGINE=INNODB; 

SET AUTOCOMMIT =0;

INSERT INTO Alumne VALUES ('DNI1','Maria Fernandez',3);
INSERT INTO Alumne VALUES ('DNI2','David Pérez',1);
SAVEPOINT A;
INSERT INTO CicleFormatiu VALUES ('SMX','Informàtica',2000);
INSERT INTO Alumne VALUES ('DNI3','Anastasia González',3);
ROLLBACK TO SAVEPOINT A;
INSERT INTO Alumne VALUES ('DNI4','Santiago Libero',NULL);

-- ***************** TRAM 1 ***************** 
SELECT * FROM Alumne; 
SELECT * FROM CicleFormatiu; 
-- *******************************************

INSERT INTO Alumne VALUES ('DNI5','Gemma Jimenez',2);
INSERT INTO Alumne VALUES ('DNI6','Daniel Trevio',1);
COMMIT; INSERT INTO CicleFormatiu VALUES ('DAM','Informàtica',2000);
SAVEPOINT B; INSERT INTO CicleFormatiu VALUES ('FAR','Medicina',2000);
ROLLBACK TO SAVEPOINT B;
INSERT INTO Alumne VALUES ('DNI7','Gustavo Sanchez',0);
INSERT INTO Alumne VALUES ('DNI8','Agustín Junco',9);
ROLLBACK;

-- ***************** TRAM 2 ***************** 
SELECT * FROM Alumne; 
SELECT * FROM CicleFormatiu; 
-- *******************************************