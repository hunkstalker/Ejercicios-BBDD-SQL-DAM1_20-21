/* APUNTES / EJEMPLOS INNER JOIN
-- INNER JOIN
-- Mostra el nom dels superherois que el seu planeta té mes de 5 llunes.
SELECT nameh, namep FROM superhero INNER JOIN planet ON namep = planetNamep
	WHERE moons > 5;
    
-- Mostra el nom del superheroi que té força superior a 10 del planeta Terra o Jupiter amb massa superior a 40.
SELECT nameh FROM superhero INNER JOIN planet ON namep = planetNamep
	WHERE mass > 40 AND strong > 10 AND namep IN ("Terra","Jupiter");

-- incluir alias
SELECT H.nameh FROM superhero H INNER JOIN planet P ON P.namep = H.planetNamep
	WHERE P.mass>40 AND H.strong>10 AND P.nameP IN ("Terra","Jupiter");
    
-- Mostra el nom dels planetes que tenen massa superior a 5.
SELECT namep FROM planet WHERE mass > 5;

-- Mostra el nom dels herois que tienen força superior a 10 i que son del planeta amb nom Terra.
SELECT nameh FROM superhero WHERE strong > 10 AND planetNameP = "Terra";
*/

-- EJERCICIO DE INNER JOIN. TAMBIÉN USAR ALIAS.

CREATE DATABASE Popietaris;
USE Popietaris;

