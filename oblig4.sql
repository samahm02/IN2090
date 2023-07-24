--oppgave 1
select per.firstname, per.lastname, c.filmcharacter
from film as f inner join filmparticipation as p using (filmid) 
inner join person as per using (personid) inner join filmcharacter as c using (partid)
where f.title = 'Star Wars' and p.parttype='cast';


--oppgave 2
select country, count(*) as l
from filmcountry
group by country
order by l desc;

--oppgave 3
select country, avg(CAST(r.time AS int))
from runningtime as r
where time ~ '^\d+$' and country is not null
group by country
having count(r.time)>=200;

--oppgave 4
select f.filmid, f.title, count(*) as l
from film as f inner join filmgenre as g using (filmid)
group by f.filmid,f.title
order by l desc,f.title,f.filmid
limit 10;

--oppgave 5
select c.country, count(*) as nr_of_movies, avg(r.rank) as rank, max(genre) as popular_genre
from filmcountry as c inner join filmrating as r using (filmid) inner join filmgenre as g using (filmid)
group by c. country;
-- får 2 rader for lite (170)

--oppgave 6
with
person1 as (select * from person inner join filmparticipation using (personid) join filmcountry as c using (filmid)
where c.country='Norway'),
person2 as (select * from person inner join filmparticipation using (personid) join filmcountry as c using (filmid)
where c.country='Norway')
select  p1.firstname || ' ' || p1.lastname as navn1, p2.firstname || ' ' || p2.lastname as navn2
from person1 as p1 inner join person2 as p2 using (filmid) join filmitem as fi using (filmid)
where p1!=p2 AND fi.filmtype='C' AND p1.personid<p2.personid
group by p1.firstname,p1.lastname,p2.firstname,p2.lastname
having count(*)>=40;


--oppgave 7
select title, prodyear
from film
left join filmgenre using (filmid)
left join filmcountry using (filmid)
where (title like '%Dark%' or title like '%Night%') and (genre = 'Horror' or country = 'Romania')
group by title, prodyear
order by title, prodyear;


--oppgave 8
select f.title, f.prodyear, count(*)
from film as f left join filmparticipation using (filmid)
where f.prodyear>=2010
group by f.title, f.prodyear
having count(*)<=2;

--oppgave 9   
select count(*)
from film join filmgenre as g using (filmid)
where g.genre!='Sci-Fi' or g.genre!='Horror';

-- tar bare med filmer som har sjanger, men ikke som er sci-fi eller horror

--oppgave 10
with
hoyr as (select *
from film as f join filmrating as r using (filmid)
join filmitem as fi using (filmid)
left join filmlanguage as l using (filmid)
where r.votes>1000 and r.rank>8 and fi.filmtype='C')

(select h.title, count(*) as l
from hoyr as h
group by h.title,h.rank,h.votes
order by h.rank,h.votes
limit 10)
union
(select h.title, count(*) as l
from hoyr as h join filmparticipation as fp using (filmid)
join person as p using (personid)
where p.firstname='Harrison' and p.lastname='Ford'
group by h.title)
union
(select h.title, count(*) as l
from hoyr as h join filmgenre as g using (filmid)
where g.genre='Comedy' or g.genre='Romance'
group by h.title);
-- ut i fra resultatet så får jeg med ingen filmer uten språk og får bare 116 rader


--denne under får med filmer uten språk, men får fremdeles bare 116 rader
with
hoyr as (select *
from filmrating as r join filmitem as fi using (filmid)
where r.votes>1000 and r.rank>8 and fi.filmtype='C')

(select f.title, count(s.language) as l
from hoyr as h join film as f using (filmid)
left join filmlanguage as s using (filmid)
group by f.title,h.rank,h.votes
order by h.rank,h.votes
limit 10)
union
(select f.title, count(s.language) as l
from hoyr as h join film as f using (filmid)
left join filmlanguage as s using (filmid)
join filmparticipation as fp using (filmid)
join person as p using (personid)
where p.firstname='Harrison' and p.lastname='Ford'
group by f.title)
union
(select f.title, count(s.language) as l
from hoyr as h join film as f using (filmid)
left join filmlanguage as s using (filmid)
join filmgenre as g using (filmid)
where g.genre='Comedy' or g.genre='Romance'
group by f.title);