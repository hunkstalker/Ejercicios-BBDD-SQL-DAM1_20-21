-- Ejercicio repaso SELECT

SELECT * FROM Actor WHERE YEAR(last_update) = 2006;

-- Ver la info de los actores que se llaman Ed, Nick o Karl;
SELECT * FROM Actor WHERE first_name IN ('Ed','Nick','Karl');

-- Ver cuántos actores se llaman Ed, Nick o Karl;
SELECT COUNT(*) FROM Actor 
	WHERE first_name IN ('Ed','Nick','Karl') OR last_name IN ('Stallone','Guiness');
    
-- Ver a los actores por orden alfabético según el apellido;
SELECT * FROM Actor ORDER BY last_name ASC, first_name ASC; -- Default ASC OPCIONAL DESC

-- Ver los actores que su última actualización fuera en febrero de cualquier año de un ID superior a 15. Ordenar la información por la última actualización descendiente.
SELECT * FROM Actor WHERE MONTH(last_update) = 2 AND actor_id>15 ORDER BY last_update DESC;

-- Ver que actores no tienen una última fecha de actualización;
SELECT * FROM Actor WHERE last_update IS NOT NULL;

-- Ver todos los apellidos diferentes que hay;
SELECT last_sanme FROM Actor;
SELECT DISTINCT last_name FROM Actor;
