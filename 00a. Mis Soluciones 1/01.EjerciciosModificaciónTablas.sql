-- EJERCICIO 1: Modificación de tablas

create database if not exists exerciciAlterDB;
use exerciciAlterDB;

CREATE TABLE IF NOT EXISTS Usuari(
	email VARCHAR(30),
	pass VARCHAR(8),
	nom VARCHAR(20),
	cognom VARCHAR(30),
	ciutat VARCHAR(20),
	dataReg DATE,
	dataNaix DATE,
	validad BOOL,
	PRIMARY KEY(email)
) ENGINE = INNODB;

SELECT * FROM user;

-- 1. Caldrà afegir un nou camp anomenat “sexe” on emmagatzemarà “H” o “D”.
ALTER TABLE Usuari ADD sexe ENUM ('H','D');

-- 2. La  taula  passarà  a  dir-se  user,  igual  que  els  camps  nom,  cognom,  dataNaix i validad per nameUser, surnameUser, birthdate i confirmed respectivament
ALTER TABLE Usuari RENAME user; -- Ok
ALTER TABLE user CHANGE COLUMN nom nameUser VARCHAR(20); -- Ok
ALTER TABLE user CHANGE COLUMN cognom surnameUser VARCHAR(30); -- Ok
ALTER TABLE user CHANGE COLUMN dataNaix birthdate DATE; -- Ok
ALTER TABLE user CHANGE COLUMN validad confirmed BOOL; -- Ok

-- 3.El camp “pass” passarà a tenir en compte les majúscules i minúscules.
-- ALTER TABLE user CHANGE COLUMN pass pass VARCHAR(8) COLLATE 'latin1_bin';
ALTER TABLE user MODIFY COLUMN pass VARCHAR(8) COLLATE 'latin1_general_cs'; -- Corrección

-- 4.Els camps de nom i cognom no poden permetre valors NULLS.
-- ALTER TABLE user CHANGE COLUMN nameUser nameUser VARCHAR(20) NOT NULL;
-- ALTER TABLE user CHANGE COLUMN surnameUser surnameUser VARCHAR(20) NOT NULL;
ALTER TABLE user MODIFY COLUMN nameUser VARCHAR(20) NOT NULL; -- Ok
ALTER TABLE user MODIFY COLUMN surnameUser VARCHAR(20) NOT NULL; -- Ok

-- 5.El vol prescindir del camp “ciutat”.
ALTER TABLE user DROP COLUMN ciutat; -- Ok

-- 6.Es vol tenir la informació amb la data i hora en el moment de registrar un usuari.
ALTER TABLE user MODIFY COLUMN dataReg DATETIME; -- Ok

-- 7.Es vol identificar a un usuari pel número de telèfon mòbil (cellphone)
-- Debido a que ya tienes datos al crear un nuevo campo para el num de telefeno cellphone
-- la primary key tiene que hacer lo siguiente
ALTER TABLE user ADD cellphone CHAR(9);
-- Llenar el campo de informaciom no repetida
-- desasignar el campo mrimary key
ALTER TABLE user DROP PRIMARY KEY;
-- Asignar la primary key a cellphone
ALTER TABLE user ADD PRIMARY KEY (cellphone);
ALTER TABLE user DROP COLUMN cellphone;

-- 8.Introdueix 2 registres d’usuaris que tu creguis oportú (omple tots els camps).
INSERT INTO user
	 VALUES ('claudia@gmail.com',555784512,'1234','Claudia','Garcia','2020-09-22','1987-04-07',True,'D');
INSERT INTO user
	 VALUES ('pedro@gmail.com',555896523,'1234','Pedro','Sánchez','2020-09-23','1984-07-11',True,'H');

-- 9. Introdueix 1 registre d’usuari amb el següent d’ordre de camps: Confirmed, birthdate, nameUser, surnameUser, cellphone, email.
INSERT INTO user
	(confirmed, birthdate, nameUser, surnameUser, cellphone, email)
    VALUES (1,'1985-03-12','Paco','Torrevieja','paco@gmail.com',555127845,'1234','2020-09-23','H');

-- 10. Introdueix 2 registres on el la instrucció ompli el camp dataReg utilitzant la hora actual del sistema de forma automàtica. (omple tots els camps).
INSERT INTO user
	 VALUES ('roger@gmail.com',555896548,'1234','Roger','Sánchez',now(),'1980-07-5',True,'H');

-- 11. Fer que la la primary key estigui en primera posici
ALTER TABLE user
	MODIFY COLUMN cellphone CHAR(9) NOT NULL FIRST;

DESCRIBE user;
SELECT * FROM user;