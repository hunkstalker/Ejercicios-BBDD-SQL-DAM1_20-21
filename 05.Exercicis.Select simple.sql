CREATE DATABASE exercici05;
USE exercici05;

CREATE TABLE IF NOT EXISTS Viatge (
	avio CHAR(5),
	data DATE,
	fila TINYINT,
	columna TINYINT,
	finestra BOOL,
    origen CHAR(3),
    desti CHAR(3),
    import DECIMAL(6,2),
    PRIMARY KEY (avio,data,fila,columna)
) ENGINE = INNODB;

INSERT INTO Viatge VALUES ('AIR-3','2020-03-10',1,1,true,'BCN','MAD',120),('AIR-3','2020-03-10',1,2,false,'BCN','MAD',110),('AIR-3','2020-03-10',1,3,false,'BCN','MAD',100), ('JET-4','2020-03-10',1,1,true,'BCN','TNS',420),('BO747','2020-05-10',1,1,false,'MAD','SEV',220),('AIR-3','2020-03-10',4,1,true,'MAD','BCN',120),('AIR-3','2020-03-10',1,6,true,'BCN','MAD',120);

-- 1. Obtenir totes les dades de la taula viatje ordenades alfabèticament per origen i destinació .
SELECT * FROM Viatge
	ORDER BY origen, desti;
-- Correciió: SELECT * FROM Viatge ORDER BY origen, desti;

-- 2. Obtenir la informació de la població d'origen i de destí de tots els viatges que s'han realitzat.
SELECT origen, desti FROM Viatge;
-- Correcció: SELECT **distinct** origen, desti from Viatge;

-- 3. Comptabilitzar quants tickets de viatge s'han venut en seients de finestra.
SELECT COUNT(*) AS "Seients Finestra" FROM Viatge
	WHERE finestra = 'true';
-- Correcció: SELECT count(*) AS 'Seients Finestra' FROM Viatge WHERE finestra = true;

-- 4. Comptabilitzar quants tickets de viatge s'han venut en seients que no siguin de finestra.
SELECT COUNT(*) AS "No son seients de finestra" FROM Viatge
	WHERE finestra = 'false';
-- Correcció: SELECT count(*) AS 'Seients Finestra' FROM Viatge WHERE finestra = false;

-- 5. Obtenir la informació de tots els avions que el seu nom començi per 'AIR-' (la consulta és case insensitive).
SELECT * FROM Viatge
	WHERE avio LIKE 'AIR-%';
-- Correcció a: SELECT * FROM Viatge WHERE LEFT(avio,3) = 'AIR';
-- Correcció b: SELECT * FROM Viatge WHERE avio LIKE 'AIR%';

-- 6. Obtenir totes les dades dels vols entre Barcelona i Madrid realitzats durant l'any 2016 ordenades per import (de major a menor import).
INSERT INTO Viatge VALUES ('AIR-3','2016-04-10',1,1,true,'BCN','MAD',100),('AIR-3','2016-03-10',1,1,true,'BCN','MAD',120),('AIR-3','2017-05-10',1,1,true,'BCN','MAD',100);

SELECT * FROM Viatge
	WHERE origen IN ('BCN','MAD') AND desti IN ('BCN','MAD') AND YEAR(data)=2020
    ORDER BY import DESC;
    
-- Correcció a:
--		SELECT * FROM Viatge WHERE desti IN ('MAD','BCN') AND origen IN ('BCN','MAD') AND year(dataV) = 2020
-- 		ORDER BY importV DESC; 
-- Correcció a:
-- 		SELECT * FROM Viatge WHERE ((origen = 'BCN' AND desti ='MAD') OR (origen = 'MAD' AND desti ='BCN')) AND year(dataV) = 2020
-- 		ORDER BY importV DESC; 

-- 7. Obtenir l'import mitjà de tots els vols entre Barcelona i Madrid realitzats els últims 10 anys. Si s'executa 
	-- la consulta el 2016 serien entre els anys (2007-2016, ambdós inclosos) i si s'executa l'any 2017 entre els anys (2008-2017 ambdós inclosos).
SELECT CONCAT(ROUND(AVG(import)),' €') AS "Import MItjà", avio FROM Viatge
	WHERE origen IN ('BCN','MAD') AND desti IN ('BCN','MAD')
    GROUP BY avio
    AND data BETWEEN YEAR(now()) AND YEAR((now())-10);
    
-- Correcció a:  
-- 		SELECT **avg(importV)** AS 'Import Mitjà' FROM Viatge 
-- 		HERE desti IN ('MAD','BCN') AND origen IN ('BCN','MAD') **AND (year(dataV)** BETWEEN (year(now()) - 10) AND year(now()));
-- Tengo el AVG no tengo que hacer yo el cálculo.

-- Correcció b:
-- 		SELECT * from avion 
-- 		WHERE (origen='barcelona' AND origen='barcelona' or desti='madrid' and desti='barcelona') and year(data) between year(now()) AND year(date_sub(now(), interval 10 year));
    
-- 8. Obtenir el total de passatgers que han ocupat el seient de la fila 2 i columna 3.
INSERT INTO Viatge VALUES ('AIR-3','2020-03-10',2,3,true,'BCN','MAD',120);
INSERT INTO Viatge VALUES ('AIR-3','2020-03-11',2,3,true,'BCN','MAD',120);

