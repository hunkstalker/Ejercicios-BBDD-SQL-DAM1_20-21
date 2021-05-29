/*Crea les taules amb els noms. Utilitzeu exemples anteriors per a crear les taules. El nom de les columnes ha de ser el mateix que el dels atributs.*/
CREATE DATABASE UnitatFormativa;
USE UnitatFormativa;

create table Alumne(
	DNI char(9),
    nom varchar(20),
    cognom varchar(30),
    ciutat varchar(30),
    primary key(dni)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS UF (
	codi char(4),
    nom varchar(40),
    hores int,
    mes varchar(20),
    preu decimal(6,2),
    primary key(codi)
) ENGINE = INNODB;

CREATE TABLE If NOT EXISTS Tutor(
	DNI CHAR(9) PRIMARY KEY,
    nom VARCHAR(20) NOT NULL,
    cognom VARCHAR(30) NOT NULL,
    curs VARCHAR(30) UNIQUE
) ENGINE = INNODB;

-- Representar la relación Cursa.
CREATE TABLE Cursa(
	alumneDNI CHAR(9),
    ufCodi CHAR(4),
    nota DECIMAL(4,2),
    PRIMARY KEY (alumneDNI,ufCodi),
    CONSTRAINT fk_cursa_alumne FOREIGN KEY (alumneDNI) 
	REFERENCES Alumne(DNI) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_cursa_uf FOREIGN KEY (ufCodi) 
	REFERENCES UF(codi) ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE = INNODB;

-- Afegin la foreign key a la taula Alumne
ALTER TABLE Alumne ADD tutorDNI CHAR(9); 
-- Fer la relació N:1 entre alumne i tutor
ALTER TABLE Alumne ADD CONSTRAINT fk_alumne_tutor FOREIGN KEY (tutorDNI) 
	REFERENCES Tutor(DNI) ON UPDATE CASCADE ON DELETE RESTRICT;

-- **************** INSERIM DADES ***************--
insert into tutor values ('TDNI1','Claudina','Riaza','DAM1'), ('TDNI2','Jaume','Fadó','DAM2');

insert into alumne values ('DNI1','Maria','Garcia Castro','Granollers','TDNI1'),
						('DNI2','Marc','Martínez Puntiga','Montornes','TDNI1'),
                        ('DNI3','Alex','Sánches Ordoñez','Granollers','TDNI1'),
                        ('DNI4','Enric','Martín González','Mollet','TDNI2');
                        
insert into UF values ('M2U1','Introducció a les BBDD',44,'Gener',45),
						('M2U2','Llenguatge SQL: DML, DDL',77,'Setembre',145),
                        ('M2U3','Llenguatge BBDD procidemental',77,'Gener',200),
                        ('M3U1','Introducció a la programació',90,'Gener',225);
                        
insert into cursa values ('DNI1','M2U1',6), ('DNI1','M2U2',7),('DNI1','M2U3',2),
						('DNI2','M2U1',5), ('DNI2','M2U2',6),('DNI2','M2U3',3),
                        ('DNI3','M2U1',3), ('DNI3','M2U2',NULL),('DNI3','M2U3',8),
                        ('DNI4','M2U1',2), ('DNI4','M2U2',9),('DNI4','M2U3',NULL);

-- 1. Determina el nom i cognom dels alumnes que no siguin de Granollers o Cardedeu.
SELECT nom, cognom, ciutat FROM Alumne WHERE ciutat NOT IN ('Granollers',"Cardedeu");

-- 2. Determina el codi, nom i hores de les unitats formatives amb un import superior a 100€
SELECT codi, nom, hores FROM UF WHERE preu > 100;

-- 3. Determina totes les dades de la taula alumne excepte els que tenen de cognom Garcia.
SELECT * FROM Alumne WHERE cognom != 'Garcia' ORDER BY nom;

-- 4. Determina el total d’hores que tenen les unitats formatives per mes. Ordena la informació de forma ascendent.
SELECT mes, sum(hores) AS TotalHores FROM UF GROUP BY mes;

-- 5. Quants alumnes hi han per cada ciutat. No es vol tenir en compte els alumnes amb nom: 'Marc' ni 'Andreu'
SELECT ciutat, count(*) AS Total FROM Alumne WHERE nom NOT IN ('Marc','Andreu') GROUP BY ciutat;

-- 6. Determina el total de preu de totes les unitats formatives que es faran el mes de octubre, novembre, gener, abril o maig.
SELECT sum(preu) AS PreuTotal FROM UF WHERE mes IN ('Octubre','Novembre','Gener','Abril','Maig'); 

-- 7. Mostra el nom i cognom representat en Cognom, Nom en una única columna, i el dia de la setmana que van neixer els alumnes de la ciutat de Granollers, Sabadell o Terrassa de l'any 2000, 2001.
SELECT CONCAT(cognom,', ',nom) AS "Nom Complet", dayName(dataNaix) AS "Data Naixament" FROM Alumne
	WHERE ciutat IN ('Granollers','Sabadell','Terrassa') AND YEAR(DataNaix) BETWEEN 2000 AND 2001;

-- 8. Determina el total d'unitats formatives que tinguin més de 20 hores i que comencin per la lletra «i» o per la lletra «p».
SELECT nom FROM UF WHERE hores > 20 AND nom LIKE "i%" OR "p%";

-- 9. Determina el màxim, mínim y promig del preu de les unitats formatives que tinguin 10 i 60 hores. Associa noms descriptius a cada una de les columnes.
SELECT (ROUND(MAX(preu))) AS Màx, ROUND(min(preu)) AS Min, ROUND(avg(preu)) AS Mitja FROM UF; --  WHERE hores = 10 AND hores = 60; -- No hay datos que cumplan con esa condición así que te los aparto para que veas que funciona.

-- 10.Digues totes les ciutats de tots els estudiants ordenades alfabèticament. Mostra en majúscula les ciutats.
SELECT DISTINCT upper(ciutat) FROM Alumne ORDER BY ciutat ASC; -- ASC ja hi sería per defecte pero t'ho poso igualment.

-- 11.Determina el nom i hores de les unitats formatives que comencin el mes de setembre, octubre, gener, abril o maig de les ufs que tenen entre 50 i 100h.
SELECT nom, hores FROM UF WHERE mes IN ('Setembre','Octubre','Gener','Abril','Maig') AND hores BETWEEN 50 AND 100;

-- 12.Determina el preu màxim per cada unitat formativa que té menys de 30 hores i més de 20 hores o que el seu preu sigui inferior a 150€.
SELECT nom AS UnitatF, FORMAT(max(preu),'c') AS PreuMaxim FROM UF WHERE (hores BETWEEN 50 AND 100) AND (preu<205) GROUP BY UnitatF;

-- 13.Determina les unitats formatives que valen entre 200€ y 500€ ordenada per preu i nom. L'ordre ha de ser de més preu a menys preu i ordenat alfabèticament en cas de coincidència de preu.
SELECT nom FROM UF WHERE preu BETWEEN 200 AND 500 ORDER BY preu DESC, nom ASC;

-- 14. A partir d’ara l’alumne té un codi de 9 caràcters
ALTER TABLE Alumne ADD codi VARCHAR(9);

/* 15.Tenint en compte que acabes de crear el camp codi i per tant no tens informació. Mostra com es veuria el codi seguint el següent algoritme de codificació:
CODI = primera lletra del nom + primera lletra del cognom + guió + any de naixement + dia de naixement
Llavors, es vol veure el nom i cognom de l'alumne amb el nou codi.*/
SELECT nom, cognom, CONCAT(LEFT(nom,1), LEFT(cognom,1),'-',YEAR(dataNaix), dayname(dataNaix)) AS codi FROM Alumne;

-- 16.Determina el nom de totes les unitats formatives excepte les que tinguin per codi «1013», «2119», «2176», «2735», «6543» o el seu codi contingui 30 (en qualsevol lloc).*/
SELECT nom FROM UF WHERE codi NOT IN ('1013','2119','2176','2735','6543') OR codi LIKE '%30%';

-- 17.Determina el preu de la unitat formativa més cara i més econòmica que tingui 30 hores. Identificar les columnes com a «econòmica» i «més cara».*/
SELECT max(preu) AS "Mes cara", min(preu) AS "Economica" FROM UF WHERE hores>30; 

-- 18.Determina el nom de les unitats formatives que no tinguin 20 hores, que comencin el mes de maig o abril i que el seu nom contingui «intro».*/
SELECT nom FROM UF WHERE hores !=20 AND mes IN ('Maig','Abril') AND nom LIKE '%intro%';

-- 19.Determinar el nom de les unitats formatives on el preu hora sigui major de 5€ i comencin al gener o març. Ordenar per aquest import de forma descendent.*/
SELECT nom FROM UF WHERE (preu/hores>5) AND mes IN ('Gener','Març') ORDER BY preu/hores DESC;

-- 20.ES vol tenir un històric de qualificacions entre unitats formatives i notes de cadascun dels alumnes. Realitza les instruccions necessàries per tal de poder donar solució a això. Cal saber la data de la nota.

-- 21.Realitzar una consulta que em retorni el text «la unitat formativa codi - nom té hores hores que equival a X crèdits» . Per a fer el càlcul s'ha de considerar que un crèdit són 10 hores.

-- 22.Just fa 7 dies (tenint en compte now(), vas treure un 7,80 en la UF, M2UF1 del teu cicle. No cal determinar el cost.*/

-- 23.Determinar el nom i cognom dels alumnes on el seu cognom comenci per ‘G’ o el nom tingui una longitud de 5 lletres.*/

-- 24.Digues el nom de les unitats formatives que tenen menys hores.*/
SELECT nom, hores FROM UF ORDER BY hores limit 1;

/* 24b. */
SELECT max(hores) FROM UF;

SELECT nom FROM UF WHERE hores=(SELECT MAX(hores) FROM UF);

-- 25.Fer un llistat que mostri les unitats formatives amb el seu preu ordenats per número de crèdits (1 crèdit = 10 hores).*/

-- 26.Mostra les 5 millors notes de l'alumne amb DNI: 'DNI3'. Cal veure de quin codi de mòdul pertany. No es vol tenir en compte aquelles qualificacions que son anteriors al 2018 inclòs.*/

-- 27.Fer un llistat del nom complet de tots els alumnes de Granollers. Has de mostrar el nom i cognom junt amb el DNI. Ex: ‘DNI:11111111 – Nom: David Porti’*/

-- 28.Fer un llistat de totes alumnes que viuen fora la ciutat de Granollers que el seu nom o cognom comencin per A o B y hagin nascut y que aquest any siguin majors d'edad.

-- 29.Fer un llistat de totes alumnes que no viuen ni a Granollers ni a Cardedeu amb DNI acabat amb k o z.*/
SELECT * FROM Alumne WHERE ciutat NOT IN ('Granollers','Cerdanyola') AND (dni like '%k'OR dni like '%z');

-- 30.Mostra quin és la longitud més gran del nom (num caracters) dels alumnes per cada una de les ciutats.*/
-- SELECT ciutat, max()lentgh

-- 08.Excercicis.SubSelect.MultiTaulas
-- Afegin la foreign key a la taula Alumne
ALTER TABLE Alumne ADD tutorDNI CHAR(9);

-- Fer la relació N:1 entre alumne i tutor
ALTER TABLE Alumne ADD CONSTRAINT fk_alumne_tutor FOREIGN KEY (tutorDNI) 
	REFERENCES Tutor(DNI) ON UPDATE CASCADE ON DELETE RESTRICT;