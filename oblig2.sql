-- Oppgave 2
--a
Select navn from planet where stjerne = 'Proxima Centauri';
--b
Select distinct oppdaget from planet where stjerne = 'TRAPPIST-1 ' or stjerne = 'Kepler-154';
--c
select count(*) from planet where masse is null;
--d
select navn,masse from planet  where masse > (select avg(masse) from planet) and oppdaget='2020';
--e
select max(oppdaget)- min(oppdaget) as diff from planet;

-- Oppgave 3
--a
select p.navn from planet as p, materie as m 
where p.navn=m.planet and  m.molekyl='H2O' and p.masse>3 and p.masse<10;

--b
select distinct p.navn from planet as p, materie as m,stjerne as s 
where s.navn = p.stjerne and m.planet=p.navn and m.molekyl like '%H%' and s.masse*12>s.avstand;

--c
select p1.navn, p2.navn from planet as p1, planet as p2, stjerne as s 
where s.navn = p1.stjerne and s.navn=p2.stjerne and p1.masse>10 and p2.masse>10 and s.avstand<50 
and p1.navn != p2.navn;

/*
oppgave 4
Natural join setter sammen de kolonnene med likt navn, sånn at bare de radene med like verdier blir værende og resten blir tatt bort.
I dette tilfellet har ikke planet og stjerne verdier som er like. Da får vi bare en tom tabell og derfor finner Nils ingen resultater i spørringen.

*/

-- Oppgave 5
--a
insert into stjerne values ('Sola',0,1 );

--b
insert into planet values ('Jorda',0.003146,NULL,'Sola' );


-- Oppgave 6
Create Table Observasjon(
Observasjons_id int primary key, 
Dato timestamp not null,
Planet text not null, 
Kommentar text);



