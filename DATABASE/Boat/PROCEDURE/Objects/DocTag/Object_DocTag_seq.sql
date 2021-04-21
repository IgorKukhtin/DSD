DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = LOWER('Object_DocTag_seq')) = 0 THEN 
    CREATE SEQUENCE Object_DocTag_seq 
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;  
    ALTER SEQUENCE Object_DocTag_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.04.21         *
*/
