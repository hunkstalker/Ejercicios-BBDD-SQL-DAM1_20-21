/******************** Ejercicio 3. JUNTA **********************************************************

sociedad: {nif(pk),nombre,presupuesto}
persona {nif(pk), nombre}
soloMiembro {nif_sociedad(fk), nif_persona(fk)}
junta {nif_sociedad(fk), nif_persona(fk)}
*/

CREATE DATABASE Junta;
USE Junta;

CREATE TABLE IF NOT EXISTS sociedad (
	nif CHAR(8) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL,
    presupuesto INT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS persona (
	nif CHAR(8) PRIMARY KEY,
    nombre VARCHAR(20) NOT NULL
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS soloMiembro (
	nifSociedad CHAR(8), -- FK
	nifPersona VARCHAR(20), -- FK
    CONSTRAINT fk_soloMiembro_sociedad FOREIGN KEY (nifSociedad) REFERENCES sociedad(nif)
		ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_soloMiembro_persona FOREIGN KEY (nifPersona) REFERENCES persona(nif)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS junta (
	nifSociedad CHAR(8), -- FK
	nifPersona VARCHAR(20), -- FK
	CONSTRAINT fk_junta_sociedad FOREIGN KEY (nifSociedad) REFERENCES sociedad(nif)
		ON UPDATE CASCADE,
    CONSTRAINT fk_junta_persona FOREIGN KEY (nifPersona) REFERENCES persona(nif)
		ON UPDATE CASCADE
) ENGINE = INNODB;

SELECT * FROM soloMiembro;

ALTER TABLE soloMiembro DROP FOREIGN KEY fk_soloMiembro_sociedad;
ALTER TABLE junta DROP FOREIGN KEY fk_junta_sociedad;

ALTER TABLE sociedad DROP nif;

ALTER TABLE soloMiembro DROP nifSociedad;
ALTER TABLE junta DROP nifSociedad;

ALTER TABLE sociedad ADD PRIMARY KEY (nombre);

ALTER TABLE soloMiembro ADD nombreSociedad VARCHAR(20);
ALTER TABLE junta ADD nombreSociedad VARCHAR(20);

ALTER TABLE soloMiembro DROP FOREIGN KEY fk_soloMiembro_persona;
ALTER TABLE junta DROP FOREIGN KEY fk_junta_persona;

ALTER TABLE soloMiembro DROP PRIMARY KEY;
ALTER TABLE junta DROP PRIMARY KEY;
ALTER TABLE soloMiembro ADD PRIMARY KEY (nombreSociedad, nifPersona);
ALTER TABLE junta ADD PRIMARY KEY (nombreSociedad, nifPersona);

ALTER TABLE soloMiembro ADD CONSTRAINT fk_soloMiembro_sociedad FOREIGN KEY (nombreSociedad) REFERENCES sociedad(nombre)
	ON UPDATE CASCADE;
ALTER TABLE soloMiembro ADD CONSTRAINT fk_soloMiembro_persona FOREIGN KEY (nifPersona) REFERENCES sociedad(nif)
	ON UPDATE CASCADE;
    
ALTER TABLE junta ADD CONSTRAINT fk_junta_sociedad FOREIGN KEY (nombreSociedad) REFERENCES sociedad(nombre)
	ON UPDATE CASCADE;
ALTER TABLE junta ADD CONSTRAINT fk_junta_persona FOREIGN KEY (nifPersona) REFERENCES sociedad(nif)
	ON UPDATE CASCADE;

DESCRIBE junta;
DESCRIBE persona;
DESCRIBE sociedad;
DESCRIBE solomiembro;

/*-- Es vol saber la població de la personal.
Per fer-ho es vol tenir una taula POBLACIÓ el qual tingui el nom, província i codi postal. Utilitza el sentit comú per determinar els comportaments dels constraints en aquesta nova relació.
*/
/********************* Ejercicio 4. VENTAS **********************************************************/

CREATE DATABASE Ventas;
USE Ventas;

CREATE TABLE IF NOT EXISTS cliente (
	dni CHAR(8) PRIMARY KEY,
	nombre VARCHAR(20)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS producto (
	lote CHAR(5),
    codigo CHAR(5),
    nombre VARCHAR(20),
    stock INT,
	PRIMARY KEY (lote,codigo)
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS compra (
	clienteDNI CHAR(8), -- FK
	productoLote CHAR(5), -- FK
    productoCodigo CHAR(5), -- FK
    precio DECIMAL(6,2),
    cantidad INT,
    fecha DATE,
    PRIMARY KEY (clienteDNI,productoLote,productoCodigo),
    
	CONSTRAINT fk_compra_producto FOREIGN KEY (productoLote,productoCodigo) REFERENCES producto(lote,codigo)
		ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_compra_cliente FOREIGN KEY (clienteDNI) REFERENCES cliente(dni)
		ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE = INNODB;


/******************** Ejercicio 5. SERIES **********************************************************/

CREATE DATABASE Series;
USE Series;

CREATE TABLE IF NOT EXISTS CompañiaTv (
	nif
    nombre
) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Canal (
	nombre
    frecuencia
    pais


) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Serie (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Emite (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Actor (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Dispone (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Actuar (



) ENGINE = INNODB;



/******************** Ejercicio 4. HOSPITAL ***********************************************************/


LAS TABLAS ESTÁN POR HACER, OJO CON SUS NOMBRES.

CREATE TABLE IF NOT EXISTS CompañiaTv (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Canal (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Actor (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Serie (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Dispone (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Actua (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Emite (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Emite (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Emite (



) ENGINE = INNODB;

CREATE TABLE IF NOT EXISTS Emite (



) ENGINE = INNODB;

