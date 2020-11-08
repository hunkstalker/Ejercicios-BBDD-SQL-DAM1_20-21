CREATE DATABASE Exerici10;
USE Exerici10;

CREATE TABLE Clients (
	dni CHAR(9) PRIMARY KEY,
	nom VARCHAR(45),
	poblacio VARCHAR(45),
	provincia VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE Articles (
	codiArt CHAR(11) PRIMARY KEY,
	nom VARCHAR(45),
	preu DECIMAL(6,2),
	familia VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE Factures (
	codiFac CHAR(9) PRIMARY KEY,
    data DATE,
    clientsDNI CHAR(9), -- FK
    CONSTRAINT fk_factures_clients FOREIGN KEY (clientsDNI) REFERENCES Clients(dni)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE LiniesFactura (
	quant INT,
    facturesCodiFact CHAR(9), -- FK
    articlesCodiArt CHAR(11), -- FK
    CONSTRAINT fk_liniesFactura_factura FOREIGN KEY (facturesCodiFact) REFERENCES Factures(codiFac)
		ON UPDATE RESTRICT
        ON DELETE RESTRICT,
	CONSTRAINT fk_liniesFactura_articles FOREIGN KEY (articlesCodiArt) REFERENCES Articles(codiArt)
   		ON UPDATE RESTRICT
        ON DELETE RESTRICT
) ENGINE = INNODB;

INSERT INTO Clients VALUES ('DNI1','Nom1','Granollers','Barcelona'),('DNI2','Nom2','Canovelles','Barcelona'),('DNI3','Nom3','Mollet','Barcelona'),('DNI4','Nom4','Mont-ras','Girona'),('DNI5','Nom5','Palafrugell','Girona');
INSERT INTO Articles VALUES ('AAB-433/DZV','Article-1',17.54,'Sobretaula'),('AAB-931/SYK','Article-2',14.88,'Joguina'),('AAB-771/TCY','Article-3',15.43,'Pel·lícules'),('AAB-122/JUC','Article-4',66.58,'Joguina'),('AAB-999/TYH','Article-5',13.53,'Joguina'),('AAB-872/CQE','Article-6',84.17,'Pel·lícules'),('AAB-616/DFD','Article-7',61.98,'Pel·lícules'),('AAB-974/DWH','Article-8',47.42,'Videojocs'),('AAB-184/RSJ','Article-9',49.95,'Pel·lícules'),('AAB-818/SMH','Article-10',79.1,'Pel·lícules'),('AAB-768/XQW','Article-11',79.52,'Sobretaula'),('AAB-637/ZYJ','Orbe',400.96,'Sobretaula'),('AAB-639/YFP','Article-13',44.53,'Videojocs'),('AAB-917/CPP','Article-14',66.83,'Pel·lícules'),('AAB-252/BQB','Article-15',15.22,'Videojocs'),('AAB-917/RLS','Article-16',77.64,'Llibres'),('AAB-298/MOI','Article-17',41.81,'Llibres'),('AAB-228/PYV','Article-18',24.39,'Joguina'),('AAB-832/IVZ','Article-19',33.95,'Videojocs'),('AAB-959/VQF','Article-20',14.45,'Sobretaula'),('AAB-434/KPO','Article-21',71.81,'Joguina'),('AAB-817/IFS','Article-22',51.13,'Llibres'),('AAB-815/EIP','Article-23',5.97,'Sobretaula'),('AAB-596/ZOS','Article-24',57.26,'Sobretaula'),('AAB-557/ACL','Article-25',16.78,'Joguina'),('AAB-325/PAL','Article-26',45.99,'Sobretaula'),('AAB-726/VLX','Article-27',55.02,'Llibres'),('AAB-339/SPY','Article-28',36.33,'Joguina'),('AAB-285/TTT','Article-29',80.2,'Joguina'),('AAB-979/ABO','Article-30',87.16,'Joguina'),('AAB-688/DCQ','Article-31',74.86,'Videojocs'),('AAB-831/HED','Article-32',32.39,'Sobretaula'),('AAB-211/BEH','Article-33',38.08,'Joguina'),('AAB-675/GZB','Article-34',96.34,'Joguina'),('AAB-644/HMH','Article-35',64.02,'Joguina'),('AAB-447/TIN','Article-36',78.12,'Videojocs'),('AAB-668/QMZ','Article-37',98.22,'Llibres'),('AAB-612/MKD','Article-38',42.87,'Joguina'),('AAB-532/BJE','Article-39',27.31,'Joguina'),('AAB-685/JMF','Article-40',25.21,'Llibres'),('AAB-195/SBM','Article-41',84.51,'Joguina'),('AAB-576/UGD','Article-42',34.99,'Videojocs'),('AAB-935/UDZ','Article-43',69.2,'Sobretaula'),('AAB-646/OWX','Article-44',86.16,'Pel·lícules'),('AAB-856/NDE','Article-45',74.34,'Joguina'),('AAB-682/TCF','Article-46',75.17,'Pel·lícules'),('AAB-987/AAC','Article-47',98.46,'Sobretaula'),('AAB-456/MSO','Article-48',58.4,'Videojocs'),('AAB-873/ILL','Article-49',36.92,'Joguina'),('AAB-534/VTG','Article-50',64.44,'Pel·lícules'),('AAB-732/MHU','Article-51',48.97,'Joguina'),('AAB-384/LDF','Article-52',79.7,'Videojocs'),('AAB-142/QRD','Article-53',9.31,'Pel·lícules'),('AAB-594/GJA','Article-54',97.77,'Sobretaula'),('AAB-196/BAB','Article-55',86.45,'Videojocs'),('AAB-731/ITB','Article-56',32.74,'Pel·lícules'),('AAB-165/FVD','Article-57',45.91,'Videojocs'),('AAB-955/UWM','Article-58',95.79,'Videojocs'),('AAB-541/WAV','Article-59',34.85,'Pel·lícules'),('AAB-126/SDH','Article-60',91.9,'Videojocs'),('AAB-437/TYU','Article-61',73.57,'Joguina'),('AAB-698/MOA','Olollo',21.06,'Videojocs'),('AAB-236/MCZ','Article-63',75.28,'Pel·lícules'),('AAB-553/JIO','Article-64',69.77,'Videojocs'),('AAB-572/XIV','Article-65',91.26,'Videojocs'),('AAB-863/SVZ','Article-66',50.92,'Joguina'),('AAB-199/IMC','Article-67',38.59,'Videojocs'),('AAB-289/CUY','Article-68',77.38,'Joguina'),('AAB-194/SHI','Article-69',84.78,'Pel·lícules'),('AAB-555/GXL','Article-70',62.86,'Videojocs'),('AAB-556/CBY','Article-71',57.26,'Joguina'),('AAB-748/VCE','Ornitorrinco',38.77,'Llibres'),('AAB-349/HTE','Article-73',38.92,'Llibres'),('AAB-919/UXN','Article-74',89.06,'Pel·lícules'),('AAB-282/HNP','Article-75',7.03,'Llibres'),('AAB-519/TJV','Article-76',75.23,'Sobretaula'),('AAB-851/FQO','Article-77',56.11,'Sobretaula'),('AAB-732/XVE','Article-78',37.62,'Pel·lícules'),('AAB-861/UFQ','Article-79',73.49,'Joguina'),('AAB-812/KOM','Article-80',55.23,'Joguina'),('AAB-223/MPM','Article-81',11.74,'Joguina'),('AAB-635/YCO','Article-82',35.39,'Llibres'),('AAB-874/ZOD','Article-83',11.59,'Videojocs'),('AAB-487/DPJ','Article-84',21.47,'Pel·lícules'),('AAB-684/YJJ','Article-85',71.36,'Joguina'),('AAB-426/MHU','Article-86',68.29,'Pel·lícules'),('AAB-115/YHM','Article-87',26.12,'Pel·lícules'),('AAB-872/CMW','Article-88',45.6,'Llibres'),('AAB-744/XQX','Article-89',21.83,'Videojocs'),('AAB-595/JAR','Article-90',87.57,'Joguina'),('AAB-194/MZM','Article-91',18.14,'Llibres'),('AAB-658/VAL','Article-92',54.6,'Videojocs'),('AAB-712/PUW','Article-93',90.21,'Sobretaula'),('AAB-681/SGH','Article-94',42.89,'Joguina'),('AAB-148/VHN','Article-95',98.92,'Videojocs'),('AAB-416/DUA','Article-96',58.07,'Sobretaula'),('AAB-753/CVL','Article-97',75.2,'Llibres'),('AAB-854/WMA','Article-98',16.83,'Pel·lícules'),('AAB-628/ZUL','Article-99',23.87,'Pel·lícules'),('AAB-915/ARZ','Article-100',63.71,'Videojocs');
INSERT INTO Factures VALUES ("203133/46","2015-07-30","DNI4"),("481715/62","2016-02-20","DNI4"),("874520/74","2016-07-06","DNI3"),("247725/94","2016-08-24","DNI4"),("790795/57","2014-12-19","DNI3"),("159504/33","2015-09-24","DNI3"),("264360/54","2016-09-04","DNI4"),("741874/69","2016-09-19","DNI3"),("094929/21","2015-01-21","DNI4"),("717511/17","2015-02-15","DNI4"),("292916/89","2015-01-10","DNI3"),("367285/72","2016-04-17","DNI4"),("778893/63","2014-12-07","DNI1"),("561572/88","2015-11-24","DNI3"),("749666/08","2016-11-21","DNI2"),("983506/50","2014-11-24","DNI3"),("149562/43","2016-02-08","DNI1"),("208930/98","2016-11-24","DNI2"),("064216/22","2015-04-05","DNI1"),("974980/13","2015-09-10","DNI4"),("809926/47","2015-06-06","DNI1"),("150185/94","2016-03-14","DNI1"),("785048/91","2015-08-09","DNI1"),("862076/02","2016-04-20","DNI4"),("079585/18","2015-11-05","DNI2"),("056835/84","2016-07-06","DNI4"),("358518/44","2015-03-07","DNI1"),("933133/36","2015-06-17","DNI2"),("723630/81","2015-12-28","DNI3"),("938071/51","2015-04-05","DNI2"),("029174/09","2015-09-10","DNI1"),("375951/73","2015-08-21","DNI3"),("883285/74","2015-10-19","DNI2"),("246883/20","2015-06-20","DNI4"),("349812/97","2015-11-01","DNI3"),("393904/52","2016-08-25","DNI4"),("934890/29","2015-05-05","DNI2"),("337625/54","2015-08-19","DNI1"),("822118/99","2015-07-09","DNI3"),("429943/02","2015-06-25","DNI2"),("308520/05","2016-01-17","DNI3"),("439777/59","2016-10-11","DNI1"),("102486/91","2016-06-30","DNI1"),("512981/58","2016-06-10","DNI2"),("778841/64","2016-01-19","DNI2"),("506113/10","2016-06-10","DNI2"),("677734/08","2016-11-22","DNI2"),("085948/35","2015-03-21","DNI2"),("752716/91","2015-07-15","DNI1"),("541510/18","2016-01-08","DNI4"),("850505/50","2016-11-13","DNI3"),("677410/42","2015-01-22","DNI3"),("992446/79","2016-07-22","DNI4"),("678037/16","2015-06-17","DNI2"),("067343/96","2016-07-18","DNI2"),("717069/74","2015-11-11","DNI4"),("855242/43","2015-03-02","DNI1"),("217529/39","2016-03-19","DNI3"),("602510/33","2015-01-05","DNI2"),("449368/85","2016-09-24","DNI3"),("314290/68","2016-10-18","DNI3"),("259729/52","2016-05-19","DNI3"),("383971/24","2015-03-03","DNI3"),("598427/79","2016-05-12","DNI2"),("350340/32","2015-09-17","DNI3"),("415581/59","2015-12-07","DNI1"),("128553/96","2015-04-09","DNI3"),("562341/78","2015-01-28","DNI2"),("671139/17","2015-12-26","DNI2"),("041758/65","2015-06-03","DNI4"),("285087/02","2015-05-14","DNI4"),("907691/67","2015-12-22","DNI2"),("201600/03","2015-02-11","DNI2"),("028319/88","2016-04-13","DNI2"),("019042/71","2015-12-31","DNI3"),("624051/22","2016-09-02","DNI2"),("680828/62","2016-11-22","DNI4"),("185133/06","2014-12-13","DNI2"),("658118/83","2015-09-18","DNI1"),("586704/92","2016-04-03","DNI1"),("220696/98","2016-08-21","DNI2"),("054791/03","2015-09-12","DNI1"),("217101/28","2016-11-05","DNI4"),("869933/37","2015-04-07","DNI3"),("356323/35","2016-04-21","DNI4"),("124933/64","2015-04-09","DNI2"),("137019/37","2015-08-11","DNI2"),("362572/44","2016-08-03","DNI1"),("803268/67","2015-01-09","DNI2"),("930186/24","2016-08-10","DNI3"),("207930/57","2015-01-10","DNI2"),("840466/04","2016-09-16","DNI2"),("247474/34","2016-06-01","DNI3"),("764310/81","2015-06-06","DNI3"),("138784/05","2015-07-24","DNI4"),("022592/56","2016-06-04","DNI2"),("346097/39","2015-09-18","DNI2"),("666778/26","2016-10-04","DNI1"),("813815/67","2015-08-02","DNI2"),("997727/76","2016-07-31","DNI2");


-- 1. Obtenir un llistat de tots els clients de Granollers o Canovelles.
SELECT nom AS Nombre, poblacio AS Poblacio FROM Clients
	WHERE poblacio IN ('Granollers','Canovelles');

-- 2. Obtenir el numero total de factures que té cada client amb el DNI i una altra columna amb el Nom i Cognom
SELECT COUNT(*), C.nom AS "Nom Client", C.DNI AS "DNI CLient"  FROM Factures F
	INNER JOIN Clients C ON C.dni = F.clientsDNI
    GROUP BY C.DNI;
    
-- 3. Obtenir el numero total de factures per a tots els clients que viuen a Barcelona.
SELECT COUNT(*) AS "Recompte de Factures", C.provincia AS "Provincia dels Clients" FROM Factures F
	INNER JOIN Clients C ON C.dni = F.clientsDNI
    WHERE C.provincia = 'Barcelona';
            
-- 4. Obtenir el numero total de factures trameses en cada una de les ciutats de província catalanes.
SELECT COUNT(*) AS "Recompte de Factures", C.poblacio AS "Població dels Clients" FROM Factures F
	INNER JOIN Clients C ON C.dni = F.clientsDNI
    GROUP BY C.poblacio;

-- 5. Realitzar un llistat de tots els articles de la familia «sobretaula» que el seu nom comenci per la lletra «o» amb un preu unitari superior a 400€.
SELECT nom AS "Nom del Article", familia AS "Familia d'article", CONCAT(preu,' €') AS "Preu del Article" FROM Articles
	WHERE familia = 'Sobretaula'AND preu > 400 AND nom LIKE 'O%';

-- 6. Obtenir la mitjana de preus de tots els articles per famílies.
SELECT familia AS "Familia dels Articles", CONCAT(ROUND(SUM(preu)/COUNT(*),2),' €') AS "Preu Mitjà" FROM Articles
	GROUP BY familia;
    
-- 7. Obtenir el codi de l'article, el nom de l'article i la quantitat comprada per a cada una de les línies de factura.
INSERT INTO liniesFactura VALUES (6,'019042/71','AAB-115/YHM'),(2,'022592/56','AAB-122/JUC'),(1,'028319/88','AAB-126/SDH'),(2,'029174/09','AAB-142/QRD'),(1,'041758/65','AAB-184/RSJ'),(1,'054791/03','AAB-194/SHI');

SELECT A.CodiArt AS "Codi d'Articles", A.nom AS "Nom d'Articles", LA.quant AS "Quantitat d'Articles" FROM Articles A
	INNER JOIN liniesFactura LA ON a.codiArt = LA.articlesCodiArt
    WHERE quant;

-- 8. Obtenir l'import total facturat amb totes les factures.



-- 9. Obtenir l'import facturat per a cada una de les famílies d'articles.
-- 10. Obtenir la informació de tots els articles i la seva quantitat venuda. Obtindrem el valor NULL o 0 (zero) en el cas que el producte no hagi tingut cap venda.
-- 11. Otenir l'import total de la factura 006746/15.
-- 12. Obtenir l'import facturat per a cada un dels clients que siguin de la ciutat de Girona. Cal ordenar el resultat de major a menor import.
-- 13. Obtenir el codi i la data de totes les factures amb un import superior al de la factura 006746/15.
-- 14. Obtenir un llistat amb: totes les dades del client, totes les dades de les seves factures, i els seus productes adquirits.
-- 15. Obtenir el total facturat per mes durant l'any 2015 i 2016. Ordenar el resultat per any i mes de forma descendent l’import.
-- 16. Obtenir quines factures tenen una facturació major a l'import mitjà de la facturació de la població de «Granollers».
-- 17. Obtenir tots els articles dels quals no s'hagi venut cap unitat.
-- 18. Obtenir el dni i el nom de tots els clients que no tinguin cap factura.
-- 19. Digues el DNI i el nom del client que ha fet la factura més cara.
-- 20. A partir d’ara es vol tenir el control de la categoria el qual pertany un article. 
	-- De la categoria es vol emmagatzemar, el nom de la categoria, si aquesta categoria té data de 
	-- caducitat i el tipus de risc que va entre 1 y 10 (per defecte és 5). Realitza les instruccions necessàries per tal de poder resoldre aquest nou requeriment.