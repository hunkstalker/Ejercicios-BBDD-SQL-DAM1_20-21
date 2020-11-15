CREATE DATABASE exercici12;
USE exercici12;

CREATE TABLE IF NOT EXISTS Poblacio (
    codiPostal CHAR(5) PRIMARY KEY,
    ciutat VARCHAR(20) NOT NULL,
    provincia VARCHAR(20)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Sinistre (
    num INT PRIMARY KEY,
    nom VARCHAR(30),
    gravetat INT DEFAULT 1,
    cost DECIMAL(7,2)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Precipitacio (
    dataP DATE,
    tipus CHAR(1) NOT NULL,
    quantitat DECIMAL(5,2) NOT NULL,
    durada INT,
    PRIMARY KEY (dataP,tipus)
)  ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS PPS (
    poblacioCodiPostal CHAR(5),
    precipitacioDataP DATE,
    precipitacioTipus CHAR(1),
    sinistreNum INT,
    PRIMARY KEY (poblacioCodiPostal , precipitacioDataP , precipitacioTipus,sinistreNum),
    CONSTRAINT fk_pps_poblacio FOREIGN KEY (poblacioCodiPostal)
        REFERENCES Poblacio (CodiPostal)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pps_precipitacio FOREIGN KEY (precipitacioDataP,precipitacioTipus)
        REFERENCES Precipitacio (dataP,tipus)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_pps_sinistre FOREIGN KEY (sinistreNum)
        REFERENCES Sinistre (num)
        ON UPDATE CASCADE ON DELETE RESTRICT
)  ENGINE=INNODB;



INSERT INTO poblacio VALUES ('08401','Granollers','Barcelona'),('08402','Granollers','Barcelona'),
							('08420','Canovelles','Barcelona'),('17580','Calella Palafrugell','Girona'),
							('08430','Cardedeu','Barcelona'),('45300','Reus','Tarragona'),
                            ('08701','Sabadell','Barcelona'),('17520','Sils','Girona'),
                            ('17300','Agramunt','Lleida'),('45302','Salou','Tarragona');
INSERT INTO Sinistre VALUES (1,'Inhundació casa',3,500), (2,'Inhundació carretera',6,6000),
				(3,'Semàfor',8,500),(4,'Incendi contenidor',2,700),
                (5,'Teulada Casa',8,2500),(6,'Enfonsament',3,9500),
                (10,'Desbordament riu',3,2500);
INSERT INTO precipitacio VALUES('2019-1-2','p',40,20),('2019-2-2','p',30,15),('2019-2-6','p',50,22);
INSERT INTO precipitacio VALUES('2019-1-3','p',10,20),('2019-2-2','r',20,15),('2019-2-6','n',10,10);
INSERT INTO precipitacio VALUES('2012-1-2','p',20,20),('2017-2-2','p',20,15),('2018-2-6','p',60,22);
INSERT INTO precipitacio VALUES('2018-1-2','p',70,20),('2017-1-27','p',60,15),('2017-2-6','p',90,10);
INSERT INTO precipitacio VALUES('2018-3-2','p',50,20),('2019-4-2','n',130,15),('2019-3-6','p',60,22);
INSERT INTO precipitacio VALUES('2018-3-2','n',110,20),('2017-4-2','r',20,15),('2017-4-6','p',10,10);
INSERT INTO precipitacio VALUES('2019-3-2','n',50,20),('2019-4-2','p',130,15),('2019-5-6','p',60,22);
INSERT INTO PPS VALUES
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2019-1-2','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2019-2-2','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2019-2-6','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2017-4-6','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2012-1-2','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2019-5-6','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2018-3-2','n',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2019-3-2','n',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1)),
((SELECT codiPostal FROM Poblacio ORDER BY RAND() LIMIT 1),'2019-5-6','p',(SELECT num FROM Sinistre ORDER BY RAND() LIMIT 1));

-- VIEW
CREATE VIEW V_Poblacio (CP, Ciutat, Provincia, Data, Tipus, NoSinistre)
AS SELECT Po.*, P.precipitacioDataP, P.precipitacioTipus, P.sinistreNum FROM Poblacio Po
	INNER JOIN PPS P ON Po.codiPostal = P.poblacioCodiPostal;

