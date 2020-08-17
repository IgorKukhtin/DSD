-- Function: zfConvert_StringToFloat

-- DROP FUNCTION IF EXISTS zfConvert_StringToFloat (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToFloat(Number TVarChar)
RETURNS TFloat AS
$BODY$
BEGIN
  RETURN Number :: TFloat;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToFloat (TVarChar) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 07.05.18                                        *  
*/

-- ����
-- SELECT * FROM zfConvert_StringToFloat ('TVarChar')
-- SELECT * FROM zfConvert_StringToFloat ('10')
