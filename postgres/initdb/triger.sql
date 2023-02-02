
-- CREATE TRIGGER "log_events" ---------------------------------------
CREATE TRIGGER log_events
  AFTER UPDATE ON events
  FOR EACH ROW EXECUTE PROCEDURE log_event();
-- -------------------------------------------------------------
