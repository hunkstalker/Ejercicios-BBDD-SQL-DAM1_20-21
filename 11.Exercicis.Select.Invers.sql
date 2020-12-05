CREATE DATABASE exercici11;
USE exercici11;

CREATE TABLE IF NOT EXISTS Curs(
	codi VARCHAR(4),
	nom VARCHAR(50),
	durada INT,
	categoria VARCHAR(20),
	PRIMARY KEY(codi)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Poblacio(
	CP CHAR(5),
	ciutat VARCHAR(20),
	provincia VARCHAR(20),
	PRIMARY KEY(cp)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Alumne(
	DNI CHAR(9),
	nom VARCHAR(20),
	cognom VARCHAR(30),
	adreca VARCHAR(30),
	duradaFCT INT,
	poblacioCP CHAR(5),
	cursCodi VARCHAR(4),
	PRIMARY KEY(DNI),
	CONSTRAINT fk_alumne_curs FOREIGN KEY (cursCodi) REFERENCES curs(codi)
		ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT fk_alumne_poblacio FOREIGN KEY (poblacioCP) REFERENCES poblacio(CP)
		ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Empresa(
	CIF CHAR(9),
	nom VARCHAR(20),
	adreca VARCHAR(30),
	responsable VARCHAR(20),
	qttTreballadors INT,
	poblacioCP CHAR(5), -- FK
	PRIMARY KEY(CIF),
	CONSTRAINT fk_empresa_poblacio FOREIGN KEY (poblacioCP) REFERENCES poblacio(CP)
		ON UPDATE CASCADE
		ON DELETE SET NULL
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Conveni(
	dataInici DATE,
	dataFinal DATE,
	durada INT,
	alumneDNI CHAR(9), -- FK
	empresaCIF CHAR(9), -- FK
	PRIMARY KEY(alumneDNI,empresaCIF,dataInici),
	CONSTRAINT fk_conveni_alumne FOREIGN KEY (alumneDNI) REFERENCES alumne(DNI)
		ON UPDATE CASCADE
		ON DELETE RESTRICT,
	CONSTRAINT fk_conveni_empresa FOREIGN KEY (empresaCIF) REFERENCES empresa(CIF)
		ON UPDATE CASCADE
			ON DELETE CASCADE
) ENGINE=INNODB;

-- 1. S’ha donat d’alta l’alumne “Maria Garcia” de Mollet (08102) amb DNI: “11223344Z” al curs de SMX. L’alumne té una exempció d’un 50%.
INSERT INTO Poblacio VALUES ("08104","Mollet","Barcelona"),("08100","Mollet","Barcelona");
INSERT INTO Curs VALUES ("0001","SMX",340,"Informática");
INSERT INTO Alumne VALUES ("11223344Z","Maria","Garcia","Jaume I",170,"08104","0001");

-- 2. Es vol saber el total d’empreses que hi ha convenis actius per categoria.
-- A data d’avui, la coordinadora em dona un conveni que iniciaré la propera setmana. Aquest conveni NO es considera Actiu.
INSERT INTO Empresa VALUES ("12481632F","Cartonajes Miralles","Pol.Ind Can Prat","Paco Miralles",230,"08100");
INSERT INTO Poblacio VALUES ("601-8","Minami Ward","Kyoto");
INSERT INTO Empresa VALUES ("22441616G","Nintendo","Minami Ward","Fusajiro Yamauchi",5120,"601-8");
INSERT INTO Curs VALUES ("0002","DAM1","420","Programació");
INSERT INTO Alumne VALUES ("DNI2","Denis","Anfruns","Calle24","336","08100","0002");
-- INSERT INTO Conveni VALUES ("2019-11-04",NULL,100,"DNI2","CIF2"),("2021-10-01",NULL,50,"DNI3","CIF2");

SELECT COUNT(Co.empresaCIF) AS "Qtt d'Empreses", Cu.categoria AS "Categoría Curs" FROM Conveni Co
	INNER JOIN Alumne A ON A.dni = Co.alumnedni
	INNER JOIN Curs Cu ON Cu.codi = A.cursCodi
    WHERE Co.dataInici <= NOW()
    GROUP BY Cu.categoria;

-- 3. Cal mostrar un llistat d’alumnes (nom i cognom) que tenen algun tipus d’exempció. Mostra la informació per cicle.
-- .nom AS "Nom Alumne", A.cognom AS "Cognom Alumne", Cu.nom AS "Nom Cicle" 
INSERT INTO Alumne VALUES ("DNI3","Nom3","Cognom3","Calle50",NULL,"08100","0002");

SELECT A.nom AS "Nom Alumne", A.cognom AS "Cognom Alumne", Cu.nom "Nom Cicle"  FROM Alumne A
	INNER JOIN Curs Cu ON A.cursCodi = Cu.codi
    WHERE duradaFCT < Cu.durada
	ORDER BY Cu.nom;

-- 4. Cal modificar l’atribut Nom de l’alumne per una longitud de 10 caràcters més dels que hagis configurat.
ALTER TABLE Alumne MODIFY COLUMN nom VARCHAR(30);

-- 5. Quina és l’empresa que té més treballadors de la província de Barcelona.
INSERT INTO Empresa VALUES ("CIF3","Dynacast","Carrer Flanders","Señor Dynacast",500,"08100");

-- 1er PASO.
SELECT E.nom AS "Nom d'Empresa", MAX(qttTreballadors) AS "Qtt Treballadors" FROM Empresa E
	INNER JOIN Poblacio P ON P.CP = E.poblacioCP
	WHERE P.provincia = "Barcelona";
-- Me da el máximo de empleados, pero no corresponde con el nombre, así que uso SubSelect.

-- 2o PASO.
SELECT E.nom AS "Nom Empresa", E.qttTreballadors AS "Qtt Treballadors" FROM Empresa E
	INNER JOIN Poblacio P ON P.CP = E.poblacioCP
    WHERE P.provincia = "Barcelona" AND
	qttTreballadors = (SELECT MAX(qttTreballadors) FROM Empresa E
			INNER JOIN Poblacio P ON P.CP = E.poblacioCP
			WHERE P.provincia = "Barcelona");
    
SELECT * FROM Empresa;
SELECT * FROM Poblacio;

-- 6. Volem veure el nom i cognom en una columna anomenada Nom Complet dels alumnes de DAM o ASIX que han iniciat algun conveni aquest any. Cal mostrar el nom i cognom en una única columna ordenat Nom del curs.
INSERT INTO Alumne VALUES ("DNI4","Nom4","Cognom4","Calle60",10,"08104","0001");
INSERT INTO Conveni VALUES ("2020-11-04",NULL,110,"DNI4","CIF3");

SELECT CONCAT(A.nom," ",A.cognom) AS "Nom Complet", Cu.nom AS "Nom Curs", Cu.codi AS "Codi Curs", Co.dataInici AS "Data Inici" FROM Curs Cu
	INNER JOIN Alumne A ON Cu.codi = A.cursCodi
    INNER JOIN Conveni Co ON A.dni = Co.alumneDni
    WHERE Cu.codi IN ("0001") OR ("0002")
    AND YEAR(Co.dataInici)=YEAR(NOW())
    ORDER BY Cu.nom;

-- 7. Es vol determinar quina és la quantitat de convenis que hi ha per categoria.
SELECT COUNT(*) AS "Qtt de Convenis", Cu.categoria AS "Categoría Curs" FROM Conveni Co
	INNER JOIN Alumne A ON A.dni = Co.alumnedni
	INNER JOIN Curs Cu ON Cu.codi = A.cursCodi
    GROUP BY Cu.categoria;

-- 8. L’alumne de DAM d’informàtica, en Marc González amb DNI: “12345678Z” de La Roca del Vallès (08430) 
-- sense direcció específica ha iniciat les pràctiques avui fins el 12 de Març el qual farà un total de 135 h 
-- en l’empresa “Google Spain” de 120 treballadors de Sabadell (08207) amb CIF ‘B1234568’. La resta de dades no les sabem. Cal tenir en compte que l’alumne no té cap tipus d’exempció.
-- Posa les instruccions necessàries donant per suposat que no hi ha cap dada introduïda.
INSERT INTO Poblacio VALUES ("08430","La Roca del Vallès","Barceloa"),("08207","Sabadell","Barcelona");
INSERT INTO Alumne VALUES ("12345678Z","Marc","González",NULL,NULL,"08430","0002");
INSERT INTO Empresa VALUES ("B1234568","Google Spain",NULL,NULL,120,"08207");
INSERT INTO Conveni VALUES (DATE(NOW()),"2021-03-12",135,"12345678Z","B1234568");

-- 9. Es vol veure els dies de mitja que hi ha per conveni de les empreses.
-- Ex: Si tenim l’empresa Google que un alumne de DAM ha fet 10 dies i un alumne de SMX ha fet 5, el total de dies d’aquesta empresa és: 7,50. Considerem que es compten els caps de setmana.
-- Representa la informació amb dos decimals.
SELECT ROUND(AVG(DATEDIFF(Co.dataFinal,Co.dataInici)),2) AS "Mitja", E.nom FROM Conveni Co
	INNER JOIN Empresa E ON E.CIF = Co.empresaCIF
    GROUP BY E.nom;

-- 10.Es vol saber el nom i cognom dels alumnes que han iniciat convenis els mesos de Gener, Març, Juny o desembre on la seva ciutat (alumne) sigui de Granollers o Cardedeu o Mataró.
INSERT INTO Alumne VALUES ("DNI5","Nom5","Cognom5",NULL,NULL,"CPGRA","0002"),("DNI6","Nom6","Cognom6",NULL,NULL,"CPCAR","0002"),
	("DNI7","Nom7","Cognom7",NULL,NULL,"CPMAT","0001"),("DNI8","Nom8","Cognom8",NULL,NULL,"CPMAT","0001"),("DNI9","Nom9","Cognom9",NULL,NULL,"CPMRU","0001");
INSERT INTO Conveni VALUES ("2020-01-05",NULL,50,"DNI5","CIF3"),("2020-02-05",NULL,50,"DNI6","CIF3"),("2020-03-05",NULL,50,"DNI7","CIF3"),
	("2020-06-05",NULL,50,"DNI8","CIF3"),("2020-12-05",NULL,50,"DNI9","CIF3");
INSERT INTO Poblacio VALUES ("CPGRA","Granollers","Barcelona"),("CPCAR","Cardedeu","Barcelona"),("CPMAT","Mataró","Barcelona");
    
SELECT A.nom AS "Nom Alumne", A.cognom AS "Cognom Alumne", Co.datainici AS "Data Conveni" FROM Alumne A
	INNER JOIN Conveni Co ON A.dni = Co.alumneDNI
    WHERE MONTH(dataInici) IN (1,2,3,6,12) AND A.poblacioCP IN ("CPGRA","CPCAR","CPMAT");

-- 11.Es vol veure els alumnes que no tenen cap ‘I’ en el seu cognom, són de la província de Barcelona, Lleida o Tarragona. Ordena’ls per Cognom i després per Nom ascendent ment.
INSERT INTO Poblacio VALUES ("CPMRU","Mollerusa","Lleida"),("CPTAR","PuebloTarragona","Tarragona");

SELECT A.nom AS "Nom Alumne", A.cognom AS "Cognom Alumne", P.provincia AS "Nom Provincia" FROM Alumne A
	INNER JOIN Poblacio P ON P.CP = A.poblacioCP
    WHERE P.provincia IN ("Barcelona","Lleida","Tarragona") AND A.cognom NOT LIKE "%l%"
    ORDER BY A.cognom, A.nom;

-- 12.Indica el nom i cognom dels alumnes que han de fer més de 200 hores de pràctiques i que encara no hi ha cap conveni introduït.
INSERT INTO Alumne VALUES ("DNI10","Nom10","Cognom10","Adreca10",205,"CPGRA","0001");

SELECT A.nom AS "Nom Alumne", A.cognom AS "Cognom Alumne", A.duradaFCT AS "Hores Conveni", Co.dataInici AS "Data d'Inici Conveni" FROM Alumne A
	LEFT JOIN Conveni Co ON A.DNI = Co.alumneDNI
    WHERE A.duradaFCT >= 200 AND Co.dataInici IS NULL;

-- 13.Determina el nom i cognom dels alumnes tenen més convenis que l’alumne Marc Garcia.
SELECT COUNT(*) FROM Conveni Co
	INNER JOIN Alumne A ON A.DNI = Co.alumneDNI
    WHERE A.nom = 'Marc' AND A.cognom = 'Garcia';
    
SELECT A.nom, A.Cognom, COUNT(*) AS "Total Convenis" FROM Alumne A
	INNER JOIN Conveni Co ON A.DNI = Co.alumneDNI
    GROUP BY A.DNI
    HAVING COUNT(*)>(SELECT COUNT(*) FROM Conveni Co
			INNER JOIN Alumne A ON A.DNI = Co.alumneDNI
			WHERE A.nom = 'Marc' AND A.cognom = 'Garcia');

-- 14.Es vol saber la quantitat d’empreses que encara no han tingut cap conveni.
INSERT INTO Empresa VALUES ("CIF4","Ibermatica","Adreca4","NomResp04",200,"08100");

SELECT COUNT(E.nom) AS "Qtt d'Empresas", Co.empresaCIF AS "CIF d'Empresa" FROM Empresa E 
	LEFT JOIN Conveni Co ON E.CIF = Co.empresaCIF
    WHERE Co.empresaCIF IS NULL;
      
-- 15.Es vol saber el nom dels cursos que superen en més de 5 convenis actius aquest any. Ordena els cursos alfabèticament.
SELECT Cu.nom AS "Nom Curs", Co.dataInici AS "Data Inici" FROM Curs Cu 
	INNER JOIN Alumne A ON Cu.codi = A.cursCodi
    INNER JOIN Conveni Co ON A.DNI = Co.alumneDNI
    WHERE YEAR(Co.dataInici) = YEAR(NOW())
	HAVING Co.dataInici > 5
    ORDER BY Cu.nom;

-- 16.Ens donen un llistat de tutors de FCT on tenim DNI, nom i cognom. Cada tutor pot tenir tutelats més d'un alumne. 
-- Un alumne té UN tutor de FCT. Escriu les instruccions necessàries per poder donar solució aquest nou requeriment.
CREATE TABLE IF NOT EXISTS TutorFCT (
	DNI CHAR(9) PRIMARY KEY,
    Nom VARCHAR(20),
    cognom VARCHAR(20)
) ENGINE = INNODB;

ALTER TABLE Alumne ADD COLUMN tutorDNI CHAR(9);
ALTER TABLE Alumne ADD CONSTRAINT fk_alumne_tutorfct FOREIGN KEY (tutorDNI) REFERENCES TutorFCT(DNI);

-- 17.Es vol saber la quantitat d’empreses per PROVINCIA que encara no han tingut cap conveni. No es vol tenir en compte la província de Barcelona.
SELECT E.poblacioCP, COUNT(*) AS "Qtt d'empresas" FROM Empresa E
	LEFT JOIN Conveni Co ON E.CIF = Co.empresaCIF
    WHERE E.poblacioCP IN ('601-8','CPMRU','CPTAR');
    
SELECT P.provincia, COUNT(*) AS "Total" FROM Poblacio P
	INNER JOIN Empresa E ON P.CP = E.poblacioCP
    LEFT JOIN Conveni Co ON E.CIF = Co.empresaCIF
    WHERE P.provincia <> 'Barcelona' AND Co.empresaCIF IS NULL;

SELECT * FROM Poblacio;