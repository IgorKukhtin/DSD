-- Function: zfCalc_UserSite

DROP FUNCTION IF EXISTS zfCalc_UserSite ();

CREATE OR REPLACE FUNCTION zfCalc_UserSite()
RETURNS TVarChar
AS
$BODY$
BEGIN
     
     RETURN ('2071121');

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfCalc_UserSite () OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 06.04.16                                        *
*/

-- ����
-- SELECT * FROM Object WHERE Id = zfCalc_UserSite() :: Integer
