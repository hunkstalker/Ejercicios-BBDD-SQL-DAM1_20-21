DROP DATABASE IF EXISTS TransaccionsExercici3;
CREATE DATABASE IF NOT EXISTS TransaccionsExercici3;
USE TransaccionsExercici3;
 
CREATE TABLE CicleFormatiu(
 codi CHAR(5) PRIMARY KEY,
 categoria VARCHAR(20), hores int 
 )ENGINE = InnoDB;
 
 CREATE TABLE IF NOT EXISTS Alumne(
 DNI CHAR(9) PRIMARY KEY,
 nom VARCHAR(20), qttGermans tinyint,
 cicleFormatiuCodi CHAR(5),
 CONSTRAINT fk_alumne_cicleFormatiu FOREIGN KEY(cicleFormatiuCodi) REFERENCES CicleFormatiu(codi)
 ON UPDATE CASCADE ON DELETE CASCADE 
 ) ENGINE = MyISAM;
 
 SET AUTOCOMMIT =0;
 
 INSERT INTO CicleFormatiu VALUES ('GA','Finances',2000);
 INSERT INTO CicleFormatiu VALUES ('AIF','Finances',2000);
COMMIT;
 
 INSERT INTO Alumne VALUES ('DNI1','Maria Fernandez',3,'AIF');
 INSERT INTO Alumne VALUES ('DNI2','David Pérez',1,'AIF');
 
ROLLBACK;
 INSERT INTO Alumne VALUES ('DNI3','Anastasia González',3,'GA');
 INSERT INTO Alumne VALUES ('DNI4','Santiago Libero',NULL, 'AIF');
 INSERT INTO Alumne VALUES ('DNI5','Gemma Jimenez',2,'GA');
 COMMIT;
 
 UPDATE Alumne SET qttGermans = qttGermans+2 WHERE qttGermans >1;
 UPDATE CicleFormatiu SET codi = 'GAC' WHERE codi ='GA';
 
 -- ***************** TRAM 1 *****************
 SELECT * FROM Alumne;
 SELECT * FROM CicleFormatiu;
 -- ******************************************* 
 
 INSERT INTO CicleFormatiu VALUES ('SMX','Informàtica',2000);
 DELETE FROM CicleFormatiu WHERE CODI = 'GAC';
 
 -- ***************** TRAM 2 *****************
 SELECT * FROM Alumne;
 SELECT * FROM CicleFormatiu;
 -- *******************************************
ROLLBACK;
COMMIT;
 -- ***************** TRAM 3 *****************
 SELECT * FROM Alumne;
 SELECT * FROM CicleFormatiu;
 -- ******************************************* 
 
 ROLLBACK;
 INSERT INTO Alumne VALUES ('DNI1','Maria Fernandez',3,'AIF');
 INSERT INTO Alumne VALUES ('DNI2','David Pérez',1,'AIF');
 SAVEPOINT B;
 
 INSERT INTO CicleFormatiu VALUES ('TEI','Educació',2000);
 INSERT INTO CicleFormatiu VALUES ('BATX','Batxillerat',1500);
 ROLLBACK TO SAVEPOINT B;
 COMMIT;
 
 -- ***************** TRAM 4 ***************** 
 SELECT * FROM Alumne;
 SELECT * FROM CicleFormatiu;
 -- *******************************************
 
 BEGIN;
 INSERT INTO CicleFormatiu VALUES ('DAM','Informàtica',2000);
 INSERT INTO Alumne VALUES ('DNI6','Daniel Trevio',1,'DAM');
 INSERT INTO Alumne VALUES ('DNI8','Agustín Junco',9,'DAM');
 INSERT INTO Alumne VALUES ('DNI7','Gustavo Sanchez',0,'GA');
 INSERT INTO CicleFormatiu VALUES ('MEC','Mecanica',2000);
 INSERT INTO CicleFormatiu VALUES ('INF','Infermeria',1500);
 ROLLBACK;
 
 INSERT INTO CicleFormatiu VALUES ('DAM','Informàtica',2000);
 INSERT INTO Alumne VALUES ('DNI6','Daniel Trevio',1,'DAM');
 INSERT INTO Alumne VALUES ('DNI8','Agustín Junco',9,'DAM');
 INSERT INTO Alumne VALUES ('DNI7','Gustavo Sanchez',0,'GA');
 
 
