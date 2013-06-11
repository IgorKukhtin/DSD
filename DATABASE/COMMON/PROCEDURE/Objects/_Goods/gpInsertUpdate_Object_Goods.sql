-- Function: gpInsertUpdate_Object_Goods()

-- DROP FUNCTION gpInsertUpdate_Object_Goods();

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId	                 Integer   ,   	-- ключ объекта <Товар>
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
   DECLARE Code_max Integer;   
 
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());

   -- !!! Проверем уникальность имени
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);
   UserId := inSession;

   -- Если код не установлен, определяем его каи последний+1
   IF COALESCE (inCode, 0) = 0
   THEN 
       SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Goods();
   ELSE
       Code_max := inCode;
   END IF; 

   -- проверка прав уникальности для свойства <Наименование Товара>
   PERFORM lpCheckUnique_Object_ValueData (ioId, zc_Object_Goods(), inName);
   -- проверка прав уникальности для свойства <Код Товара>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), Code_max);

   -- Вставляем объект
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), Code_max, inName);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- Вставляем ссылку
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- Вставляем Управленческие аналитики
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_InfoMoney(), ioId, inInfoMoneyId);
   -- Вставляем вес
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_Weight(), ioId, inWeight);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$
  LANGUAGE plpgsql VOLATILE                                                                         
  COST 100;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, Integer, tvarchar)
  OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 11.06.13          *
 11.05.13                                        * rem lpCheckUnique_Object_ValueData

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
