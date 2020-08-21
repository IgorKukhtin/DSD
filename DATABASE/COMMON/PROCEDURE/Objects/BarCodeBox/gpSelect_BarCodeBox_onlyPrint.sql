-- Function: gpSelect_BarCodeBox_onlyPrint (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_BarCodeBox_onlyPrint (Integer,Integer,TVarChar);
DROP FUNCTION IF EXISTS gpSelect_BarCodeBox_onlyPrint (Integer,Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_BarCodeBox_onlyPrint(
    IN inId             Integer  , -- ссылка на Ящик
    IN inBarCode1       Integer  , -- 
    IN inBarCode2       Integer  , -- 
    IN inSession        TVarChar       -- сессия пользователя
)
RETURNS TABLE (BarCode TVarChar--, AmountPrint TFloat
              ) AS
$BODY$
  DECLARE vbUserId      Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Object_BarCodeBox());
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= inSession;
   
   RETURN QUERY
  SELECT (REPEAT ('0', 5 - LENGTH (tmp.Num :: TVarChar) ) || tmp.Num) :: TVarChar AS BarCode
  FROM (SELECT GENERATE_SERIES (inBarCode1, inBarCode2) as Num) as tmp;
  
  -- сохранили <Объект>
  PERFORM lpInsertUpdate_Object (inId, zc_Object_BarCodeBox(), Object.ObjectCode, inBarCode2 :: TVarChar)
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
--SELECT * FROM gpSelect_BarCodeBox_onlyPrint (1,10,'2'::TVarChar)