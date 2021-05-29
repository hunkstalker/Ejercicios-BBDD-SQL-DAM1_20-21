-- Para escribir comentarios se ponen 2 guiones al inicio de lo que quieras comentar.

/*
Barra-asterisco si el comentario es multilínea
*/

CREATE DATABASE testDB; -- Crear base de datos
USE testDB; -- Seleccionar la base de datos en la que quieres trabajar

-- Crear tabla
CREATE TABLE avion(
	codigo	CHAR(5), -- CHAR es para intriducir un valor de carácteres (letras) con un valor que indicas entre paréntesis. En este caso significa que será de 5 carácteres sí o sí.
    modelo	VARCHAR(25), -- VARCHAR lo mismo que CHAR sólo que en paréntesis indicas el máximo de carácteres, luego puedes introducir 5, 10 lo que sea con máximo 25 en este caso.
    capacidad	INT, -- Valor que es para introducir números con los que poder hacer cálculos (con CHAR también puedes meter números pero los considera carácteres y no se pueden hacer cálculos).
    peso	DECIMAL(4,2), -- Como INT pero valores con decimales exactos, se usa para valores de precisión como precios. Entre paréntesis, el primer valor es la cantidad máxima de números y el segundo dentro de la capacidad máxima cuantos serán decimales.
    aerolinea	VARCHAR(20),
    fechaFabricacion DATE, -- Para indotrucir una fecha, en este caso un año-mes-día (2020/05/22). Existe DATETIME que también agrega la hora.
    PRIMARY KEY (codigo) -- Esto es más complejo de explicar, demasiado para una línea xd
) ENGINE = INNODB;
-- De momento ponemos al final de la tabla lo de "ENGINE=INNODB", en teoría no hace falta porque lo pone por defecto Workbench.

-- Las palabras clave (como CREATE TABLE) siempre en mayúsculas. Funciona en minúsculas pero es de convención general ponerlo así.
-- Todo lo demás en minúsculas.
    
DROP TABLE avion; -- Eliminar tabla

INSERT INTO avion VALUES ('FG456','Boing 747',324,7.4,'Vueling','2020-05-22'); -- Insertar valor
INSERT INTO avion VALUES ('FG456','Boing 730',311,7.1,'Vueling','2020-05-23'); -- error PK

SELECT * FROM avion;

-- ##########################################################################################

CREATE TABLE IF NOT EXISTS cuentabancaria(
	DNI CHAR(9) PRIMARY KEY,
    banco VARCHAR(20),
    IBAN CHAR(24),
    saldo DECIMAL(15,2),
    nombre VARCHAR(20),
    primerApellido VARCHAR(20),
    segundoApellido VARCHAR(20),
    direccCalle VARCHAR(20),
    direccNum VARCHAR(20),
    direccPiso VARCHAR(20),
    direccPuerta VARCHAR(20),
    direccPoblacion VARCHAR(20),
    direccProvincia VARCHAR(20),
    direccCP INT,
    tipoCuenta VARCHAR(20),
    intereses TINYINT,
    alta DATE
    
) ENGINE = INNODB;

-- ##########################################################################################

CREATE TABLE  IF NOT EXISTS jugadorfutbol(
	ID INT PRIMARY KEY,
    num INT,
    coleccion VARCHAR(20),
    nombre VARCHAR(60),
    dorsal TINYINT,
    puesto VARCHAR(10),
    fichaje DATE,
    altura DECIMAL(3,2),
    peso TINYINT,
    nacimiento DATE,
    nacionalidad VARCHAR(20)
    
) ENGINE = INNODB;

-- ##########################################################################################

CREATE TABLE  IF NOT EXISTS libro(
	ISBN INT PRIMARY KEY,
    titulo VARCHAR(30),
	autor VARCHAR(60),
	editorial VARCHAR(20),
    genero VARCHAR(20),
    numPags INT,
    anyoPublicacion DATE,
    pagsEco boolean,
	precio DECIMAL(4,2),
	edicion TINYINT,
    tipo VARCHAR(20),
    origen VARCHAR(20)
    
) ENGINE = INNODB;

-- ##########################################################################################

