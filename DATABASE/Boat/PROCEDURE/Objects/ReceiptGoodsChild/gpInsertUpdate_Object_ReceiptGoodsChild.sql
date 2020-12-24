-- Function: gpInsertUpdate_Object_ReceiptGoodsChild()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoodsChild(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inComment             TVarChar  ,    -- Название объекта
    IN inReceiptGoodsId      Integer   ,
    IN inObjectId            Integer   ,
    IN inProdColorPatternId  Integer   ,
 INOUT ioValue               TFloat    ,
 INOUT ioValue_service       TFloat    ,
    IN inIsEnabled           Boolean   ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbIsInsert Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);


   -- замена
   IF ioValue = 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       ioValue:= ioValue_service;
   ELSE
       ioValue_service:= 0;
   END IF;



   -- Проверка
   IF COALESCE (inReceiptGoodsId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.ReceiptGoodsId не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptGoodsChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;

   -- Проверка
   IF COALESCE (inObjectId, 0) = 0 AND COALESCE (inProdColorPatternId, 0) = 0
   THEN
       RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не установлен.'
                                             , inProcedureName := 'gpInsertUpdate_Object_ReceiptGoodsChild'
                                             , inUserId        := vbUserId
                                              );
   END IF;


   IF inIsEnabled = FALSE
   THEN
       -- Проверка
       IF COALESCE (ioId, 0) = 0
       THEN
           RAISE EXCEPTION '%', lfMessageTraslate (inMessage       := 'Ошибка.Элемент не может быть удален.'
                                                 , inProcedureName := 'gpInsertUpdate_Object_ReceiptGoodsChild'
                                                 , inUserId        := vbUserId);
       END IF;

       -- удалили
       PERFORM lpUpdate_Object_isErased (inObjectId:= ioId, inIsErased:= TRUE, inUserId:= vbUserId);

   ELSE
       -- определяем признак Создание/Корректировка
       vbIsInsert:= COALESCE (ioId, 0) = 0;

       -- сохранили <Объект>
       ioId := lpInsertUpdate_Object(ioId, zc_Object_ReceiptGoodsChild(), 0, inComment);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_Value(), ioId, ioValue);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods(), ioId, inReceiptGoodsId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), ioId, inObjectId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern(), ioId, inProdColorPatternId);

       -- замена
       IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
       THEN
           ioValue_service:= ioValue;
           ioValue:= 0;
       END IF;

   END IF;


   IF vbIsInsert = TRUE THEN
      -- сохранили свойство <Дата создания>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Insert(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (создание)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Insert(), ioId, vbUserId);
   ELSE
      -- сохранили свойство <Дата корр>
      PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Protocol_Update(), ioId, CURRENT_TIMESTAMP);
      -- сохранили свойство <Пользователь (корр)>
      PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Protocol_Update(), ioId, vbUserId);

   END IF;


   IF inIsEnabled = TRUE
   THEN
       -- сохранили протокол
       PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*-------------------------------------------------------------------------------
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoodsChild()
