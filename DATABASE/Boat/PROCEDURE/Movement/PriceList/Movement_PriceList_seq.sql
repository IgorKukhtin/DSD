DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = 'movement_PriceList_seq') = 0 THEN
    CREATE SEQUENCE movement_PriceList_seq
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;
    ALTER TABLE movement_PriceList_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 23.06.21         *
*/
