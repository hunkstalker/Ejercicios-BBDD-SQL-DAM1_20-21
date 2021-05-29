create database ExamenFinalUF2;
use ExamenFinalUF2;

create table professor (
	DNI char(9),
    nom varchar(20) not null,
    cognom varchar(20) not null,
    especialitat varchar(20),
    primary key (DNI)
)engine = InnoDB;


create table modul (
	nom varchar(20),
    num tinyint,
    professorDNI char(9),
    primary key (nom),
    
    constraint fk_modul_professor foreign key (professorDNI)
		references professor(DNI)
        on update cascade
        on delete set null
		
)engine = InnoDB;


create table uf (
	nom varchar(40),
    num tinyint,
    hores tinyint,
    modulNom varchar(20),
    primary key (nom),
    
    constraint fk_uf_modul foreign key (modulNom)
		references modul(nom)
		on update cascade
        on delete cascade
)engine = InnoDB;

create table alumne (
	DNI char(9),
    nom varchar(20) not null,
    cognom varchar(20) not null,
    poblacio varchar(20),
    primary key (dni)    
    	
)engine = InnoDB;


create table cursa (
	alumneDNI char(9),

    ufNom varchar(40),
    primary key (alumneDNI, ufNom),
    
    constraint fk_cursa_alumne foreign key (alumneDNI)
		references alumne(DNI)
        on update cascade
        on delete restrict,

	constraint fk_cursa_uf foreign key (ufNom)
		references uf(nom)
        on update cascade
        on delete cascade
		
)engine = InnoDB;


create table examen (
	codi char(5),
    dataE date not null,
    ufNom varchar(20),
    primary key (codi),
    
    constraint fk_examen_uf foreign key (ufNom)
		references uf(nom)
        on update cascade
        on delete cascade
		
)engine = InnoDB;


                            
create table pregunta (
	codi char(5),
    enunciat varchar(200) not null,
    respostaCorrecta char(1) not null,
    examenCodi char(5),
    primary key (codi),
    
    constraint fk_pregunta_Examen foreign key (examenCodi)
		references examen(codi)
        on update restrict
        on delete cascade
		
)engine = InnoDB;


create table contesta (
	alumneDNI char(9),
    preguntaCodi char(5),
    respostaAlumne char(5),
    
    primary key (alumneDNI,preguntaCodi),
    
    constraint fk_contesta_alumne foreign key (alumneDNI)
		references alumne(DNI)
        on update cascade
        on delete restrict,
	constraint fk_contesta_pregunta foreign key (preguntaCodi)
		references pregunta(codi)
        on update cascade
        on delete cascade
		
)engine = InnoDB;



-- ------------------ PREGUNTES DE L'EXAMEN  ---------------


-- 1.	Mostra quantes unitats formatives per nom del mòdul i per professor (dni) de l’especialitat d’informàtica o farmacia.
-- Cal mostrar nom del mòdul, dni de professor, nom i cognom en mayúscula i total d'unitats formatives.


-- 2. Mostra quantes unitats formatives que tenen entre 10 y 100 hores, no s'han realitzat examens.


-- 3.	Quantes respostes correctes ha fet l’alumne “Pol Pérez” amb en l'examen amb codi “E001” 


-- 4.	L’alumne Susana Lòpez, ha modificat la resposta de les preguntes amb codi “P001” i "P002". Les respostes passan a ser C en els dos casos.


-- 5. Mostra aquelles unitats formatives que té 2 alumnes o més, 
-- mostrant nom del modul i la quantitat d'alumnes matriculats


-- 6.	L’alumne “Juli Pascual Gonzalez” amb 'DNI5' que no té identificada la població, va contestar “B” en la pregunta “P510” , 'Què és una xarxa LAN?',
-- de l’examen “E009” del dia 3 de febrer del 2019. La resposta correcta d’aquesta pregunta és la C. L'examen pertany al mòdul 5 de Xarxes Locals
-- unitat formativa 1 'introducció Xarxes' de 66h, que imparteix el professor 'Sergi Jimenez' amb DNI 'DNI8'. LA seva especialitat és Informàtica.

-- 7.	Quin és el total de respostes correctes de cada examen de la unitat formativa 2, 
--  del Mòdul de Base de dades del 10 d’octubre del 2019

-- 8. Mostra un llistat amb el nom dels mòduls que han fet menys examens que el modul de Base de dades.
-- Cal utilitzar una vista durant el procés de creació de la consulta.

-- 9. Realitza les instruccions necessaries per poder fer el següent procés.

-- 1. Cal inserir el professor Eric Sotelo Casanovas amb dni DNI12 de l'especialitat d'Informàtica.
-- 2. La persona que ha introduït la informació s'ha equivocat i cal canviar la especialitat a 'Administració'del professor introduït.
-- 3. Veiem que finalment, aquest professor no vol treballar a l'escola. Cal retirar les instruccions realitzades. (No utilitzar un DELETE)
-- 4. Ara sí, sabem segur que es dona d'alta el professor Santiago Colina Pérez amb dni DNI13 amb l'especialitat d'Informàtica.
-- 5. Cal asegurar que les instruccions no es puguin anular.


-- 10.	Cal eliminar les preguntes de l’examen amb codi “E002” del mòdul de Base de dades de l'alumne 'Pol Pérez' 

-- 11. L'administrador de la base de dades, s'ha donat compte que les consultes sobre la taula Alumne, solen ser sobre la població del qual pertanyen.
-- Cal que realitzis la instrucció o instruccions necessaries per tal d'optimitzar al màxim  les consultes que es realitzéssin en aquesta taula.


-- 12.	S’ha decidit modificar el tipus de exàmens que es volen emmagatzemat a la base de dades. Ja no seran només, 
-- preguntes de tipus test, sinó que haurem de poder emmagatzemar la seva resposta. Resposta alumne (abans): ‘A’
-- Resposta alumne (posterior): ‘Leonardo Da Vinci’.
-- Per seguretat, també es vol fer no es pogui actualitzar ni eliminar cap pregunta. (constraint)
-- Quines instruccions realitzaries per donar solució a això?


