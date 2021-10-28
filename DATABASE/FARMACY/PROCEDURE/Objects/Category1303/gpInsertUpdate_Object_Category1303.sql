-- Function: gpInsertUpdate_Object_Category1303()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Category1303 (Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Category1303(
 INOUT ioId	                 Integer   ,    -- ключ объекта <> 
    IN inCode                Integer   ,    -- код объекта 
    IN inName                TVarChar  ,    -- Название объекта <>
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Integer
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId:= lpCheckRight(inSession, zc_Enum_Process_...());
   vbUserId:= lpGetUserBySession (inSession);

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Category1303());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Category1303(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Category1303(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Category1303(), inCode, inName);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.10.21                                                       *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Category1303 (324, 2, '17', '3');