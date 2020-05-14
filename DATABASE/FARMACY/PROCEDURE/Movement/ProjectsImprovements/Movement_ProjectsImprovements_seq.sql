DO $$
BEGIN
  IF (SELECT COUNT(*) from pg_statio_all_sequences where relname = 'movement_ProjectsImprovements_seq') = 0 THEN 
    CREATE SEQUENCE Movement_ProjectsImprovements_seq 
    INCREMENT 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    START 101
    CACHE 1;  
    ALTER TABLE Movement_ProjectsImprovements_seq
      OWNER TO postgres;
  END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 12.05.20                                                       *
*/
