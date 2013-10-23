-- Sequence: Movement_Income_seq

-- DROP SEQUENCE Movement_Income_seq;

CREATE SEQUENCE Movement_Income_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 1
  CACHE 1;
ALTER TABLE Movement_Income_seq
  OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.10.13                                        *
*/
