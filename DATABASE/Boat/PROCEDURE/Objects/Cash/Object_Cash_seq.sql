DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = LOWER('Object_Cash_seq')) = 0 THEN 
    CREATE SEQUENCE Object_Cash_seq 
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;  
    ALTER SEQUENCE Object_Cash_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 03.02.21         *
*/
