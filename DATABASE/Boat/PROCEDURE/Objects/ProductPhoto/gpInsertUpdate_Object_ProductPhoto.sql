-- Function: gpInsertUpdate_Object_ProductPhoto(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProductPhoto(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProductPhoto(
 INOUT ioId                        Integer   , -- ключ объекта <Документ артикула>
    IN inPhotoName                 TVarChar  , -- Файл
    IN inProductId                   Integer   , -- Артикул
    IN inProductPhotoData            TBlob     , -- Тело документа 	
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Product());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- проверка
   IF COALESCE (inProductId, 0) = 0
   THEN
       --RAISE EXCEPTION 'Ошибка! Договор не установлен!';
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Лодка не установлена.'       :: TVarChar
                                             , inProcedureName := 'gpInsertUpdate_Object_ProductPhoto' :: TVarChar
                                             , inUserId        := vbUserId
                                             );
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProductPhoto(), 0, inPhotoName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ProductPhoto_Data(), ioId, inProductPhotoData);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProductPhoto_Product(), ioId, inProductId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.11.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ProductPhoto (ioId:=0, inValue:=100, inProductId:=5, inProductConditionKindId:=6, inSession:='2')

