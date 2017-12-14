DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = 'movement_promocode_guid_seq') = 0 THEN
    CREATE SEQUENCE movement_promocode_guid_seq
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;
    ALTER TABLE movement_promocode_guid_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.    ������ �.�.
 14.12.17                                        *
*/
