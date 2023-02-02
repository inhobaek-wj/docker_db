
-- CREATE VIEW "holidays" ---------------------------------------
CREATE VIEW holidays AS
  SELECT event_id AS holiday_id, title AS name, starts AS date, colors
  FROM events
  WHERE title LIKE '%Day%'
  AND venue_id IS NULL;
-- -------------------------------------------------------------


-- CREATE RULE "update_holidays" ---------------------------------------
CREATE RULE update_holidays AS ON UPDATE TO holidays DO INSTEAD
  UPDATE events
  SET title = NEW.name,
      starts = NEW.date,
      colors = NEW.colors
  WHERE title = OLD.name;
-- -------------------------------------------------------------

