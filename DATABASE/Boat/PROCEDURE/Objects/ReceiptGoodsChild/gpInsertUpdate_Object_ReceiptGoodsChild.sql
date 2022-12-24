-- Function: gpInsertUpdate_Object_ReceiptGoodsChild()
   
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TFloat, TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, NUMERIC (16, 8), NUMERIC (16, 8), TFloat, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_ReceiptGoodsChild (Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar, TFloat, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_ReceiptGoodsChild(
 INOUT ioId                  Integer   ,    -- ключ объекта <>
    IN inComment             TVarChar  ,    -- Название объекта
    IN inReceiptGoodsId      Integer   ,
    IN inObjectId            Integer   ,
    IN inProdColorPatternId  Integer   ,
    IN inMaterialOptionsId   Integer   ,
    IN inReceiptLevelId_top  Integer   ,
    IN inReceiptLevelId      Integer   ,
    IN inGoodsChildId        Integer   ,
 INOUT ioValue               TVarChar    ,
 INOUT ioValue_service       TVarChar    ,
 INOUT ioForCount            TFloat    ,
    IN inIsEnabled           Boolean   ,
   OUT outReceiptLevelName   TVarChar  ,
    IN inSession             TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbIsInsert Boolean;

   DECLARE vbValue         NUMERIC (16, 8); 
   DECLARE vbValue_service NUMERIC (16, 8);
BEGIN
   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_ReceiptGoodsChild());
   vbUserId:= lpGetUserBySession (inSession);

   -- переводим
   vbValue        := zfConvert_StringToFloat (REPLACE (ioValue,         ',' , '.'));
   vbValue_service:= zfConvert_StringToFloat (REPLACE (ioValue_service, ',' , '.'));
   
   -- замена ioValue если больше 4-х знаков, тогда ForCount = 1000 а в ioValue записсываем ioValue * 1000
   IF (vbValue <> vbValue :: TFloat) 
   THEN
       ioForCount:= 1000; 
       vbValue   := (vbValue * 1000) :: TFloat;
   ELSEIF COALESCE (ioForCount, 0) = 0
   THEN
       ioForCount:= 1; 
   END IF;
   
   -- замена
   IF vbValue = 0 AND EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
   THEN
       vbValue:= vbValue_service :: TFloat;
   ELSE
       vbValue_service:= 0;
   END IF;                        
  --  RAISE EXCEPTION '%', ioValue;


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

   -- переопределяем
   IF COALESCE (inReceiptLevelId, 0) = 0
   THEN
       inReceiptLevelId := inReceiptLevelId_top;
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
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_Value(), ioId, vbValue);

       -- сохранили свойство <>
       IF COALESCE (ioForCount, 0) <= 0 THEN ioForCount:= 1; END IF;
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_ReceiptGoodsChild_ForCount(), ioId, ioForCount);
       

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ReceiptGoods(), ioId, inReceiptGoodsId);

       -- сохранили свойство <>
       IF EXISTS (SELECT 1 FROM ObjectLink AS OL WHERE OL.ObjectId = inProdColorPatternId AND OL.ChildObjectId > 0 AND OL.DescId = zc_ObjectLink_ProdColorPattern_Goods())
       THEN
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), ioId, inObjectId);
       ELSE
           PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_Object(), ioId, inObjectId);
       END IF;
       

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ProdColorPattern(), ioId, inProdColorPatternId);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_MaterialOptions(), ioId, inMaterialOptionsId);

       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_ReceiptLevel(), ioId, inReceiptLevelId);
       -- сохранили свойство <>
       PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_ReceiptGoodsChild_GoodsChild(), ioId, inGoodsChildId);

       -- замена
       IF EXISTS (SELECT 1 FROM Object WHERE Object.Id = inObjectId AND Object.DescId =  zc_Object_ReceiptService())
       THEN
           vbValue_service:= vbValue;
           vbValue:= 0;
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

   outReceiptLevelName :=  (SELECT Object.ValueData FROM Object WHERE Object.Id = inReceiptLevelId);
   
   -- возвращаем в грид
   ioValue        := CAST (vbValue         / CASE WHEN ioForCount > 0 THEN ioForCount ELSE 1 END AS TVarChar);
   ioValue_service:= CAST (vbValue_service AS TVarChar);


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
 23.06.22         * inMaterialOptionsId
 01.12.20         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_ReceiptGoodsChild()