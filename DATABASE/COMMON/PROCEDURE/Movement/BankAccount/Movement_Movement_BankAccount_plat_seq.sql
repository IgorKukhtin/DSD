DO $$
BEGIN
  -- для платежки
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname ILIKE 'movement_bankaccount_plat_seq') = 0 THEN
    CREATE SEQUENCE movement_bankaccount_plat_seq
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 10001
    CACHE 1;
    ALTER TABLE movement_bankaccount_plat_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А.
 07.05.14                                        *
*/