CREATE VIEW V_Precipitacio (Data, Tipus, Quantitat, Durada, CP, NoSinistre)
AS SELECT Pre.*, P.poblacioCodiPostal, P.sinistreNum FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP;
    
CREATE VIEW V_Sinistre (Numero, Nom, Gravetat, Cost, CP, Data, Tipus)
AS SELECT Si.*, P.poblacioCodiPostal, P.precipitacioDataP, P.precipitacioTipus FROM Sinistre Si
	INNER JOIN PPS P ON Si.num = P.sinistreNum;
    
CREATE VIEW V_Preci_to_Poblacio (Data, Tipus, Quantitat, Durada, CP, NoSinistre, Ciutat, Provincia)
AS SELECT Pre.*, P.poblacioCodiPostal, P.sinistreNum, Po.ciutat, Po.provincia FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
    INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal;
  
CREATE VIEW V_All (Data, Tipus, Quantitat, Durada, NoSinistre, NomSinistre, Gravetat, Cost, CP, Ciutat, Provincia)
AS SELECT Pre.*, Si.num, Si.nom, Si.gravetat, Si.Cost, Po.codiPostal, Po.ciutat, Po.provincia FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
    INNER JOIN Sinistre Si ON Si.num = P.sinistreNum
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal;
    
-- 1. Determina la precipitació total segons l'any en què s'ha produït.
SELECT SUM(quantitat) AS Quantitat, dataP AS Data FROM Precipitacio
	GROUP BY YEAR(dataP);
    
-- 2. Mostra per població el total de minuts que ha plogut per any.
SELECT Ciutat, CONCAT(CAST(SUM(Durada) AS CHAR),' min') AS Temps, YEAR(Data) AS Any FROM V_Preci_to_Poblacio
	GROUP BY Ciutat
    ORDER BY Ciutat; -- Porque puedo.

-- 3. Mostra la mitjana de precipitació de la ciutat de Granollers.
-- CONSULTA AMB VISTA
SELECT CONCAT(CAST(ROUND(AVG(Quantitat),2) AS CHAR),' l/m2') AS 'Precipitació', Ciutat FROM V_Preci_to_Poblacio
	WHERE Ciutat = 'Granollers';

-- CONSULTA NORMAL
SELECT CONCAT(CAST(ROUND(AVG(Quantitat),2) AS CHAR),' l/m2') AS Quantitat, Po.ciutat AS Ciutat FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
    WHERE Ciutat = 'Granollers';
       
-- 4. Determina la precipitació total segons el lloc i el tipus. Cal que s'ordeni per lloc i tipus.
-- CONSULTA AMB VISTA
SELECT CONCAT(CAST(ROUND(AVG(Quantitat),2) AS CHAR),' l/m2') AS 'Precipitació', Ciutat, Tipus AS 'Tipus Precipitació' FROM V_Preci_to_Poblacio
    GROUP BY Ciutat, Tipus
    ORDER BY Ciutat, Tipus;

-- CONSULTA NORMAL
SELECT CONCAT(CAST(ROUND(AVG(Quantitat),2) AS CHAR),' l/m2') AS 'Precipitació', Po.ciutat AS Ciutat, Pre.tipus AS 'Tipus Precipitació' FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
    GROUP BY Ciutat, Tipus
    ORDER BY Ciutat, Tipus;

-- 5. Fer una consulta que mostri: A la ciutat de «ciutat» en el mes «mes» en el dia «dia» ha plogut «x». «dia» ha de ser monday, tuesday … segons la data de la precipitació. Només per l'any 2016.
-- CONSULTA AMB VISTA
SELECT Ciutat, MONTH(Data) AS Mes, DAYNAME(Data) AS Dia, CONCAT(CAST(ROUND(Quantitat,2) AS CHAR),' l/m2') AS 'Precipitació', Tipus, YEAR(Data) AS Any FROM V_Preci_to_Poblacio
	WHERE YEAR(Data)=2018 AND Tipus ='p'
	GROUP BY Ciutat, Mes, Dia, Quantitat, Tipus, Any;
    
