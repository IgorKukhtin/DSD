-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть
    IN inUserId              Integer   ,    -- 
    IN inMakerId             Integer   ,    -- Производитель
    IN inMakerName           TVarChar  ,    -- Производитель
    IN inCheckName           Boolean  DEFAULT true
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode Integer;
BEGIN
   -- !!!проверка уникальности <Наименование> для "любого" inObjectId
   IF inCheckName = TRUE
   THEN
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
                 WHERE GoodsName = inName AND Id <> COALESCE(ioId, 0)
                   AND ((ObjectId IS NULL AND inObjectId = 0)
                     OR (ObjectId = inObjectId AND inObjectId <> 0))
                )
      THEN
          RAISE EXCEPTION 'Значение <(%)%>%не уникально для справочника %.', inCode, inName
                        , CASE WHEN COALESCE (inObjectId, 0) = 0 THEN '' ELSE ' в торговой сети <' || COALESCE (lfGet_Object_ValueData (inObjectId), 'NULL') || '> ' END
                        , CASE WHEN COALESCE (inObjectId, 0) = 0 THEN '<Товары - общие>' ELSE '<Товары>' END;
      END IF; 
   END IF;

   -- проверка уникальности <Код>
   IF COALESCE (inObjectId, 0) = 0 -- AND inUserId <> 3 -- !!!только когда руками новую сеть!!!
   THEN
      -- !!!для "общего справочника" - GoodsCodeInt
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
                 WHERE GoodsCodeInt = inCode :: Integer AND Id <> COALESCE (ioId, 0)
                   AND ObjectId IS NULL
                )
      THEN
         RAISE EXCEPTION 'Код "%" не уникально для справочника "Товары"', inCode;
      END IF; 
   ELSE
      -- !!!для inObjectId - GoodsCode (TVarChar)
      IF EXISTS (SELECT GoodsName FROM Object_Goods_View 
                 WHERE GoodsCode = inCode AND Id <> COALESCE (ioId, 0)
                   AND ObjectId = inObjectId 
                )
      THEN
         RAISE EXCEPTION 'Код "%" не уникально для справочника "Товары"', inCode;
      END IF; 
   END IF;
   
   -- попытка преобразовать код
   BEGIN
        vbCode:= inCode :: Integer;
   EXCEPTION           
            WHEN data_exception
            THEN vbCode := 0;
   END;


   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object (ioId, zc_Object_Goods(), vbCode, inName);

   -- если НЕ из "общего справочника"
   IF COALESCE (inObjectId, 0) <> 0
   THEN
      -- Строковый код
      PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Code(), ioId, inCode);
      -- сохранили свойство <связи чьи товары>
      PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Object(), ioId, inObjectId);

   ELSE
       -- иначе отметили что товар из "общего справочника"
       PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_isMain(), ioId, TRUE);
   END IF; 


   -- сохранили связь с <Группа>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsGroup(), ioId, inGoodsGroupId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили свойство <НДС>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_NDSKind(), ioId, inNDSKindId );

   -- сохранили свойство <Производитель>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Maker(), ioId, inMakerId);
   -- сохранили свойство <Производитель>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), ioId, inMakerName);


   -- сохранили протокол - !!!только для "общего справочника"!!!
   IF COALESCE (inObjectId, 0) = 0
   THEN
       PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   END IF; 


END;
$BODY$
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
