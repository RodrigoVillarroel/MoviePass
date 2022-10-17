create database MP;

use MP;

drop database MP;

-- #######################################  PERFILUSERS  ##############################################

create table perfilUsers(
    id_perfil integer auto_increment primary key,
    user_name varchar(50) unique not null,
    firstName varchar(50) not null,
    lastName varchar(50) not null,
    dni integer unique not null
);

/*drop table perfilUsers;*/
select * from perfilusers;

-- #######################################  ROL  ##############################################

create table rol(
    id_rol int primary key,
    name_description varchar(50) unique not null
);

/*drop table rol;*/
select * from rol;

-- #######################################  USERS  ##############################################

create table users(
id_user integer auto_increment primary key,
email varchar(50) not null,
password varchar (50) not null,
id_perfilUser integer not null,
id_rol integer not null,
constraint fk_id_perfilUser foreign key(id_perfilUser) references perfilUsers(id_perfil),
constraint fk_id_rol foreign key(id_rol) references rol(id_rol));

/*drop table users;*/
select * from users;

insert into rol(id_rol,name_description) values(1,'CLIENTE'),(2,'ADMINISTRADOR');
select * from rol;
insert into perfilusers(user_name,firstName,lastName,dni) value('Rodri_07','Rodrigo','Villarroel',39809917);
insert into users(email,password,id_perfilUser,id_rol) value('rodrigo_villarroel@outlook.com',123456,1,2);

select * from perfilusers;
select * from users;

-- #######################################  Movies  ##############################################

create table Movies(
    id_Movie integer primary key,
    title_Movie varchar(50),
    image blob,
    lenght int,
    lenguage varchar(50)
);

/*drop table Movies;*/
select * from movies;

-- #######################################  Genders  ##############################################

create table Genders(
    id_Gender integer primary key,
    name_Gender varchar(50)
);

/*drop table Genders;*/

select * from Genders;
-- #######################################  GendersXMovies  ##############################################

create table GendersXMovies(
    id_Gender integer,
    id_Movie integer,
    constraint pk_GendersXMovies primary key(id_Movie,id_Gender),
    constraint fk_id_Gender foreign key(id_Gender) references Genders(id_Gender),
    constraint fk_id_Movie foreign key(id_Movie) references Movies(id_Movie)
);

/*drop table GendersXMovies;*/


-- #######################################  Cinemas  ##############################################

Create table Cinemas(
    id_cinema integer auto_increment primary key,
    adress varchar(50) not null,
    namee varchar(50) not null,
    price_ticket integer not null
);


select count(id_cinema) from Cinemas;


/*SELECT c.capacity from cinemas c - count(t.nro_entrada) FROM Ticket t JOIN Showings s ON s.id_Showing = t.id_Showing WHERE (s.id_Showing = :id_Showing);*/

drop table Cinemas;
select * from Cinemas;

-- #######################################  Room  ##############################################

create table Room(
idRoom integer auto_increment primary key,
nombre varchar(50) not null,
capacidad integer not null,
id_Cine integer not null,
constraint foreign key fk_id_Cine(id_Cine) references Cinemas(id_cinema)
);
select * from Room;
drop table room;

-- #######################################  Turns  ##############################################


create table Turns(
id_turno integer auto_increment primary key,
hr_start time not null,
hr_finish time not null);

select * from turns;

-- #######################################  Showings  ##############################################

create table Showings(
    id_Showing integer auto_increment primary key,
    day date not null,
    id_turno integer,
    idMovie integer,
	idRoom integer,
    constraint fk_id_turno foreign key(id_turno) references turns(id_turno),
    constraint fk_id_Room foreign key(idRoom) references Room(idRoom),
    constraint fk_id_Movie foreign key(idMovie) references Movies(id_Movie)
);

drop table Showings;
select * from showings;




select * from users;
select * from perfilusers;

-- #######################################  Ticket  ##############################################


create table Ticket(
nro_entrada integer auto_increment primary key,
qr varchar(50) not null,
id_Showing integer not null,
id_Buy integer not null,
constraint fk_id_Showing foreign key(id_Showing) references showings(id_Showing),
constraint fk_id_Buy foreign key(id_Buy) references Buy(id_Buy)
);
drop table ticket;

select * from ticket;
select count(nro_entrada) from ticket where ticket.id_Showing =1;

