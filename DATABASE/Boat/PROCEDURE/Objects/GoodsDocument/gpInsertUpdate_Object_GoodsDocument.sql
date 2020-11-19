-- Function: gpInsertUpdate_Object_GoodsDocument(Integer, TVarChar, Integer, TBlob, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_GoodsDocument(Integer, TVarChar, Integer, TBlob, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_GoodsDocument(
 INOUT ioId                        Integer   , -- ключ объекта <Документ артикула>
    IN inDocumentName              TVarChar  , -- Файл
    IN inGoodsId                   Integer   , -- Артикул
    IN inGoodsDocumentData         TBlob     , -- Тело документа 	
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);
   
    -- проверка
   IF COALESCE (inGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка! Договор не установлен!';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_GoodsDocument(), 0, inDocumentName);
   
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectBlob (zc_ObjectBlob_GoodsDocument_Data(), ioId, inGoodsDocumentData);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_GoodsDocument_Goods(), ioId, inGoodsId);   

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
-- SELECT * FROM gpInsertUpdate_Object_GoodsDocument (ioId:=0, inValue:=100, inGoodsId:=5, inGoodsConditionKindId:=6, inSession:='2')

