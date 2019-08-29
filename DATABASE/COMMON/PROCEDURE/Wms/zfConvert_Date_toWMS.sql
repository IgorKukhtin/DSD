-- Function: zfConvert_Date_toWMS

DROP FUNCTION IF EXISTS zfConvert_Date_toWMS (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_Date_toWMS (inValue TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (TO_CHAR (inValue, 'DD-MM-YYYY'));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_Date_toWMS (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19                                        *
*/

-- ����
-- SELECT * FROM zfConvert_Date_toWMS (CURRENT_DATE)
