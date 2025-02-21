DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname ILIKE 'MI_PartionPassport_seq') = 0 THEN
    CREATE SEQUENCE MI_PartionPassport_seq
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;
    ALTER TABLE MI_PartionPassport_seq
      OWNER TO postgres;
    ALTER TABLE MI_PartionPassport_seq
      OWNER TO project;
    ALTER TABLE MI_PartionPassport_seq
      OWNER TO admin;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.02.25                                        *
*/
