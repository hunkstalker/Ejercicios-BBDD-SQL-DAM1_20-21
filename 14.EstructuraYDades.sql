CREATE DATABASE IF NOT EXISTS exercici14;
USE exercici14;

CREATE TABLE conductor (
	dni CHAR(9),
	nom VARCHAR(100) NOT NULL,
	telefon CHAR(10),
	PRIMARY KEY (dni)
) ENGINE=INNODB;

CREATE TABLE camio (
	matricula CHAR(8),
	tonatge DECIMAL(6,2) NOT NULL,
	consum DECIMAL(4,2) NOT NULL, --  El consum és cada 100 km
	conductorDNI CHAR(9),
	estat CHAR(1) NOT NULL,  -- A per actiu, B per baixa
	PRIMARY KEY (matricula),
	CONSTRAINT fk_camio_conductor FOREIGN KEY (conductorDNI) REFERENCES conductor (DNI)
		ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=INNODB;

CREATE TABLE ruta (
	codi CHAR(3),
	cporigen CHAR(5) NOT NULL,  -- Codi postal poblacio origen  
	cpdesti VARCHAR(5) NOT NULL, -- Codi postal poblacio desti
	PRIMARY KEY (codi)
) ENGINE=INNODB;

CREATE TABLE fa (
	camioMatricula CHAR(8),
	rutaCodi CHAR(3),
	data DATE NOT NULL,
	temps INTEGER,  -- expressat en minuts
    PRIMARY KEY (camioMatricula,rutaCodi,data),
	CONSTRAINT fk_fa_ruta FOREIGN KEY (rutaCodi) REFERENCES ruta (codi)
			ON DELETE RESTRICT ON UPDATE RESTRICT,
	 CONSTRAINT fk_fa_camio FOREIGN KEY (camioMatricula) REFERENCES camio (matricula)
			ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=INNODB;

-- Entidad débil
CREATE TABLE tram (
	puntKilom DECIMAL(3,1) ,
	cost_peatge DECIMAL(4,2), distancia DECIMAL(3,1),
	rutaCodi CHAR(3),
	PRIMARY KEY (rutaCodi,puntKilom),
	CONSTRAINT fk_trams_ruta FOREIGN KEY (rutaCodi) REFERENCES ruta (codi)
		ON DELETE RESTRICT
		ON UPDATE RESTRICT
) ENGINE=INNODB;

INSERT INTO conductor VALUES ('DNI1','Marc Garcia','TELF1'), ('DNI2','Estefania Sánchez','TELF2'),
				('DNI3','Raúl Bellido','TELF3'),('DNI4','Carlos Garcia','TELF4');
INSERT INTO camio VALUES ('0001AAA',40,22.20,'DNI1','A'), ('0001BBB',60,32.20,'DNI1','A'),
					('0001CCC',20,10,'DNI2','A'),('0001DDD',30,60,NULL,'B'),
                    ('0001EEE',200,25,'DNI4','A'),('0001FFF',80,40,NULL,'B');
INSERT INTO ruta VALUES ('R01','00001','00010'),('R02','00002','00020'),('R03','00003','00030'),
						('R04','00005','00030');

INSERT INTO fa VALUES ('0001AAA','R01','2018-11-20',30), ('0001BBB','R01','2018-11-10',45),
					('0001BBB','R02',NOW(),120),('0001CCC','R03',NOW(),150),('0001DDD','R03',NOW(),130);
                    
INSERT INTO tram VALUES (0,0,30,'R01'), (30,5,10,'R01'),(40,8.25,50,'R01'),
						(0,0,20,'R02'),(20,1,30,'R02'),(50,0,30,'R02'),(80,12,60,'R02'),
                        (0,10,90,'R03'), (95,4,5,'R03'),(1,0,15,'R04'),(16,2,12,'R04'),(29,0,50,'R04');
                        
-- 1. Introduir 2 trams a la base de dades
-- Les dades del primer tram seran les que es mostren a continuació, tenint en compte que la ruta 666, s’inicia al codi postal 08120 i finalitza al 17342.
-- MIRAR PDF...
INSERT INTO ruta VALUES ('666','08120','17342');
INSERT INTO tram VALUES (20.3,3.23,30,'666');

-- 2. El conductor amb dni 87654321A ha realitzat la ruta 666 que va entre els pobles amb codi postal 08102 (origen) i 17342 (destí) el 9 de març de l'any 2016 amb una durada de 500minuts amb el camió amb matrícula ‘1234HGT’.
INSERT INTO conductor VALUES ('87654321A','Alberto Garcia','TELF5');
INSERT INTO camio VALUES ('1234HGT',40,22.20,'87654321A','A');
INSERT INTO fa VALUES ('1234HGT','666','2016-03-09',500);

-- 3. Obtenir tots els trams (punts de quilometratge) de la ruta que s'inicia en el codi postal 04232 i finalitza en el codi postal 06584.
INSERT INTO ruta VALUES ('777','04232','06584');
INSERT INTO tram VALUES (20.3,3.23,30,'777'),(30.2,1.20,10,'777');

SELECT DISTINCT T.puntKilom FROM tram T
INNER JOIN ruta R ON R.codi = T.rutaCodi
WHERE R.cporigen = '04232' AND R.cpdesti = '06584';

-- 4. L'empresa ha decidit donar de baixa (no eliminar) tots els camions que tinguin un consum superior a 12,5 si el seu tonatge és superior a 1300 kg o un consum superior a 11,5 si el seu tonatge es inferior a 1300 kg.
INSERT INTO camio VALUES ('HUNK001',1500,22.20,NULL,'A'),('HUNK002',1200,10.5,NULL,'A');

UPDATE camio
SET estat = 'B'
WHERE (consum > 12.5 AND tonatge > 1300) OR (consum > 11.5 AND tonatge < 1300);

-- 5. Calcular la distancia total i el cost total de totes les rutes que s'inicien en el codi postal 08102 ordenat segons codi de ruta.
INSERT INTO ruta VALUES ('AP7','08102','08100'),('AP6','08102','08452');
INSERT INTO tram VALUES (10,1.20,30,'AP7'),(20,1.20,10,'AP7');
INSERT INTO tram VALUES (50,8.20,80,'AP6'),(60,2.20,8,'AP6'),(70,20.5,99.1,'AP6');

SELECT SUM(T.cost_peatge) AS CostTotal, SUM(T.distancia) AS DistanciaTotal, R.codi FROM tram T
INNER JOIN ruta R ON R.codi = T.rutaCodi
WHERE R.cporigen = '08102'
GROUP BY R.codi;

-- 6. Obtenir tota la informació de tots els conductors que el seu nom comenci per N o M amb camions de tonatge superior a 1000 kgs que no hagin realitzat cap ruta.
INSERT INTO conductor VALUES ('21654987A','Narcis López','TELF6');
INSERT INTO conductor VALUES ('21654981A','Mario López','TELF7');
INSERT INTO camio VALUES ('HUNK003',1500,22.20,'21654987A','A');
INSERT INTO camio VALUES ('HUNK004',1600,22.20,'21654981A','A');

SELECT Co.* FROM conductor Co
INNER JOIN camio Ca ON Co.dni = Ca.conductorDNI
LEFT JOIN fa ON Ca.matricula = Fa.camioMatricula
WHERE (Co.nom LIKE 'N%' OR Co.nom LIKE 'M%') AND Ca.tonatge > 1000 AND Fa.camioMatricula IS NULL
GROUP BY Co.dni;

-- CORREGIR -- NO DA EL MÍNIMO
-- 7. Obtenir totes les dades de tots els conductors i camions del camió que tingui un menor consum.
SELECT DISTINCT Co.*, Ca.* FROM conductor Co
INNER JOIN camio Ca ON Co.dni = Ca.conductorDNI
GROUP BY Co.dni AND Ca.matricula
HAVING MIN(Ca.consum);


SELECT * FROM camio
ORDER BY consum DESC;

-- 8. Obtenir tota la informació de totes les rutes que la seva distància sigui superior a la ruta identificada pel codi 666. Cal utilitzar una vista per a resoldre l'exercici.
CREATE VIEW Distancia666 AS
SELECT SUM(distancia) AS TotalKm FROM ruta R
INNER JOIN tram T ON R.codi = T.rutaCodi
WHERE R.codi = '666';

SELECT R.*, SUM(T.distancia) AS TotalKm FROM ruta R
INNER JOIN tram T ON R.codi = T.rutaCodi
GROUP BY R.codi
HAVING TotalKm > (SELECT * FROM Distancia666);

-- 9. Dóna tota la informació de la ruta que més vegades s'ha realitzat. Podeu utilitzar vistes.
CREATE VIEW QttRutas AS
SELECT COUNT(F.rutaCodi) FROM ruta R
INNER JOIN fa F ON R.codi = F.rutaCodi;

SELECT * FROM QttRutas;

SELECT R.* FROM ruta R
INNER JOIN fa F ON R.codi = F.rutaCodi
HAVING MAX(F.rutaCodi) = (SELECT COUNT(F.rutaCodi) FROM QttRutas);

SELECT COUNT(R.codi), R.codi FROM ruta R
INNER JOIN fa F ON R.codi = F.rutaCodi
GROUP BY R.codi
HAVING COUNT(R.codi);

-- -------------------------------------------------------------------------------------------

-- 10.Llista els trams que hi ha per ruta ordenats per punt quilomètric.


-- 11.Es vol saber el total de km que ha fet cada conductor per anys. Només es vol tenir en compte els camions que actualment no són Baixa.


-- 12.Eliminar tots els conductors que no tinguin cap camió associat.
DELETE Co.* FROM Conductor Co
	LEFT JOIN Camio Ca ON Co.DNI = Ca.conductorDNI
    WHERE Ca.matricula IS NULL;

-- 13.Es vol eliminar aquells trams que pertanyin a rutes que s’inicien per el codi postal '08430'.
DELETE T.* FROM tram T
	INNER JOIN ruta R ON R.codi = T.rutaCodi
    WHERE R.cporigen = '08430';

-- 14. Per error el conductor 'Marcel Parra' del camió amb matricula '1234GTS' va fer la ruta 666, 50 minuts més dels que es van fer.
UPDATE Conductor Co
INNER JOIN Camio Ca ON Co.DNI = Ca.conductorDNI
INNER JOIN Fa ON Ca.matricula = Fa.camioMatricula
SET Fa.temps = Fa.temps +50
WHERE Co.nom = 'Marcel Parra' AND Ca.matricula = '1234GTS' AND Fa.codiRuta = '666';

-- 15.Es volen eliminar tots aquells camions que estiguin de baixa o aquells que els seus conductors on el seu número de telèfon acabi en 56.

SELECT * FROM Conductor;
-- BEGIN;
-- 	INSERT INTO conductor VALUES ('21654987z','Narcis López','TELF6');
-- 	SAVEPOINT A;
-- 	INSERT INTO conductor VALUES ('21654987z','Narcis López','TELF6');
-- COMMIT;

-- 16. Volem saber el nom del conductor de camions que tenen un camions amb més consum que la mitja de camions.


-- 17.Escriu les instruccions necessàries per tal de que en cas que s'elimini o actualitzi la matricula d'un camió, quedin modificades la resta de dades per tal de que no hi hagin dades inconsistents.
-- 18.Es vol saber quina és la ruta que és mes cara a nivell de peatges.
SELECT T.rutaCodi, SUM(T.cost_peatge) FROM Tram T
	GROUP BY T.cost_peatge
	ORDER BY T.cost_peatge LIMIT 1;


-- 19.Volem eliminar aquells viatges que han s'han fet durant el 2010 i 2013 dels conductors amb DNI 12345678A d'aquells trams que iniciïn en el codi postal 08420.
-- 20.Ets responsable de la introducció de dades en SQL. Quines son les instruccions que faries servir en cas que passes tot això:
		-- a) Insertes un camió de 1300kg i consum 34.22 amb matricula 56788FGT d'en Gerard Martínez.
		-- b) Per error t'equivoques, resulta que la matrícula era incorrecte. Era 56789FGT.
		-- c) Et diuen al final que no.. que no cal introduir aquestes dades. (No utilitzar DELETE).
		-- d) Ara sí, et diuen que SEGUR has de posar camió de 1100kg i consum 24.22 amb matricula 1234FGT d'en Raúl Lorca.
		-- e) Has d'assegurar-te que aquesta instrucció no es podrà revocar.
	SET AUTOCOMMIT = 0;
