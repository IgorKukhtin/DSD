-- Function: gpInsertUpdate_Object_Goods()

-- DROP FUNCTION gpInsertUpdate_Object_Goods();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   , -- ключ объекта <Товар>
    IN inCode                Integer   , -- Код объекта <Товар>
    IN inName                TVarChar  , -- Название объекта <Товар>
    IN inWeight              TFloat    , -- Вес
    IN inGoodsGroupId        Integer   , -- ссылка на группу Товаров
    IN inMeasureId           Integer   , -- ссылка на единицу измерения
    IN inTradeMarkId         Integer   , -- ссылка на Торговые марки
    IN inInfoMoneyId         Integer   , -- Управленческие аналитики
    IN inBusinessId          Integer   , -- Бизнесы
    IN inFuelId              Integer   , -- Вид топлива
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbCode_calc Integer;   
BEGIN

   -- проверка прав пользователя на вызов процедуры
   -- PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Goods()());
   vbUserId := inSession;
   
   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! vbCode_calc:=lfGet_ObjectCode (inCode, zc_Object_Goods());
   IF COALESCE (inCode, 0) = 0  THEN vbCode_calc := NULL; ELSE vbCode_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode_calc, inName);
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Weight(), ioId, inWeight);
   -- сохранили связь с <Группой товара>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
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

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, vbUserId);

END;
$BODY$

LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods (Integer, Integer, TVarChar, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.09.13                                        * add zc_ObjectLink_Goods_Fuel
 01.09.13                                        * add zc_ObjectLink_Goods_Business
 30.06.13                                        * add vb
 20.06.13          * vbCode_calc:=lpGet_ObjectCode (inCode, zc_Object_Goods());
 16.06.13                                        * IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL ...
 11.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods (ioId:=0, inCode:=-1, inName:= 'TEST-GOODS', ... , inSession:= '2')
