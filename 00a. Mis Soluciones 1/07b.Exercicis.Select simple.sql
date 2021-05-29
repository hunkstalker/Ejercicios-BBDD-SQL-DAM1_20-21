create database if not exists dbhero2;
use dbhero2;
create table if not exists planet ( 
	namep   varchar(40), 
    mass    decimal(6,2) not null,
    moons	tinyint,
    avgTemp int,
    primary key(namep)
) engine=innodb;
create table if not exists superhero(
	nameh 			varchar(40),
    planetNamep		varchar(20),
    intelligence	decimal(4,2) not null,
    strong			decimal(4,2) not null,
    primary key(nameh),
    constraint fk_superhero_planet foreign key (planetNamep) references planet(namep)
			on delete restrict
			on update cascade
) engine=innodb;
insert into planet values ("Mercury",0.06,0,150),("Venus",0.82,3,-50),("Terra",1,1,20),("Mart",0.11,12,200),
	("Jupiter",317.8,6,null),("Saturn",95.2,33,-30),("Uranus",14.6,null,null),("Neptune",17.2,8,60);
select * from planet;
insert into superhero values
("Superman","Terra",round(rand()*100,2),round(rand()*100,2)),
("Batman","Terra",round(rand()*100,2),round(rand()*100,2)),
("Spiderman","Jupiter",round(rand()*100,2),round(rand()*100,2)),
("Thor","Terra",round(rand()*100,2),round(rand()*100,2)),
("Hal Jordan",NULL,round(rand()*100,2),round(rand()*100,2)),
("Wonder Woman","Terra",round(rand()*100,2),round(rand()*100,2)),
("Captain America",NULL,round(rand()*100,2),round(rand()*100,2)),
("Martian Manhunter","Mart",round(rand()*100,2),round(rand()*100,2));

SELECT * FROM planet;
SELECT * FROM superhero;

SELECT nameh, planetnamep FROM superhero;

-- El nom de tots els superherois que tenen la màxima intel·ligència.
SELECT max(intelligence) FROM superhero;

-- Quin es el nom del superheroi que té aquella màxima intel·liegncia.
SELECT nameh, intelligence FROM superhero
	WHERE intelligence = (SELECT max(intelligence) FROM superhero);
    
-- Cerca els noms del superherois que superen la mitja de força.
SELECT AVG(strong) FROM superhero;

SELECT nameh, strong FROM superhero
	WHERE strong = (SELECT AVG(strong) FROM superhero);

-- El nom de tots els superherois que tenen la intel·ligència superior a la mitjana i estan associats al planeta Terra.
SELECT nameh, intelligence FROM superhero
	WHERE intelligence>(SELECT avg(intelligence) FROM superhero) AND planetNamep = "Terra";

-- Digues el nom dels superherois del planeta terra que tenen la intel. Superior a la mitja de la intel. Del planeta terra.
select nameh from superhero
	where planetNamep = 'Terra' and intelligence >
			(select avg(intelligence) from superhero where planetNamep = 'Terra');

-- Mostra el nom dels herois del planeta terra, namek, uranus que ténen la força inferior a 90.

