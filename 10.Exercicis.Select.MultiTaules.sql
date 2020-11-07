CREATE DATABASE Excercici10;
USE Excercici10;

CREATE TABLE IF NOt EXISTS Clients (
	dni CHAR(9) PRIMARY KEY,
    nom VARCHAR(45),
    poblacio VARCHAR(45),
    provincia VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Factures (
	codiFac CHAR(9) PRIMARY KEY,
    data DATE,
    clientsDni CHAR(9),
    CONSTRAINT fk_Factures_Clients FOREIGN KEY (clientsDni) REFERENCES Clients(dni)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Articles (
	codiArt CHAR(11),
    preu DECIMAL(6,2),
	dataCr DATE,
    nom VARCHAR(45),
    familia VARCHAR(45),
    articleCodiArt CHAR(11),
    articlePreu DECIMAL(6,2),
    articleDataCr DATE,
    PRIMARY KEY (codiArt,preu,dataCr),
    CONSTRAINT fk_Articles_Art FOREIGN KEY (articleCodiArt,articlePreu,articleDataCr) REFERENCES Articles(codiArt,preu,dataCr)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS LiniesFactura (
	quant INT,
    facturesCodiFac VARCHAR(8),
    articlesCodiArt CHAR(11),
    CONSTRAINT fk_LiniesFactura_Factures FOREIGN KEY (facturesCodiFac) REFERENCES Factures(codiFac)
		ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_LiniesFactura_Articles FOREIGN KEY (articlesCodiArt) REFERENCES Articles(codiArt)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB; 

INSERT INTO Clients VALUES ("DNI1","Denis","Granollers","Barcelona"),("DNI2","Gerard","Granollers","Barcelona"),("DNI3","Aina","Granollers","Barcelona"),
	("DNI4","Maria","Canovelles","Barcelona"),("DNI5","Alex","Canovelles","Barcelona"),("DNI6","Anna","Canovelles","Barcelona"),
    ("DNI7","Carlos","Sabadell","Barcelona"),("DNI8","Sandra","Terrassa","Barcelona"),("DNI9","Ivy","Mollet","Barcelona");
    
    SELECT * FROM Clients;    
-- 1. Obtenir un llistat de tots els clients de Granollers o Canovelles.
SELECT nom AS Nom, poblacio AS Poblacio FROM Clients WHERE poblacio IN ("Granollers","Canovelles");

-- 2. Obtenir el numero total de factures que té cada client amb el DNI i una altra columna amb el Nom i Cognom
INSERT INTO Articles VALUES ("ABB-745/GME",79.99,"2015-02-23","Mass Effect Andromeda","Videojoc",NULL,NULL,NULL),("ABB-746/GME",69.99,"2020-12-23","Mass Effect Trilogy","Videojoc",NULL,NULL,NULL),
	("IDR-043/GME",49.95,"2025-11-20","Star Citizen","Videojoc",NULL,NULL,NULL),("IDR-042/GME",79.99,"2022-11-20","Squadron 42","Videojoc",NULL,NULL,NULL),
    ("ABB-777/LLI",19.55,"2008-02-23","El Juego de Ender","Llibre",NULL,NULL,NULL),("CHE-832/LLI",19.55,"1990-02-23","Picnic Extraterrestre","Llibre",NULL,NULL,NULL);
INSERT INTO Factures VALUES ("000000/01","2015-02-25","DNI4"),("000000/02","2020-12-25","DNI4"),("000000/03","2015-03-25","DNI4"),
	("000000/04","2009-02-25","DNI1"),("000000/05","1995-02-25","DNI1");
    
SELECT COUNT(*) AS "Quantitat de Factures", C.dni AS "DNI Client", C.nom AS "Nom Client" FROM Factures F
	INNER JOIN Clients C ON F.clientsDni = C.dni
    GROUP BY C.dni, C.nom;
    
-- 3. Obtenir el numero total de factures per a tots els clients que viuen a Barcelona.
INSERT INTO Factures VALUES ("000000/06","2016-02-25","DNI2"),("000000/07","2015-12-25","DNI9");
    
SELECT COUNT(*) AS "Quantitat de Factures", C.poblacio AS "Poblacio" FROM Factures F
	INNER JOIN Clients C ON F.clientsDni = C.dni
    WHERE C.poblacio = "Barcelona";

-- 4. Obtenir el numero total de factures trameses en cada una de les ciutats de província catalanes.
INSERT INTO Clients VALUES ("DNI10","Miquel","Mont-ras","Girona");
INSERT INTO Factures VALUES ("000000/08","2016-03-25","DNI10"),("000000/09","2016-03-26","DNI10");

SELECT COUNT(*) AS "Quantitat de Factures", C.poblacio AS "Poblacio", C.provincia AS "Provincia" FROM Factures F
	INNER JOIN Clients C ON F.clientsDni = C.dni
    GROUP BY C.provincia;

-- 5. Realitzar un llistat de tots els articles de la familia «sobretaula» que el seu nom comenci per la lletra «o» amb un preu unitari superior a 400€.
SELECT * FROM Factures;

-- 6. Obtenir la mitjana de preus de tots els articles per famílies.
-- 7. Obtenir el codi de l'article, el nom de l'article i la quantitat comprada per a cada una de les línies de factura.
-- 8. Obtenir l'import total facturat amb totes les factures.
-- 9. Obtenir l'import facturat per a cada una de les famílies d'articles.
-- 10. Obtenir la informació de tots els articles i la seva quantitat venuda. Obtindrem el valor NULL o 0 (zero) en el cas que el producte no hagi tingut cap venda.
-- 11. Otenir l'import total de la factura 006746/15.


-- 12. Obtenir l'import facturat per a cada un dels clients que siguin de la ciutat de Girona. Cal ordenar el resultat de major a menor import.
-- Provincia
-- Desenvolupament aplicacions multiplataforma (DAM)
-- Mòdul 2 – Bases de dades - UF2 - llenguatges SQL: DML i DDL
-- Tema 2 – Introducció . Consultes Simple
-- 3/ 3
-- 13. Obtenir el codi i la data de totes les factures amb un import superior al de la factura 006746/15.
-- 14. Obtenir un llistat amb: totes les dades del client, totes les dades de les seves factures, i els seus productes adquirits.
-- 15. Obtenir el total facturat per mes durant l'any 2015 i 2016. Ordenar el resultat per any i mes de forma descendent l’import.
-- 16. Obtenir quines factures tenen una facturació major a l'import mitjà de la facturació de la població de «Granollers».
-- 17. Obtenir tots els articles dels quals no s'hagi venut cap unitat.
-- 18. Obtenir el dni i el nom de tots els clients que no tinguin cap factura.
-- 19. Digues el DNI i el nom del client que ha fet la factura més cara.
-- 20. A partir d’ara es vol tenir el control de la categoria el qual pertany un article. De la categoria es vol emmagatzemar, el nom de la categoria, si aquesta categoria té data de caducitat i el tipus de risc que va entre 1 y 10 (per defecte és 5). Realitza les instruccions necessàries per tal de poder resoldre aquest nou requeriment.
