-- Function: zfConvert_StringToNumber

-- DROP FUNCTION IF EXISTS zfConvert_StringToNumber (TVarChar);

CREATE OR REPLACE FUNCTION zfErrorXmlStrToXmlStr(inStr Text)
RETURNS Text AS
$BODY$
  DECLARE Res Text;
BEGIN
  -- 1. Экранируем < и >. Тут как бы все очень просто, потому как они парные. И если уж есть < то точно должен быть и >.

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
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  09.02.15                        *  
*/

-- тест
-- SELECT * FROM zfConvert_StringToNumber ('TVarChar')
-- SELECT * FROM zfConvert_StringToNumber ('10')