-- CONSULTA NORMAL
SELECT Po.ciutat AS Ciutat, MONTH(Pre.dataP) AS Mes, DAYNAME(Pre.dataP) AS Dia, CONCAT(CAST(ROUND(Pre.quantitat,2) AS CHAR),' l/m2') AS 'Precipitació',
		Pre.tipus AS Tipus, YEAR(Pre.dataP) AS Any FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
    WHERE YEAR(Pre.dataP)=2018 AND Tipus ='p'
	GROUP BY Ciutat, Mes, Dia, Quantitat, Tipus, Any;
    
    -- 6. Obtenir la intensitat mitja anual (quantitat/durada) de pluja de cada una de les ciutats. Cal ordenar segons any de forma descendent.
-- CONSULTA AMB VISTA
SELECT CONCAT(ROUND((SUM(Quantitat/Durada)/COUNT(Data)),2),' l/m2') AS Intensitat, Ciutat, YEAR(Data) AS Any FROM V_Preci_to_Poblacio
	GROUP BY Ciutat, Any;

-- CONSULTA NORMAL
SELECT CONCAT(ROUND((SUM(Pre.quantitat/Pre.durada)/COUNT(Pre.dataP)),2),' l/m2') AS Intensitat, Po.ciutat, YEAR(Pre.dataP) AS Any FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
	GROUP BY Po.ciutat, YEAR(Pre.dataP);
    
-- 7. Mostra quines ciutats tenen més precipitació de tipus neus que la població de Cardedeu. Utilitza una vista per la població de Cardedeu.
SELECT Ciutat, SUM(Quantitat) AS Precipitació, Tipus FROM V_Preci_to_Poblacio
GROUP BY Ciutat, Tipus
HAVING Tipus = 'n' AND SUM(Quantitat) > (SELECT SUM(Quantitat) FROM V_Preci_to_Poblacio WHERE Ciutat = 'Cardedeu' AND Tipus ='n');

-- 8. Mostra la quantitat total de precipitació de totes les ciutats que continguin al seu nom les lletres NA i que no continguin BA i a mes hagin tingut un sinistre amb gravetat entre 5 i 10.
-- CONSULTA AMB VISTA
SELECT SUM(Quantitat) AS Precipitació, Ciutat, Gravetat FROM V_All
	WHERE Gravetat BETWEEN 5 AND 10 AND Ciutat NOT LIKE '%BA%' AND Ciutat LIKE '%NA%'
	GROUP BY Ciutat;

-- CONSULTA NORMAL
SELECT SUM(Pre.quantitat) AS Precipitació, Po.ciutat, Si.gravetat FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
    INNER JOIN Sinistre Si ON Si.num = P.sinistreNum
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
    WHERE Si.gravetat BETWEEN 5 AND 10 AND Po.ciutat NOT LIKE '%BA%' AND Po.ciutat LIKE '%NA%'
	GROUP BY Po.ciutat;

-- 9. Obtenir la quantitat de precipitació màxima per a cada una de les següents ciutats: Granollers, Barcelona, Tarragona, Lleida i Girona.
-- CONSULTA AMB VISTA
SELECT MAX(Quantitat), Ciutat FROM v_Preci_to_Poblacio
    GROUP BY Ciutat
    HAVING Ciutat IN ('Granollers','Barcelona','Tarragona','Lleida','Girona');

-- CONSULTA NORMAL A
SELECT MAX(Pre.quantitat) AS Precipitació, Po.ciutat AS Ciutat FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
    GROUP BY Po.ciutat
    HAVING Po.ciutat IN ('Granollers','Barcelona','Tarragona','Lleida','Girona');

-- CONSULTA NORMAL B
SELECT MAX(Pre.quantitat) AS Precipitació, Po.ciutat AS Ciutat FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
	WHERE Po.ciutat IN ('Granollers','Barcelona','Tarragona','Lleida','Girona')
    GROUP BY Po.ciutat;

-- 10. Determina la precipitació total per a cada un dels anys a Barcelona durant el mes de febrer.
-- CONSULTA AMB VISTA
SELECT SUM(Quantitat) AS Precipitació, Ciutat, YEAR(Data) AS Any FROM v_preci_to_poblacio
    WHERE Ciutat = 'Sabadell'
    GROUP BY YEAR(Data), Ciutat;

