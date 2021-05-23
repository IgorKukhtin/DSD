-- Function: gpUpdate_Object_Account_PrintDetail (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUpdate_Object_Account_PrintDetail (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Account_PrintDetail(
    IN inId                     Integer,    -- ключ объекта <Счет>
    IN inIsPrintDetail          Boolean,    -- Показать развернутым при печати
    IN inSession                TVarChar    -- сессия пользователя
)
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Account());
   vbUserId:= lpGetUserBySession (inSession);


   IF COALESCE (inId,0) = 0
   THEN
       RETURN;
   END IF;
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Account_PrintDetail(), inId, inIsPrintDetail);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
  
/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.01.19         *
*/