-- #######################################  Buy  ##############################################


create table Buy(
id_Buy integer auto_increment primary key,
quantity_ticket int not null,
discount integer not null,
days date,
total integer,
id_Pay integer,
id_User integer not null,
constraint fk_id_Pay foreign key(id_Pay) references PayTC(id_Pay),
constraint fk_id_User foreign key(id_User) references users(id_user)
);

drop table buy;
select * from Buy;
-- #######################################  CreditAccount  ##############################################

create table CreditAccount(
id_CreditAccount integer primary key,
company varchar(50));
-- #######################################  PayTC  ##############################################


create table PayTC(
id_Pay integer auto_increment primary key,
cod_aut integer not null,
days date not null,
total float not null,
id_CreditAccount integer not null,
constraint fk_id_CreditAccount foreign key(id_CreditAccount) references CreditAccount(id_CreditAccount)
);

select * from paytc;


drop procedure `CountQuantityForMovieXTurnXCinema`;
DELIMITER //
CREATE PROCEDURE `CountQuantityForMovieXTurnXCinema` (in movie int,in turn int,in roomm int)
BEGIN
    select r.capacidad - count(t.nro_entrada) as cant from Showings s
	inner join Ticket t
	on s.id_Showing = t.id_Showing
    inner join room r
    on r.idRoom = s.idRoom
	where s.idMovie = movie and s.id_turno = turn and s.idRoom = roomm;
END //

call CountQuantityForMovieXTurnXCinema(475557,1,1);


DELIMITER //
CREATE PROCEDURE `CountQuantity` (in idShowing int)
BEGIN
    select r.capacidad - count(t.nro_entrada) as cant from Showings s
	inner join Ticket t
	on s.id_Showing = t.id_Showing
    inner join room r
    on r.idRoom = s.idRoom
	where s.id_Showing = idShowing;
END //


DELIMITER //
CREATE PROCEDURE `Total` (in idShowing int)
BEGIN
    select sum(b.total) as total from showings s
	inner join Ticket t
	on t.id_Showing = s.id_Showing 
    inner join Buy b
    on  t.id_Buy = b.id_Buy
	where s.id_Showing = 1;
END //



call CountQuantity(2);


select ifnull(m.id_Movie,'a') as id from Movies m
where m.id_Movie = 475557;

select r.capacidad - count(t.nro_entrada) as cant from Showings s
	inner join Ticket t
	on s.id_Showing = t.id_Showing
    inner join room r
    on r.idRoom = s.idRoom
	where s.idMovie = 475557 and s.id_turno = 1 and s.idRoom = 1;

call CountQuantityForMovieXTurnXCinema(475557,1,1);

select * from Showings;

insert into rol(id_rol,name_description) values (1,'CLIENT'),(2,'ADMINISTRATOR');

insert into perfilusers(user_name,firstName,lastName,dni) value('ADMIN','Rodrigo','Villarroel',39809917);
insert into users(email,password,id_rol,id_perfilUser) value('rodrigo_villarroel@outlook.com',123456,2,2);


select * from perfilUsers;
select * from rol;
select * from users;
select * from movies;
select * from genders;
select * from gendersxmovies;
select * from cinemas;
select * from Showings;



select * from Cine;
select * from Salas;



/*drop table movies;*/
/*drop table genders;*/
/*drop table gendersxmovies;*/

select * from Movies;
select * from Genders;
select * from GendersXMovies;

select c.capacity from cinemas c;

select count(t.nro_entrada) 
from ticket t
inner join showings s
on s.id_Showing = t.id_Showing
where s.id_Showing =2;

drop procedure `CountQuantityForMovie`;

DELIMITER //
CREATE PROCEDURE `CountQuantityForMovie` (in Valuee int)
BEGIN
	select count(t.nro_entrada) from Ticket t
	inner join Showings s
	on s.id_Showing = t.id_Showing 
	where s.idMovie = Valuee;
END //

DELIMITER //
CREATE PROCEDURE `CountQuantityForCinema` (in Valuee int)
BEGIN
	select count(t.nro_entrada) from Ticket t
	inner join Showings s
	on s.id_Showing = t.id_Showing 
	where s.idCine = Valuee;
END //

