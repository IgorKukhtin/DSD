 -- Function: gpUpdate_Object_Car_size()

--DROP FUNCTION IF EXISTS  gpUpdate_Object_Car_size (Integer, TFloat, TFloat, TFloat, TVarChar);
DROP FUNCTION IF EXISTS  gpUpdate_Object_Car_size (Integer, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_Car_size(
      IN inId               Integer,     -- ид
      IN inLength           TFloat ,     -- 
      IN inWidth            TFloat ,     -- 
      IN inHeight           TFloat ,     --
      IN inWeight           TFloat ,     --
      IN inSession          TVarChar     -- Пользователь
      )
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Car());
   
   IF inId = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Элемент не сохранен.';
   END IF;
     
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Length(), inId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Height(), inId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Width(), inId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Car_Weight(), inId, inWeight);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.11.21         * add inWeight
 05.10.21         *
*/

-- тест
--