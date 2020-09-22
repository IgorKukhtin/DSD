-- Function: zfConvert_StringToNumber

-- DROP FUNCTION IF EXISTS zfConvert_StringToNumber (TVarChar);

CREATE OR REPLACE FUNCTION zfStrToXmlStr(inStr TVarChar)
RETURNS TVarChar AS
$BODY$
  DECLARE Res TVarChar;
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


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
  09.02.15                        *  
*/

-- тест
-- SELECT * FROM zfConvert_StringToNumber ('TVarChar')
-- SELECT * FROM zfConvert_StringToNumber ('10')
