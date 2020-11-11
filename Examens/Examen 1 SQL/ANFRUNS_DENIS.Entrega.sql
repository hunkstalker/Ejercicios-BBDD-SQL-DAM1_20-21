CREATE DATABASE M2UF2ExamenParcialPart2;
use M2UF2ExamenParcialPart2;


CREATE TABLE if not exists Dotacio(
	alias varchar(20) primary key,
    dataCr date not null,
    qtt tinyint default 1
) engine=InnoDB;

CREATE TABLE if not exists Bomber (
	DNI char(9) primary key,
    nom varchar(20),
    especialitat varchar(20),
    jefebomberDNI char(9),
    dotacioAlias varchar(20),
    
    CONSTRAINT fk_Bomber_Bomber FOREIGN KEY(jefeBomberDNI) REFERENCES Bomber(DNI)
		ON UPDATE cascade
        ON DELETE restrict,
	CONSTRAINT fk_Bomber_Dotacio FOREIGN KEY(dotacioAlias) REFERENCES Dotacio(alias)
		ON UPDATE cascade
        ON DELETE set null	
) engine = InnoDB;


CREATE TABLE if not exists Vehicle(
	matricula char(7) primary key,
    categoria varchar(20),
    tipus char(1) not null, -- T:Terra, A:Aeri M:Marítim
    capacitat int -- en litres aigua

) engine=InnoDB;

CREATE TABLE if not exists Utilitza(
	dotacioAlias varchar(20),
    vehicleMatricula char(7),
    dataU date,
    primary key (dotacioAlias,vehicleMatricula,dataU),
    CONSTRAINT fk_utilitza_dotacio FOREIGN KEY(dotacioAlias) REFERENCES Dotacio(alias)
		ON UPDATE restrict
        ON DELETE restrict,
	CONSTRAINT fk_utilitza_vehicle FOREIGN KEY(vehicleMatricula) REFERENCES Vehicle(matricula)
		ON UPDATE cascade
        ON DELETE restrict
)engine = InnoDB;


CREATE TABLE if not exists Poblacio (
	codiPostal char(5) primary key,
    ciutat varchar(20),
    provincia varchar(20),
    hectareas int

) engine = InnoDB;

CREATE TABLE if not exists Incendi(
	codi varchar(5) primary key,
    dataInici date,
    dataFi date,
    terreny char(1), -- B:Bosc, C:ciutat, ..
    hectareasCremades int, -- null si encara no esta extingit
    poblacioCP char(5),
    CONSTRAINT fk_incendi_poblacio FOREIGN KEY(poblacioCP) REFERENCES Poblacio(codiPostal)
		ON UPDATE cascade
        ON DELETE restrict
        
)engine = InnoDB;

CREATE TABLE if not exists Piroman(
	alias varchar(20) primary key,
    reincident bool default 0    
)engine = InnoDB;

CREATE TABLE Provoca(
	piromanAlias varchar(20),
    incendiCodi char(5),
    primary key (piromanAlias,incendiCodi),
    CONSTRAINT fk_provoca_incendi FOREIGN KEY(incendiCodi) REFERENCES Incendi(codi)
		ON UPDATE restrict
        ON DELETE restrict,
	CONSTRAINT fk_piroman FOREIGN KEY(piromanAlias) REFERENCES Piroman(alias)
		ON UPDATE cascade
        ON DELETE restrict
) engine = InnoDB;

CREATE TABLE if not exists Actua(
	dotacioAlias varchar(20),
    incendiCodi char(5),
    accioInicial date,    
    primary key(dotacioAlias,incendiCodi,accioInicial),
    
    CONSTRAINT fk_actua_dotacio FOREIGN KEY(dotacioAlias) REFERENCES Dotacio(alias)
		ON UPDATE cascade
        ON DELETE restrict,
    CONSTRAINT fk_actua_incendi FOREIGN KEY(incendiCodi) REFERENCES Incendi(codi)
		ON UPDATE cascade
        ON DELETE restrict
    
)engine = InnoDB;


insert into Vehicle values ('1111AAA','Camió','T',230), ('1111BBB','Camió','T',300),
							('AIR111','Avió','A',500),('HELI111','Helicopter','A',300),
                            ('1111CCC','Camió','T',300),('1111JKP','Llança','M',300);
                            
insert into Piroman values ('BurnerMan',true),('FireTrush',false),('SpiderHot',true);

insert into Dotacio values ('ApagaTot','2010-10-20',30),('AiguaFresca','2015-10-20',20), ('Suc al foc','2007-10-20',50);
insert into Bomber values ('DNI1','Marc Sanchez','Muntanya',NULL,'ApagaTot'),('DNI2','Joan Domenech','Muntanya','DNI1','AiguaFresca'),
					('DNI3','Aitor Caspe','Edificis',NULL,'AiguaFresca'),('DNI4','Brian Dominguez','Edificis','DNI3','AiguaFresca'),
                    ('DNI5','Adrià Colom','Muntanya','DNI3','ApagaTot'),('DNI6','Nil Panadero','Edificis','DNI3','ApagaTot');

		
insert into Poblacio values ('08401','Granollers','Barcelona',500),('08402','Granollers','Barcelona',700),
				('08202','Sabadell','Barcelona',1500),('08209','Terrassa','Barcelona',2500);
insert into Incendi values ('FOC01','2018-08-15','2018-08-25','M',230,'08402'),
								('FOC02','2018-09-25',null,'M',1230,'08202'),
								('FOC03','2018-10-15',null,'E',230,'08209'),
								('FOC04','2018-09-05','2018-09-15','M',230,'08402');

