DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = 'Movement_LoyaltySaveMoney_seq') = 0 THEN
    CREATE SEQUENCE Movement_LoyaltySaveMoney_seq
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 1
    CACHE 1;
    ALTER TABLE Movement_LoyaltySaveMoney_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 24.12.19                                                       *
 
*/
