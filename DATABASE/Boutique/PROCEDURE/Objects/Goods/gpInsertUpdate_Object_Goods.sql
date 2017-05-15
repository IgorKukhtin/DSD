-- Function: gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Товары> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Товары>     
    IN inName                     TVarChar  ,    -- Название объекта <Товары>
    IN inGoodsGroupId             Integer   ,    -- ключ объекта <Группы товаров> 
    IN inMeasureId                Integer   ,    -- ключ объекта <Единицы измерения> 
    IN inCompositionId            Integer   ,    -- ключ объекта <Состав товара> 
    IN inGoodsInfoId              Integer   ,    -- ключ объекта <Описание товара> 
    IN inLineFabricaID            Integer   ,    -- ключ объекта <Линия коллекции> 
    IN inLabelId                  Integer   ,    -- ключ объекта <Название для ценника> 
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS record
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbGroupNameFull TVarChar;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);

   -- Нужен ВСЕГДА- ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) <> 0 THEN  ioCode := NEXTVAL ('Object_Goods_seq'); 
   END IF; 

   -- Нужен для загрузки из Sybase т.к. там код = 0 
   IF COALESCE (ioId, 0) = 0 AND COALESCE(ioCode,0) = 0  THEN  ioCode := NEXTVAL ('Object_Goods_seq'); 
   ELSEIF ioCode = 0
         THEN ioCode := COALESCE((SELECT ObjectCode FROM Object WHERE Id = ioId),0);
   END IF; 

   -- проверка прав уникальности для свойства <Наименование>
   --PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- проверка уникальности для свойства <Код>
   --PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), ioCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), ioCode, inName);

   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
 
   -- сохранили Полное название группы + 
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
  
   -- сохранили связь с <Группы товаров>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <Единицы измерения>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили связь с <Состав товара>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Composition(), ioId, inCompositionId);
   -- сохранили связь с <Описание товара>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsInfo(), ioId, inGoodsInfoId);
   -- сохранили связь с <Линия коллекции>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_LineFabrica(), ioId, inLineFabricaId);
   -- сохранили связь с <Название для ценника>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Label(), ioId, inLabelId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
13.05.17                                                           *
03.03.17                                                           *
02.03.17                                                           *
01.03.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods()
