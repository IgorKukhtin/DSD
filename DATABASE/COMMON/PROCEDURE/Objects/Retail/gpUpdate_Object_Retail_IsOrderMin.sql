-- Function: gpUpdate_Object_Retail_IsOrderMin()

DROP FUNCTION IF EXISTS gpUpdate_Object_Retail_IsOrderMin (Integer, boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Object_Retail_IsOrderMin(
    IN inId                  Integer   ,  -- ключ объекта <> 
    IN inIsOrderMin          boolean   , 
   OUT outIsOrderMin          boolean   , 
    IN inSession             TVarChar     -- сессия пользователя
)
  RETURNS boolean AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight(inSession, zc_Enum_Process_Update_Object_Retail_IsOrderMin());

   outIsOrderMin:= NOT inIsOrderMin;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Retail_isOrderMin(), inId, outIsOrderMin);


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.10.19         *
*/

-- тест
--