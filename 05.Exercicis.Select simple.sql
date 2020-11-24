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

INSERT INTO Viatge VALUES ('AIR-3','2020-03-10',1,1,true,'BCN','MAD',120),
						('AIR-3','2020-03-10',1,2,false,'BCN','MAD',110),
						('AIR-3','2020-03-10',1,3,false,'BCN','MAD',100),
						('JET-4','2020-03-10',1,1,true,'BCN','TNS',420),
						('BO747','2020-05-10',1,1,false,'MAD','SEV',220),
						('AIR-3','2020-03-10',4,1,true,'MAD','BCN',120),
						('AIR-3','2020-03-10',1,6,true,'BCN','MAD',120);

-- 1. Obtenir totes les dades de la taula viatje ordenades alfabèticament per origen i destinació .
SELECT * FROM viatge
ORDER BY origen, desti;

-- 2. Obtenir la informació de la població d'origen i de destí de tots els viatges que s'han realitzat.
SELECT DISTINCT origen, desti FROM viatge;

-- 3. Comptabilitzar quants tickets de viatge s'han venut en seients de finestra.
SELECT COUNT(*) FROM viatge
WHERE finestra = true;

-- 4. Comptabilitzar quants tickets de viatge s'han venut en seients que no siguin de finestra.
SELECT COUNT(*) FROM viatge
WHERE finestra = false;

-- 5. Obtenir la informació de tots els avions que el seu nom començi per 'AIR-' (la consulta és case insensitive).
SELECT avio FROM viatge
WHERE avio LIKE 'AIR-%';

-- 6. Obtenir totes les dades dels vols entre Barcelona i Madrid realitzats durant l'any 2016 ordenades per import (de major a menor import).
INSERT INTO Viatge VALUES ('AIR-3','2016-03-10',1,1,true,'BCN','MAD',120),('AIR-3','2016-04-10',1,1,true,'MAD','BCN',300);

SELECT * FROM viatge
WHERE ((origen = 'BCN' AND desti = 'MAD') OR (origen = 'MAD' AND desti= 'BCN')) AND YEAR(data) = 2016;

-- 7. Obtenir l'import mitjà de tots els vols entre Barcelona i Madrid realitzats els últims 10 anys. Si s'executa 
-- a consulta el 2016 serien entre els anys (2007-2016, ambdós inclosos) i si s'executa l'any 2017 entre els anys (2008-2017 ambdós inclosos).
INSERT INTO Viatge VALUES ('AIR-3','2017-03-10',1,1,true,'BCN','MAD',120),('AIR-3','2018-04-10',1,1,true,'MAD','BCN',600),('AIR-3','2005-03-10',1,1,true,'BCN','MAD',120);

SELECT CONCAT(ROUND(AVG(import),2),' €') AS 'Import mitjà', data FROM viatge
WHERE origen IN ('BCN' OR 'MAD') AND desti IN ('BCN' OR 'MAD') AND (YEAR(data) BETWEEN (YEAR(now())-10) AND YEAR(now()))
GROUP BY YEAR(data);

-- 8. Obtenir el total de passatgers que han ocupat el seient de la fila 2 i columna 3.
INSERT INTO Viatge VALUES ('AIR-3','2017-03-10',2,3,false,'BCN','MAD',120),('AIR-3','2018-03-10',2,3,false,'BCN','MAD',120);

SELECT COUNT(*) AS Passatgers FROM viatge
WHERE fila = 2 AND columna = 3; 

-- 9. Obtenir el nombre total de passatgers que han sortit de Barcelona amb l'avió AIRBUS A320 PASSENGER amb destinació a Madrid.
INSERT INTO Viatge VALUES ('AIRBUS A320 PASSENGER','2020-03-10',2,3,false,'BCN','MAD',500);

SELECT COUNT(*) AS Passatgers FROM viatge
WHERE (origen = 'BCN' AND desti = 'MAD') AND avio LIKE 'AIRBUS A320 PASSENGER';

