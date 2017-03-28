DO $$
BEGIN
      IF NOT EXISTS(SELECT 1 FROM pg_statio_all_sequences WHERE relname = 'movement_routemember_seq')
      THEN
           CREATE SEQUENCE movement_routemember_seq
           INCREMENT 1
           MINVALUE 1
           MAXVALUE 9223372036854775807
           START 1
           CACHE 1;
           ALTER SEQUENCE movement_routemember_seq
             OWNER TO postgres;
      END IF;
END $$;


/*-------------------------------------------------------------------------------
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   �������� �.�.
 27.03.17         *
*/
