-- 1. Mostra un llistat de qualificacions, on es vegi el nom complet (en un únic camp) de cada alumne amb la relació del nom de la unitat formativa i nota.
SELECT CONCAT(A.nom,' ',A.cognom) AS "Nom complet", U.nom AS Curs, C.nota AS Nota FROM Cursa C
	INNER JOIN Alumne A ON A.DNI = alumneDNI
    INNER JOIN UF U ON U.codi = ufCodi;

-- 2. Mostra el nom de cada tutor, el total d’alumnes que té. No es vol tenir en compte el cicle de DAM (tant primer com segon curs: DAM1-DAM2).
SELECT  T.nom AS Tutor, count(A.nom) AS "Nombre l'alumnes" FROM Alumne A
	INNER JOIN Tutor T ON T.DNI = tutorDNI GROUP BY Tutor;

-- 3. Mostra els ingressos per ciutat que generen els alumnes.
SELECT A.ciutat AS Ciutat, sum(U.preu) AS Ingresos FROM Alumne A
	INNER JOIN Cursa C ON A.DNI = alumneDNI
    INNER JOIN UF U ON U.Codi = ufCodi GROUP BY A.ciutat;

-- 4. Mostra un llistat amb el nom dels tutors de DAM o SMX (de qualsevol curs), alumne i uf’s que cursa que inicien a l’Octubre, Novembre o Gener.


-- 5. Afegeix el camp “Data de Naixement” a la taula alumne.
ALTER TABLE Alumne ADD dataNaix DATE;

-- 6. Es vol un llistat amb els nom i cognom dels alumnes que cursen la UF que té més hores.

SELECT MAX(hores) FROM UF;

SELECT A.nom, A.cognom, UF.nom, UF.hores FROM Alumne A
	INNER JOIN Cursa C ON A.DNI = C.alumneDNI
	INNER JOIN UF ON UF.codi = C.ufCodi
WHERE UF.hores =(SELECT MAX(hores) FROM UF);

-- 6B. Es vol un llistat amb els nom i cognom dels alumnes que cursen la UF cursada que té més hores.

SELECT MAX(hores) FROM UF INNER JOIN Cursa C ON UF.Codi = C.ufCodi;

SELECT A.nom, A.cognom, UF.nom, UF.hores FROM Alumne A
	INNER JOIN Cursa C ON A.DNI = C.alumneDNI
	INNER JOIN UF ON UF.codi = C.ufCodi
WHERE UF.hores =(SELECT MAX(hores) FROM UF INNER JOIN Cursa C ON UF.Codi = C.ufCodi);
    
-- 7. Es vol veure el nom i cognom dels alumnes amb el tutor que té (nom) d’aquells alumnes que cursen UFS amb el mínim d’hores i ténen un preu inferior a 50€
SELECT MAX(hores) FROM UF INNER JOIN Cursa C ON UF.Codi = C.ufCodi;

SELECT A.nom, A.cognom, T.nom, UF.hores FROM Tutor T
	INNER JOIN Alumne A ON T.DNI = A.tutorDNI
	INNER JOIN Cursa C ON A.DNI = C.AlumneDNI
	INNER JOIN UF ON C.ufCodi = UF.codi
WHERE UF.hores =(SELECT MIN(hores) FROM UF WHERE UF.preu<50);

-- 8. Es vol veure els alumnes (nom i cognom) que han superat les unitats formatives del curs de AIF1.


-- 9. Es vol determinar per UF i nota, quants alumnes hi han, només tenint en compte les ciutats de “Granollers” i “Montornes”.


-- 10. Determina el nom d’aquells alumnes que aquest mes celebren el seu 18 aniversari.