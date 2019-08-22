-- Function: zfConvert_DateToWMS

DROP FUNCTION IF EXISTS zfConvert_DateToWMS (TDateTime);

CREATE OR REPLACE FUNCTION zfConvert_DateToWMS (inValue TDateTime)
RETURNS TVarChar
AS
$BODY$
BEGIN
  RETURN (TO_CHAR (inValue, 'DD-MM-YYYY'));

END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_DateToWMS (TDateTime) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 20.08.19                                        *
*/

-- ����
-- SELECT * FROM zfConvert_DateToWMS (CURRENT_DATE)
