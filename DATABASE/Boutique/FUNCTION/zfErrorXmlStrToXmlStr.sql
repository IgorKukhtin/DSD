-- Function: zfConvert_StringToNumber

-- DROP FUNCTION IF EXISTS zfConvert_StringToNumber (TVarChar);

CREATE OR REPLACE FUNCTION zfErrorXmlStrToXmlStr(inStr Text)
RETURNS Text AS
$BODY$
  DECLARE Res Text;
BEGIN
  -- 1. ���������� < � >. ��� ��� �� ��� ����� ������, ������ ��� ��� ������. � ���� �� ���� < �� ����� ������ ���� � >.

  Res := replace(inStr, '&', '&amp;');
  Res := replace(inStr, '''', '&apos;');
  Res := replace(inStr, '"', '&quot;');
  Res := replace(inStr, '<', '&lt;');
  Res := replace(inStr, '>', '&gt;');
  RETURN Res;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfErrorXmlStrToXmlStr (Text) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  09.02.15                        *  
*/

-- ����
-- SELECT * FROM zfConvert_StringToNumber ('TVarChar')
-- SELECT * FROM zfConvert_StringToNumber ('10')
