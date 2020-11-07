/*************************************************************************
MedgeCapcalera:{codi(pk),nomComplet(UQ),especialitatNom,estudisMinims}
Pacient:{numSS(pk),nom,cognom,adreça(UQ),dataNaix,metxeCapcaleraCodi(fk)}
Fabricant:{nif(pk),nom}
Medicina:{nom(pk),fabricanteNIF(fk)}
Recepta:{data(pk), qtt, metgecapcaleraCodi(pk,fk),pacienmtNumSS(pk,fk),
	medicinaNom(pk.fk)}
Farmacia:{nom(pk),poblacio}
Contracte:{dataInici(pk), dataFi,fabricantNIF(pk.fk),farmaciaNom(pk,fk)}
Ven:{preu,medicinaNom(pk,fk),farmaciaNm(pk,fk)}
Treballador:{DNI(pk), nom,cognom,farmaciaNom()<pk,fk}

**************************************************************************/

CREATE TABLE IF NOT EXISTS MedgeCapcalera (
	codi CHAR(9) PRIMARY KEY,
    nomComplet VARCHAR(45) UNIQUE,
    especialitatNom VARCHAR(45),
    estudisMinims VARCHAR(45)
) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Pacient (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Fabricant (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Medicina (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Recepta (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Farmacia (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Contracte (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Ven (

) ENGINE=INNODB;

CREATE TABLE IF NOT EXISTS Treballador (

) ENGINE=INNODB;

/*
1  Granollers es possible que hi hagin 3 farmàcies.
2. En Marc té un metge de capçalera
3. L’administrador de la base de dades, pot saber en quins llocs ha treballat el treballador Joan Garcia amb DNI: ‘52112233B’.
4. Es pot saber quins preus es ven un tipus de medicina en una farmàcia en concret.
5. Tens parella (cert) i sou molt molt feliços, tant, que viviu junts.
6. Donat un pacient, puc saber totes les receptes que ha tingut al llarg de l’històric de la base de dades.
7. Un fabricant pot tenir varis contractes amb la mateixa farmàcia.
8. El Dr. Teputican és Reumatòleg i Cardiòleg.
*/

/*
Cal registrar que el Dr Marcelino García amb codi MG001 especialista en Cardiologia, ha receptat a l'Eduard Riera amb NSS RIRAEDU0002, 3 cajas de DIACEPAN de la marca HACENDADO (B00021)
*/

INSERT INTO Fabricant VALUES ('B00021','HACENDADO');
INSERT INTO Medicina VALUES ('Diacepan','B00021');
INSERT INTO Pacient VALUES ('RIRAEDU0002','Eduard','Riera',NULL,NULL,'MG001');
INSERT INTO MedgeCapcalera VALUES ('Marcelino García','Cardiologia',NULL);
INSERT INTO Recepta VALUES (now(),3,'MG001','RIRAEDU0002','Diacepan');

DROP TABLE Recepta;
DROP TABLE MedgeCapcalera;
DROP TABLE Pacient;
DROP TABLE Medicina;
DROP TABLE Fabricant;

ALTER TABLE Pacient ADD email VARCHAR(45) UNIQUE;

/*
1. El nostre hospital s’està modernitzant i pensa en el nostre medi ambient. A partir d’ara, ja no enviarà per correu ordinari les dates de visita, ho farà per correu electrònic.
ALTER TABLE Pacient ADD COLUMN email VARCHAR(45) UNIQUE;

2. El nostre Hospital ha incorporat un metge de capçalera que tot ho cura! El metge tindrà com a codi ‘CAP111’ i es diu ‘Victorio Manuel Garcia de Los Santos Cristos’, especialista en Psiquiatria.
ALTER TABLE metgecapcalera MODIFY COLUMN nomComplet VARCHAR(50);
INSERT INTO MetgeCapcalera VALUES ('MC001',''...);
INSERT INTO MetgeCapcalera (codi, nomComplet, especialitat) VALUES ('',''...);

3. La teva parella no té carnet de conduir. Voleu estar registrats en el mateix hospital. Soluciona-ho que sinó, et tocarà portar-lo/a en cotxe cada vegada.
ALTER TABLE Pacident DROP Index adreca; -- Quita el índice de UNIQUE

4. El nou govern, ha implantat una nova llei. La llei ha de determinar el grau de somnolència del medicament. Per defecte sempre és 1. El grau està entre 1 i 10.
NOTA: No cal determinar el rang [1..10]. Això es faria amb un procediment.
ALTER TABLE Medicina ADD somnolencia TINYINT DEFAULT 1 ;

5. El nou govern està implantant una nova mesura. Només permet tenir una farmàcia per població.
ALTER TABLE Farmacia MODIFY COLUMN poblacio VARCHAR(20) UNIQUE;

6. Cal automatitzar el procés de que quan un metge recepti alguna cosa, posi la data actual i una unitat (qtt).
ALTER TABLE Recepta MODIFY COLUMN data datatime default now();
ALTER TABLE Recepta MODIFY COLUMN qtt SMALLINT DEFAULT 1;

7. Per termes jurídics del nostre gestor, no podem utilitzar el nom “fabricant”, cal que es digui “Proveidor”. Canvia en TOTS els llocs on aparegui fabricant, per proveïdor.
ALTER TABLE Fabricant RENAME proveidor;
ALTER TABLE Medicina CHANGE COLUMN fabricantNIF proveidorNIF CHAR(9);
ALTER TABLE Contracta CHANGE COLUMN fabricantNIF proveidorNIF CHAR(9);

8. Modifica la teva base de dades per tal de que es pugui saber quins efectes secundaris té cada medicament. Un efecte secundari està determinat per un grau de gravetat entre 1 i 10. No cal validar.
Per exemple: vòmits té un grau de 2, somnolència té un grau de 6, infart cardíac té un grau de 10.
CREATE TABLE EfecteSecundari (
	nom VARCHAR(20) PRIMARY KEY
) ENGINE=INNODB;

CREATE TABLE Produeix (
	medicinaNom VARCHAR(20) PRIMARY KEY
    ESecundariTipus VARCHAR(20),
    PRIMARY KEY (medicinaNom,ESecundariTipus)
    CONSTRAINT Produeix_medicina
    CONSTRAINT Produeix_efectessecundaris
) ENGINE=INNODB;

9. Amb les teves dades reals, introdueix a la base de dades que avui has anat al teu metge de capçalera perquè tenies MOOLT mal de cap. Les dades que et faltin, posa les reals o si no la saps, com el proveïdor de la medicina, la busques per internet.
INSERT INTO MetgeCapcalera VALUES (now(),1,'MC002');
INSERT INTO Pacient VALUES (now(),1,'MC002');
INSERT INTO Proveidor VALUES (now(),1,'MC002');
INSERT INTO Medicina VALUES (now(),1,'MC002');
INSERT INTO Recepta VALUES (now(),1,'MC002');

10.El fabricant “FarmaCon” amb NIF: ‘B12345678” ha contractat avui amb la farmàcia “LoCuroTodo” de Montornés. El contracte és de 1 any.
INSERT INTO Proveidor VALUES ('B12345678','Farmacon');
INSERT INTO Farmacia VALUES ('LoCuroTodo','Montornes');
INSERT INTO Contracta VALUES (now(), DATE_ADD (now(), interval 1 YEAR),'B12345678','LoCuroTodo');

11. La dataFi de contracte, mai pot ser NULL.
ALTER TABLE Contracta MODIFY COLUMN dataFi date NOT NULL;

12.Ens demanen que el nom del camp “preu” ha de passar a dir-se PVP
ALTER TABLE Ven CHANGE COLUMN Preu PVP DECIMAL(6,2);

13.Cal registrar que s’ha venut de la farmàcia que hi ha davant de l’escola, s’ha venut un Gelocatil per 9,95€. La resta d’informació que et falta, troba-la on creguis oportú.
INSERT INTO Farmacia
INSERT INTO Proveidor
INSERT INTO Medicina
INSERT INTO Ven VALUES ('Arimany','Gelocatil'9.95);
*/

