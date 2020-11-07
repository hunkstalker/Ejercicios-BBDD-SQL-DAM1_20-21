CREATE DATABASE DBArxius;
USE DBArxius;

CREATE TABLE IF NOT EXISTS Usuari (
	login CHAR(45) PRIMARY KEY,
    nom VARCHAR(45) NOT NULL,
    dataCr DATE NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Arxiu (
	nom CHAR(45),
    versio DECIMAL(4,2),
    dataCr DATE,
    usuariLogin CHAR(45),
    arxiuNom CHAR(45),
    arxiuVersio DECIMAL(4,2),
    PRIMARY KEY (nom, versio),
	CONSTRAINT fk_arxiu_usuari FOREIGN KEY (usuariLogin) REFERENCES Usuari(login)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
    CONSTRAINT fk_arxiu_arxiu FOREIGN KEY (arxiuNom, arxiuVersio) REFERENCES Arxiu(nom,versio)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Format (
	nom CHAR(45) PRIMARY KEY,
    tipus VARCHAR(45)
) ENGINE = INNODB;	

CREATE TABLE IF NOT EXISTS Disponible (
	formatNom CHAR(45),    
    arxiuNom CHAR(45),
    arxiuVersio DECIMAL(4,2),
    PRIMARY KEY (formatNom,arxiuNom,arxiuVersio),
    CONSTRAINT fk_disponible_format FOREIGN KEY (formatNom) REFERENCES Format(nom)
		ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_disponible_arxiu FOREIGN KEY (arxiuNom,arxiuVersio) REFERENCES Arxiu(nom,versio)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

INSERT INTO Usuari VALUES ("Suki","Jerry","2019-05-10"),("Phillip","Ariel","2017-03-28"),("Shelly","Daryl","2018-02-01"),
	("Jasper","Jelani","2018-12-13"),("Philip","Nayda","2017-09-21"),("Shaeleigh","Jasper","2021-04-14"),("Zenaida","Eve","2019-01-28"),
    ("Zahir","Jaime","2018-09-19"),("Rajah","Amanda","2018-11-24"),("Ocean","Clare","2015-12-27");
INSERT INTO Format VALUES ("jpeg","image"),("gif","image"),("mp4","video"),("avi","video"),("mp3","audio");

-- 1. Obtenir el nom de tots els autors que tinguin algun arxiu creat.
SELECT DISTINCT U.nom, A.usuariLogin, A.nom FROM Usuari U 
	INNER JOIN Arxiu A ON U.login = A.usuariLogin;

-- 2. Obtenir el nom del format de tots els arxius que s'han creat durant l'any 2017. El nom de la col·lumna ha de ser "Nom Format".
		-- INSERT INTO Arxiu VALUES ("Imatge",0.1,"Phillip",NULL,NULL);
		-- INSERT INTO Arxiu VALUES ("Video",0.3,"2017-09-21","Phillip",NULL,NULL);
		-- INSERT INTO Disponible VALUES ("mp4","video",0.3);
SELECT D.formatNom AS "Nom Format", A.dataCr AS "Data Creació" FROM Disponible D
	INNER JOIN Arxiu A ON A.nom = D.arxiuNom AND A.versio = D.arxiuVersio
    WHERE YEAR(A.DataCr);

-- 3. Obtenir tots els arxius del tipus amb format image.
SELECT D.arxiuNom AS "Nom Arxiu", D.arxiuVersio AS "Versio d'arxiu", F.nom AS "Nom Format" FROM Disponible D
	INNER JOIN Format F ON D.formatNom = F.nom 
    WHERE F.tipus LIKE '%image%';

-- 4. Obtenir el total d'arxius originals creats l'any 2016.
		-- INSERT INTO Arxiu VALUES ("ImatgePaisatge",0.1,"2016-05-01","Jasper",NULL,NULL);
		-- INSERT INTO Arxiu VALUES ("ImatgePaisatge","0.3","2017-01-25","Jasper","ImatgePaisatge",0.1);
SELECT COUNT(*), nom AS "Nom", dataCr AS "Data Creació" FROM Arxiu
	WHERE YEAR(dataCr)=2016 AND arxiuVersio IS NULL GROUP BY DataCr;

-- 5. Obtenir el nom de l'autor de l'arxiu més antic.
SELECT U.nom AS Autor, A.dataCr AS "Fecha Creació" FROM Arxiu A
	INNER JOIN Usuari U ON A.usuariLogin = U.login
    WHERE A.dataCr=(SELECT MIN(dataCr) FROM Arxiu);
    
-- 6. Obtenir el total d'arxius originals creats l'any 2016 creats per l'usuari de nom Sandra.
		-- 	INSERT INTO Usuari VALUES ("Utena01","Sandra","2010-02-06");
		-- 	INSERT INTO Arxiu VALUES ("CodiVideojoc",0.2,"2010-02-28","Utena01",NULL,NULL),("CodiVideojocNivell_01",1.0,"2010-03-25","Utena01",NULL,NULL);
		-- 	INSERT INTO Arxiu VALUES ("CodiVideojoc_02",1.0,"2016-02-28","Utena01",NULL,NULL),("CodiVideojocNivell_05",1.0,"2016-03-25","Utena01",NULL,NULL);
		-- 	INSERT INTO Arxiu VALUES ("CodiVideojoc_03",1.0,"2016-06-01","Utena01",NULL,NULL),("CodiVideojocNivell_04",1.0,"2016-06-25","Utena01",NULL,NULL);
		-- 	INSERT INTO Arxiu VALUES ("CodiVideojoc_02",2.0,"2017-03-05","Utena01","CodiVideojoc_02",0.2),("CodiVideojocNivell_05",2.0,"2018-05-12","Utena01","CodiVideojocNivell_05",1.0);
SELECT COUNT(*) AS "Quantitat d'arxius", usuariLogin AS "Usuari" FROM Arxiu
	WHERE YEAR(dataCr) = 2016 AND usuariLogin = ("Utena01") AND arxiuVersio IS NULL;
-- Pide nombre, porque no puedes saber a quien corresponde el login

-- 7. Obtenir tota la informació de totes les versions dels arxius. Cal ordenar pel nom de l'arxiu i de la versió més recents a la més antiga.
SELECT * FROM Arxiu ORDER BY nom ASC, dataCr DESC;

-- 8. Obtenir el login de tots els autors que hagin creat algun arxiu que el seu tipus sigui imatge.
SELECT A.usuariLogin AS "Login del autor", F.tipus AS "Tipus d'arxiu" FROM Arxiu A 
	INNER JOIN Disponible D ON A.nom = D.arxiuNom 
    INNER JOIN Format F ON D.formatNom = F.nom
    WHERE F.tipus = "image";
    
SELECT DISTINCT A.usuariLogin AS "Login del autor", F.tipus AS "Tipus d'arxiu" FROM Arxiu A 
	INNER JOIN Disponible D ON A.nom = D.arxiuNom AND A.versio = D.arxiuVersio
    INNER JOIN Format F ON F.nom = D.formatNom
    WHERE F.tipus = "image";

-- 9. Identificar l'arxiu amb el número de versió més gran.
-- SELECT nom, versio FROM Arxiu ORDER BY versio DESC LIMIT 1; Alternativa.
SELECT nom, versio FROM Arxiu WHERE versio=(SELECT MAX(versio) FROM Arxiu);

-- 10.Contabilitza el nombre arxius amb versio=2.
		-- INSERT INTO Arxiu VALUES ("Animacio_01",2.3,"2017-12-31","Rajah",NULL,NULL);
SELECT COUNT(versio) AS "Quant. d'arxius", nom AS "Nom del arxiu", usuariLogin AS "Autor" FROM Arxiu WHERE versio = 2;

-- 11.Obtenir el nom dels usuaris que hagin creat arxius amb el tipus de format image.
		-- INSERT INTO Disponible VALUES ("gif","Animacio_01","2.0");
SELECT U.nom AS "Nom del Usuari", F.tipus AS "Tipus d'arxiu" FROM Format F 
	INNER JOIN Disponible D ON F.nom = D.formatNom
    INNER JOIN Arxiu A ON D.arxiuNom = A.nom AND D.arxiuVersio = A.versio
    INNER JOIN Usuari U ON A.usuariLogin = U.login 
    WHERE F.tipus = "image";

-- 12.Obtenir el nom de l'autor de l'arxiu original més nou que sigui del tipus imatge.
SELECT U.nom AS "Nom de l'autor", A.dataCr AS "Versio del arxiu", F.tipus AS "Tipus d'arxiu" FROM Format F 
	INNER JOIN Disponible D ON D.formatNom = F.nom
    INNER JOIN Arxiu A ON A.nom = D.arxiuNom
    INNER JOIN Usuari U ON U.login = A.usuariLogin
    WHERE F.tipus = "image" ORDER BY A.dataCr DESC LIMIT 1;
    
    -- REPETIR

-- 13.Obtenir un llistat d’autors amb login i nom d’aquells que encara no han creat cap arxiu.
SELECT U.login AS "Login", U.nom AS "Nom del Autor" FROM Usuari U
	LEFT JOIN Arxiu A ON U.login = A.usuariLogin 
    WHERE A.usuariLogin IS NULL;

-- 14.Volem veure el nom dels usuaris creats abans del 2010 que hagin realitzat algun arxiu originals, en tipus format vídeo o que el nom del format sigui PDF.
		-- INSERT INTO Format VALUES ("pdf","text");
		-- INSERT INTO Arxiu VALUES ("Exercici DAM1 Tema1",1.0,"2008-05-01","Suki",NULL,NULL),("Exercici DAM1 Tema2",1.0,"2008-05-01","Suki",NULL,NULL);
		-- INSERT INTO Disponible VALUES ("pdf","Exercici DAM1 Tema1",1.0),("pdf","Exercici DAM1 Tema2",1.0);
SELECT DISTINCT U.nom AS "Nom de l'autor", A.dataCr AS "Versio del arxiu", F.tipus AS "Tipus d'arxiu" FROM Format F 
	INNER JOIN Disponible D ON  F.nom = D.formatNom
    INNER JOIN Arxiu A ON D.arxiuNom = A.nom 
    INNER JOIN Usuari U ON A.usuariLogin = U.login 
    WHERE (YEAR(U.dataCr) < 2010 AND A.arxiuVersio IS NULL) AND F.tipus = "video" OR F.nom = "pdf";

-- 15.Volem veure tots els formats que encara no han sigut utilitzats. Fes la consulta utilitzant un left join i tb l’equivalent en Right join.
SELECT F.nom AS "Nom Format", F.tipus AS "Tipus Format" FROM Format F
	LEFT JOIN Disponible D ON F.nom = D.formatNom
    WHERE D.arxiuVersio IS NULL;
    
SELECT F.nom AS "Nom Format", F.tipus AS "Tipus Format" FROM Disponible D
	RIGHT JOIN Format F ON  D.formatNom = F.nom
    WHERE D.arxiuVersio IS NULL;

-- 16.Volem veure el total d’arxius amb nom de format pdf, docx, mpg per any de creació de l’arxiu i per format.
		-- INSERT INTO Format VALUES ("docx","text"),("mpg","audio-video");
        -- INSERT INTO Arxiu VALUES ("Apunts",1.0,"2018-06-02","Ocean",NULL,NULL),("Video Festa 01",1.0,"2017-05-08","Hunk",NULL,NULL);
		-- INSERT INTO Disponible VALUES ("docx","Apunts",1.0),("mpg","Video Festa 01",1.0);
SELECT COUNT(A.nom) AS "Quantitat d'arxius", D.formatNom AS "Nom del format", A.dataCr AS "Data de Creació" FROM Arxiu A
	INNER JOIN Disponible D ON D.arxiuNom = A.nom
    WHERE D.formatNom IN ("pdf","docx","mpg") GROUP BY YEAR(A.dataCr);

-- 17.Volem saber el format més utilitzat, TIP: utilitza Limit operator.
		-- INSERT INTO Arxiu VALUES ("Video Festa 02",1.0,"2018-06-09","Ocean",NULL,NULL),("Video Festa 03",1.0,"2017-05-16","Hunk",NULL,NULL),
		-- 	("Video Festa 04",1.0,"2018-06-23)","Ocean",NULL,NULL),("Video Festa 05",1.0,"2017-05-30","Hunk",NULL,NULL);
		-- INSERT INTO Disponible VALUES ("avi","Video Festa 02",1.0),("avi","Video Festa 03",1.0),
		-- 	("avi","Video Festa 04",1.0),("avi","Video Festa 05",1.0);
SELECT COUNT(*) AS "Quantitat d'us del format", F.nom AS "Nom del Format" FROM Format F 
	INNER JOIN Disponible D ON F.nom = D.formatNom
    GROUP BY F.nom;
    
-- 17b.Volem saber el format que s'ha utilitzat 3 cops.
SELECT  F.nom AS "Nom del Format", COUNT(*) AS "Quantitat d'us del format" FROM Format F 
	INNER JOIN Disponible D ON F.nom = D.formatNom
	GROUP BY F.nom
    HAVING COUNT(*) = 3;

-- MAÑANA.

-- 18.Es vol premiar als usuaris que porten 10 o més anys a l’empresa. Aquests usuaris es consideren VETERANS. Volem saber el total d’arxius que ha creat cada veterà.
		-- INSERT INTO Usuari VALUES ("Eserendib","Oriol","2003-05-11");
SELECT U.nom AS "Nom d'Usuari", U.dataCr AS "Fecha de Creació", COUNT(A.nom) AS "Nombre d'Arxius" FROM Usuari U
	LEFT JOIN Arxiu A ON A.usuariLogin = U.login
	WHERE YEAR(U.dataCr)<YEAR(now())-10 GROUP BY U.nom;
    
-- 19 CLASE: Mostra el nom de l'arxiu que s'ha versionar 2 cops.
SELECT nom AS "Nom", COUNT(*) AS "Quantitat" FROM Arxiu
	GROUP BY nom
    HAVING COUNT(*) = 2;