-- Sequence: Movement_Transport_seq

-- DROP SEQUENCE Movement_Transport_seq;

CREATE SEQUENCE Movement_Transport_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE Movement_Transport_seq
  OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.13                                        *
*/
