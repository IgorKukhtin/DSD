-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, INTEGER, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть
    IN inUserId              Integer   ,    -- Пользователь
    IN inMakerId             Integer   ,    -- Производитель
    IN inMakerName           TVarChar  ,    -- Производитель
    IN inCheckName           boolean  DEFAULT true
)
RETURNS integer AS
$BODY$
  DECLARE vbCode INTEGER;
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   
   -- !!! проверка уникальности <Наименование>
   IF inCheckName THEN
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
           WHERE ((inObjectId = 0 AND ObjectId IS NULL) OR (ObjectId = inObjectId AND inObjectId <> 0))
             AND GoodsName = inName AND Id <> COALESCE(ioId, 0) ) THEN
          RAISE EXCEPTION 'Значение "%" не уникально для справочника "Товары"', inName;
      END IF; 
   END IF;

   -- !!! проверка уникальности <Код>
   IF inObjectId = 0 THEN
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
               WHERE ObjectId IS NULL 
                 AND GoodsCodeInt = inCode::Integer AND Id <> COALESCE(ioId, 0)  ) THEN
         RAISE EXCEPTION 'Код "%" не уникально для справочника "Товары"', inCode;
      END IF; 
   ELSE
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
               WHERE ObjectId = inObjectId 
                 AND GoodsCode = inCode AND Id <> COALESCE(ioId, 0)  ) THEN
         RAISE EXCEPTION 'Код "%" не уникально для справочника "Товары"', inCode;
      END IF; 
   END IF;
   
   BEGIN
     vbCode := inCode::Integer;
   EXCEPTION           
     WHEN data_exception THEN
         vbCode := 0;
   END;

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), vbCode, inName);

   IF COALESCE(inObjectId, 0) <> 0 THEN
      -- Строковый код
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), ioId, inCode);
      -- сохранили свойство <связи чьи товары>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, inObjectId);
   ELSE
      PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Goods_isMain(), ioId, true);
   END IF; 

   -- сохранили связь с <Группа>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили свойство <НДС>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );

   -- сохранили свойство <Производитель>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Maker(), ioId, inMakerId );

   -- сохранили свойство <Производитель>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), ioId, inMakerName );

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.10.14                        *
 29.07.14                        *
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
