-- Function: gpInsertUpdate_Object_Goods()

-- DROP FUNCTION gpInsertUpdate_Object_Goods();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                Integer   ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- ссылка на группу Товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inWeight              TFloat    ,    -- Вес
    IN inInfoMoneyId         Integer   ,    -- Управленческие аналитики
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_calc Integer;   
BEGIN

   --  PERFORM lpCheckRight(inSession, zc_Enum_Process_InsertUpdate_Object_Goods()());
   UserId := inSession;
   
   -- !!! Если код не установлен, определяем его как последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! Code_calc:=lpGet_ObjectCode (inCode, zc_Object_Goods());
   IF COALESCE (inCode, 0) = 0  THEN Code_calc := NULL; ELSE Code_calc := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), Code_calc);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), Code_calc, inName);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили связь с <Управленческие аналитики>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_InfoMoney(), ioId, inInfoMoneyId);
   -- сохранили свойство <Вес>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_Weight(), ioId, inWeight);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, Integer, tvarchar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
               
 20.06.13          *  Code_calc:=lpGet_ObjectCode (inCode, zc_Object_Goods());
 16.06.13                                        * IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL ...
 11.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods()