insert into Actua values ('ApagaTot','FOC01','2018-08-15'),('ApagaTot','FOC01','2018-08-16'),
						('AiguaFresca','FOC02','2018-09-25'),('ApagaTot','FOC02','2018-09-25'),
                        ('AiguaFresca','FOC03','2018-10-17'),('AiguaFresca','FOC04','2018-09-10');




-- 1. Mostra el nom de les ciutats excepte les de la provincia de Barcelona o Girona que NO han sofert cap tipus d'incendi.
SELECT P.ciutat FROM Poblacio P
	LEFT JOIN Incendi I ON P.codiPostal = I.poblacioCP
    WHERE I.poblacioCP IS NULL
    GROUP BY P.provincia = 'Barcelona' OR 'Girona';

-- 2.Ha arribat el dia del judici, i ens demanen que calculis les hectàres que ha cremat en total el piròman BurnerMan
INSERT INTO Provoca VALUES ('BurnerMan','FOC01');

SELECT SUM(I.hectareasCremades) AS HA, P.piromanAlias AS NomPiroman FROM Provoca P
	INNER JOIN Incendi I ON I.codi = P.incendiCodi
    WHERE P.piromanAlias = 'BurnerMan';
	
-- 3.S'ha incorporat en Jaume Ponseca amb DNI: 'DNI10', el millor bomber en Muntanya. Degut a que és nou en la Dotació de 'AiguaFresca', té com a jefe en Joan Domenech.
-- Es tant bo, que ha va fer que la seva dotació, actués el 18 d'octubre del 2020 en ajudar en intentar apagar el FOC03, amb el camió 1111BBB.
-- Realitza les instruccions necessaries per tenir registrada tota aquesta informació.
INSERT INTO Bomber VALUES ('DNI10','Jaume Ponseca','Muntanya','DNI2','AiguaFresca');
INSERT INTO Utilitza VALUES ('AiguaFresca','1111BBB','2018-10-18');
INSERT INTO actua VALUES ('AiguaFresca','FOC03','2018-10-18');

-- 4.Mostra per codi Postal , el total d'hectareas cremades dels incendis que estan ja Extingits ON ha intervingut la dotació creades a partir del 2000
-- Cal veure també la ciutat del codi postal.
INSERT INTO Dotacio VALUES ('LosMachos','2019-05-01','20');
INSERT INTO Incendi VALUES ('FOC05','2020-05-05','2020-05-06','M','2000','08100'); 
INSERT INTO Poblacio VALUES ('08100','Mollet','Barcelona','700');
INSERT INTO Actua VALUES ('LosMachos','FOC05','2020-05-05');

SELECT P.codiPostal AS CP, P.ciutat AS NomCiutat, SUM(hectareasCremades) AS TotalHA, D.alias AS NomDotacio FROM Poblacio P
	INNER JOIN Incendi I ON I.poblacioCP = P.codiPostal
	INNER JOIN Actua A ON I.codi = A.incendiCodi
    INNER JOIN Dotacio D ON D.alias = A.dotacioAlias
	WHERE I.dataFi IS NOT NULL AND YEAR(D.dataCr)<2000
    GROUP BY P.ciutat;


-- 5.Es vol saber el total de bombers que no son d'especialitat de Ciutat ni Muntanya, que el seu nom comença per A i contenen una C, i finalment que no ténen cap jefe.
SELECT COUNT(*) AS TotalBombers FROM Bomber
	WHERE especialitat NOT IN ('Ciutat','Muntanya') AND nom LIKE 'a%c%' AND jefebomberDNI IS NULL;

-- 6.Es vol saber la població del qual pertany cada Piròman, realitza les instruccions necessaries per tal de poder donar solució això.
-- Cal utilitzar la taula població.
ALTER TABLE Piroman ADD poblacioCP CHAR(45);
ALTER TABLE piroman ADD CONSTRAINT fk_piroman_poblacio FOREIGN KEY (poblacioCP) REFERENCES Poblacio(codiPostal);
-- UPDATE piroman COLUMN poblacioCP SET ni idea 
SELECT poblacioCP, alias FROM Piroman;

-- 7.Es vol saber quins incendis encara no han rebut l'intervenció de cap Dotació de Bombers iniciats ahir.
-- No cal tenir present les hores. Simplement ahir.
SELECT I.codi FROM Incendi I 
	LEFT JOIN Actua A ON I.codi = A.incendiCodi
	WHERE DAY(I.dataInici)=DAY(now())-1 AND A.dotacioAlias IS NULL;
    
SELECT * FROM Actua;

-- 8.Fes un llistat de les actuacions (data) de cada bomber (nom del bomber, dotacio que pertany)
-- en els incendis (codi)durant els darrers 5 anys. Cal ordenar el llistat per nom del bomber en ordre descendent.
SELECT  A.accioInicial, B.nom, D.Alias, I.codi FROM Bomber B 
		INNER JOIN Dotacio D ON d.alias=b.dotacioalias
		INNER JOIN Actua A ON a.dotacioalias=d.alias
        INNER JOIN Incendi I ON i.codi=a.incendicodi
        WHERE YEAR(I.dataInici)>=YEAR(now())-5
        ORDER BY B.nom DESC;

-- 9.Digues les ciutats ON la suma d'hectarees cremades és superior a 1000.
SELECT p.ciutat, SUM(hectareasCremades) AS HATotal  FROM Poblacio P
	INNER JOIN Incendi I on I.poblacioCP = P.codiPostal
	GROUP BY P.Ciutat
    HAVING SUM(hectareasCremades)>1000;

-- 10.	Mostra totes les dades dels vehicles que s’han utilitzat igual o més que el vehicle amb matricula AIR111.
SELECT * FROM Vehicle V
	INNER JOIN Utilitza U ON V.matricula = U.vehicleMatricula
	GROUP BY V.matricula
	HAVING count(*)>(SELECT count(*) FROM utilitza WHERE vehiclematricula='AIR111');
