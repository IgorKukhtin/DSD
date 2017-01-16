-- Function: zfFormat_BarCodeShort

DROP FUNCTION IF EXISTS zfFormat_BarCodeShort (TVarChar);

CREATE OR REPLACE FUNCTION zfFormat_BarCodeShort(
    IN inBarCode     TVarChar
)
RETURNS TVarChar AS
$BODY$
  DECLARE vbValue BIGINT;
BEGIN

     -- возвращается значение !!!13 символов!!!
     RETURN (SUBSTRING (inBarCode FROM 1 FOR 13)
          || CASE CHAR_LENGTH (inBarCode)
                  WHEN 0  THEN '0000000000000'
                  WHEN 1  THEN '000000000000'
                  WHEN 2  THEN '00000000000'
                  WHEN 3  THEN '0000000000'
                  WHEN 4  THEN '000000000'
                  WHEN 5  THEN '00000000'
                  WHEN 6  THEN '0000000'
                  WHEN 7  THEN '000000'
                  WHEN 8  THEN '00000'
                  WHEN 9  THEN '0000'
                  WHEN 10 THEN '000'
                  WHEN 11 THEN '00'
                  WHEN 12 THEN '0'
                  ELSE ''
             END);
   
END;
$BODY$
  LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfFormat_BarCodeShort (TVarChar) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 17.05.15                                        *
*/

-- тест
-- SELECT * FROM zfFormat_BarCodeShort ('12345')
-- SELECT * FROM zfFormat_BarCodeShort ('12345')