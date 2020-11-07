/****************************************************************************/
/*							RELACIONES N:M									*/
/****************************************************************************/

CREATE DATABASE DBRelacionada;
USE DBRelacionada;

-- Según ejemplo del aula

/*
Alumno: {DNI(pk), nombre , apellido, fechaNac}
UF: {codigo(pk), nombre, horas}
Cursando: {fechaInicio(pk), alumnoDNI(pk,fk), ufCodigo(pk,fk)}
*/

CREATE TABLE IF NOT EXISTS alumno(
	DNI CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    fechaNac DATE    
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS UF(
	codigo CHAR(4) PRIMARY KEY,
    nombre VARCHAR(20),
    horas INT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS cursando(
	fechaInicio DATE,
    alumnoDNI CHAR(9), -- fk hacia alumno
    ufCodigo CHAR(4), --  fk hacia UF
    PRIMARY KEY (fechaInicio, alumnoDNI, ufCodigo),
	CONSTRAINT fk_cursando_alumno FOREIGN KEY (alumnoDNI)
		REFERENCES alumno(DNI),
	CONSTRAINT fk_cursando_uf FOREIGN KEY (ufCodigo)
        REFERENCES UF(codigo)
) ENGINE = INNODB;

INSERT INTO alumno (DNI, nombre, apellido) VALUES ('DNI1','Claudina','Riaza'),
	('DNI2','David','Delgado'),('DNI3','Quim','Molina');
INSERT INTO uf VALUES ('UF01','Lenguaje SQL',190),('UF02','Progrmación',90),('UF03','Lenguaje HTML',40);
INSERT INTO Cursando VALUES ('2020-02-12','DNI2','UF01'),
	('2020-02-12','DNI1','UF01'),('2020-02-12','DNI3','UF01');

SELECT * FROM cursando;
SELECT * FROM alumno;
SELECT * FROM uf;