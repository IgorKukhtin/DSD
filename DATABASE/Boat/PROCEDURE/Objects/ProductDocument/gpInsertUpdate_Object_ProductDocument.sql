-- Function: gpInsertUpdate_Object_ProductDocument(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ProductDocument(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ProductDocument(
 INOUT ioId                        Integer   , -- ключ объекта <Документ артикула>
    IN inDocumentName              TVarChar  , -- Файл
    IN inProductId                   Integer   , -- Артикул
    IN inProductDocumentData         TBlob     , -- Тело документа 	
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
        RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка! Договор не установлен!'        :: TVarChar
                                              , inProcedureName := 'gpInsertUpdate_Object_ProductDocument'   :: TVarChar
                                              , inUserId        := vbUserId
                                              );
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ProductDocument(), 0, inDocumentName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_ProductDocument_Data(), ioId, inProductDocumentData);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ProductDocument_Product(), ioId, inProductId);   

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 21.04.21         *
*/

-- тест
--