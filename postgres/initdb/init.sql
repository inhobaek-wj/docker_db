-- CREATE TABLE "countries" ---------------------------------------
CREATE TABLE countries (
  country_code char(2) PRIMARY KEY,
  country_name text UNIQUE
);
-- -------------------------------------------------------------


-- CREATE TABLE "cities" ---------------------------------------
CREATE TABLE cities (
  name text NOT NULL,
  postal_code varchar(9) CHECK (postal_code <> ''),
  country_code char(2) REFERENCES countries,
  PRIMARY KEY (country_code, postal_code)
);
-- -------------------------------------------------------------


-- CREATE TABLE "venues" ---------------------------------------
CREATE TABLE venues (
  venue_id SERIAL PRIMARY KEY,
  name varchar(255),
  street_address text,
  type char(7) CHECK ( type in ('public','private') ) DEFAULT 'public',
  postal_code varchar(9),
  country_code char(2),
  active boolean DEFAULT TRUE,
  FOREIGN KEY (country_code, postal_code) REFERENCES cities (country_code, postal_code) MATCH FULL
);
-- -------------------------------------------------------------


-- CREATE TABLE "events" ---------------------------------------
CREATE TABLE events (
  event_id SERIAL PRIMARY KEY,
  title varchar(255),
  starts timestamp,
  ends timestamp,
  venue_id int,
  FOREIGN KEY (venue_id) REFERENCES venues (venue_id)
);
-- -------------------------------------------------------------


-- ALTER TABLE "events" ---------------------------------------
ALTER TABLE events
ADD colors text ARRAY;
-- -------------------------------------------------------------


-- CREATE TABLE "logs" ---------------------------------------
CREATE TABLE logs (
  event_id integer,
  old_title varchar(255),
  old_starts timestamp,
  old_ends timestamp,
  logged_at timestamp DEFAULT current_timestamp
);
-- -------------------------------------------------------------


-- CREATE TABLE "genres" ---------------------------------------
CREATE TABLE genres (
  name text UNIQUE,
  position integer
);
-- -------------------------------------------------------------


-- CREATE TABLE "movies" ---------------------------------------
CREATE TABLE movies (
  movie_id SERIAL PRIMARY KEY,
  title text,
  genre cube
);
-- -------------------------------------------------------------


-- CREATE TABLE "actors" ---------------------------------------
CREATE TABLE actors (
  actor_id SERIAL PRIMARY KEY,
  name text
);
-- -------------------------------------------------------------


-- CREATE TABLE "movies_actors" ---------------------------------------
CREATE TABLE movies_actors (
  movie_id integer REFERENCES movies NOT NULL,
  actor_id integer REFERENCES actors NOT NULL,
  UNIQUE (movie_id, actor_id)
);

-- -------------------------------------------------------------


-- Dump data of "countries" -----------------------------------
BEGIN;

INSERT INTO countries (country_code, country_name) VALUES
('us','United States'),
('mx','Mexico'),
('au','Australia'),
('gb','United Kingdom'),
('de','Germany');
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "cities" -----------------------------------
BEGIN;

INSERT INTO cities VALUES
('Portland','97205','us');
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "venues" -----------------------------------
BEGIN;

INSERT INTO venues (name, postal_code, country_code) VALUES
('Crystal Ballroom', '97205', 'us'),
('Voodoo Donuts', '97205', 'us');
COMMIT;
-- ---------------------------------------------------------


-- Dump data of "events" -----------------------------------
BEGIN;

INSERT INTO events (title, starts, ends, venue_id) VALUES
('LARP Club', '2012-02-15 17:30:00', '2012-02-15 19:30:00', 2),
('April Fools Day', '2012-04-01 00:00:00', '2012-04-01 23:59:00', NULL),
('Christmas Day', '2012-12-25 00:00:00', '2012-12-25 23:59:00', NULL);
COMMIT;
-- ---------------------------------------------------------


-- CREATE INDEX "events_title" --------------------
CREATE INDEX events_title ON events USING hash (title);
-- -------------------------------------------------------------


-- CREATE INDEX "events_starts" --------------------
CREATE INDEX events_starts ON events USING btree (starts);
-- -------------------------------------------------------------


-- CREATE INDEX "movies_actors_movie_id" --------------------
CREATE INDEX movies_actors_movie_id ON movies_actors (movie_id);
-- -------------------------------------------------------------


-- CREATE INDEX "movies_actors_actor_id" --------------------
CREATE INDEX movies_actors_actor_id ON movies_actors (actor_id);
-- -------------------------------------------------------------


-- CREATE INDEX "movies_genres_cube" --------------------
CREATE INDEX movies_genres_cube ON movies USING gist (genre);
-- -------------------------------------------------------------


-- CREATE INDEX "movies_title_pattern" --------------------
CREATE INDEX movies_title_pattern ON movies (lower(title) text_pattern_ops);
-- -------------------------------------------------------------
