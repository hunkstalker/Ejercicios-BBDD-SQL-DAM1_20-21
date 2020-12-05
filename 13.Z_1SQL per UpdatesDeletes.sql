DROP SCHEMA IF EXISTS exercici06;
CREATE SCHEMA IF NOT EXISTS exercici06;
USE exercici06;

CREATE TABLE IF NOT EXISTS Article (
	codi CHAR(5),
    nom VARCHAR(40) NOT NULL,
    familia VARCHAR(30),
    PRIMARY KEY (codi)
)ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Magatzem (
	codi CHAR(5),
	nom VARCHAR(30) NOT NULL,
    poblacio VARCHAR(40) NOT NULL,
    PRIMARY KEY (codi)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS emmagatzema (
	articleCodi CHAR(8),
    magatzemCodi CHAR(8),
    preu DECIMAL(6,2) NOT NULL,
	estoc DECIMAL(6,2) NOT NULL,
    PRIMARY KEY(articleCodi,magatzemCodi),
    CONSTRAINT fk_emmagatzema_article
		FOREIGN KEY (articleCodi) REFERENCES Article(codi)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_emmagatzema_magatzem
		FOREIGN KEY (magatzemCodi) REFERENCES Magatzem(codi)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=INNODB;

INSERT INTO article VALUES ("ART1","Lenovo","Portatils"),
	("ART2","HP","Sobretaula"),
    ("ART3","ACER","Sobretaula");
    
INSERT INTO magatzem VALUES ("MAG1","GranBCN","Barcelona"),
	("MAG2","BigGra","Granollers"),
    ("MAG3","ParkBCN","Barcelona");
    
INSERT INTO emmagatzema VALUES("ART1","MAG1",100,30),("ART1","MAG2",200,30),
	("ART2","MAG1",300,40),("ART3","MAG1",50,100);
    

-- Fer una cópia de seguretat de la base de dades original.
-- CREATE DATABASE exercici06_UpdateDeletesBACK;
-- USE exercici06_UpdateDeletesBACK;

-- CREATE TABLE Article LIKE exercici06_deletes.Article;
-- CREATE TABLE Magatzem LIKE exercici06_deletes.magatzem;
-- CREATE TABLE Emmagatzema LIKE exercici06_deletes.emmagatzema;

-- INSERT INTO Article SELECT * FROM exercici06_deletes.Article;
-- INSERT INTO Magatzem SELECT * FROM exercici06_deletes.magatzem;
-- INSERT INTO Emmagatzema SELECT * FROM exercici06_deletes.emmagatzema;

-- 1 Incrementar tots els preus un 10%.
SELECT * FROM Emmagatzema;

UPDATE Emmagatzema
SET preu = preu*1.1;

SET AUTOCOMMIT = 0;
DELETE FROM Emmagatzema
	WHERE preu < 150;
ROLLBACK;

-- 2 Disminuir el preu un 5% de tots els articles que el seu estoc sigui superior a 30.
UPDATE Emmagatzema
SET preu = preu -preu*0.5
WHERE estoc > 30;

-- 3 Incrementar l'estoc amb 5 unitats de tots els productes de la familia Portatils.
UPDATE Emmagatzema E
	INNER JOIN Article A ON A.codi = E.articleCodi
    SET E.estoc = E.estoc+5
    WHERE A.familia = 'Portatils';

-- 4 Decrementar amb 3 unitats tots els productes de la familia Sobretaula dels magatzems ubicats a Barcelona.
UPDATE Magatzem M
	INNER JOIN Emmagatzema E ON M.codi = E.magatzemCodi
    INNER JOIN Article A ON A.codi = E.articleCodi
SET E.estoc = E.estoc-3
WHERE A.familia = 'Sobretaula' AND M.poblacio = 'Barcelona';

-- 6. Afegir una 'No_' davant de tots els articles que encara no estan en cap magatzem.
INSERT INTO Article VALUES ('ART4','Alienware','Portatils');
UPDATE Article A 
	LEFT JOIN Emmagatzema E ON A.codi = E.articleCodi
SET A.nom = CONCAT('No_',A.nom)
WHERE E.articleCodi IS NULL;

-- 7.Canviar el codi de MAG1 per MAG5.
UPDATE Magatzem
SET codi = 'MAG5'
WHERE codi = 'MAG1';

SELECT * FROM Article;
SELECT * FROM Magatzem;
SELECT * FROM Emmagatzema;

-- USE exercici06_deletes;
-- ALTER TABLE Emmagatzema DROP FOREIGN KEY fk_emmagatzema_magatzem;
-- ALTER TABLE Emmagatzema ADD CONSTRAINT fk_emmagatzema_magatzem FOREIGN KEY (magatzemCodi) REFERENCES Magatzem(codi)
--         ON UPDATE CASCADE
--         ON DELETE RESTRICT;