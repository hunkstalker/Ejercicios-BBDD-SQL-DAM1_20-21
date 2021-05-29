CREATE DATABASE exercici06;
USE exercici06;


INSERT INTO Vehicle VALUES ('BAST1','0000AAA',now(),'Blanc',11000.00,10000.00),
	('BAST2','0001AAA',now(),'Blanc',20000.00,19000.00), ('BAST3','0002AAA',now(),'Groc',21000.00,20000.00),
    ('BAST4','0003AAA',now(),'Vermell',18000.00,17000.00), ('BAST5','0004AAA',now(),'Blau',15000.00,14000.00),
    ('BAST6','0005AAA',now(),'Blau',30000.00,29000.00), ('BAST7','0006AAA',now(),'Blanc',35000.00,31000.00),
    ('BAST8','0007AAA',now(),'Negre',30000.00,29000.00),('BAST9','0008AAA',now(),'Negre',15000.00,14000.00);

-- 1. Obtenir la informació de tots els vehicles
-- 2. Obtenir el codi de bastidor i el preu de cost de tots els vehicles. Cal mostrar la informació ordenada pel preu de cost (de més a menys).
-- 3. Obtenir el preu de cost mínim i màxim de la taula de vehicles (només el preu de cost, sense cap altra dada associada al vehicle). El nom associat a la columna ha de ser Cost Maxim i Cost Mínim.
-- 4. Obtenir el total del preu de cost de tots els vehicles.
-- 5. Obtenir la matrícula, la data de venda i el preu de venda de tots els cotxes venuts.
-- 6. Obtenir un llistat de tots els cotxes. El llistat ha de mostrar els vehicles ordenats, en primer criteri, de menys a més preu de cost i, en segon criteri, de menys a més preu de venta final.
-- 7. Obtenir l'import obtingut de la venda de tots els vehicles.
-- 8. Tot i no tenir coherència, mostra el bastidor i la matrícula al revés de tots els vehicles amb un preu de cost entre 1000 y 5000
-- Ex: Matricular: JKG1234  4321GKJ
-- 9. Obtenir el benefici de cada un dels cotxes venuts. El resultat s'ha de visualitzar amb el text «Euros». Cal ordenar el llistat de més a menys benefici.
-- 10.Obtenir totes els anys que s’han venut vehicles. El títol de la columna ha de ser “Anys amb ventes”.
-- 11.Obtenir tota la informació de tots els cotxes de color groc disponibles per a la venda.
-- 12.Obtenir tota la informació de tots els cotxes de color groc venuts l'any 2015.
-- 13.Mostra el bastidor i la matrícula de tots els vehicles correctament codificada (amb el guió) i assegurat que es mostra en majúscules d’aquells vehicles que ja han estat venuts. Codificada: JKG-1234
-- 14.Obtenir tota la informació de tots els cotxes de color groc excepte els venuts l’any 2015.
-- 15.Obtenir tota la informació de tots els cotxes de color groc o que s'hagin venut l'any 2015.
-- 16.Obtenir el benefici total obtingut amb les vendes realitzades entre els anys 2013 i el 2015.
-- 17.Obtenir els colors dels vehicles disponibles per a la venda.
-- 18.Obtenir tots els cotxes venuts que no siguin de color groc o que el seu preu de venta final hagi estat superior a 10.000.
-- 19.Cal mostrar de cada vehicle venut, el total de dies que està en circulació.
-- 20.Quin és el benefici acumulat de l’empresa dels cotxes venuts en entre el 2000 i 2018 de color “verd” o “vermell”.