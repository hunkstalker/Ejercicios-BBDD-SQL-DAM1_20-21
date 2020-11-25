CREATE DATABASE IF NOT EXISTS Exercici13;
USE Exercici13;

CREATE TABLE IF NOT EXISTS genere (
	codi CHAR(5) PRIMARY KEY,
    nom VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS soci (
	Codi CHAR(5) PRIMARY KEY,
    DNI CHAR(9) UNIQUE,
    nom VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS llibre (
	ISBN CHAR(13) PRIMARY KEY,
    titol VARCHAR(45),
	totalExemplars INT,
	genereCodi CHAR(5),  -- FK
    CONSTRAINT fk_llibre_genere FOREIGN KEY (genereCodi) REFERENCES Genere(codi)
		ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS perestecs (
	llibreISBN	CHAR(13), -- FK PK
    sociCodi CHAR(5), -- FK PK
    NumProrogues INT,
    dataPrestec DATE, -- PK
    dataRetorn DATE,
    dataRetornTeo DATE,
    PRIMARY KEY (llibreISBN,sociCodi),
    CONSTRAINT fk_prestecs_llibres FOREIGN KEY (llibreISBN) REFERENCES Llibre(ISBN)
		ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT fk_prestecs_soci FOREIGN KEY (sociCodi) REFERENCES Soci(codi)
		ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE = INNODB;

-- Se me olvidó crear el campo como case sensitive
ALTER TABLE genere
MODIFY COLUMN nom VARCHAR(45) COLLATE Latin1_General_CS;

INSERT INTO Genere VALUES ('GEN01','Drama'),('GEN02','Humor'),('GEN03','Terror');
INSERT INTO Soci VALUES ('B0765','40334123N','Anna'),('A2501','40314123E','Maria'),('UMBLA','60785123Y','Hunk');
INSERT INTO Llibre VALUES ("9788473291941","L'últim mono",5,"GEN02"),("9788416367245","Puresa",3,"GENO3"),("7854473291941","The Umbrella Chronicles",10,"GENO3");

-- 4. Es vol un llistat de tots els llibres per nom de gènere. Cal tenir en compte que no es volen llistar aquells llibres que tenen menys de 10 exemplars o ni que siguin del gènere “Drama” o “Terror”.
SELECT L.*, G.nom FROM Llibre L
INNER JOIN Genere G ON G.codi = L.genereCodi
WHERE NOT L.totalExemplars < 10 OR NOT G.nom IN ('Drama','Terror');

-- 5. Per error documental, cal incrementar en 5 el total d’exemplars de les categories de ‘Drama’, ‘Terror’ i també d’aquells codis on el seu gènere estigui entre el 1 i el 9.
-- Cal dir que els codis poden ser: ‘GEN01’, ‘GEN23’.
UPDATE Llibre L
INNER JOIN Genere G ON G.codi = L.genereCodi
SET l.totalExemplars = l.totalExemplars + 5
WHERE (RIGHT(G.codi,2) BETWEEN 1 AND 9) OR G.nom IN ('Drama','Terror');

-- OPTIONAL
UPDATE Llibre L
INNER JOIN Genere G ON G.codi = L.genereCodi
SET l.totalExemplars = l.totalExemplars + 5
WHERE G.codi LIKE 'GEN_' OR G.nom IN ('Drama','Terror');

-- SET AUTOCOMMIT = 0;
-- COMMIT;
-- ROLLBACK;

-- 6. Fes un llistat amb totes les dades dels llibres que encara no han estat prestats.
SELECT L.* FROM llibre L
	LEFT JOIN prestecs P ON L.ISBN = P.llibreISBN
    WHERE P.dataPrestec IS NULL;
    
-- 6b. Fer un llistat de tots els llibres on es vegi el ISBN i titol amb el nombre de vegades que ha estat prestat.
INSERT INTO Llibre VALUES ("9788473291222","Titanic",5,"GEN01",0);

SELECT DISTINCT L.ISBN, l.TITOL, COUNT(*) AS VegadesPrestats FROM llibre L
	LEFT JOIN prestecs P ON L.ISBN = P.llibreISBN
    GROUP BY L.ISBN
    ORDER BY VegadesPrestats DESC;

-- 7. Cal actualitzar i posar en majúscula la primer lletra del nom de cada soci.
UPDATE soci
SET nom=CONCAT(UPPER(LEFT(nom,1)),LOWER(SUBSTRING(nom,2,LENGTH(nom))));

-- hacer la resta a LENGTH(nom)

SELECT * FROM soci;
-- 8. La Maria ha agafat prestat el llibre Puresa. La data que ha de constar com a préstec és la data d'avui. El llibre s'haurà de tornar en 25 dies.
INSERT INTO prestecs VALUES ("9788416367245","A2501",NULL,DATE(now()),DATE(DATE_ADD(now(),INTERVAL 25 DAY)),DATE(DATE_ADD(now(),INTERVAL 25 DAY)));

-- 9. La Maria ha agafat prestat el llibre L'últim mono. La data que ha de constar és la data d'avui. El llibre s'haurà de tornar en 25 dies. Si ho creieu convenient podeu introduir més préstecs.
INSERT INTO prestecs VALUES ("9788473291941","A2501",NULL,DATE(now()),DATE(DATE_ADD(now(),INTERVAL 25 DAY)),DATE(DATE_ADD(now(),INTERVAL 25 DAY)));

-- 10. Quants cops els socis han tornat el llibre més tard de la data de retorn que tenia que ser.
ALTER TABLE prestecs DROP FOREIGN KEY fk_prestecs_llibres; 
ALTER TABLE prestecs DROP FOREIGN KEY fk_prestecs_soci; 
ALTER TABLE prestecs DROP PRIMARY KEY;
ALTER TABLE prestecs ADD PRIMARY KEY (llibreISBN,sociCodi,dataPrestec);
ALTER TABLE prestecs ADD CONSTRAINT fk_prestecs_llibres FOREIGN KEY (llibreISBN) REFERENCES Llibre(ISBN)
		ON UPDATE RESTRICT ON DELETE CASCADE;
ALTER TABLE prestecs ADD CONSTRAINT	fk_prestecs_soci FOREIGN KEY (sociCodi) REFERENCES Soci(codi)
		ON UPDATE RESTRICT ON DELETE RESTRICT;

INSERT INTO prestecs VALUES ("9788416367245","A2501",0,'2019-02-08','2019-03-11','2019-03-11');
INSERT INTO prestecs VALUES ("9788473291941","A2501",0,'2020-05-08','2020-07-08','2020-07-08');
INSERT INTO prestecs VALUES ("9788473291941","A2501",0,'2021-05-08','2021-07-08','2021-07-07');

select * from prestecs;

SELECT COUNT(*) AS TotalRetard FROM prestecs
WHERE dataRetorn > dataRetornTeo AND dataRetorn IS NULL;

-- 11. Es vol obtenir un llistat de la següent forma <codi> - <DNI> : <nom> dels socis que no han realitzat cap préstec.
SELECT CONCAT(codi,' - ',dni,': ',nom) AS Socis FROM soci S
LEFT JOIN prestecs P ON S.codi = P.sociCodi
WHERE P.sociCodi IS NULL;

-- 12. La Maria ha demanat una pròrroga pel llibre L'últim mono. La pròrroga li concedeix 20 dies més.
-- EN CASO DE QUE NumProrogues sea NULL.
UPDATE llibre L
INNER JOIN prestec P ON L.ISBN = P.llibreISBN
INNER JOIN soci S ON S.codi = P.sociCodi
	SET P.dataRetornTeo = DATE(DATE_ADD(P.dataRetornTeo,INTERVAL 20 DAY)),
    P.NumProrogues = 1 WHERE P.NumProrogues IS NULL AND S.nom = 'Maria' AND L.titol = "L'últim mono";

-- Alternativa ALTER TABLE

-- Denis version locker!
-- Caldria tenir en compte si numprog is null
UPDATE llibre L
INNER JOIN prestec P ON L.ISBN = P.llibreISBN
INNER JOIN soci S ON S.codi = P.sociCodi
	SET P.dataRetornTeo = DATE(DATE_ADD(P.dataRetornTeo,INTERVAL 20 DAY)), P.NumProrogues = IF(ISNULL(P.NumProrogues),1,P.NumProrogues+1)
    WHERE S.nom = 'Maria' AND L.titol = "L'últim mono";
    
-- EN CASO DE QUE NumProrogues sea 0 (lo ideal sería que este campo no pudiera ser NULL, pudiéndolo establecer en 0 de inicio y siempre sumar en caso necesario).
ALTER TABLE prestecs
MODIFY NumProrogues INT NOT NULL; 

UPDATE prestecs
	SET dataRetornTeo = DATE(DATE_ADD(dataRetornTeo,INTERVAL 20 DAY)),
    NumProrogues = NumProrogues + 1;

-- 13. Hunk ha retornat el llibre Umbrella Chronicles 3 dies abans de la data de retorn establerta, Hunk es bona persona.
INSERT INTO prestecs VALUES ('7854473291941','UMBLA',0,'2020-11-01',NULL,'2020-11-21');
UPDATE prestecs
SET dataRetorn = dataRetornTeo-3
WHERE llibreISBN = '7854473291941' AND sociCodi = 'UMBLA' AND dataPrestec = '2020-11-01';

-- 14. La Maria ha tornat a agafar el llibre puresa el 25 de febrer del 2016. El llibre s'ha de tornar en 20 dies.
INSERT INTO prestecs VALUES ('9788416367245','A2501',0,'2016-02-25',NULL,DATE(DATE_ADD('2016-02-25',INTERVAL 20 DAY)));

-- 15. La Maria ha demanat una pròrroga pel llibre puresa. Se li donen 20 dies més.
UPDATE prestecs
SET NumProrogues = NumProrogues + 1,
	dataRetornTeo = DATE(DATE_ADD(dataRetornTeo,INTERVAL 20 DAY))
WHERE llibreISBN = '9788416367245' AND sociCodi = 'A2501' AND dataPrestec = '2016-02-25';

-- 16. Fer un llistat de Títol Llibre, Total Exemplars, Gènere i una columna més que digui si el total exemplars és inferior a 5, posi “Estoc insuficient”, sinó res. Ordenat per gènere.
-- NOTA: Utilitza la funció IF. (search your life ;P )
SELECT titol AS Titol, totalExemplars AS Exemplars, genereCodi AS Codi, IF(totalExemplars<5, "Estoc insuficient", totalExemplars) AS Estoc FROM llibre;

-- 17. Afegeix el camp ciutat al socis. Tots els socis que el seu codi comenci per A seran de la ciutat de Granollers.
ALTER TABLE soci ADD COLUMN ciutat VARCHAR(45);
UPDATE soci
SET ciutat = 'Granollers'
WHERE (LEFT(codi,1) = 'A');

-- 18. Es vol saber quins llibres han estat MES reservats que el llibre ‘Puresa’.
SELECT L.*, COUNT(*) AS Prestecs FROM llibre L
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
GROUP BY P.llibreISBN
HAVING Prestecs > (SELECT COUNT(*) FROM llibre L
				INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
				WHERE L.titol = 'Puresa');

-- Comprobaciones 1/2
SELECT  L.*, COUNT(*) AS Prestecs FROM llibre L
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
GROUP BY P.llibreISBN;

-- Comprobaciones 2/2
SELECT * FROM prestecs;

-- 19. Hi ha hagut un error. Tots els llibres d’Humor que es van reservar el mes de febrer dels anys 2016 i 2017, la seva data de préstec és exactament un mes després.
INSERT INTO Soci VALUES ('DB777','12345678Z','Son Goku','M.T.Baozi');
INSERT INTO prestecs VALUES ('9788473291941','DB777',0,'2016-02-01',NULL,DATE(DATE_ADD('2016-02-01',INTERVAL 10 DAY)));

UPDATE prestecs
SET dataRetorn = dataRetornTeo
WHERE llibreISBN = '9788473291941' AND sociCodi = 'DB777' AND dataPrestec = '2016-02-01';

UPDATE genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
SET P.dataPrestec = DATE(DATE_ADD(P.dataPrestec,INTERVAL 1 MONTH)),
	P.dataRetorn = DATE(DATE_ADD(P.dataRetorn,INTERVAL 1 MONTH)),
	P.dataRetornTeo = DATE(DATE_ADD(dataRetornTeo,INTERVAL 1 MONTH))
WHERE YEAR(P.dataPrestec) BETWEEN 2016 AND 2017 AND MONTH(P.dataPrestec) = 2 AND G.nom = 'Humor';

select * from prestecs;

-- 20. Per desgracia, de cada llibre de gènere de Drama i Terror s’ha traslladat dos exemplars. Cal decrementar en 2 el total d’exemplars. Si pots, controla que no sigui negatiu en cas que tingui 0 o 1 exemplar.
INSERT INTO Llibre VALUES ("1234573291941","Picnic Extraterrestre",1,"GEN03"),("5467573292587","Kpax",10,"GEN01");

UPDATE genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
SET L.totalExemplars = totalExemplars - 2
WHERE G.nom IN ('Drama','Terror') AND totalExemplars > 1;

--  CORREGIR.
-- 21. Fes un llistat per generes, dels llibres que tenen més exemplars que el promig d’exemplars que tenen els llibres del gènere de ‘Humor’.
INSERT INTO Genere VALUES ('GEN04','Sci Fi');
INSERT INTO llibre VALUES ("7734573291941","Jericho",10,"GEN03"),("7634573291941","Mass Effect",20,"GEN04");


SELECT G.nom, SUM(L.totalExemplars) AS Exemplars FROM genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
GROUP BY G.nom
HAVING Exemplars > (SELECT (SUM(L.totalExemplars))/(COUNT(L.totalExemplars)) FROM genere G
				INNER JOIN llibre L ON G.codi = L.genereCodi
                WHERE G.nom = 'Humor');
                
SELECT G.nom, SUM(L.totalExemplars) AS Exemplars FROM genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
GROUP BY G.nom
HAVING Exemplars > (SELECT AVG(L.totalExemplars) FROM genere G
				INNER JOIN llibre L ON G.codi = L.genereCodi
                WHERE G.nom = 'Humor');

CREATE VIEW MitjaExemplarsHumor AS
SELECT AVG(L.totalExemplars) FROM genere G
	INNER JOIN llibre L ON G.codi = L.genereCodi
	WHERE G.nom = 'Humor';
    
SELECT * FROM llibre
WHERE totalExemplars > (SELECT * FROM MitjaExemplarsHumor);

-- 22. Afegeix un camp totalReserves a la taula Llibre. Aquest camp s’omplirà (UPDATE) amb el total de reserves que ha tingut el llibre 'Puresa' al llibre Puresa (Cal fer una vista).
ALTER TABLE llibre
ADD COLUMN totalReserves VARCHAR(45);

CREATE VIEW V_ReservesPuresa (Reserves)
AS SELECT COUNT(P.dataPrestec) FROM llibre L
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
WHERE L.titol = 'Puresa';

UPDATE llibre
SET totalReserves = (SELECT Reserves FROM V_ReservesPuresa)
WHERE ISBN = '9788416367245';

-- CORREGIR
-- 23. Es vol saber quin el nom del llibre amb el seu gènere ha estat més prestat en la biblioteca. 
-- OPCIÓ 1         
SELECT L.titol, G.nom, COUNT(*) AS Cantidad FROM genere G
		INNER JOIN llibre L ON G.codi = L.genereCodi
		INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
		GROUP BY P.llibreISBN
        HAVING MAX(Cantidad)
        ORDER BY L.titol; -- De A a Z.
	
-- OPCIÓ 2
SELECT L.titol, G.nom, COUNT(*) AS Cantidad FROM genere G
		INNER JOIN llibre L ON G.codi = L.genereCodi
		INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
		GROUP BY L.ISBN
        HAVING MAX(Cantidad)
        ORDER BY L.titol LIMIT 1;
        
-- OPCIÓ 3
CREATE VIEW V_TotalPrestecs (Titol, Genere, TotalPrestecs)
AS SELECT L.titol, G.nom, COUNT(*) FROM genere G
		INNER JOIN llibre L ON G.codi = L.genereCodi
		INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
		GROUP BY P.llibreISBN
        ORDER BY L.titol;
        
SELECT L.titol, G.nom, COUNT(*) FROM genere G
		INNER JOIN llibre L ON G.codi = L.genereCodi
		INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
		GROUP BY P.llibreISBN
        ORDER BY L.titol;

SELECT Titol, Genere, MAX(TotalPrestecs) FROM V_TotalPrestecs;


-- 24. Ens han canviat de Software i cal que tots els llibres introduïts, el seu nom hagi d’estar en majúscula. ‘L’últim mono’  ‘L’ÚLTIM MONO’
UPDATE llibre
SET titol = UPPER(titol);

-- 25. S'ha decidit canviar el gènere de negra per "novel·la negra". Explica quin problema hi ha i executa les instruccions oportunes per a resoldre aquest problema.
-- Si existiera ese género podemos o bien asignarle el nuevo valor al completo o concatenarlo al existente.
INSERT INTO Genere VALUES ('GEN05','Negra');
UPDATE Genere
SET nom = CONCAT('Novel·la ',nom)
WHERE codi = 'GEN05';

-- 26. Es vol veure el total d’exemplars que hi ha per cada gènere.
SELECT G.nom, SUM(L.totalExemplars) FROM genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
GROUP BY G.nom;

-- 27. Es vol saber el nom del soci amb el seu DNI i el ISBN del primer llibre que es va prestar.
SELECT S.nom AS Nom, S.dni AS DNI, P.llibreISBN AS ISBN, dataPrestec FROM soci S
INNER JOIN prestecs P ON S.codi = P.sociCodi
GROUP BY S.nom, S.dni
HAVING MIN(dataPrestec);

-- 28. Tots els usuaris que tenen en préstec algun llibre del gènere Humor se’ls hi dóna 20 dies més per a retornar el llibre.
UPDATE prestecs
SET dataRetornTeo = DATE_ADD(dataRetornTeo, INTERVAL 20 DAY)
WHERE dataRetorn IS NULL; 

-- 29. Llista quins llibres estan pendents de retornar, només el seu nom.
SELECT L.titol FROM llibre L
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
WHERE P.dataRetorn IS NULL;

-- 30. Volem veure l'usuari més actiu de la biblioteca.
-- 1/3
SELECT S.nom AS Usuari, COUNT(P.sociCodi) AS Quantitat_Prestecs FROM soci S
INNER JOIN prestecs P ON S.codi = P.sociCodi
GROUP BY S.nom;

-- 2/3 o si quieres podemos crear una vista paa filtrar.
CREATE VIEW V_ActivitatSocis (Usuari, Quantitat_Prestecs)
AS SELECT S.nom, COUNT(P.sociCodi) FROM soci S
INNER JOIN prestecs P ON S.codi = P.sociCodi
GROUP BY S.nom;

-- 3/3
SELECT Usuari, MAX(Quantitat_Prestecs) AS 'Quantitat Prestecs' FROM V_ActivitatSocis;

-- 31. Volem veure un llistat dels llibres que s'ha prestat als socis només tenint en compte els llibres del genere de Terror, Drama i Cómic.
-- Cal utilitzar una vista que només vegi els llibres d’aquest gènere prestats. Llavors, a partir d’aquesta taula temporal, els socis amb aquest llistat de socis.
-- OPCIÓ 1
SELECT L.titol, G.nom FROM genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN
WHERE G.nom IN ('Terror','Drama','Cómic');

-- OPCIÓ QUE ES DEMANA
CREATE VIEW V_Llibres_Prestats(Titol_Llibre, Nom_Genere)
AS SELECT L.titol, G.nom FROM genere G
INNER JOIN llibre L ON G.codi = L.genereCodi
INNER JOIN prestecs P ON L.ISBN = P.llibreISBN;

-- PA TU BODY
SELECT Titol_Llibre, Nom_Genere FROM V_Llibres_Prestats
WHERE Nom_Genere IN ('Terror','Drama','Cómic');

-- 32. Crea una vista on mostri tota les dades del soci menys el DNI, el títol dels llibres per ordre de data préstec tots aquells llibres retornats.
-- Cal mostrar el gènere per si a posterior cal poder filtrar per aquest camp.
CREATE VIEW V_Prestecs_Socis (Codi_Soci, Nom_Soci, Ciutat_Soci, Titol, Data_Prestec, Data_Retorn, Genere)
AS SELECT S.codi, S.nom, S.ciutat, L.titol, P.dataPrestec, P.dataRetorn, G.nom FROM soci S
INNER JOIN prestecs P ON S.codi = P.sociCodi
INNER JOIN llibre L ON L.ISBN = P.llibreISBN
INNER JOIN genere G ON G.codi = L.genereCodi
WHERE P.dataRetorn IS NOT NULL
ORDER BY dataPrestec;

SELECT * FROM V_Prestecs_Socis;

-- 33. Crear una vista que no permeti la inserció o modificació en aquesta de llibres amb menys de 5 examplars.
CREATE VIEW V_Llibres_Limitats
AS SELECT * FROM llibre
WHERE totalExemplars > 5;

SELECT * FROM V_Llibres_Limitats; 