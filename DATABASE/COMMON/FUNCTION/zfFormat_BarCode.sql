-- Function: zfFormat_BarCode

DROP FUNCTION IF EXISTS zfFormat_BarCode (Integer, TVarChar);
DROP FUNCTION IF EXISTS zfFormat_BarCode (TVarChar, Integer);

CREATE OR REPLACE FUNCTION zfFormat_BarCode(
    IN inBarCodePref TVarChar,
    IN inId          Integer
)
RETURNS TVarChar AS
$BODY$
--  DECLARE vbValue BIGINT;
BEGIN
     /*vbValue:= (inBarCodePref
             || CASE CHAR_LENGTH (inId :: TVarChar)
                     WHEN 0 THEN '000000000'
                     WHEN 1 THEN '00000000'
                     WHEN 2 THEN '0000000'
                     WHEN 3 THEN '000000'
                     WHEN 4 THEN '00000'
                     WHEN 5 THEN '0000'
                     WHEN 6 THEN '000'
                     WHEN 7 THEN '00'
                     WHEN 8 THEN '0'
                     ELSE ''
                END
             || inId :: TVarChar) :: TVarChar;
     
     RETURN (vbValue);*/

     -- возвращается значение !!!12 символов!!!, т.к. используется только для печати ШК, а там последний символ добавляется компонентой
     IF CHAR_LENGTH (inBarCodePref) = 4
     THEN
     RETURN ((inBarCodePref
          ||  CASE CHAR_LENGTH (inBarCodePref)
                   WHEN 0 THEN NULL
                   WHEN 1 THEN '000'
                   WHEN 2 THEN '00'
                   WHEN 3 THEN '0'
                   WHEN 4 THEN ''
                   ELSE NULL
              END
           || CASE CHAR_LENGTH (inId :: TVarChar)
                   WHEN 0 THEN '00000000'
                   WHEN 1 THEN '0000000'
                   WHEN 2 THEN '000000'
                   WHEN 3 THEN '00000'
                   WHEN 4 THEN '0000'
                   WHEN 5 THEN '000'
                   WHEN 6 THEN '00'
                   WHEN 7 THEN '0'
                   WHEN 8 THEN ''
                   WHEN 9 THEN '?'
                   WHEN 10 THEN '?'
                   WHEN 11 THEN '?'
                   WHEN 12 THEN '?'
                   WHEN 13 THEN '?'
                   ELSE ''
              END
           || inId :: TVarChar));

     ELSEIF CHAR_LENGTH (inBarCodePref) = 3
     THEN
     RETURN ((inBarCodePref
           || CASE CHAR_LENGTH (inId :: TVarChar)
                   WHEN 0 THEN '000000000'
                   WHEN 1 THEN '00000000'
                   WHEN 2 THEN '0000000'
                   WHEN 3 THEN '000000'
                   WHEN 4 THEN '00000'
                   WHEN 5 THEN '0000'
                   WHEN 6 THEN '000'
                   WHEN 7 THEN '00'
                   WHEN 8 THEN '0'
                   WHEN 9 THEN ''
                   WHEN 10 THEN '?'
                   WHEN 11 THEN '?'
                   WHEN 12 THEN '?'
                   WHEN 13 THEN '?'
                   ELSE ''
              END
           || inId :: TVarChar));

     ELSE
     RETURN ((inBarCodePref
          ||  CASE CHAR_LENGTH (inBarCodePref)
                   WHEN 0 THEN NULL
                   WHEN 1 THEN '0000'
                   WHEN 2 THEN '000'
                   WHEN 3 THEN '00'
                   WHEN 4 THEN '0'
                   WHEN 5 THEN ''
                   ELSE NULL
              END
           || CASE CHAR_LENGTH (inId :: TVarChar)
                   WHEN 0 THEN '0000000'
                   WHEN 1 THEN '000000'
                   WHEN 2 THEN '00000'
                   WHEN 3 THEN '0000'
                   WHEN 4 THEN '000'
                   WHEN 5 THEN '00'
                   WHEN 6 THEN '0'
                   WHEN 7 THEN ''
                   WHEN 8 THEN '?'
                   WHEN 9 THEN '?'
                   WHEN 10 THEN '?'
                   WHEN 11 THEN '?'
                   WHEN 12 THEN '?'
                   WHEN 13 THEN '?'
                   ELSE ''
              END
           || inId :: TVarChar));

     END IF;

END;
$BODY$
LANGUAGE PLPGSQL IMMUTABLE;
ALTER FUNCTION zfFormat_BarCode (TVarChar, Integer) OWNER TO postgres;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.02.15                                        *
*/

-- тест
-- SELECT * FROM zfFormat_BarCode (zc_BarCodePref_Object(), 12345)
-- SELECT * FROM zfFormat_BarCode (zc_BarCodePref_Movement(), 12345)