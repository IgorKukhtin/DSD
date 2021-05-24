-- Function: gpGet_Onject_BarCodeBox_ValueData (TVarChar)

DROP FUNCTION IF EXISTS gpGet_Onject_BarCodeBox_ValueData (Integer,TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Onject_BarCodeBox_ValueData(
    IN inId             Integer  , -- ссылка на Ящик
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (BarCode TFloat--, AmountPrint TFloat
              ) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);
   
   --проверка. если выбрали штрихкод с префиксом
   IF (SELECT POSITION ('-' IN Object.ValueData) FROM Object WHERE Object.Id = inId) > 0
   THEN
        RAISE EXCEPTION 'Ошибка.Выбранный штрихкод содержит префикс.';
   END IF;
   
   RETURN QUERY
  SELECT (zfConvert_StringToFloat(Object.ValueData) + 1) ::TFloat AS BarCode
  FROM Object
  WHERE Object.Id = inId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.08.20         *
*/

-- тест
--SELECT * FROM gpGet_Onject_BarCodeBox_ValueData (3654036 ,'2'::TVarChar)