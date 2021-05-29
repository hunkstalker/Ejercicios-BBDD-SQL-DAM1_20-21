CREATE DATABASE IF NOT EXISTS Exercici13;
USE Exercici13;

CREATE TABLE IF NOT EXISTS genere (
	codi CHAR(5) PRIMARY KEY,
    nom VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS soci (
	Codi CHAR(5) PRIMARY KEY,
    DNI CHAR(9) UNIQUE,
    nom VARCHAR(45)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS llibre (
	ISBN CHAR(13) PRIMARY KEY,
    titol VARCHAR(45),
	totalExemplars INT,
	genereCodi CHAR(5),  -- FK
    CONSTRAINT fk_llibre_genere FOREIGN KEY (genereCodi) REFERENCES Genere(codi)
		ON UPDATE CASCADE ON DELETE SET NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS perestecs (
	llibreISBN	CHAR(13), -- FK PK
    sociCodi CHAR(5), -- FK PK
    NumProrogues INT,
    dataPrestec DATE, -- PK
    dataRetorn DATE,
    dataRetornTeo DATE,
    PRIMARY KEY (llibreISBN,sociCodi),
    CONSTRAINT fk_prestecs_llibres FOREIGN KEY (llibreISBN) REFERENCES Llibre(ISBN)
		ON UPDATE RESTRICT ON DELETE CASCADE,
	CONSTRAINT fk_prestecs_soci FOREIGN KEY (sociCodi) REFERENCES Soci(codi)
		ON UPDATE RESTRICT ON DELETE RESTRICT
) ENGINE = INNODB;

-- 1. A la base de dades hi ha 3 tipus de gènere diferents: Drama, Humor, Terror i Novel·la amb codificació ‘GEN01’,’GEN02’,
	-- ’GEN03’, ‘GEN04’ respectivament. A més a més, abans d’introduir aquestes dades, fes que el camp NOM, sigui CASE SENSITIVE.
    -- Tingues en compte que no volem esborrar dades que ja teníem.
INSERT INTO genere VALUES ('GEN01','Drama')


-- 2. A la base de dades hi ha com a mínim 2 socis introduïts amb la següent informació. Podeu introduir més socis si ho creieu convenient.


-- • Codi soci: B0765
-- • DNI:40334123N
-- • Nom: Anna
-- • Codi soci: A2501
-- • DNI: 40314123E
-- A la base de dades hi ha també 2 llibres
-- o ISBN: 9788473291941
-- o Títol: L'últim mono
-- o Gènere: Humor
-- o Nombre exemplars: 5
-- o ISBN: 9788416367245
-- o Títol: Puresa
-- o Gènere: Terror
-- o Nombre exemplars: 3

-- 4. Es vol un llistat de tots els llibres per nom de gènere. Cal tenir en compte que no es volen llistar aquells llibres que tenen menys de 10 exemplars o ni que siguin del gènere “Drama” o “Terror”.



-- 5. Per error documental, cal incrementar en 5 el total d’exemplars de les categories de ‘Drama’, ‘Terror’ i també d’aquells codis on el seu gènere estigui entre el 1 i el 9.
-- Cal dir que els codis poden ser: ‘GEN01’, ‘GEN23’.



-- 6. Fes un llistat amb totes les dades dels llibres que encara no han estat prestats.



-- 7. Cal actualitzar i posar en majúscula la primer lletra del nom de cada soci.



-- 8. La Maria ha agafat prestat el llibre Puresa. La data que ha de constar com a préstec és la data d'avui. El llibre s'haurà de tornar en 25 dies.



-- 9. La Maria ha agafat prestat el llibre L'últim mono. La data que ha de constar és la data d'avui. El llibre s'haurà de tornar en 25 dies. Si ho creieu convenient podeu introduir més préstecs.



-- 10. Quants cops els socis han tornat el llibre més tard de la data de retorn que tenia que ser.





-- 11. Es vol obtenir un llistat de la següent forma <codi> - <DNI> : <nom> dels socis que no han realitzat cap préstec.



-- 12. La Maria ha demanat una pròrroga pel llibre L'últim mono. La pròrroga li concedeix 20 dies més.



-- 13. La Maria ha retornat el llibre puresa 3 dies abans de la data de retorn establerta.



-- 14. La Maria ha tornat a agafar el llibre puresa el 25 de febrer del 2016. El llibre s'ha de tornar en 20 dies.



-- 15. La Maria ha demanat una pròrroga pel llibre puresa. Se li donen 20 dies més.
-- Fer un llistat de Títol Llibre, Total Exemplars, Gènere i una columna més que digui si el total exemplars és inferior a 5, posi “Estoc insuficient”, sinó res. Ordenat per gènere.
-- NOTA: Utilitza la funció IF. (search your life ;P )
-- Afegeix el camp ciutat al socis. Tots els socis que el seu codi comenci per A seran de la ciutat de Granollers.




-- 18. Es vol saber quins llibres han estat més reservats que el llibre ‘Puresa’.



-- 19. Hi ha hagut un error. Tots els llibres d’Humor que es van reservar el mes de febrer dels anys 2016 i 2017, la seva data de préstec és exactament un mes després.



-- 20. Per desgracia, de cada llibre de gènere de Drama i Terror s’ha traslladat dos exemplars. Cal decrementar en 2 el total d’exemplars. Si pots, controla que no sigui negatiu en cas que tingui 0 o 1 exemplar.



-- 21. Fes un llistat per generes, dels llibres que tenen més exemplars que el promig d’exemplars que tenen els llibres del gènere de ‘Humor’.



-- 22. Afegeix un camp totalReserves a la taula Llibre. Aquest camp s’omplirà (UPDATE) amb el total de reserves que ha tingut el llibre 'Puresa' al llibre Puresa.
-- Cal fer una vista.



-- 23. Es vol saber quin el nom del llibre amb el seu gènere ha estat més prestat en la biblioteca.




-- 24. Ens han canviat de Software i cal que tots els llibres introduïts, el seu nom hagi d’estar en majúscula. ‘L’últim mono’  ‘L’ÚLTIM MONO’




-- 25. S'ha decidit canviar el gènere de negra per "novel·la negra". Explica quin problema hi ha i executa les instruccions oportunes per a resoldre aquest problema.




-- 26. Es vol veure el total d’exemplars que hi ha per cada gènere.




-- 27. Es vol saber el nom del soci amb el seu DNI i el ISBN del primer llibre que es va prestar.



-- 28. Tots els usuaris que tenen en préstec algun llibre del gènere Humor se’ls hi dóna 20 dies més per a retornar el llibre.


