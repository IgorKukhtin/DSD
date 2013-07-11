-- Sequence: objectcost_id_seq

-- DROP SEQUENCE objectcost_id_seq;

CREATE SEQUENCE objectcost_id_seq
  INCREMENT 1
  MINVALUE 1
  MAXVALUE 9223372036854775807
  START 16
  CACHE 1;
ALTER TABLE objectcost_id_seq
  OWNER TO postgres;

/*
 ПРИМЕЧАНИЯ:
 ИСТОРИЯ РАЗРАБОТКИ:
 ДАТА         АВТОР
 ----------------
                 Климентьев К.И.   Кухтин И.В.
11.07.13                                *      
*/