SELECT COUNT(*) AS "Qtt de passatgers", COUNT(columna) AS "Qtt de passatgers" FROM Viatge
	WHERE fila = '2' AND columna = '3';
-- Correcció: SELECT COUNT(*) FROM Viatge WHERE fila = 2 AND col = 3;

-- 9. Obtenir el nombre total de passatgers que han sortit de Barcelona amb l'avió AIRBUS A320 PASSENGER amb destinació a Madrid.
INSERT INTO Viatge VALUES ('A320','2020-03-10',2,3,true,'BCN','MAD',120),('A320','2020-03-10',2,2,true,'BCN','MAD',120),('A320','2020-03-10',2,1,true,'BCN','MAD',120);

SELECT COUNT(*) AS "Passatgers" FROM Viatge
	WHERE origen = 'BCN' AND desti = 'MAD' AND avio = 'A320';
-- Correcció: SELECT COUNT(*) AS 'Total passatgers' FROM Viatge WHERE origen ='BCN' and desti = 'MAD' AND avio = 'AIRBUS A320 PASSENGER';

-- 10.Obtenir tots els avions de la taula viatje.
SELECT DISTINCT avio AS "Avions" FROM Viatge;
-- Correcció: SELECT **DISTINCT** avio from Viatge;

-- 11.Obtenir l'import màxim i mínim dels viatges efectuats el mes de febrer de l'any 2016 que han sortit de Palma.
INSERT INTO Viatge VALUES ('A320','2016-03-10',2,3,true,'PAL','MAD',100),('A320','2016-04-11',2,3,true,'PAL','MAD',300),('A320','2016-05-20',2,3,true,'MAD','PAL',150);
INSERT INTO Viatge VALUES ('A320','2016-02-10',2,3,true,'PAL','MAD',100),('A320','2016-02-11',2,3,true,'PAL','MAD',300),('A320','2016-02-20',2,3,true,'MAD','PAL',150);

SELECT MAX(import), MIN(import) FROM Viatge
	WHERE MONTH(data)=2 AND YEAR(data)=2016 AND origen = 'PAL';
-- Correcció: SELECT MIN(importV), max(importV) FROM Viatge WHERE
-- 					MONTH(dataV) = 2 AND YEAR(dataV) = 2016 AND origen = 'PALMA';


-- 12.Obtenir el nom de tots els avions que el seu nom contingui 'AIR-' i acabin amb 360.
INSERT INTO Viatge VALUES ('AIR-300','2020-03-10',2,3,true,'PAL','MAD',300),('AIR-360','2020-03-10',2,3,true,'PAL','MAD',300);

SELECT COUNT(avio) FROM Viatge
	WHERE avio LIKE '%AIR-%360';
-- Correcció a: SELECT avio FROM Viatge WHERE avio LIKE '%AIR-%360';
-- Correcció b: SELECT avio FROM Viatge WHERE avio LIKE '%AIR-%' AND avio LIKE '%360';
    
-- 13.Comptabilitzar el total de viatjes que estan pendents de realitzar-se (data futura).
INSERT INTO Viatge VALUES ('AIR-300','2021-03-10',2,3,true,'PAL','MAD',300),('AIR-360','2021-03-10',2,3,true,'PAL','MAD',300);

SELECT COUNT(*) AS "Viatges Pendents", data Data FROM Viatge
	WHERE data > now();
-- Correcció: SELECT COUNT(*) AS 'Viatges pendents' FROM Viatge WHERE dataV>now();

-- 14.Obtenir totes les dades dels viatjes de l'any 2014, pels mesos de gener, febrer, març, juny , agost i setembre.
INSERT INTO Viatge VALUES ('AIR-300','2014-01-10',2,3,true,'PAL','MAD',300),('AIR-360','2014-02-10',2,3,true,'PAL','MAD',300),
	('AIR-300','2014-08-10',2,3,true,'PAL','MAD',300),('AIR-300','2014-09-10',2,3,true,'PAL','MAD',300),('AIR-300','2014-10-10',2,3,true,'PAL','MAD',300);

SELECT COUNT(*) AS "Total Viatges" FROM Viatge
	WHERE YEAR(data)=2014 AND MONTH(data) IN (1,2,3,6,8,9);
-- Correcció: SELECT * FROM Viatge WHERE MONTH(dataV) IN (1,2,3,6,8,9) AND YEAR(dataV) = 2014;

-- 15.Obtenir l’import total de tots els viatges que han sortit de Barcelona o de Madrid durant l’any 2016 o el 2017.
SELECT CONCAT(SUM(import),'€') AS "Import Total" FROM Viatge
	WHERE origen IN ('BCN','MAD') AND desti IN ('BCN','MAD') AND year(data) IN (2016,2017);

-- Correcció a: SELECT SUM(importV) AS Total FROM Viatge WHERE origen IN ('BCN','MAD') AND YEAR(dataV) IN (2016,2017);
-- Correcció b: SELECT SUM(importV) AS Total FROM Viatge WHERE (origen ='BCN' OR origen = 'MAD') AND YEAR(dataV) IN (2016,2017);