CREATE TABLE  IF NOT EXISTS portatil(
    numProducto CHAR(20) PRIMARY KEY,
	numSerie VARCHAR(20),
    marca VARCHAR(20),
    modelo VARCHAR(20),
    cpuMarca VARCHAR(20),
    cpuModelo VARCHAR(20),
    cpuGen INT,
    cpuClock INT,
    gpuMarca VARCHAR(20),
    gpuModelo VARCHAR(20),
    gpuMem INT,
    RAM INT,
    tipoAlmacenamiento1 VARCHAR(20),
    tipoAlmacenamiento2 VARCHAR(20),
    tipoAlmacenamiento3 VARCHAR(20),
    tipoAlmacenamiento4 VARCHAR(20),
	tipoAlmacenamiento5 VARCHAR(20),
    cantAlmacenamiento1 INT,
    cantAlmacenamiento2 INT,
    cantAlmacenamiento3 INT,
    cantAlmacenamiento4 INT,
	cantAlmacenamiento5 INT,
    color VARCHAR(20),
    pantallaTipo VARCHAR(20),
    resolucion VARCHAR(20),
    peso DECIMAL(3,2),
    SO VARCHAR(20),
    RGB BOOL
    
) ENGINE = INNODB;

-- ##########################################################################################

CREATE TABLE  IF NOT EXISTS bombilla(
	numProducto CHAR(10) PRIMARY KEY,
    numSerie VARCHAR(20),
    marca VARCHAR(20),
    tcnologia VARCHAR(20),
    potenciaCons INT,
    potenciaLumen INT,
	precio DECIMAL(5,2),
    stock INT,
    clase VARCHAR(20),
    temperatura INT,
    garantia TINYINT,
    voltaje TINYINT,
    resistencia TINYINT
    
) ENGINE = INNODB;

-- ##########################################################################################

DESCRIBE alumno;

INSERT INTO alumno VALUES('DENIS','ANFRUNS','DAM1',1); -- Insertar valores en una tabla
INSERT INTO alumno (nombre, apellido, ciclo) VALUES ('Gerard','Fernández','DAM1'); -- Insretar valore solo en los campos que se quiere

SELECT * FROM alumno; -- Mostrar valores de toda la tabla
SELECT nombre, apellido FROM alumno; -- Mostrar valores concretos de una tabla


CREATE TABLE IF NOT EXISTS alumno(
	nombre VARCHAR(20),
    apellido VARCHAR (20),
    ciclo VARCHAR (20) NOT NULL, -- Para no permitir que el valor pueda ser Null
    hermanos TINYINT DEFAULT NULL,
    PRIMARY KEY (nombre, apellido)
    
) ENGINE = INNODB;

-- ##########################################################################################

CREATE TABLE IF NOT EXISTS Ciudad(
	codigoPostal CHAR(5) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    cantHabitantes INT,
    provincia VARCHAR(20) DEFAULT 'Barcelona',
    partidoPoliticoActual ENUM('PP','PSOE','VOX','ERC')
) ENGINE = INNODB;

INSERT INTO Ciudad VALUES ('08401','Granollers',300000,NULL,'PSOE');
INSERT INTO Ciudad (codigoPostal, nombre, partidoPoliticoActual) VALUES ('08402','Granollers','PP');
INSERT INTO Ciudad (codigoPostal, nombre, partidoPoliticoActual) VALUES ('08403','Granollers','VOX');

-- Modificar nombre de la tabla
ALTER TABLE Ciudad RENAME Ciutat;
-- Añadir un campo a la tabla
ALTER TABLE Ciutat ADD Clima VARCHAR(20) DEFAULT 'Mediterráneo';
-- Eliminar un campo de la tabla
ALTER TABLE Ciutat DROP partidoPoliticoActual;
-- Eliminar la Primary Key
ALTER TABLE Ciutat DROP PRIMARY KEY;
-- Modificar el tipo de un campo ya existente
ALTER TABLE Ciutat MODIFY COLUMN Provincia VARCHAR(40);
-- Modificar nombre de un campo
ALTER TABLE Ciutat CHANGE COLUMN nombre nom VARCHAR(25);

DESCRIBE Ciutat;

SELECT * FROM Ciutat;


