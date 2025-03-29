-- Function: lpGetUserBySession (TVarChar)

DROP FUNCTION IF EXISTS lpGetUserBySession (TVarChar);

CREATE OR REPLACE FUNCTION lpGetUserBySession (
    IN inSession TVarChar
)
RETURNS Integer
AS
$BODY$  
BEGIN

     IF inSession = '1234551'
     THEN
         RAISE EXCEPTION '������.';
     END IF;
     

     IF inSession <> ''
     THEN RETURN to_number (inSession, '00000000000');   
     ELSE RETURN 0;
     END IF;

END;$BODY$
  LANGUAGE plpgsql IMMUTABLE;
ALTER FUNCTION lpGetUserBySession (TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.
 11.02.14                                        * check inSession <> ''
*/

-- ����
-- SELECT * FROM lpGetUserBySession (inSession:= zfCalc_UserAdmin())
