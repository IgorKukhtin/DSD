-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inGoodsMainId         Integer   ,    -- Ссылка на главный товар
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть
    IN inUserId              Integer        -- Пользователь
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE vbCode Integer;   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   -- !!! проверка уникальности <Наименование>
   IF EXISTS (SELECT GoodsName FROM Object_Goods_View AND GoodsName = inName AND Id <> COALESCE(inId, 0) ) THEN
      RAISE EXCEPTION 'Значение "%" не уникально для справочника "Товары"', inName;
   END IF; 

   -- !!! проверка уникальности <Код>
   IF EXISTS (SELECT ObjectCode FROM Object WHERE DescId = inDescId AND ObjectCode = inObjectCode AND Id <> COALESCE( inId, 0) ) THEN
      SELECT ItemName INTO ObjectName FROM ObjectDesc WHERE Id = inDescId;
      RAISE EXCEPTION 'Значение "%" не уникально для справочника "%"', inObjectCode, ObjectName;
   END IF; 

   vbCode := inCode::Integer;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), vbCode, inName);

   IF COALESCE(inObjectId, 0) <> 0 THEN
      -- Строковый код
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), vbGoodsId, inCode);
      -- сохранили свойство <связи чьи товары>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, inObjectId);
      -- сохранили связь с <Главным товаром>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsMain(), vbGoodsId, inGoodsMainId);
   END; 

   -- сохранили связь с <Группа>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили свойство <НДС>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.07.14                        *
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
