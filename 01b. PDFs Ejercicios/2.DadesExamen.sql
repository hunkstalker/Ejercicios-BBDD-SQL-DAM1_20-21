-- *****************************************************************************************
--  								DADES PER EXAMEN
-- *****************************************************************************************
use ExamenFinalUF2;

insert into professor values ('DNI1','Claudina','Riaza','Informàtica'), ('DNI2','David','Porti','Informàtica'),
		('DNI3','Mario','Casanova','Finances'), ('DNI4','Marta','Serra','Farmacia'),
        ('DNI5','Arnau','González','Farmacia'), ('DNI6','Jaume','Fadó','Informàtica');

insert into modul values ('Sistemes',1,'DNI6'),('Base de dades',2,'DNI2'),('Programació',3,'DNI1'),
						('Fàrmacs bàsics',1,'DNI4');

insert into uf values ('Introducció BBDD',1,66,'Base de dades'),('Llenguatge DML',2,66,'Base de dades'),
					('Windows 10',1,40,'Sistemes'),('Linux Ubuntu',2,50,'Sistemes'),
                    ('Fonaments bàsics',1,90,'Programació'),('Antibiòtics',1,70,'Fàrmacs bàsics');

insert into alumne values ('DNI1','Andreu','Garcia','Granollers'), ('DNI2','Pol','Pérez','Granollers'),
						('DNI3','Susana','Lòpez','Mollet'),('DNI4','Anastasia','Nomena','Cardedeu');
                        
insert into cursa values ('DNI1','Windows 10'), ('DNI1','Introducció BBDD'),('DNI1','Llenguatge DML'),
						('DNI1','Fonaments bàsics'),('DNI2','Windows 10'), 
                        ('DNI2','Introducció BBDD'),('DNI2','Llenguatge DML'),
						('DNI2','Fonaments bàsics'),
                        ('DNI3','Antibiòtics'),('DNI4','Antibiòtics');
                        
insert into examen values ('E001','2019-11-01','Windows 10'),('E002','2019-11-20','Introducció BBDD'),
						('E003','2019-10-10','Llenguatge DML'),('E004','2019-11-25','Fonaments bàsics');

insert into pregunta values ('P001','Enunciat 1','A','E001'), ('P002','Enunciat 2','C','E001'),
							('P003','Enunciat 3','B','E001'),('P004','Enunciat 4','C','E001'),
                            ('P101','Enunciat 1','A','E002'), ('P102','Enunciat 2','B','E002'),
							('P103','Enunciat 3','C','E002'),('P104','Enunciat 4','C','E002'),
                            ('P201','Enunciat 1','A','E003'), ('P202','Enunciat 2','A','E003'),
							('P203','Enunciat 3','D','E003'),('P204','Enunciat 4','A','E003'),
                            ('P301','Enunciat 1','C','E004'), ('P302','Enunciat 2','A','E004'),
							('P303','Enunciat 3','D','E004'),('P304','Enunciat 4','D','E004');
                            

insert into contesta values ('DNI1','P001','A'), ('DNI1','P002','A'),('DNI1','P003','A'),('DNI1','P004','A'),
							('DNI2','P001','A'), ('DNI2','P002','C'),('DNI2','P003','B'),('DNI2','P004','C'),
							('DNI3','P001','C'), ('DNI3','P002','A'),('DNI3','P003','A'),('DNI3','P004','A'),
							
							('DNI1','P101','A'), ('DNI1','P102','A'),('DNI1','P103','B'),('DNI1','P104','D'),
							('DNI2','P101','D'), ('DNI2','P102','B'),('DNI2','P103','A'),('DNI2','P104','A'),
							('DNI3','P101','A'), ('DNI3','P102','A'),('DNI3','P103','D'),('DNI3','P104','C'),
							
                            ('DNI1','P201','A'), ('DNI1','P202','A'),('DNI1','P203','A'),('DNI1','P204','A'),
							('DNI2','P201','C'), ('DNI2','P202','C'),('DNI2','P203','C'),('DNI2','P204','A'),
							('DNI3','P201','D'), ('DNI3','P202','A'),('DNI3','P203','A'),('DNI3','P204','A'),
							
                            ('DNI4','P301','C'), ('DNI4','P302','A'),('DNI4','P303','C'),('DNI4','P304','D');
						