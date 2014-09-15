-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inName                TVarChar  , -- Название объекта <Товар>
    IN inWeight              TFloat    , -- Вес
    IN inGoodsGroupId        Integer   , -- ссылка на группу Товаров
    IN inGroupStatId         Integer   , -- ссылка на группу Товаров (статистика)   
    IN inMeasureId           Integer   , -- ссылка на единицу измерения
    IN inTradeMarkId         Integer   , -- ссылка на Торговые марки
    IN inInfoMoneyId         Integer   , -- Управленческие аналитики
    IN inBusinessId          Integer   , -- Бизнесы
    IN inFuelId              Integer   , -- Вид топлива
    IN inGoodsTagId          Integer   , -- ссылка на признак товара 
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
                                , inAccessKeyId:= CASE WHEN inFuelId <> 0 AND NOT EXISTS (SELECT 1 FROM ObjectLink WHERE DescId = zc_ObjectLink_TicketFuel_Goods() AND ChildObjectId = ioId)
                                                            THEN zc_Enum_Process_AccessKey_TrasportAll()
                                                  END);

   -- сохранили свойство <Полное название группы>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_GroupNameFull(), ioId, vbGroupNameFull);
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <Группой товара(статистика)>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroupStat(), ioId, inGroupStatId);
   -- сохранили связь с <Единицей измерения>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили связь с <Торговые марки>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_TradeMark(), ioId, inTradeMarkId);   
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили связь с <Бизнесы>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Business(), ioId, inBusinessId);
   -- сохранили связь с <Вид топлива>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_Fuel(), ioId, inFuelId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsTag(), ioId, inGoodsTagId);   


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;
 
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.14         * add inGoodsTagId
 04.09.14         * add inGroupStatId
 13.01.14                                        * add vbGroupNameFull
 14.12.13                                        * add inAccessKeyId
 20.10.13                                        * vbCode:=0
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 30.06.13                                        * add vb
 20.06.13          * vbCode:=lpGet_ObjectCode (inCode, zc_Object_Goods());
 16.06.13                                        * IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL ...
 11.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