--     INSERT INTO conductor... Gerard
--     INSERT INTO camio...
    UPDATE camio SET matricula = '56788FGT' WHERE matricula = '56788FGT';
    ROLLBACK;
--     INSERT conductor... Lorca
--     INSERT camio...
	COMMIT;

-- 21.Crea una vista per tal de tenir un resum global per rutes del total de costos de peatge, distancia i que val en € cada kilòmetre degut al cost dels peatges.
SELECT R.codi, SUM(T.cost_peatge), SUM(distancia), ROUND(SUM(cost_peatge)/SUM(distancia),2) AS CostKm
	FROM Tram
	GROUP BY rutaCodi;

-- S’haurà de mostrar la informació de la següent forma:
-- MIRAR PDF...
-- 22.En Marcel Parra ahir va tenir un accident mortal. En honor a ell, s’ha decidit tancar (eliminar) tots els trams que ahir va fer.
-- 23.Volem eliminar aquells viatges que han s'han fet durant el mes de maig del 2016 i durant el dia 18-06-2013 dels conductors que el 
-- nom comença amb A i d'aquells trams que el seu codi postal d'inici sigui 08420.


-- 24.Volem eliminar tots aquells camions que el seu tonatge sigui major de 1000 i que estiguin donats de baixa.
-- 25.Es vol eliminar els trams on el seu cost de peatge sigui més elevat.