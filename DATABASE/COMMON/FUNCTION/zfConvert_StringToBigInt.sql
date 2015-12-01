-- Function: zfConvert_StringToBigInt

-- DROP FUNCTION IF EXISTS zfConvert_StringToBigInt (TVarChar);

CREATE OR REPLACE FUNCTION zfConvert_StringToBigInt (Number TVarChar)
RETURNS BigInt AS
$BODY$
BEGIN
  RETURN Number :: BigInt;
EXCEPTION
  WHEN OTHERS THEN	
     RETURN 0;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfConvert_StringToBigInt (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
 01.12.15                                        *
*/

-- ����
-- SELECT * FROM zfConvert_StringToBigInt ('TVarChar')
-- SELECT * FROM zfConvert_StringToBigInt ('98635287405961')
