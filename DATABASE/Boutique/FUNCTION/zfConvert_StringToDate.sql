-- Function: zfConvert_StringToDate

DROP FUNCTION IF EXISTS zfConvert_StringToDate (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToDate (Value TVarChar)
RETURNS TDateTime AS
$BODY$
BEGIN
  RETURN Value :: TDateTime;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN NULL;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToDate (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 04.06.15                                        *
*/

-- ����
-- SELECT * FROM zfConvert_StringToDate ('TVarChar')
-- SELECT * FROM zfConvert_StringToDate ('10')
-- SELECT * FROM zfConvert_StringToDate ('01.01.2015')