CREATE TABLE IF NOT EXISTS Propietari (
	DNI CHAR(9) PRIMARY KEY,
    nom VARCHAR(45),
    dataNaix DATE,
    dataDefuncio DATE
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Animal (
	xip CHAR(11) PRIMARY KEY,
    nom VARCHAR(45),
    dataNaix DATE,
    especie ENUM("Gat","Gos","Rèptil","Ocell","Peix"),
    dataDefuncio DATE,
    cost DECIMAL(5,2),
    impost DECIMAL(4,2),
	DNIPropietari CHAR(9), -- FK
    CONSTRAINT fk_animal_propietari	FOREIGN KEY (DNIPropietari) REFERENCES Propietari(DNI)
		ON DELETE RESTRICT
		ON UPDATE CASCADE
) ENGINE = INNODB;

INSERT INTO Propietari VALUES ("00000000A","Andres","1985-05-08",NULL),("00000000B","Anna","1956-10-07",NULL),("00000000C","Alex","1980-05-13",NULL);
INSERT INTO Animal VALUES (1,"Tonia","1995-06-05","Gos","2011-07-20",40,10,"00000000C"),(2,"Buch","1998-02-04","Gos","2013-02-04",40,10,"00000000A"),
							(3,"Dina","2018-09-03","Gat",NULL,5,10,"00000000B"),(4,"Joy","2019-10-02","Gat",NULL,5,10,"00000000B");
                            
SELECT * FROM Propietari;
SELECT * FROM Animal;

SELECT P.*, A.nom FROM Propietari P 
	INNER JOIN Animal A ON P.dni = A.DNIPropietari;
    
INSERT INTO Propietari VALUES ("32348676K","Ivan","1986-02-11",NULL);
INSERT INTO Animal VALUES (5,"Milú","1993-06-05","Gos","2011-06-04",40,10,"32348676K");
INSERT INTO Animal VALUES (6,"Rambo","1990-01-05","Ocell","1991-06-04",0,80,"32348676K");
INSERT INTO Animal VALUES (7,"Wolf","1985-01-05","Peix","1995-06-04",500,10,"00000000A");
INSERT INTO Animal VALUES (8,"Reptile","2020-01-05","Rèptil",NULL,0,80,"32348676K");
						
-- 1. Obtenir les espècies de tots els animals que on el seu impost sigui més gran que el 10% del cost.
SELECT DISTINCT especie FROM Animal WHERE impost > 0.1*cost;

-- 2. Obtenir el cost final total de tots els animals vius associats al propietari amb dni 32348676K.
SELECT SUM(cost+impost) AS 'Importe Total', nom FROM Animal WHERE dniPropietari = '32348676K' AND dataDefuncio IS NULL; -- He añadido el nombre del animal por tener alguna referencia del animal que me devuelve.

-- 3. Obtenir el cost total de tots els animals vius que tenen com a propietari a la Sandra.


-- 4. Obtenir el nom del propietari on l'impost de l’animal és més elevat
SELECT MAX(impost) FROM Animal WHERE DNIPropietari IS NOT NULL;

SELECT DISTINCT P.nom FROM Propietari P 
	INNER JOIN Animal A ON P.DNI = A.DNIPropietari
    WHERE A.impost = (SELECT MAX(impost) FROM Animal WHERE DNIPropietari IS NOT NULL);

-- 5. Obtenir la informació de tots els animals amb el nom del seu propietari.
SELECT A.*, P.nom
	FROM Animal A INNER JOIN Propietari P ON P.dni = A.DNIPropietari ORDER BY xip; -- Me he tomado la libertad de ordenadrlos por el chip.

-- 6. Obtenir el nom de l'animal o animals que tenen l'impost més elevat i que l'animal encara està en vida.
SELECT MAX(impost) FROM Animal WHERE DataNaix IS NULL;

SELECT nom FROM Animal
	WHERE impost = (SELECT MAX(impost) FROM Animal WHERE dataDefuncio IS NULL) AND dataDefuncio IS NULL;

-- 7. Obtenir el cost final de tots els animals MORTS ordenats de major a menor preu. Associa el nom de "Cost Total" a la columna.
SELECT nom, cost+impost AS CostTotal FROM Animal 
	WHERE DataDefuncio IS NOT NULL
    ORDER BY CostTotal DESC;

-- 8. Obtenir el cost final més gran de tots els animals.
SELECT MAX(cost+impost) AS CosteMax FROM Animal;

-- 9. Obtenir el nom de l'animal més car (major cost final).
SELECT nom FROM Animal WHERE impost+cost = (SELECT MAX(cost+impost) FROM Animal);

-- 10.Obtenir el nom del propietari de l'animal que té un cost final més elevat
SELECT P.nom, A.nom, A.cost+A.impost AS CostTotal
	FROM Propietari P INNER JOIN Animal A ON P.DNI = A.DNIPropietari
    WHERE A.cost+A.impost = (SELECT MAX(cost+impost) FROM Animal);

-- 11.Veure el nom del propietari amb el seu nom d’animal que han nascut entre els anys 2010 i 2015 (els animals), que encara estiguin vius.
SELECT P.nom, A.nom FROM Propietari P INNER JOIN Animal A ON P.DNI = A.DNIPropietari
	WHERE YEAR(A.dataNaix) BETWEEN 2015 AND 2020 AND A.dataDefuncio IS NULL; -- He cambiado los años para que me coincida con algún animal.
    
-- 12.Volem veure el nom dels animal que el seu propietari tingui signe de l’horòscop: Balança.


-- SUPOSEM QUE BALANÇA ES 23/09 AL 22/10
SELECT A.nom, P.nom, P.dataNaix FROM Animal A
	INNER JOIN Propietari P ON P.DNI = A.DNIPropietari
	WHERE (DAY(P.dataNaix) >=23 AND MONTH(P.dataNaix)=9) OR (DAY(P.dataNaix)<=22 AND MONTH(P.dataNaix)=10);

-- 13.Volem veure el nom dels propietaris que aquest mes faci un any que se li va morir la seva mascota.
SELECT P.nom FROM Propietari P INNER JOIN Animal A ON P.DNI = A.DNIPropietari
	WHERE YEAR(now())-1 = YEAR(A.DataDefuncio) AND MONTH(A.DataDefuncio) = MONTH(now());

-- 14.Volem determinar quins animals de l’espècia Rèptils o Gossos que han nascut a l’agost i setembre.


-- 15.Volem determinar quants animals té cada propietari. No es vol tenir en compte l’espècie “Peixos”.
SELECT P.nom, count(*) AS numAnimals FROM Animal A 
	INNER JOIN Propietari P ON P.DNI = A.DNIPropietari
	WHERE A.especie <> 'Peixos'
	GROUP BY P.nom;
    
-- 16.Es vol determinar el xip i nom de l’animal que té un cost superior a la mitja.
SELECT xip, nom FROM Animal WHERE cost > (SELECT avg(cost) FROM Animal);

-- 17.Volem veure quins animals tenen un impost superior al 10% del cost de l’animal.
SELECT * FROM Animal WHERE impost > cost*0.1;

-- 18.Volem determinar quins animals són orfes en quant a propietari.
-- PRIMER CAS: Que no té propietari. 
SELECT * FROM Animal WHERE dnipropietari IS NULL;

-- SEGON CAS: Que té propietari pero s'ha mort.
SELECT A.nom FROM Animal A INNER JOIN Propietari P ON P.dni = A.DNIPropietari
	WHERE P.dataDefuncio IS NOT NULL;

-- 19.Volem determinar la mitja de vida (en dies) de cada espècie.
SELECT especie, ROUND(avg(datediff(dataDefuncio,dataNaix))) AS "Mitja de Vida" FROM Animal WHERE dataDefuncio IS NOT NULL
	GROUP BY especie;
    
-- 20.Volem que li ha costat a cada propietari el seu conjunt d’animals vius o no vius. Només es vol tenir en compte les espècies: Gat, Gos, Ocell.
-- CAS 1. Volem mostrar el nom del propietari.
SELECT P.DNI, P.nom, sum(cost+impost) AS "Despeses Animal" FROM Propietari P
	INNER JOIN Animal A ON P.DNI = A.DNIPropietari
	WHERE especie IN ('Gat','Gos','Ocell')
    GROUP BY P.DNI;
    
-- Volem mostrar el dni del propietari. Cas 2.
SELECT DNIPropietari AS DNI, sum(cost+impost) AS "Despeses Anmal"
	FROM Animal WHERE especie IN ('Gat','Gos','Ocell')
    GROUP BY DNI;

-- 21.Per cada any, mostra la quantitat d’animals que han mort. No cal tenir en compte les especies de Gat i Gos i tampoc l’any 2015 perquè vam cedir l’exploració del negoci.
SELECT YEAR(dataDefuncio) AS "Any de defuncio", count(*) AS "Total Defuncio" FROM Animal
	WHERE especie NOT IN ('Gat','Gos') AND YEAR(dataDefuncio) != 2015
	GROUP BY "Any Defuncio";

-- 22.Tenint en compte que tots els animals es van donar d’alta a la Clínica Veterinària un cop passat els primers 30 dies després de que van néixer,
-- i tenint en compte que cada dia que està inscrit a la Clínica, costa 2,60€, calcula la despesa per animal VIU a data d’avui només dels animals on el seu propietari ha nascut abans del 2000.
SELECT A.nom, (CONCAT(FORMAT((datediff(now(),A.dataNaix)-30)*2.6,'c'),'€')) AS Despesa FROM Animal A INNER JOIN Propietari P ON P.DNI = A.DNIPropietari
	WHERE A.dataNaix IS NOT NULL AND YEAR(P.dataNaix) < 2000;
-- Ex: Bobby va néixer 01/01/2015 doncs calcular els cost tenint en compte 2,60€ a partir del 01/02/2015 fins a data d’avui.

-- 23. A partir d'ara es vol saber la població de cada Propietari. De la població
-- es vol emmagatzemar el CP i el nom de la població.
CREATE TABLE IF NOT EXISTS Poblacio (
	CP CHAR(5) PRIMARY KEY,
    nom VARCHAR(20),
    provincia VARCHAR(20)
) ENGINE = INNODB;

ALTER TABLE Propietari ADD poblacioCP CHAR(5);
ALTER TABLE Propietari ADD CONSTRAINT fk_propietari_poblacio FOREIGN KEY (poblacioCP)
	REFERENCES Poblacio(CP)
    ON UPDATE CASCADE ON DELETE RESTRICT;
DESCRIBE propietari;

-- 24.Mostra el nom d'aquells animals, excepte les tortugues, on l'animal sigui orfa d'aquells propietaris que eren de Granollers o Cardedeu.
SELECT A.nom FROM Animal A
	INNER JOIN Propietari P ON P.DNI = A.DNIPropietari
    INNER JOIN Poblacio Po ON Po.CP = P.poblacioCP
    WHERE P.dataDefuncio IS NOT NULL AND A.especie != 'Tortuga'
    AND Po.nom IN ('Granollers','Cardedeu') AND A.DataNaix IS NULL;

-- 25.Mostra per any de naixement de propietari (només els vius) el total d'animals que hi han.
-- Només cal tenir en compte els que tenen un cost superior a 100€ i que el seu propietari sigui de codi postal '08430' o Granollers.
SELECT YEAR(P.dataNaix) AS "Any Naixament", COUNT(*) AS Total FROM Animal A 
	INNER JOIN Propietari P ON P.DNI = A.DNIPropietari
    INNER JOIN Poblacio Po ON Po.CP = P.poblacioCP
    WHERE P.DataDefuncio IS NULL AND A.cost > 100 AND (Po.CP = '08030' OR Po.nom = 'Granollers') 
    GROUP BY "Any Naixament" DESC;
    
-- 26.Mostra per nom de població de propietari quants animals estan morts.
SELECT Po.nom AS Poblacio, COUNT(*) AS "Total animals morts" FROM Animal A 
	INNER JOIN Propietari P ON P.DNI = A.DNIPropietari
    INNER JOIN Poblacio Po ON Po.CP = P.poblacioCP
    WHERE A.dataDefuncio IS NOT NULL
    GROUP BY Poblacio;
