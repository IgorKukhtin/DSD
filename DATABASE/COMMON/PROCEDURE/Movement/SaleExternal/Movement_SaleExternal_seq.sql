DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = 'movement_SaleExternal_seq') = 0 THEN
    CREATE SEQUENCE movement_SaleExternal_seq
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;
    ALTER TABLE movement_SaleExternal_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
31.10.20          *

*/
