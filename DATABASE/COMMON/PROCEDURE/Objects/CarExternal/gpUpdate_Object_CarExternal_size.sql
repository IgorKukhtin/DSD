 -- Function: gpUpdate_Object_CarExternal_size()

DROP FUNCTION IF EXISTS  gpUpdate_Object_CarExternal_size (Integer, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Object_CarExternal_size(
      IN inId               Integer,     -- ид
      IN inLength           TFloat ,     -- 
      IN inWidth            TFloat ,     -- 
      IN inHeight           TFloat ,     --
      IN inWeight           TFloat ,     --
      IN inYear             TFloat ,     -- год  выпуска
      IN inVIN              TVarChar,    -- VIN код
      IN inSession          TVarChar     -- Пользователь
      )
  RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_CarExternal());
   vbUserId:= lpGetUserBySession (inSession);
   
   IF inId = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Элемент не сохранен.';
   END IF;
     
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Length(), inId, inLength);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Height(), inId, inHeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Width(), inId, inWidth);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Weight(), inId, inWeight);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_CarExternal_Year(), inId, inYear);

   -- сохранили св-во <>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_CarExternal_VIN(), inId, inVIN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.21         *
*/

-- тест
--