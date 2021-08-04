-- Function: gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ModelServiceItemChild(Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ModelServiceItemChild(
 INOUT ioId                       Integer   , -- ключ объекта <Подчиненные элементы Модели начисления>
    IN inComment                  TVarChar  , -- Примечание
    IN inFromId                   Integer   , -- Товар(От кого)
    IN inToId                     Integer   , -- Товар(Кому) 	
    IN inFromGoodsKindId          Integer   , -- Вид товара(От кого)
    IN inToGoodsKindId            Integer   , -- Вид товара(Кому) 	
    IN inFromGoodsKindCompleteId  Integer   , -- Вид товара(От кого, готовая продукция)
    IN inToGoodsKindCompleteId    Integer   , -- Вид товара(Кому, готовая продукция)	
    IN inModelServiceItemMasterId Integer   , -- главный элемент
    IN inFromStorageLineId        Integer   , -- линия пр-ва (От кого)
    IN inToStorageLineId          Integer   , -- линия пр-ва (Кому)
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- vbUserId := PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ModelServiceItemChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- проверка прав
   IF NOT EXISTS (SELECT 1 FROM Object_RoleAccessKey_View WHERE Object_RoleAccessKey_View.UserId = vbUserId AND Object_RoleAccessKey_View.AccessKeyId = zc_Enum_Process_Update_Object_ModelService())
   THEN
        RAISE EXCEPTION 'Ошибка.%Нет прав корректировать = <%>.'
                      , CHR (13)
                      , (SELECT ObjectDesc.ItemName FROM ObjectDesc WHERE ObjectDesc.Id = zc_Object_ModelServiceItemChild())
                       ;
   END IF;

    -- проверка
   IF COALESCE (inModelServiceItemMasterId, 0) = 0
   THEN
       RAISE EXCEPTION 'Ошибка. Не установлен главный элемент!';
   END IF;
   
   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_ModelServiceItemChild(), 0, '');
   
   -- сохранили свойство <>   
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_ModelServiceItemChild_Comment(), ioId, inComment);
   
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_From(), ioId, inFromId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_To(), ioId, inToId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_FromGoodsKind(), ioId, inFromGoodsKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ToGoodsKind(), ioId, inToGoodsKindId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_FromGoodsKindComplete(), ioId, inFromGoodsKindCompleteId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ToGoodsKindComplete(), ioId, inToGoodsKindCompleteId);
   
      -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ModelServiceItemMaster(), ioId, inModelServiceItemMasterId);

   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_FromStorageLine(), ioId, inFromStorageLineId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ModelServiceItemChild_ToStorageLine(), ioId, inToStorageLineId);

   -- сохранили протокол 
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
--ALTER FUNCTION gpInsertUpdate_Object_ModelServiceItemChild (Integer, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*---------------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
26.05.17         * add StorageLine
27.12.16         *
20.10.13         * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ModelServiceItemChild (0, '1000', 5, 6, '2')
    