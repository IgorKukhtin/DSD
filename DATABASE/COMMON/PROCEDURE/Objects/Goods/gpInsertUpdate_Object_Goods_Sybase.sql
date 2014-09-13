-- Function: gpInsertUpdate_Object_Goods_Sybase()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods_Sybase(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods_Sybase(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inName                TVarChar  , -- Название объекта <Товар>
    IN inWeight              TFloat    , -- Вес
    IN inGoodsGroupId        Integer   , -- ссылка на группу Товаров
    IN inMeasureId           Integer   , -- ссылка на единицу измерения
    IN inInfoMoneyId         Integer   , -- Управленческие аналитики
    IN inBusinessId          Integer   , -- Бизнесы
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode Integer;   
   DECLARE vbGroupNameFull TVarChar;   
BEGIN
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Object_Goods());
   
   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode:=lfGet_ObjectCode (inCode, zc_Object_Goods());
   IF COALESCE (inCode, 0) = 0  THEN vbCode := 0; ELSE vbCode := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode);


   -- расчетно свойство <Полное название группы>
   vbGroupNameFull:= lfGet_Object_TreeNameFull (inGoodsGroupId, zc_ObjectLink_GoodsGroup_Parent());

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName
                                , inAccessKeyId:= CASE WHEN ioId <> 0
                                                            THEN (SELECT inAccessKeyId FROM Object WHERE Id= ioId)
                                                  END);

   -- сохранили свойство <Полное название группы>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <Единицей измерения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <Бизнесы>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Business(), ioId, inBusinessId);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods_Sybase (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 13.09.14                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods_Sybase (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
