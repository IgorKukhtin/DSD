-- Function: zfConvert_StringToFloat

DROP FUNCTION IF EXISTS zfConvert_StringToFloat (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToFloat (Number TVarChar)
RETURNS NUMERIC (16, 8)
AS
$BODY$
BEGIN
  RETURN Number :: NUMERIC (16, 8);
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.18                                        *  
*/

-- ����
-- SELECT * FROM zfConvert_StringToFloat ('TVarChar')
-- SELECT * FROM zfConvert_StringToFloat ('10')
