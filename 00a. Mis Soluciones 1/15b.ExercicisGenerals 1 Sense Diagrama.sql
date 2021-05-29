CREATE DATABASE exercici15b;
USE exercici15b;

CREATE TABLE IF NOT EXISTS poblacio (
	codiPostal CHAR(5) PRIMARY KEY,
	nom VARCHAR(30)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS propietari (
	dni CHAR(9) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    poblacioCodiPostal CHAR(5),
    
    CONSTRAINT fk_propietari_poblacio FOREIGN KEY(poblacioCodiPostal)
		REFERENCES poblacio(codiPostal)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS clinica (
	cif CHAR(9) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    poblacioCodiPostal CHAR(5),
    
    CONSTRAINT fk_clinica_poblacio FOREIGN KEY(poblacioCodiPostal)
		REFERENCES poblacio(codiPostal)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS metge (
	nif CHAR(9) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    poblacioCodiPostal CHAR(5),
    clinicaCIF CHAR(9),
    
    CONSTRAINT fk_metge_poblacio FOREIGN KEY(poblacioCodiPostal)
		REFERENCES poblacio(codiPostal)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
        
	CONSTRAINT fk_metge_clinica FOREIGN KEY(clinicaCIF)
		REFERENCES clinica(cif)
        ON UPDATE CASCADE
        ON DELETE SET NULL        
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS animal (
	
    xip CHAR(9) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    raca VARCHAR(20),
    dataNaixament DATE,
    propietariDNI CHAR(9) NOT NULL,
    
    CONSTRAINT fk_animal_propietari FOREIGN KEY(propietariDNI)
		REFERENCES propietari(dni)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS operacions (
	nom VARCHAR(20) PRIMARY KEY,
    preu DECIMAL (6,2) NOT NULL,
    tempsPrevist INT NOT NULL

) ENGINE= INNODB;

CREATE TABLE IF NOT EXISTS recursos (
	
    operacioNom VARCHAR(20),
    nomRecurs VARCHAR(20),
    PRIMARY KEY(operacioNom,nomRecurs),
    
    CONSTRAINT fk_recursos_operacio FOREIGN KEY (operacioNom)
		REFERENCES operacions(nom)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE= INNODB;

CREATE TABLE IF NOT EXISTS mao(

	metgeNIF CHAR(9),
    operacionsNom VARCHAR(20),
    animalXip CHAR(9),
    dataMao DATE,
    pes DECIMAL (5,3),  -- 3 decimals 
    temps INT,  -- expressat en minuts
    PRIMARY KEY(metgeNIF,operacionsNom,animalxip,dataMAO),
    
     CONSTRAINT fk_mao_metge FOREIGN KEY (metgeNIF)
		REFERENCES metge(NIF)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_mao_operacions FOREIGN KEY (operacionsNom)
		REFERENCES operacions(nom)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
	CONSTRAINT fk_mao_animal FOREIGN KEY (animalXip)
		REFERENCES animal(xip)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=INNODB;


-- INSERCIO
-- El dia 15/3/2016 es va fer una operació de catarates al gos “Bobby” amb xip “BC1234567” . 
-- L’operació la va realitzar el metge “Smith” amb DNI 45397854-X i va durar 30 minuts. 
-- El propietari del gos és l'Anna Quiroz amb DNI 74321344-Y i resident a Granollers amb codi postal «08400». 
-- Les dades no facilitades pots inventar-te-les.
insert into poblacio
insert into clinica
insert into metge
insert into propietari
insert into animal
insert into operacios
insert into mao

 

-- 2	Obtenir un llistat de totes les dades de tots els metges de la clínica “Dexeus” de Barcelona.


-- 3	Per error ha mort un animal en una operació de Tiroides. Per evitar que els Mossos d’esquadra ens tanquin el local, 
-- es vol eliminar que nosaltres fem operacions d’aquest tipus. No es vol deixar cap rastre. 
-- Realitza les modificacions que facin falta perquè sinó el propietari de la clínica et farà responsable i aniràs a la presó.
-- Realitza l'exercici utitlizant els deletes i una altre fent una variació en l'estructura de la taula.

-- UTILITZANT DELETES:
DELETE FROM mao WHERE operacionsNom = 'tiroides';
DELETE FROM recursos WHERE operacionsNom = 'tiroides';
DELETE FROM operacions WHERE nom = 'tiroides';

-- MODIFICANT L'ESTRUCTURA:
ALTER TABLE mao DROP FOREIGN KEY fk_mao_operacions;
ALTER TABLE mao ADD CONSTRAINT fk_mao_operacions FOREIGN KEY (operacionsNom)
		REFERENCES operacions(nom)
        ON UPDATE CASCADE ON DELETE CASCADE;
        
ALTER TABLE recursos DROP FOREIGN KEY fk_recursos_operacio;
ALTER TABLE recursos ADD CONSTRAINT fk_recursos_operacio FOREIGN KEY (operacioNom)
		REFERENCES operacions(nom)
        ON UPDATE CASCADE ON DELETE CASCADE;

-- 4	Digues la quantitat de recursos associats a cada operació. 
SELECT operacioNom, COUNT(*) AS QttRecursos FROM recursos 
	GROUP BY operacioNom;

-- 5	Obtenir el nom i dni dels propietaris de la població de “Granollers”, “Barcelona” i “Canovelles”. 

-- 6	Obtenir el nom de tots els gossos que el seu Xip comenci per “B” or per “H”.  

-- 7	Modificar el nom de la clínica amb CIF: “B60147645” a “Guau Guau”. 

-- 8	Veure el nom i raça de tots els animals que ha operat el metge “Smith” durant els anys 2010 i 2017.
SELECT a.nom, a.raca FROM animal a
	INNER JOIN mao ON a.xip = mao.animalXip
    INNER JOIN metge m ON m.nif = mao.metgenif
    WHERE m.nom = 'smith' AND YEAR(mao.data) BETWEEN 2010 AND 2017;

-- 9	Veure nom de l’operació que requereix més temps “Temps previst” 
SELECT nom FROM operacions WHERE tempsPrevist = (SELECT MAX(tempsprevist) FROM operacions);

-- 9b   Veure el nom de l'operació del Dr. Smith que ha trigat més.
select max(temps) from mao
	inner join metge m on m.nif = mao.metgeNIF
    where m.nom = 'smith';
    
-- pas 2: determinar el nom de les operacions que tenen aquest valor de temps màxim calculat.
SELECT mao.operacionsNom, mao.temps FROM mao
	INNER JOIN metge m ON m.nif = mao.metgeNIF
    WHERE m.nom = 'smith' AND mao.temps = (SELECT MAX(temps) FROM mao
											INNER JOIN metge m ON m.nif = mao.metgeNIF
											WHERE m.nom = 'smith');

-- 10	Veure quants animals té cada propietari de la ciutat de Barcelona.

-- 11	Es volen eliminar aquells metges que siguin de Granollers, Mollet o del codi postal 08420 o 08480.
DELETE m.* FROM metge 
	INNER JOIN poblacio p ON p.codipostal = m.poblaciocodipostal
    WHERE p.nom IN ('Granollers','Mollet') OR p.codipostal IN ('08420','08100');

-- 12	Obtenir quina desviació hi ha hagut de cada una de les operacions (de forma individual) segons el temps previst i el temps real invertit. 
-- Ordena-ho per nom d'operació i temps.
SELECT o.nom, o.tempsPrevist, mao.temps, mao.temps-o.tempsPrevist AS desviacio FROM operacio o
	INNER JOIN mao ON o.nom = mao.operacionsNom
    ORDER BY o.nom, desviacio;

-- 13	Obtenir totes les dades de l'operació/operacions que ha tingut una major desviació. 
-- Utilitzar una vista a partir de la consulta anterior. 
CREATE VIEW llistatDesviacions AS
SELECT o.nom, o.tempsPrevist, mao.temps, mao.temps-o.tempsPrevist AS desviacio FROM operacio o
	INNER JOIN mao ON o.nom = mao.operacionsNom
    ORDER BY o.nom, desviacio;
    
SELECT * FROM llistatDesviacions;

SELECT * FROM llistatDesviacions
	WHERE desviacio = (SELECT MAX(desviacio) FROM llistatDesviacions);


-- 14	El codi postal «08400» és incorrecte. Cal modificar-lo per 08402. 



-- 15	Veure un llistat de dates i nom d'operacions dels animals intervinguts a la clínica “Pets4ever”.



-- 16	Obtenir per any de data de naixement, el número de xip d'aquells animals que el seu 
-- propietari no sigui de la població de «Barcelona» ni de «Girona» i la seva data de naixement sigui anteiror a l'any 2015. 


-- 17	Actualitzar el pes de l’animal amb xip “FC1234567” de l’operació del dia “12/06/2015” a 6,45 kg 
-- degut a que hi va haver un error inicial.
UPDATE mao
SET pes = 6.45
WHERE animalXip = 'FC1234567' AND dataMao = '2015-06-12';

-- 17b Cal incrementar un 20% més de temps a totes aquelles operacions de Catarates o Ganglis fetes a la clinica "Cocochan" que hagi operat el Dr. Smith.
UPDATE mao
	INNER JOIN metge m ON m.NIF = mao.metgeNIF
    INNER JOIN clinica c ON c.cif = m.clinicacif
	SET temps = temps*1.2
	WHERE m.nom = 'smith' AND operacionsNom IN ('Catarates','Ganglis') AND c.nom = 'Cocochan';

-- 18	Veure quantes operacions va realitzar la clínica “Pets4ever” durant l’any 2013 i 2014.
-- 19	Augmenta el temps en un 20% d'aquelles operacions de la clínica «Pets4ever» on els animals són de la raça «Husky» o «Bulldog».


-- 20	Obtenir totes les poblacions que no tinguin cap clínica.


-- 21	Obtenir totes les poblacions que estiguin associades a un metge, a una clínica o a un propietari (utilitzeu una vista).
CREATE VIEW llistaPoblacionsGenerals AS
SELECT p.nom FROM poblacio INNER JOIN metge m ON p.codipostal = m.poblaciocodipostal
UNION
SELECT p.nom FROM poblacio INNER JOIN clinica c ON p.codipostal = c.poblaciocodipostal
UNION
SELECT p.nom FROM poblacio INNER JOIN propietari pr ON p.codipostal = pr.poblaciocodipostal;

SELECT DISTINCT nom FROM llistaPoblacionsGenerals;

    

-- 22	Modificar el temps de totes les operacions de l'any 2015 que ha realitzat el metge «Smith» en un 10%.

-- 23	Obtenir la facturació anual total per clínica.

    
-- 24	Obtenir el nom de l'operació i el total de temps real emprat en cada una de les operacions. 


-- 25	Digues quina és l'operació que s'ha tardat més estona en realitzar-se.


-- 26	Obtenir el preu de cada una de les operacions tenint en compte que el preu de la 
-- operació augmenta en 0,15€ per minut de més segons el temps previst. Considerar només les operacions que superen el temps previst.
-- A partir de la vista que ja tenim que es diu llistatDesviacions calculem el cost extra.
SELECT * FROM llistatDesviacions;

SELECT *, desviacio*0.15 AS facturacioPerAlbert FROM llistatDesviacions
WHERE desviacio > 0;


-- 27	Elimina tots aquells metges que no han realitzat cap operació que siguin de la clínica «Pets4ever». 
DELETE m.* FROM clinica c LEFT JOIN metge m ON c.cif = m.clinicacif
	LEFT JOIN mao ON m.nif = mao.metgenif
    WHERE m.nom = 'Pets4ever' AND mao.metgenif IS NULL;


-- 28	Es volen realitzar moltes consultes a partir del nom de raça de l'animal. -- variada
-- Executa les accions que faries per tal d'optimitzar aquestes consultes
create index iraca on animal(raca);

-- 29	Es volen realitzar moltes consultes a partir del nom de poblacio. -- variada
-- Executa les accions que faries per tal d'optimitzar aquestes consultes




-- 30	Cal eliminar aquells animals on els seu propietari sigui de Barcelona.


-- 30B	Cal eliminar aquells metges que no han realitzat cap operació.


-- 31	Com administrador de la base de dades, et demanen que a partir d’ara, el metge també tindrà un 
-- camp “codi” únic i identificatiu a la base de dades. Aquest codi no s’assigna immediatament al metge sinó 
-- al cap d’un temps. De totes formes, aquest metge pot fer operacions sense codi. També veus que aquest codi, és molt usat en les consultes. Quines instruccions SQL utilitzaries per donar solució a tot això, tot optimitzant el motor de la base de dades.



-- 32	En el país el qual està en producció aquesta base de dades, no existeixen poblacions amb diferents codis postals. 
-- Et dones compte que la majoria de consultes que et demanen son per nom de població. 
-- Expressa en SQL quines sentencies utilitzaries per optimitzar les cerques.

