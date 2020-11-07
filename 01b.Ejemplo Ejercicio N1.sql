-- Base de datos relacionada

CREATE DATABASE ejemploRelacionesDB;
USE ejemploRelacionesDB;

CREATE TABLE IF NOT EXISTS ciclo(
	codigo CHAR(4) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
	tipo ENUM ('Superior','Medio') NOT NULL,
    cantHoras INT DEFAULT 2000
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS alumno(
	DNI CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(30),
	cicloCodigo CHAR(4),
    CONSTRAINT fk_alumno_ciclo FOREIGN KEY (cicloCodigo)
		REFERENCES ciclo(codigo)
) ENGINE = INNODB;

/*
alumno: {dni(pk),nombre,cicloCodigo(fk)}
ciclo: {codigo(pk), nombre, tipo, qttHoras}
*/

-- 



