
create table persons (
	id INTEGER
		GENERATED BY DEFAULT AS IDENTITY 
			(start with 11903874)
		constraint pk_persons primary key,
	name varchar2(150) not null,
	birthdate date null
);

create table movies (
	id INTEGER
		GENERATED BY DEFAULT AS IDENTITY 
			(start with 8079269)
		constraint pk_movies primary key,
	title varchar2(300) not null,
	year smallint not null,
	duration smallint null,
	synopsis varchar2(1000) null,
	poster_uri varchar2(300) null,
	color varchar2(20) null,
	pg varchar2(15) null,
	director_id integer null,
	constraint uniq_movies UNIQUE(title, year),
	constraint chk_movies_year CHECK(year >= 1850)
);

create table play(
	movie_id integer not null,
	actor_id integer not null,
	role varchar2(100),
	constraint pk_play primary key(movie_id, actor_id)
);

create table have_genre(
	movie_id integer not null,
	genre varchar2(20) not null,
	constraint pk_have_genre primary key(movie_id, genre)
);

alter table movies add constraint fk_movies_director 
	FOREIGN KEY (director_id)
	references persons(id);
alter table play add constraint FK_PLAY_MOVIE 
	FOREIGN KEY (movie_id)
	references movies(id);
alter table play add constraint FK_PLAY_ACTOR 
	FOREIGN KEY (actor_id)
	references persons(id);
alter table have_genre add constraint FK_HAVE_GENRE 
	FOREIGN KEY (movie_id)
	references movies(id);


