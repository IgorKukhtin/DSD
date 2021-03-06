-- Function: gpInsertUpdate_Object_MedicKashtan()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_MedicKashtan (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_MedicKashtan(
 INOUT ioId	                 Integer   ,    -- ключ объекта <> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <>
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_MedicKashtan(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.03.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_MedicKashtan (324, 2, '17', '3');