DELIMITER //
CREATE PROCEDURE `CountQuantityForTurn` (in Valuee int)
BEGIN
	select count(t.nro_entrada) from Ticket t
	inner join Showings s
	on s.id_Showing = t.id_Showing 
	where s.id_turno = Valuee;
END //



call CountQuantityForMovie(475557);
call CountQuantityForCinema(1);
call CountQuantityForTurn(1);

DELIMITER //
CREATE PROCEDURE `CountMoneyForMovie` (in Valuee int)
BEGIN
    select sum(b.total) from buy b
	inner join ticket t
	on t.id_Buy = b.id_Buy 
	inner join showings s
	on t.id_Showing = s.id_Showing
	where s.idMovie = valuee;
END //
-- --------------------------------------------------------------------------------


-- ---------------------------------------------------------------------------------

call CountQuantityForMovieXTurnXCinema(475557,1,1);
		select * from ticket;
        
        
DELIMITER //
CREATE PROCEDURE `CountMoneyForCinema` (in Valuee int)
BEGIN
    select sum(b.total) from buy b
	inner join ticket t
	on t.id_Buy = b.id_Buy 
	inner join showings s
	on t.id_Showing = s.id_Showing
	where s.idCine = valuee;
END //

DELIMITER //
CREATE PROCEDURE `CountMoneyForTurn` (in Valuee int)
BEGIN
    select sum(b.total) from buy b
	inner join ticket t
	on t.id_Buy = b.id_Buy 
	inner join showings s
	on t.id_Showing = s.id_Showing
	where s.id_turno = valuee;
END //


call CountMoneyForMovie(475557);
call CountMoneyForCinema(1);
call CountMoneyForTurn(4);

select count(t.nro_entrada) from ticket t
inner join showings s
on s.id_Showing = t.id_Showing 
where s.idMovie = 475557;

select count(t.nro_entrada) from ticket t
inner join showings s
on s.id_Showing = t.id_Showing 
where s.idCine = 2;

select count(t.nro_entrada) from ticket t
inner join showings s
on s.id_Showing = t.id_Showing 
where s.id_turno = 3;

select sum(b.total) from buy b
inner join ticket t
on t.id_Buy = b.id_Buy 
inner join showings s
on t.id_Showing = s.id_Showing
where s.idMovie = 475557;

select sum(b.total) from buy b
inner join ticket t
on t.id_Buy = b.id_Buy 
inner join showings s
on t.id_Showing = s.id_Showing
where s.idCine = 1;

select sum(b.total) from buy b
inner join ticket t
on t.id_Buy = b.id_Buy 
inner join showings s
on t.id_Showing = s.id_Showing
where s.id_turno = 1;

select t.nro_entrada,t.qr,s.day,c.namee,c.adress,m.title_Movie,tur.hr_start 
from ticket t
inner join showings s 
on s.id_Showing = t.id_Showing
inner join cinemas c
on s.idCine = c.id_cinema
inner join movies m
on m.id_Movie = s.idMovie
inner join turns tur 
on tur.id_turno = s.id_turno;
drop procedure `GetAllByIdUser`;
DELIMITER // 
create procedure `GetAllByIdUser`(in id integer)
BEGIN
select * from ticket t
inner join buy b
on b.id_Buy = t.id_Buy
where id_User = id
group by t.id_Buy;
END //

call GetAllByIdUser(2);

select * from Buy;

DELIMITER //
create procedure `GetAllTicketByIdBuy`(in id integer)
BEGIN
select c.namee, r.nombre, m.title_Movie, s.day ,t.hr_start,ti.id_Buy from ticket ti
inner join showings s
on s.id_Showing = ti.id_Showing
inner join turns t
on s.id_turno = t.id_turno
inner join movies m
on m.id_Movie = s.idMovie
inner join room r
on s.idRoom = r.idRoom
inner join cinemas c
on r.id_Cine = c.id_cinema
where ti.id_Buy = id;
END //

call GetAllTicketByIdBuy(28);

DELIMITER //
Create Procedure `ShowingForDays` (in days date, in endDay date)
BEGIN
	select * from showings s
    where s.day between days and endDay;
END //

call ShowingForDays('2019-11-20','2019-11-26');


truncate table cinemas;
truncate table room;
truncate table showings;
truncate table ticket;
truncate table paytc;
truncate table buy;
