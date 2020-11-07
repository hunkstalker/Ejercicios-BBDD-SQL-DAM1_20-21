/****************************************************************************/
/*							Ejercicio 1 									*/
/****************************************************************************/

/*
Comunidad: {nombre(pk)}
Provincias: {nombre(pk), comunidadNombre(fk)}
*/

CREATE DATABASE Geografia;
USE Geografia;

CREATE TABLE IF NOT EXISTS comunidad(
	nombre VARCHAR(20) PRIMARY KEY
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS provincia(
	nombre VARCHAR(20) PRIMARY KEY,
    comunidadNombre VARCHAR(20), -- FK
    CONSTRAINT fk_provincia_comunidad FOREIGN KEY (comunidadNombre)
		REFERENCES comunidad(nombre)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = INNODB;



/****************************************************************************/
/*					Ejercicio 2	- Diagrama Trabajo 							*/
/****************************************************************************/

/*
Trabajador: {nss(pk), nombre}
Trabajos: {nombre(pk), descripcion, duracion, fecha, trabajadorNSS(fk)}
*/

CREATE DATABASE Trabajo;
USE Trabajo;

CREATE TABLE IF NOT EXISTS trabajador(
	nss CHAR(11) PRIMARY KEY,
    nombre VARCHAR(20)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS trabajo(
	nombre VARCHAR(20) PRIMARY KEY,
    descripcion VARCHAR(200),
    duracion INT,
    fecha DATE,
    trabajadorNSS CHAR(11), -- FK
    CONSTRAINT fk_trabajo_trabajador FOREIGN KEY (trabajadorNSS)
		REFERENCES trabajador(nss)
        ON UPDATE CASCADE
        ON DELETE NO ACTION
) ENGINE = INNODB;

ALTER TABLE trabajo DROP FOREIGN KEY fk_trabajo_trabajador;
ALTER TABLE trabajo ADD CONSTRAINT fk_trabajo_trabajador FOREIGN KEY (trabajo)
REFERENCES trabajador(nss) ON UPDATE CASCADE;

/****************************************************************************/
/*							Ejercicio 3 									*/
/****************************************************************************/

/*
Proveedor: {NIF(uq), nombre, direccion, ciudad, telefono}
Producto: {codigo, nombre, PVC, PVP, proeedorNIF(fk)}
*/

CREATE DATABASE Proveedores;
USE Proveedores;

CREATE TABLE IF NOT EXISTS proveedor(
	NIF CHAR(9) UNIQUE,
	nombre VARCHAR(20),
    direccion VARCHAR(20),
    ciudad VARCHAR(20) DEFAULT 'Barcelona',
    telefono VARCHAR(9) UNIQUE
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS producto(
	codigo CHAR(5) PRIMARY KEY,
    nombre VARCHAR(20),
    PVC DECIMAL(6,2),
    PVP DECIMAL(6,2),
    proveedorNIF CHAR(9), -- FK
    CONSTRAINT fk_producto_proveedor FOREIGN KEY (proveedorNIF)
		REFERENCES proveedor(NIF)
        ON UPDATE CASCADE
        ON DELETE SET NULL
) ENGINE = INNODB;

INSERT INTO proveedor VALUES ('NIF1', 'Danone','Valencia 45','Girona','666112233');
INSERT INTO proveedor (nif,nombre) VALUES ('NIF2', 'Hacendado');

INSERT INTO producto VALUES ('PRO1','Natillas',1.50,1.75,'NIF1');

/****************************************************************************/
/*							Ejercicio 4 									*/
/****************************************************************************/

/*
Sociedad: {NIF(pk), nombre, presupuesto}
Persona: {NIF(pk), nombre}
SoloMiembro: {sociedadNIF(fk), personaNIF(fk)}
*/

CREATE DATABASE Sociedades;
USE Sociedades;

CREATE TABLE IF NOT EXISTS sociedad(
	NIF CHAR(8) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    presupuesto REAL NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS persona(
	NIF CHAR(8) PRIMARY KEY,
	nombre VARCHAR(20) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS soloMiembro(
	sociedadNIF CHAR(8), -- PK FK hacia sociedad
    personaNIF CHAR(8), -- PK FK hacia persona
    PRIMARY KEY (sociedadNIF, personaNIF),
    CONSTRAINT fk_soloMiembro_sociedad FOREIGN KEY (sociedadNIF) REFERENCES sociedad(NIF)
        ON DELETE RESTRICT,
	CONSTRAINT fk_soloMiembro_persona FOREIGN KEY (personaNIF) REFERENCES persona(NIF)
        ON DELETE RESTRICT 
) ENGINE = INNODB;



/****************************************************************************/
/*							Ejercicio 5 									*/
/****************************************************************************/

/*
Caballo: {nombre(pk), edad, fechaNacimiento, raza, trabajadorNSS(fk)}
Trabajador: {NSS(pk), nombre}
*/

CREATE DATABASE Hípica;
USE Hípica;

CREATE TABLE IF NOT EXISTS trabajador(
	nss CHAR(11) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS caballo(
	nombre CHAR(20) PRIMARY KEY,
    fechaNacimiento DATE NOT NULL,
    raza VARCHAR(20) NOT NULL,
    trabajadorNSS CHAR(11), -- FK
    CONSTRAINT fk_caballo_trabjador FOREIGN KEY (trabajadorNSS)	REFERENCES trabajador(nss)
		ON UPDATE CASCADE
		ON DELETE SET NULL
) ENGINE = INNODB;



/****************************************************************************/
/*							Ejercicio 6 									*/
/****************************************************************************/

/*
Persona: {DNI(pk), nombre}
Trasto: {numSerie(pk), nombre, adquisicion, destruccion}
Destruir: {DNI(fk), numSerie(fk)}
*/

CREATE DATABASE Trasto;
USE Trasto;

CREATE TABLE IF NOT EXISTS persona(
	DNI CHAR(9) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL	
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS trasto(
	numSerie CHAR(15) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    adquisicion DATE NOT NULL,
    destruccion DATE
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS destruir(
	personaDNI CHAR(9), -- FK hacia persona
	trastoNumSerie CHAR(15), -- FK hacia trasto
    PRIMARY KEY (personaDNI, trastoNumSerie),
    CONSTRAINT fk_destruir_persona FOREIGN KEY (personaDNI)	REFERENCES persona(DNI)
		ON DELETE RESTRICT,
	CONSTRAINT fk_destruir_trasto FOREIGN KEY (trastoNumSerie) REFERENCES trasto(numSerie)
		ON DELETE RESTRICT
) ENGINE = INNODB;

ALTER TABLE trasto MODIFY COLUMN DNI CHAR(9) COLLATE 'latin1_general_cs';



/****************************************************************************/
/*	-- Relación 1:1				Ejercicio 7.1								*/
/****************************************************************************/

/*
President: {DNI(pk), name, politicalGroup}
Country: {codigo(pk), name, capital, population}
*/

CREATE DATABASE Presidency;
USE Presidency;

CREATE TABLE IF NOT EXISTS President(
	DNI CHAR(9) PRIMARY KEY,
    name VARCHAR(20),
    politicalGroup VARCHAR(20)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Country(
	code CHAR(9) PRIMARY KEY,
    name VARCHAR(20),
    capital VARCHAR(20),
    population INT
) ENGINE = INNODB;

/****************************************************************************/
/*	-- Relación N:M				Ejercicio 7.2								*/
/****************************************************************************/

/*
Office: {sucursal(pk), phone(pk), address, city}
Client: {DNI(pk), accountNum(pk), name, surname, entryDate, balance}
Interaction: {sucursal(fk), phone(fk), DNI(fk), accountNum(fk)}
*/

CREATE DATABASE Bank;
USE Bank;

CREATE TABLE IF NOT EXISTS Office(
	sucursal CHAR(4),
    phone INT,
    address VARCHAR(20),
    city VARCHAR(20),
    PRIMARY KEY (sucursal, phone)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Client(
	DNI CHAR(9),
    accountNum INT,
    name VARCHAR(20),
    surname VARCHAR(20),
    entryDate DATE,
    balance INT,
    PRIMARY KEY (DNI, accountNum)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Interaction(
	sucursalOffice CHAR(4), -- FK hacia Office
    phoneOffice INT, -- FK hacia Office
    DNIClient CHAR(9), -- FK hacia Client
    accountNumClient INT, -- FK hacia accountName
    PRIMARY KEY (sucursalOffice, phoneOffice, DNIClient, accountNumClient),
    CONSTRAINT fk_interaction_office FOREIGN KEY (sucursalOffice, phoneOffice)
		REFERENCES Office(sucursal, phone),
	CONSTRAINT fk_interaction_client FOREIGN KEY (DNIClient, accountNumClient)
		REFERENCES Client(DNI,accountNum)
) ENGINE = INNODB;

/*
Alumno: {NIF(pk), nombre, apellido, numHermanos, profesorNombre(fk), profesorApellido(fk)}
Profesor: {nombre(pk), apellido(pk), especialidad}
Enseña: {NIF(fk), alumnoNIF(pk,fk), profesorNombre(pk,fk), profesorApellido(pk,fk)}
*/

CREATE TABLE IF NOT EXISTS profesor(
	nombre CHAR(20),
    apellido VARCHAR(20),
    especialidad VARCHAR(50),
    
    PRIMARY KEY (nombre, apellido)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS alumno(
	NIF CHAR(9) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    apellido VARCHAR(20) NOT NULL,
    numHermanos TINYINT,
	profesorNombre CHAR(20), -- FK
    profesorApellido VARCHAR(20), -- FK
    
    CONSTRAINT fk_alumno_profesor FOREIGN KEY (profesorNombre, profesorApellido) REFERENCES profesor(nombre, apellido)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS ensenya(
	fechaE DATE,
    alumnoNIF CHAR(9),
	profesorNombre CHAR(20),
    profesorApellido VARCHAR(20),
    
    PRIMARY KEY (fechaE, alumnoNIF, profesorNombre, profesorApellido),
    
    CONSTRAINT fk_ensenya_alumnoc FOREIGN KEY (alumnoNIF) REFERENCES Alumno(NIF),
    CONSTRAINT fk_ensenya_profesor FOREIGN KEY (profesorNombre, profesorApellido) REFERENCES profesor(nombre, apellido)
) ENGINE = INNODB;

/***********************************************************************/

CREATE TABLE IF NOT EXISTS genero (
	isbn CHAR(9) PRIMARY KEY,
    titulo VARCHAR(20)
    


) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS libro (
	isbn CHAR(9) PRIMARY KEY,
    titulo VARCHAR(20),
    numPag INT,
	generoNombre VARCHAR(20),
    CONSTRAINT fk_libro_genero FOREIGN KEY (
    ON DELETE CASCADE
	ON DELETE CASCADE
) ENGINE = INNODB;

/*
ALTER TABLE libro DROP FOREIGN KEY fk_genero_libro;
ALTER TABLE libro ADD CONSTRAINT fk_genero_libro FOREIGN KEY (generoNombre) REFERENCES genero(nombre)
	ON UPDATE SET NULL
    ON DELETE RESTRICT;
*/

INSERT INTO genero VALUES ('Drama','Barcelona');
INSERT INTO genero VALUES ('Comic','Mataró');
INSERT INTO genero VALUES ('Misterio','Girona');
INSERT INTO libro VALUES ('Drama','Barcelona');
INSERT INTO libro VALUES ('Comic','mataró');
INSERT INTO libro VALUES ('Drama','Barcelona');

SELECT * FROM genero;
SELECT * FROM libro