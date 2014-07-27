-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                Integer   ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС

    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbCode Integer;   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   vbCode := lfGet_ObjectCode (inCode, zc_Object_Goods());
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), vbCode);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), vbCode, inName);
   -- сохранили связь с <Группа>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили свойство <НДС>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );
   -- сохранили свойство <связи чьи товары>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, null);
  

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
