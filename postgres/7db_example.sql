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