-- CONSULTA NORMAL A
SELECT SUM(Pre.quantitat) AS Precipitació, Po.ciutat AS Ciutat, YEAR(Pre.dataP) AS Any FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
    WHERE Po.ciutat = 'Sabadell'
    GROUP BY YEAR(Pre.dataP), Po.ciutat;

-- CONSULTA NORMAL B
SELECT SUM(Pre.quantitat) AS Precipitació, Po.ciutat AS Ciutat, YEAR(Pre.dataP) AS Any FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
	GROUP BY YEAR(Pre.dataP), Po.ciutat
    HAVING Po.ciutat = 'Sabadell';
    
-- 11. Fer una consulta que mostri: A la ciutat de «ciutat» en el mes «mes» ha plogut «x» en format «format».
-- CONSULTA AMB VISTA
SELECT Ciutat, MONTHNAME(Data) AS Mes, CONCAT(Quantitat) AS Precipitació, Tipus FROM v_preci_to_poblacio
	GROUP BY Ciutat, MONTHNAME(Data), Precipitació, Tipus;
    
-- CONSULTA NORMAL
SELECT Po.ciutat AS Ciutat, MONTHNAME(Pre.dataP) AS Mes, CONCAT(Pre.quantitat,' l/m2') AS Precipitació, P.precipitacioTipus AS Tipus FROM Precipitacio Pre
	INNER JOIN PPS P ON Pre.dataP = P.precipitacioDataP
	INNER JOIN Poblacio Po ON Po.codiPostal = P.poblacioCodiPostal
	GROUP BY Po.ciutat, MONTHNAME(Pre.dataP), Precipitació, Tipus;
	
-- 12. Determina quins sinistres tenen un cost superior al sinistre amb nom ‘Inhundació’.
SELECT Si.nom, Si.cost FROM Sinistre Si;

-- 13. Determina la mitjana de precipitació de cada una de les ciutats de Granollers i Barcelona que
-- no sigui de tipus pedra.

-- 14. Mostra la precipitació en forma de pedra de la ciutat de Granollers durant el mes de març de
-- l'any 2014 on tinguin sinistres amb cost superior a 50€.

-- 15. Obtenir totes les ciutats que hagin tingut una precipitació mitjana superior a la precipitació
-- mitjana de Granollers en l'any 2014. (utilitza una vista)

-- 16. Mostra tota la informació de les precipitacions on la precipitació en format de neu sigui superior
-- a 40.

-- 17. Obtenir totes les ciutats que la precipitació total anual hagi estat inferior a la precipitació
-- màxima de Barcelona.

-- 18. Fer una consulta que retorni el total de precipitació en cap de setmana.

-- 19. Fer una vista on es vegi per nom de sinistre, la quantitat de vegades on ha succeït. No es vol
-- tenir en compte els sinistres de gravetat 7.

-- 20. Obtenir totes les ciutats on la precipitació mitjana durant l'any 2015 entre els mesos de gener i
-- juny hagi estat superior a la mitjana de precipitació de la ciutat de Granollers pel mateix període.
-- 21. Obtenir la quantitat de precipitació màxima en format de pluja i neu per la ciutat de Granollers.
-- 22. Obtenir totes les poblacions en les quals ha plogut més dies de total de dies que ha plogut a la
-- ciutat de Barcelona.
-- 23. Determina la mitjana de precipitació de les ciutats de Granollers, Barcelona, Girona, Tarragona,
-- Reus, Figueres i Estartit pel mes de febrer per a cada un dels anys.
-- 24. Obtenir tots els llocs que hi hagi hagut alguna precipitació que comencin per B i acabin per A
-- excepte la ciutat de Barcelona.
-- 25. Obtenir la intensitat mitja anual de pluja de cada una de les ciutats. Cal ordenar segons any de
-- forma descendent i ciutat de forma alfabètica.
-- 26. Fer una consulta que mostri: A la ciutat de «ciutat» en el mes «mes» ha plogut «x». (pluja)
-- 27. Obtenir una consulta que em retorni el dia de la setmana (monday, tuesday, …) amb la
-- precipitació i el lloc on s'ha produït.