-- Ejericio 2. BD relacionada
-- 1er Diagrama

CREATE DATABASE DBRelacionada;
USE DBRelacionada;

CREATE TABLE IF NOT EXISTS genero(
	nombre VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(300)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS videojuego(
	codigo CHAR(8) PRIMARY KEY,
    nombre VARCHAR(30),
    plataforma VARCHAR(20),
    precio DECIMAL(4,2),
    generoNombre VARCHAR(20),
    CONSTRAINT fk_videojuego_genero FOREIGN KEY (generoNombre)
		REFERENCES genero(nombre)
) ENGINE = INNODB;

INSERT INTO genero (nombre) VALUES ('Plataformas'),('Shooter'),('RPG'),('RogueLike');

INSERT INTO videojuego (codigo, nombre, precio, generoNombre)
	VALUES ('V2010000','Mario',59.99,'Plataformas');
INSERT INTO videojuego (codigo, nombre, precio, generoNombre)
	VALUES ('V2010001','Battlefield',59.99,'Shooter'),('V2010002','Secfret of Evermore',29.99,'RPG');

-- 2o Diagrama

/* Mal, lo hice ak revés.

CREATE TABLE IF NOT EXISTS ropa(
	codigoBarras CHAR(13) PRIMARY KEY,
    precioCompra DECIMAL(6,2),
    precioVenta DECIMAL(6,2),
    tipo ENUM ('Camiseta','Camisa','Pantalón Largo','Pantalón Corto','Jersey','Blusa','Vesitdo'),
    fechaEntrada DATETIME
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS cliente(
	DNI CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20),
    codigoBarrasRopa CHAR(13),
    CONSTRAINT fk_cliente_ropa FOREIGN KEY (codigoBarrasRopa)
		REFERENCES ropa(codigoBarras)
) ENGINE = INNODB;
*/

CREATE TABLE IF NOT EXISTS cliente(
	DNI CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20),
    apellido VARCHAR(20)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS ropa(
	codigoBarras CHAR(13) PRIMARY KEY,
    precioCompra DECIMAL(6,2),
    precioVenta DECIMAL(6,2),
    tipo VARCHAR(20),
    fechaEntrada DATETIME,
    clienteDNI CHAR(9), -- FK
	CONSTRAINT fk_ropa_cliente FOREIGN KEY (clienteDNI)
		REFERENCES cliente(DNI)
) ENGINE = INNODB;


SELECT * FROM videojuego;
SELECT * FROM genero;

/* CLIENTE: {DNI, nombre(pk), apellido(pk)}
ROPA: {codigoBarras(fk), tipo, precioCompra, precioVenta, fechEntrada,
	clientenombre(fk), clienteApellido(fk)}
*/

CREATE TABLE IF NOT EXISTS cliente2(
    nombre VARCHAR(20),
    apellido VARCHAR(20),
	DNI CHAR(9),
    PRIMARY KEY (nombre,apellido)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS ropa2(
	codigoBarras CHAR(13) PRIMARY KEY,
    precioCompra DECIMAL(6,2),
    precioVenta DECIMAL(6,2),
    tipo VARCHAR(20),
    fechaEntrada DATETIME,
    clienteNombre CHAR(20), -- FK
    clienteApellido CHAR(20), -- FK
    CONSTRAINT fk_ropa_cliente2 FOREIGN KEY (clienteNombre, clienteApellido)
		REFERENCES cliente2(nombre, apellido)
) ENGINE = INNODB;

/****************************************************************************/
/*							RELACIONES N:M									*/
/****************************************************************************/

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