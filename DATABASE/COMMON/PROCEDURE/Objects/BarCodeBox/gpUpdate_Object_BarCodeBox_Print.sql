-- Function: gpUpdate_Object_BarCodeBox_Print (Integer, Integer, TVarChar, TFloat, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_BarCodeBox_Print (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_BarCodeBox_Print(
    IN inId           Integer   , -- Ключ объекта <Талоны на топливо>
    IN inAmountPrint  TFloat    , -- кол для печати
    IN inSession      TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId    Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_BarCodeBox_Print(), inId, inAmountPrint);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.05.20         *
*/

-- тест
-- SELECT * FROM gpUpdate_Object_BarCodeBox_Print()
