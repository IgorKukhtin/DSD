-- Function: zfStrToXmlStr

DROP FUNCTION IF EXISTS zfStrToXmlStr (TVarChar);
DROP FUNCTION IF EXISTS zfStrToXmlStr (Text);

CREATE OR REPLACE FUNCTION zfStrToXmlStr(inStr Text)
RETURNS Text AS
$BODY$
  DECLARE Res Text;
BEGIN
  Res := replace(inStr, '&', '&amp;');
  Res := replace(Res, '''', '&apos;');
  Res := replace(Res, '"', '&quot;');
  Res := replace(Res, '<', '&lt;');
  Res := replace(Res, '>', '&gt;');
  RETURN Res;
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
-- ALTER FUNCTION zfStrToXmlStr (Text) OWNER TO postgres;


/*-------------------------------------------------------------------------------*/
/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.
  09.02.15                        *  
*/

-- ����
-- SELECT * FROM zfStrToXmlStr ('TVarChar')
-- SELECT * FROM zfStrToXmlStr ('10')
