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
