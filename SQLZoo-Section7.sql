/*
SQLZOO Section 7 More Joins
*/

--#1
/*
List the films where the yr is 1962 [Show id, title]
*/

SELECT id, title
FROM movie
WHERE yr=1962;

--#2
/*
Give year of 'Citizen Kane'.
*/

SELECT yr
FROM movie
WHERE title = 'Citizen Kane';

--#3
/*
List all of the Star Trek movies, include the id, title and yr (all of these movies include the words Star Trek in the title). Order results by year.
*/

SELECT id, title, yr
FROM movie
WHERE title LIKE 'Star Trek%';

--#4
/*
What id number does the actor 'Glenn Close' have?
*/

SELECT id
FROM actor
WHERE name = 'Glenn Close';

--#5
/*
What is the id of the film 'Casablanca'
*/

SELECT id
FROM movie
WHERE title = 'Casablanca';

--#6
/*
Obtain the cast list for 'Casablanca'.
what is a cast list?
Use movieid=11768, (or whatever value you got from the previous question)
*/

SELECT name
FROM actor JOIN casting ON (id=actorid)
WHERE movieID = 11768;

--#7
/*
Obtain the cast list for the film 'Alien'
*/

SELECT name
FROM actor a JOIN casting c ON (a.id=c.actorid) JOIN movie m ON (m.id=c.movieid)
WHERE m.title = 'Alien';

--#8
/*
List the films in which 'Harrison Ford' has appeared
*/

SELECT m.title
FROM movie m JOIN casting c ON (m.ID=c.movieID) JOIN actor a ON (a.ID=c.actorID)
WHERE a.name = 'Harrison Ford';

--#9
/*
List the films where 'Harrison Ford' has appeared - but not in the starring role. [Note: the ord field of casting gives the position of the actor. If ord=1 then this actor is in the starring role]
*/

SELECT m.title
FROM movie m JOIN casting c ON (m.ID=c.movieID) JOIN actor a ON (a.ID=c.actorID)
WHERE a.name = 'Harrison Ford' AND c.ord <> 1;

--#10
/*
List the films together with the leading star for all 1962 films.
*/

SELECT m.title,a.name
FROM movie m JOIN casting c ON(m.id=c.movieid) JOIN actor a ON (a.id=c.actorid)
WHERE yr = 1962 AND ord = 1;

--#11
/*
Which were the busiest years for 'John Travolta', show the year and the number of movies he made each year for any year in which he made more than 2 movies.
*/

SELECT yr,COUNT(title) FROM
movie m JOIN casting c ON m.id=movieid JOIN actor a ON actorid=a.id
WHERE name='John Travolta'
GROUP BY yr
HAVING COUNT(title)=(SELECT MAX(ca) FROM
(SELECT yr,COUNT(title) AS ca FROM
movie JOIN casting c ON m.id=movieid
JOIN actor a ON actorid=a.id
WHERE name='John Travolta'
GROUP BY yr) AS t
);

--#12
/*
List the film title and the leading actor for all of the films 'Julie Andrews' played in.
Did you get "Little Miss Marker twice"?
*/

SELECT title,name
FROM movie JOIN casting ON (movieid=movie.id
AND ord=1)
JOIN actor ON (actorid=actor.id)
WHERE movie.id IN (
SELECT movieid FROM casting
WHERE actorid IN (
SELECT id FROM actor
WHERE name='Julie Andrews'));

--#13
/*
Obtain a list, in alphabetical order, of actors who've had at least 30 starring roles.
*/

SELECT name
FROM actor JOIN casting ON actor.id=casting.actorid
WHERE ord = 1
GROUP BY name
HAVING COUNT(*) >= 30;

--#14
/*
List the films released in the year 1978 ordered by the number of actors in the cast, then by title.
*/

SELECT title, COUNT(actorid)
FROM movie JOIN casting ON movie.id=casting.movieid
WHERE yr = 1978
GROUP BY title
ORDER BY COUNT(actorid) DESC,title;

--#15
/*
List all the people who have worked with 'Art Garfunkel'.
*/

SELECT a.name
FROM (SELECT movie.*
FROM movie JOIN casting ON casting.movieID=movie.id
JOIN actor ON actor.id=casting.actorid
WHERE actor.name = 'Art Garfunkel') AS m
JOIN (SELECT actor.*,casting.movieid
FROM actor JOIN casting ON casting.actorid=actor.id
WHERE actor.name <> 'Art Garfunkel') AS a
ON m.id=a.movieid;






