CREATE DATABASE Exercici10;
USE Exercici10;

CREATE TABLE Client (
	dni CHAR(9) PRIMARY KEY,
	nom VARCHAR(45),
	poblacio VARCHAR(45),
	provincia VARCHAR(45)
) ENGINE = INNODB;

create view clientBcn
	as select nom, poblacio from Client where provincia = 'Barcelona';
    
create view facturesClient
AS SELECT F.codiFac, F.data, C.nom FROM Client C
	INNER JOIN Factura F ON C.dni = F.clientDni;
    
select * from facturesClient;

CREATE TABLE Article (
	codiArt CHAR(11) PRIMARY KEY,
	nom VARCHAR(45),
	preu DECIMAL(6,2),
	familia VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE Factura (
	codiFac CHAR(9) PRIMARY KEY,
    data DATE,
    clientDNI CHAR(9), -- FK
    CONSTRAINT fk_factures_clients FOREIGN KEY (clientDNI) REFERENCES Client(dni)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE Linia (
	quant INT,
    facturaCodiFac CHAR(9), -- FK
    articleCodiArt CHAR(11), -- FK
    CONSTRAINT fk_linia_factura FOREIGN KEY (facturaCodiFac) REFERENCES Factura(codiFac)
		ON UPDATE RESTRICT
        ON DELETE RESTRICT,
	CONSTRAINT fk_linia_articles FOREIGN KEY (articleCodiArt) REFERENCES Article(codiArt)
   		ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE = INNODB;


-- 1. Obtenir un llistat de tots els clients de Granollers o Canovelles.
SELECT nom AS "Nom Client", poblacio AS Poblacio FROM Client
	WHERE poblacio IN ('Granollers','Canovelles');

-- 2. Obtenir el numero total de factures que té cada client amb el DNI i una altra columna amb el Nom i Cognom
SELECT COUNT(*) AS 'Total Factures', C.nom AS "Nom Client", C.DNI AS "DNI CLient" FROM Factura F
	INNER JOIN Client C ON C.dni = F.clientDNI
    GROUP BY C.DNI;
    
-- 3. Obtenir el numero total de factures per a tots els clients que viuen a Barcelona.
SELECT COUNT(*) AS "Recompte de Factures", C.provincia AS "Provincia dels Clients" FROM Factura F
	INNER JOIN Client C ON C.dni = F.clientDNI
    WHERE C.provincia = 'Barcelona';
            
-- 4. Obtenir el numero total de factures trameses en cada una de les ciutats de província catalanes.
SELECT COUNT(*) AS "Recompte de Factures", C.poblacio AS "Població dels Clients" FROM Factura F
	INNER JOIN Client C ON C.dni = F.clientDNI
    GROUP BY C.poblacio;

-- 5. Realitzar un llistat de tots els articles de la familia «sobretaula» que el seu nom comenci per la lletra «o» amb un preu unitari superior a 400€.
SELECT nom AS "Nom del Article", familia AS "Familia d'article", CONCAT(preu,' €') AS "Preu del Article" FROM Article
	WHERE familia = 'Sobretaula'AND preu > 400 AND nom LIKE 'O%';

-- 6. Obtenir la mitjana de preus de tots els articles per famílies.
SELECT familia AS "Familia dels Articles", CONCAT(ROUND(SUM(preu)/COUNT(*),2),' €') AS "Preu Mitjà" FROM Article
	GROUP BY familia;
    
-- 7. Obtenir el codi de l'article, el nom de l'article i la quantitat comprada per a cada una de les línies de factura.
INSERT INTO liniesFactura VALUES (2,'019042/71','AAB-115/YHM'),(1,'019042/71','AAB-122/JUC'),(1,'019042/71','AAB-126/SDH'),(1,'019042/71','AAB-142/QRD');
INSERT INTO liniesFactura VALUES (5,'022592/56','AAB-194/SHI'),(1,'022592/56','AAB-195/SBM');
INSERT INTO liniesFactura VALUES (1,'029174/09','AAB-126/SDH'),(1,'029174/09','AAB-148/VHN'),(1,'029174/09','AAB-165/FVD'),(1,'029174/09','AAB-196/BAB'),(1,'029174/09','AAB-199/IMC'),(1,'029174/09','AAB-456/MSO');

SELECT A.CodiArt AS "Codi d'Articles", A.nom AS "Nom d'Articles", LA.quant AS "Qtt comprada" FROM Article A
	INNER JOIN liniesFactura LA ON a.codiArt = LA.articleCodiArt;

-- 8. Obtenir l'import total facturat amb totes les factures.
-- SELECT A.preu AS "Import Total", F.codiFac AS "Factura" FROM Articles A
-- 	INNER JOIN liniesFactura LF ON A.codiArt = LF.articlesCodiArt
-- 	INNER JOIN Factures F ON F.codiFac = LF.facturesCodiFac
-- 	GROUP BY F.codiFac;
    
SELECT SUM(A.preu*L.quant) AS ImportTotal FROM Article A
	INNER JOIN liniesFactura L ON A.codiArt = L.articleCodiArt;
    
-- 9. Obtenir l'import facturat per a cada una de les famílies d'articles.
SELECT SUM(A.preu*L.quant) AS "Import Total", A.familia AS "Familia d'Article" FROM Article A
	INNER JOIN liniesFactura L ON A.codiArt = L.articleCodiArt
    GROUP BY familia;

-- 10. Obtenir la informació de tots els articles i la seva quantitat venuda. Obtindrem el valor NULL o 0 (zero) en el cas que el producte no hagi tingut cap venda.
SELECT A.nom AS 'Nom', CONCAT(A.preu,' €') AS 'Preu', A.familia AS 'Familia', COALESCE(LF.quant,0) AS "Quantitat Venuda" FROM Article A
	LEFT JOIN liniesFactura LF ON A.codiArt = LF.articleCodiArt
    GROUP BY codiArt;

-- 11. Otenir l'import total de la factura 006746/15.
INSERT INTO Factura VALUES ('006746/15','2020-11-08','DNI5');
INSERT INTO liniesFactura VALUES ('1','006746/15','AAB-955/UWM'),('1','006746/15','AAB-959/VQF'),('1','006746/15','AAB-974/DWH'),('1','006746/15','AAB-979/ABO'),('1','006746/15','AAB-987/AAC');

SELECT (A.preu*L.quant) AS Import, L.facturaCodiFac AS CodiFactura FROM Article A
	INNER JOIN liniesFactura L ON A.codiArt = L.articleCodiArt
    WHERE L.articleCodiArt = '006746/15';

-- 12. Obtenir l'import facturat per a cada un dels clients que siguin de la ciutat de Girona. Cal ordenar el resultat de major a menor import.
INSERT INTO Client VALUES ('DNI6','Nom6','Girona','Girona');
INSERT INTO Factura VALUES ('1067BB/15','2020-11-08','DNI6');
INSERT INTO liniesFactura VALUES ('3','1067BB/15','AAB-142/QRD'),('2','1067BB/15','AAB-854/WMA'),('1','1067BB/15','AAB-433/DZV');

SELECT SUM(A.preu*LF.quant) AS "Import", C.dni AS 'Client', C.poblacio AS 'Poblacio' FROM Article A
	INNER JOIN liniesFactura LF ON A.codiArt = LF.articleCodiArt
	INNER JOIN Factura F ON F.codiFac = LF.facturaCodiFac
    INNER JOIN Client C ON C.DNI = F.clientDNI
    WHERE C.poblacio = 'Girona' GROUP BY C.dni;

SELECT * from liniesFactura;

-- 13. Obtenir el codi i la data de totes les factures amb un import superior al de la factura 006746/15.
SELECT F.codiFac AS "Codi Factura", data AS "Data", SUM(A.preu*LF.quant) FROM Article A
	INNER JOIN liniesFactura LF ON A.codiArt = LF.articleCodiArt
	INNER JOIN Factura F ON F.codiFac = LF.facturaCodiFac
    GROUP BY F.codiFac
    HAVING SUM(A.preu*LF.quant) > (SELECT SUM(A.preu*LF.quant) FROM Article A
			INNER JOIN liniesFactura LF ON A.codiArt = LF.articleCodiArt
			INNER JOIN Factura F ON F.codiFac = LF.facturaCodiFac
            WHERE F.codiFac = '006746/15');
            
-- Comprobació, factura 006746/15, Import: 343.28 €
SELECT F.codiFac AS "Codi Factura", data AS "Data", SUM(A.preu*LF.quant) AS "Import" FROM Article A
	INNER JOIN liniesFactura LF ON A.codiArt = LF.articleCodiArt
	INNER JOIN Factura F ON F.codiFac = LF.facturaCodiFac
    WHERE F.codiFac = '006746/15';

-- 14. Obtenir un llistat amb: totes les dades del client, totes les dades de les seves factures, i els seus productes adquirits.
SELECT C.dni AS "DNI Client", C.nom AS "Nom Client", C.poblacio AS 'Poblacio', C.provincia AS 'Provincia', 
	F.codiFac AS "Codi Factura", F.data AS Data, A.nom AS 'Article' FROM Client C 
	INNER JOIN Factura F ON C.dni = F.clientDni
    INNER JOIN liniesFactura LF ON F.codiFac = LF.facturaCodiFac
    INNER JOIN Article A ON  A.codiArt = LF.articleCodiArt;

-- 15. Obtenir el total facturat per mes durant l'any 2015 i 2016. Ordenar el resultat per any i mes de forma descendent l’import.
SELECT CONCAT((A.preu*LF.quant),' €') AS 'Facturat', YEAR(F.data), MONTH(F.data) FROM Factura F
	INNER JOIN liniesFactura LF ON F.codiFac = LF.facturaCodiFac
    INNER JOIN Article A ON A.codiArt = LF.articleCodiArt
    ORDER BY YEAR(F.data) BETWEEN 2015 AND 2016 DESC;
    
-- 16. Obtenir quines factures tenen una facturació major a l'import mitjà de la facturació de la població de «Granollers».
INSERT INTO Client VALUES ('DNI1','Nom1','Granollers','Barcelona'),('DNI2','Nom2','Canovelles','Barcelona'),('DNI3','Nom3','Mollet','Barcelona');
-- 1 persona de Granollers. 2 Fuera de granollers.
INSERT INTO Article VALUES ('AAB-433/DZV','Article-1',50.00,'Sobretaula'),('AAB-931/SYK','Article-2',20.00,'Joguina'),('AAB-771/TCY','Article-3',75.00,'Pel·lícules');
-- Articulo 1, 50.00€. 		Articulo 2, 20.00€		Articulo 3, 75.00€
INSERT INTO Factura VALUES ("000001/01","2015-07-06","DNI1"),("000002/01","2015-07-06","DNI2"),("000003/01","2015-07-06","DNI3");
-- 1 Factura por cada cliente, total: 3.
INSERT INTO Linia VALUES (2,'000001/01','AAB-433/DZV'),(2,'000002/01','AAB-931/SYK'),(2,'000003/01','AAB-771/TCY');
-- Factura Cliente DNI1 de Granollers, 	2 Articulos, precio: 50.00 	Total: 50x2= 100.00€
-- Factura Cliente DNI2, 				2 Articulos, precio: 25.00 	Total: 20x2=  40.00€
-- Factura Cliente DNI3, 				2 Articulos, precio: 75.00	Total: 75x2= 150.00€

-- Media de importe de Granollers: 50+50/2= 50

-- Por lo tanto, factura del cliente DNI3 será superior. Cliente DNI será inferior y no saldrá.

-- 1er Paso. SubSelect
SELECT ROUND(SUM(A.preu*L.quant)/COUNT(DISTINCT F.codifac)) AS MitjaGranollers FROM Client C
	INNER JOIN Factura F ON C.dni = F.clientDni
	INNER JOIN liniesFactura L ON F.codiFac = L.facturaCodiFac
	INNER JOIN Article A ON A.codiArt = L.articleCodiArt
    WHERE C.poblacio = 'Granollers';
    
-- 2do Paso. SubSelect
SELECT A.preu AS FacturaSuperior, L.facturaCodiFac AS CodiFactura FROM linia L
    INNER JOIN Article A ON A.codiArt = L.articleCodiArt
    GROUP BY L.facturaCodiFac
    HAVING SUM(A.preu*L.quant) > (SELECT ROUND(SUM(A.preu*L.quant)/COUNT(DISTINCT F.codifac)) AS MitjaGranollers FROM Client C
			INNER JOIN Factura F ON C.dni = F.clientDni
			INNER JOIN linia L ON F.codiFac = L.facturaCodiFac
			INNER JOIN Article A ON A.codiArt = L.articleCodiArt
			WHERE C.poblacio = 'Granollers'); 
            
-- Probando cosas nuevas.
-- UPDATE Client SET nom='RofoldoAurelio' WHERE dni='DNI1';

-- 17. Obtenir tots els articles dels quals no s'hagi venut cap unitat.
SELECT A.nom "Nom d'Article", COALESCE(LF.articleCodiArt) AS "Articles en Factures" FROM Article A
LEFT JOIN liniesFactura LF ON A.codiArt = LF.articleCodiArt
WHERE LF.articleCodiArt IS NULL;

-- 18. Obtenir el dni i el nom de tots els clients que no tinguin cap factura.
INSERT INTO Client VALUES ('DNI4','Nom4','Barcelona','Barcelona');

SELECT DISTINCT C.dni, C.nom FROM Client C
LEFT JOIN Factura F ON C.dni= F.clientDni
WHERE F.clientDni IS NULL;

-- 19. Digues el DNI i el nom del client que ha fet la factura més cara.
-- OPCIÓN 1, LIMIT.
SELECT C.nom AS Nom, C.dni AS DNI, SUM(A.preu*L.quant) AS Preu, F.codiFac AS FacturaMesCara FROM Client C
			INNER JOIN Factura F ON C.dni = F.clientDni
			INNER JOIN linia L ON F.codiFac = L.facturaCodiFac
			INNER JOIN Article A ON A.codiArt = L.articleCodiArt
            GROUP BY F.codiFac
            ORDER BY MAX(A.preu) DESC LIMIT 1;

-- OPCIÓN 2, HAVING.
SELECT C.nom AS Nom, C.dni AS DNI, SUM(A.preu*L.quant) AS Import, F.codiFac AS FacturaMesCara FROM Client C
			INNER JOIN Factura F ON C.dni = F.clientDni
			INNER JOIN linia L ON F.codiFac = L.facturaCodiFac
			INNER JOIN Article A ON A.codiArt = L.articleCodiArt
            GROUP BY F.codiFac
            HAVING Import = (SELECT MAX(A.preu*L.quant) FROM Client C
					INNER JOIN Factura F ON C.dni = F.clientDni
					INNER JOIN linia L ON F.codiFac = L.facturaCodiFac
					INNER JOIN Article A ON A.codiArt = L.articleCodiArt);
     
-- OPCIÓN 3, VIEW.
-- SELECT * FROM VWImport;
CREATE VIEW VWImport
	AS SELECT F.codiFac, SUM(A.preu*L.quant) AS Import FROM Client C
						INNER JOIN Factura F ON C.dni = F.clientDni
						INNER JOIN linia L ON F.codiFac = L.facturaCodiFac
						INNER JOIN Article A ON A.codiArt = L.articleCodiArt
						GROUP BY F.codiFac;
                        
SELECT codiFac, Import FROM VWImport WHERE Import = (SELECT MAX(Import) FROM VWImport);

-- 20. A partir d’ara es vol tenir el control de la categoria el qual pertany un article. 
	-- De la categoria es vol emmagatzemar, el nom de la categoria, si aquesta categoria té data de 
	-- caducitat i el tipus de risc que va entre 1 y 10 (per defecte és 5). Realitza les instruccions necessàries per tal de poder resoldre aquest nou requeriment.
    
    