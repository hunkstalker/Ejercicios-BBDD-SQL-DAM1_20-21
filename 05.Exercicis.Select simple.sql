/*
Exercici 1:
Crear l’estructura que representa el model ER que es mostra.
Cal afegir algunes dades representatives. Alerta amb les claus primàries.
*/



/*
Exercici 2:
Resol les següents consultes:
1. Obtenir totes les dades de la taula viatje ordenades alfabèticament per origen i destinació .*/
SELECT * FROM Viatge ORDER BY origen, desti;
/*
2. Obtenir tots els origens i destins de viatges realitzats.*/
SELECT DISTINCT origen, desti FROM Viatge;
/*
3. Comptabilitzar quants tickets de viatge s'han venut en seients de finestra.*/
SELECT COUNT(*) AS 'Seients finestra' FROM Viatge WHERE finestra = true;
/*
4. Comptabilitzar quants tickets de viatge s'han venut en seients que no siguin de finestra.*/
SELECT COUNT(*) AS 'Seients finestra' FROM Viatge WHERE finestra = false;
/*
5. Obtenir la informació de tots els avions que el seu nom començi per 'AIR-' (la consulta és case insensitive).*/
SELECT * FROM Viatge WHERE LEFT (avio,3) = 'AIR';
SELECT * FROM Viatge WHERE Avio LIKE 'AIR';
/*
6. Obtenir totes les dades dels vols entre Barcelona i Madrid realitzats durant l'any 2016 ordenades per import (de major a menor import).*/
SELECT * FROM Viatge WHERE desti IN ('Madrid','BCN') AND origen IN ('Madrid','BCN') AND YEAR(dataV) = 2016
	ORDER BY importV DESC;
SELECT * FROM Viatge WHERE desti IN ('Madrid','BCN') AND origen IN ('Madrid','BCN') AND YEAR(dataV) BETWEEN 2016 AND 2020
	ORDER BY importV DESC;
/*
7. Obtenir l'import mitjà de tots els vols entre Barcelona i Madrid realitzats els últims 10 anys. Si s'executa la consulta el 2016 serien entre els anys (2007-2016, ambdós inclosos) i si s'executa l'any 2017 entre els anys (2008-2017 ambdós inclosos).*/
SELECT AVG(import) AS 'Import Mitjà' FROM Viatge
	WHERE desti IN ('Madrid','BCN') AND Origen IN ('Madrid','BCN') AND (YEAR(dataV) BETWEEN (YEAR(now()) - 10 )) AND (YEAR(now()));
    
    
    AND origen IN ('BCN','Madrid') AND YEAR(dataV) BETWEEN (YEAR(now()) - 10) AND (YEAR(now()));

/*
8. Obtenir el total de passatgers que han ocupat el seient de la fila 2 i columna 3.*/

/*
9. Obtenir el nombre total de passatgers que han sortit de Barcelona amb l'avió AIRBUS A320 PASSENGER amb destinació a Madrid.*/
SELECT COUNT(*) AS 'Total Passatgers' FROM Viatge WHERE (origen = 'BCN' AND desti = 'Madrid' AND avio = 'obluvuv');

/*
10.Obtenir tots els avions de la taula viatje.*/

/*
11.Obtenir l'import màxim i mínim dels viatges efectuats el mes de febrer de l'any 2016 que han sortit de Palma.*/

/*
12.Obtenir el nom de tots els avions que el seu nom contingui 'AIR-' i acabin amb 360.*/

/*
13.Comptabilitzar el total de viatjes que estan pendents de realitzar-se (data futura).*/

/*
14.Obtenir totes les dades dels viatjes de l'any 2014, pels mesos de gener, febrer, març, juny , agost i setembre.*/

/*
15.Obtenir l’import total de tots els viatges que han sortit de Barcelona o de Madrid durant l’any 2016 o el 2017.*/
SELECT SUM(importV) FROM Viatge WHERE origen = 'BCN';
SELECT SUM(importV) FROM Viatge WHERE origen = 'Madrid';

-- Ver los importes sumados de los aviones agrupado por origen. Desglose
SELECT origen, SUM(importV) FROM Viatge GROUP BY origen;

-- Ver el importe máximo y mínimo de los aviones según el origen
SELECT origen, MAX(importV) AS 'Máx Import', MIN(importV) AS 'Min Import' FROM Viatge 
	GROUP BY origen;
    
-- que su fecha esté entre los años 2010 y 2020. Ordena la información según los datos descendientemente.
SELECT origen, MAX(importV) AS 'Máx Import', MIN(importV) AS 'Min Import' FROM Viatge
	WHERE YEAR(dataV) BETWEEN 2010 AND 2020
	GROUP BY origen
    ORDER BY origem DESC;
    
-- Ver los 5 asientos más caros
SELECT * FROM Viatge ORDER BY importV DESC LIMIT 5;