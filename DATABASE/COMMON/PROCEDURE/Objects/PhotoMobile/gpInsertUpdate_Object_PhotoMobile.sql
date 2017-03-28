-- Function: gpInsertUpdate_Object_PhotoMobile()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_PhotoMobile(Integer, Integer, TVarChar, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_PhotoMobile(
 INOUT ioId             Integer   ,     -- ключ объекта <Регионы> 
    IN inCode           Integer   ,     -- Код объекта  
    IN inName           TVarChar  ,     -- Название объекта 
    IN inPhotoData      TBlob     ,
    IN inSession        TVarChar        -- сессия пользователя
)
  RETURNS integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
    vbUserId:=lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_PhotoMobile());

   -- пытаемся найти код
   IF ioId <> 0 AND COALESCE (inCode, 0) = 0 THEN inCode := (SELECT ObjectCode FROM Object WHERE Id = ioId); END IF;

   -- Если код не установлен, определяем его каи последний+1
   vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_PhotoMobile());
   
   -- проверка прав уникальности для свойства <Наименование>
   PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_PhotoMobile(), inName);
   -- проверка прав уникальности для свойства <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_PhotoMobile(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_PhotoMobile(), vbCode_calc, inName);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob( zc_ObjectBlob_PhotoMobile_Data(), ioId, inPhotoData);
   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.03.17         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_PhotoMobile(ioId:=null, inCode:=null, inName:='Регион 1', inSession:='2')