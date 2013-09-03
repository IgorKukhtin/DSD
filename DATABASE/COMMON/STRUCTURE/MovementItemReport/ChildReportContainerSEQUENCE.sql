-- Sequence: childreportcontainer_id_seq

-- DROP SEQUENCE childreportcontainer_id_seq;

CREATE SEQUENCE childreportcontainer_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 16
  CACHE 1;
ALTER TABLE childreportcontainer_id_seq
  OWNER TO postgres;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.09.13                                        *
*/
