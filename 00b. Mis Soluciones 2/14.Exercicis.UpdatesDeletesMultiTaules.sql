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
	cost_peatge DECIMAL(4,2),
   distancia DECIMAL(3,1),
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
	-- Les dades del primer tram seran les que es mostren a continuació, tenint en compte que la ruta 666, 
	-- s’inicia al codi postal 08120 i finalitza al 17342.
INSERT INTO ruta VALUES ('666','08120','17342');
INSERT INTO tram VALUES (0,5,30,'666'),(30,10,50,'666');

SELECT * FROM tram;
-- 2. El conductor amb dni 87654321A ha realitzat la ruta 666 que va entre els pobles amb codi postal 
	-- 08102 (origen) i 17342 (destí) el 9 de març de l'any 2016 amb una durada de 500minuts amb el camió 
	-- amb matrícula ‘1234HGT’.
INSERT INTO conductor VALUES ('87654321A','Denis Anfruns','TLF5');
INSERT INTO camio VALUES ('1234HGT',40,22.20,'87654321A','A');

SELECT * FROM camio;

-- 3. Obtenir tots els trams (punts de quilometratge) de la ruta que s'inicia en el codi postal 04232 i finalitza en el codi postal 06584.


-- 4. L'empresa ha decidit donar de baixa (no eliminar) tots els camions que tinguin un consum superior a 12,5 si el seu tonatge és superior a 1300 kg o un consum superior a 11,5 si el seu tonatge es inferior a 1300 kg.


-- 5. Calcular la distancia total i el cost total de totes les rutes que s'inicien en el codi postal 08102 ordenat segons codi de ruta.
-- 6. Obtenir tota la informació de tots els conductors que el seu nom comenci per N o M amb camions de tonatge superior a 1000 kgs que no hagin realitzat cap ruta.
-- 7. Obtenir totes les dades de tots els conductors i camions del camió que tingui un menor consum
-- 8. Obtenir tota la informació de totes les rutes que la seva distància sigui superior a la ruta identificada pel codi 666. Cal utilitzar una vista per a resoldre l'exercici.
-- 9. Dóna tota la informació de la ruta que més vegades s'ha realitzat. Podeu utilitzar vistes.
-- 10.Llista els trams que hi ha per ruta ordenats per punt quilomètric.
-- 11.Es vol saber el total de km que ha fet cada conductor per anys. Només es vol tenir en compte els camions que actualment no són Baixa.
-- 12.Eliminar tots els conductors que no tinguin cap camió associat.
-- 13.Es vol eliminar aquells trams que pertanyin a rutes que s’inicien per el codi postal '08430'.
-- 14. Per error el conductor 'Marcel Parra' del camió amb matricula '1234GTS' va fer la ruta 666, 50 minuts més dels que es van fer.
-- 15.Es volen eliminar tots aquells camions que estiguin de baixa o aquells que els seus conductors on el seu número de telèfon acabi en 56.
-- 16. Volem saber el nom del conductor de camions que tenen un camions amb més consum que la mitja de camions.
-- 17.Escriu les instruccions necessàries per tal de que en cas que s'elimini o actualitzi la matricula d'un camió, quedin modificades la resta de dades per tal de que no hi hagin dades inconsistents.
-- 18.Es vol saber quina és la ruta que és mes cara a nivell de peatges.
-- 19.Volem eliminar aquells viatges que han s'han fet durant el 2010 i 2013 dels conductors amb DNI 12345678A d'aquells trams que iniciïn en el codi postal 08420.
-- 20.Ets responsable de la introducció de dades en SQL. Quines son les instruccions que faries servir en cas que passes tot això:
	-- a) Insertes un camió de 1300kg i consum 34.22 amb matricula 56788FGT d'en Gerard Martínez.
	-- b) Per error t'equivoques, resulta que la matrícula era incorrecte. Era 56789FGT.
	-- c) Et diuen al final que no.. que no cal introduir aquestes dades. (No utilitzar DELETE).
	-- d) Ara sí, et diuen que SEGUR has de posar camió de 1100kg i consum 24.22 amb matricula 1234FGT d'en Raúl Lorca.
	-- e) Has d'assegurar-te que aquesta instrucció no es podrà revocar.
-- 21.Crea una vista per tal de tenir un resum global per rutes del total de costos de peatge, distancia i que val en € cada kilòmetre degut al cost dels peatges.
-- S’haurà de mostrar la informació de la següent forma:
-- Ex: Ruta Peatge Distancia Cost/Km
	-- 123 34€ 100km 0,34€/km
-- 22.En Marcel Parra ahir va tenir un accident mortal. En honor a ell, s’ha decidit tancar (eliminar) tots els trams que ahir va fer.
-- 23.Volem eliminar aquells viatges que han s'han fet durant el mes de maig del 2016 i durant el dia 18-06-2013 dels conductors que el nom comença amb A i d'aquells trams que el seu codi postal d'inici sigui 08420.
-- 24.Volem eliminar tots aquells camions que el seu tonatge sigui major de 1000 i que estiguin donats de baixa.
-- 25.Es vol eliminar els trams on el seu cost de peatge sigui més elevat.
