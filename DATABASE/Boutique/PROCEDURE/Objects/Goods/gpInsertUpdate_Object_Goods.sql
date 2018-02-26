-- Function: gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar)

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                       Integer   ,    -- Ключ объекта <Товар> 
 INOUT ioCode                     Integer   ,    -- Код объекта <Товар>     
    IN inName                     TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId             Integer   ,    -- Группа товара
    IN inMeasureId                Integer   ,    -- Единица измерения
    IN inCompositionId            Integer   ,    -- Состав
    IN inGoodsInfoId              Integer   ,    -- Описание
    IN inLineFabricaID            Integer   ,    -- Линия
    IN inLabelId                  Integer   ,    -- Название в ценнике
    IN inSession                  TVarChar       -- сессия пользователя
)
RETURNS RECORD
AS
$BODY$
   DECLARE vbUserId        Integer;
   DECLARE vbInfoMoneyId   Integer;
   DECLARE vbGroupNameFull TVarChar;
   DECLARE vbIsInsert      Boolean;
BEGIN
   -- проверка прав пользователя на вызов процедуры
   --vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   vbUserId:= lpGetUserBySession (inSession);


   -- для загрузки из Sybase т.к. там код НЕ = 0 
   IF vbUserId = zc_User_Sybase()
   THEN
       -- Проверка
       IF COALESCE (ioCode, 0) >= 0 THEN RAISE EXCEPTION 'COALESCE (ioCode, 0) >= 0 : <%>', ioCode; END IF;

       -- Определили
       ioCode:= -1 * ioCode;

   -- Нужен ВСЕГДА - ДЛЯ НОВОЙ СХЕМЫ С ioCode -> ioCode
   ELSEIF COALESCE (ioId, 0) = 0
   THEN
       -- Проверка
       IF COALESCE (ioCode, 0) <= 0 THEN RAISE EXCEPTION 'Ошибка.Ошибочно передано "предварительное" значение кода : <%>', ioCode; END IF;

       -- Определили
       ioCode:= NEXTVAL ('Object_Goods_seq'); 

   END IF; 

   -- НЕ Нужен для загрузки из Sybase т.к. там код НЕ = 0 
   -- IF COALESCE (ioId, 0) = 0 AND COALESCE (ioCode, 0) = 0  THEN ioCode := NEXTVAL ('Object_Goods_seq'); 
   -- ELSEIF ioCode = 0
   --       THEN ioCode := COALESCE ((SELECT ObjectCode FROM Object WHERE Id = ioId), 0);
   -- END IF; 

   -- Проверка
   IF TRIM (inName) = '' THEN
      RAISE EXCEPTION 'Ошибка.Необходимо ввести Название.';
   END IF;

   -- Проверка
   IF COALESCE (inGoodsGroupId, 0) = 0 THEN
      RAISE EXCEPTION 'Ошибка.Необходимо ввести Группу.';
   END IF;

   -- проверка прав уникальности для свойства <Название>
   -- PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- проверка уникальности для свойства <Код>
   -- PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), ioCode);

   -- определяем признак Создание/Корректировка
   vbIsInsert:= COALESCE (ioId, 0) = 0;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), ioCode, inName);

   -- только для Update
   IF vbIsInsert = FALSE
   THEN
       -- !!!не забыли - изменили свойства в партии!!!
       PERFORM lpUpdate_Object_PartionGoods_Goods (inGoodsId       := ioId
                                                 , inGoodsGroupId  := inGoodsGroupId
                                                 , inMeasureId     := inMeasureId
                                                 , inCompositionId := inCompositionId
                                                 , inGoodsInfoId   := inGoodsInfoId
                                                 , inLineFabricaID := inLineFabricaID
                                                 , inLabelId       := inLabelId
                                                 , inUserId        := vbUserId
                                                  );
   END IF;

   -- расчет - Полное название группы
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());
   -- из ближайшей группы где установлено <Статьи назначения>
   vbInfoMoneyId:= lfGet_Object_GoodsGroup_InfoMoneyId (inGoodsGroupId);

   -- сохранили Полное название группы
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
  
   -- сохранили связь с <Группы товаров>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <Единицы измерения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили связь с <Состав товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Composition(), ioId, inCompositionId);
   -- сохранили связь с <Описание товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsInfo(), ioId, inGoodsInfoId);
   -- сохранили связь с <Линия коллекции>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_LineFabrica(), ioId, inLineFabricaId);
   -- сохранили связь с <Название для ценника>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Label(), ioId, inLabelId);
   -- сохранили связь с ***<УП статья назначения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, vbInfoMoneyId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;


/*-------------------------------------------------------------------------------*/
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Полятикин А.А.
07.06.17          * add vbInfoMoneyId
13.05.17                                                           *
03.03.17                                                           *
02.03.17                                                           *
01.03.17                                                           *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods()
