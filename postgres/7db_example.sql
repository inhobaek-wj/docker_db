SELECT '1'::cube;

SELECT * FROM pg_extension;

SELECT * FROM pg_class;

SELECT venue_id, count(*)
  OVER (PARTITION BY venue_id)
FROM events
ORDER BY venue_id;

SELECT add_event('House Party', '2012-05-03 23:00', '2012-05-04 02:00', 'Run''s House', '97205', 'us');

UPDATE events
SET ends='2012-05-04 01:00:00'
WHERE title='House Party';

UPDATE holidays SET colors = '{"red","green"}'
WHERE name = 'Christmas Day';

SELECT extract(year from starts) as year, extract(month from starts) as month, count(*)
FROM events
GROUP BY year, month;

CREATE TEMPORARY TABLE month_count(month INT);
INSERT INTO month_count VALUES (1),(2),(3),(4),(5),(6),(7),(8),(9),(10),(11),(12);

SELECT * FROM crosstab(
    'SELECT extract(year from starts) as year,
        extract(month from starts) as month, count(*)
    FROM events
    GROUP BY year, month',
    'SELECT * FROM month_count'
) AS (
  year int,
  jan int, feb int, mar int, apr int, may int, jun int, jul int, aug int, sep int, oct int, nov int, dec int
) ORDER BY YEAR;

SELECT * FROM crosstab(
    'SELECT extract(year from starts) as year,
        extract(month from starts) as month, count(*)
    FROM events
    GROUP BY year, month',
    'SELECT generate_series(1, 12)'
) AS (
year int,
jan int, feb int, mar int, apr int, may int, jun int, jul int, aug int, sep int, oct int, nov int, dec int
) ORDER BY YEAR;

SELECT * FROM crosstab(
    'WITH cte1 AS
    (
      SELECT t.d1::DATE
      FROM GENERATE_SERIES
           (
             TIMESTAMP ''2012-02-01'',
             TIMESTAMP ''2012-02-28'',
             INTERVAL  ''7 DAY''
           ) AS t(d1)
    ),
    cte2 AS
    (
      SELECT extract(WEEK from starts) as week2
      FROM events
      WHERE extract(month from starts) = 2
    )
    SELECT extract(WEEK from d1) as week, extract(dow from starts) as dow, CASE WHEN extract(WEEK from d1) = week2 THEN count(*) ELSE NULL END as cnt
    FROM events, cte1, cte2
    WHERE extract(month from starts) = 2
    GROUP BY week, week2, dow',
    'SELECT generate_series(0, 6)'
) AS (
  week int,
  sun int, mon int, tue int, wed int, thu int, fri int, sat int
) ORDER BY week;


SELECT COUNT(*) FROM movies WHERE title !~* '^the.*';

SELECT movie_id, title FROM movies
WHERE levenshtein(lower(title), lower('a hard day nght')) <= 3;

SELECT show_trgm('Avatar');

CREATE INDEX movies_title_trigram ON movies USING gist (title gist_trgm_ops);

SELECT *
FROM movies
WHERE title % 'Avatre';

SELECT title
FROM movies
WHERE title @@ 'night & day';
SELECT title
FROM movies
WHERE to_tsvector(title) @@ to_tsquery('english', 'night & day');

SELECT to_tsvector('A Hard Day''s Night'), to_tsquery('english', 'night & day');

SELECT to_tsvector('english', 'A Hard Day''s Night');
SELECT to_tsvector('simple', 'A Hard Day''s Night');

SELECT ts_lexize('english_stem', 'Day''s');
SELECT to_tsvector('german', 'was machst du gerade?');

CREATE INDEX movies_title_searchable ON movies USING gin(to_tsvector('english', title));

EXPLAIN
SELECT *
FROM movies
WHERE title @@ 'night & day';

EXPLAIN
SELECT *
FROM movies
WHERE to_tsvector('english',title) @@ 'night & day';

SELECT name, dmetaphone(name), dmetaphone_alt(name), metaphone(name, 8), soundex(name)
FROM actors;

SELECT title
FROM movies NATURAL JOIN movies_actors NATURAL JOIN actors 
WHERE metaphone(name, 6) = metaphone('Broos Wils', 6);

SELECT name, cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) as score
FROM genres g
WHERE cube_ur_coord('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)', position) > 0;

SELECT *, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist
FROM movies ORDER BY dist;

SELECT cube_enlarge('(1, 1)', 1, 2);

SELECT title, cube_distance(genre, '(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)') dist 
FROM movies
WHERE cube_enlarge('(0,7,0,0,0,0,0,0,0,7,0,0,0,0,10,0,0,0)'::cube, 5, 18) @> genre 
ORDER BY dist;

SELECT m.movie_id, m.title
FROM movies m, (SELECT genre, title FROM movies WHERE title = 'Mad Max') s 
WHERE cube_enlarge(s.genre, 5, 18) @> m.genre AND s.title <> m.title
ORDER BY cube_distance(m.genre, s.genre)
LIMIT 10;