-- 10.Obtenir tots els avions de la taula viatje.
SELECT DISTINCT avio FROM viatge;

-- 11.Obtenir l'import màxim i mínim dels viatges efectuats el mes de febrer de l'any 2016 que han sortit de Palma.
INSERT INTO Viatge VALUES ('AIRBUS A320 PASSENGER','2016-03-10',2,3,false,'PMA','MAD',500),('AIRBUS A320 PASSENGER','2016-04-10',2,3,false,'PMA','MAD',250),('AIRBUS A320 PASSENGER','2016-05-10',2,3,false,'PMA','MAD',100);
INSERT INTO Viatge VALUES ('AIRBUS A320 PASSENGER','2016-03-11',2,3,false,'PMA','MAD',510),('AIRBUS A320 PASSENGER','2016-04-12',2,3,false,'PMA','MAD',260),('AIRBUS A320 PASSENGER','2016-05-13',2,3,false,'PMA','MAD',110);
INSERT INTO Viatge VALUES ('AIRBUS A320 PASSENGER','2016-02-15',2,3,false,'PMA','MAD',500),('AIRBUS A320 PASSENGER','2016-02-16',2,3,false,'PMA','MAD',250),('AIRBUS A320 PASSENGER','2016-02-17',2,3,false,'PMA','MAD',100);
INSERT INTO Viatge VALUES ('AIRBUS A320 PASSENGER','2017-02-15',2,3,false,'PMA','MAD',500),('AIRBUS A320 PASSENGER','2018-02-16',2,3,false,'PMA','MAD',250),('AIRBUS A320 PASSENGER','2005-02-17',2,3,false,'PMA','MAD',100);
INSERT INTO Viatge VALUES ('AIRBUS A320 PASSENGER','2005-02-14',2,3,false,'PMA','MAD',1000),('AIRBUS A320 PASSENGER','2004-02-1',2,3,false,'PMA','MAD',20),('AIRBUS A320 PASSENGER','2003-02-17',2,3,false,'PMA','MAD',10);

SELECT MAX(import) AS ImportMax, MIN(import) AS ImportMin, data FROM viatge
WHERE MONTH(data)=2 AND YEAR(data)=2016 AND origen = 'PMA';

-- 12.Obtenir el nom de tots els avions que el seu nom contingui 'AIR-' i acabin amb 360.
INSERT INTO Viatge VALUES ('AIRBUS XBOX 360','2012-02-14',2,3,false,'MAD','PMA',300);
INSERT INTO Viatge VALUES ('AIR-BOX 360','2012-02-14',2,3,false,'MAD','PMA',300);

SELECT * FROM viatge
WHERE avio LIKE '%AIR-%360';
    
-- 13.Comptabilitzar el total de viatjes que estan pendents de realitzar-se (data futura).
INSERT INTO Viatge VALUES ('AIR-XBOX 360','2022-02-14',2,3,false,'MAD','PMA',300);

SELECT COUNT(*) AS Quantitat FROM viatge
WHERE data > now();

-- 14.Obtenir totes les dades dels viatjes de l'any 2014, pels mesos de gener, febrer, març, juny , agost i setembre.
INSERT INTO Viatge VALUES ('AIR-XBOX 360','2014-01-14',2,3,false,'MAD','PMA',300),('AIR-XBOX 360','2014-09-14',2,3,false,'MAD','PMA',300);

SELECT * FROM viatge
WHERE YEAR(data)=2014 AND MONTH(data) IN (1,2,3,6,8,9);

-- 15.Obtenir l’import total de tots els viatges que han sortit de Barcelona o de Madrid durant l’any 2016 o el 2017.
SELECT SUM(import) AS 'Suma_Import_Viatges_2016/2017' FROM viatge
WHERE (origen = 'BCN' AND desti = 'MAD') AND (YEAR(data)=2017 OR YEAR(data)=2016);

SELECT avio, import, data FROM viatge
WHERE (origen = 'BCN' OR origen = 'MAD') AND YEAR(data) IN (2016,2017);
