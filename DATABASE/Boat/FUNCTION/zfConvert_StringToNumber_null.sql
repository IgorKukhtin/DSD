-- Function: zfConvert_StringToNumber_null

-- DROP FUNCTION IF EXISTS zfConvert_StringToNumber_null (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToNumber_null(Number TVarChar)
RETURNS Integer AS
$BODY$
BEGIN
  RETURN NULLIF (COALESCE (Number :: Integer, 0), 0);
EXCEPTION
  WHEN OTHERS THEN	
     RETURN NULL;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 22.01.24                                        *  
*/

-- ����
-- SELECT * FROM zfConvert_StringToNumber_null ('TVarChar')
-- SELECT * FROM zfConvert_StringToNumber_null ('10')
