-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer, Integer);

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
    IN inCheckName           Boolean  DEFAULT true ,
    IN inAreaId              Integer  DEFAULT 0,      -- 
    IN inNameUkr             TVarChar DEFAULT '',     -- Название украинское
    IN inCodeUKTZED          TVarChar DEFAULT '',    -- Код УКТЗЭД
    IN inExchangeId          Integer  DEFAULT 0,       -- Од:
    IN inGoodsAnalogId       Integer  DEFAULT 0      -- Аналоги товара
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode Integer;
BEGIN
   -- !!!проверка уникальности <Наименование> для "любого" inObjectId
   IF inCheckName = TRUE
   THEN
      IF EXISTS (SELECT GoodsName
                 FROM Object_Goods_View 
                 WHERE GoodsName = inName AND Id <> COALESCE(ioId, 0)
                   AND ((ObjectId IS NULL AND inObjectId = 0)
                     OR (ObjectId = inObjectId AND inObjectId <> 0))
                   AND (-- если Регион соответсвует
                        COALESCE (Object_Goods_View.AreaId, 0) = inAreaId
                        -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
                     OR (inAreaId = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
                        -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
                     OR (inAreaId = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
                       )
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
                   AND (-- если Регион соответсвует
                        COALESCE (Object_Goods_View.AreaId, 0) = inAreaId
                        -- или Это регион zc_Area_Basis - тогда ищем в регионе "пусто"
                     OR (inAreaId = zc_Area_Basis() AND Object_Goods_View.AreaId IS NULL)
                        -- или Это регион "пусто" - тогда ищем в регионе zc_Area_Basis
                     OR (inAreaId = 0 AND Object_Goods_View.AreaId = zc_Area_Basis())
                       )
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

   -- сохранили свойство <Название украинское>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_NameUkr(), ioId, inNameUkr);
   -- сохранили свойство <Код УКТЗЭД>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CodeUKTZED(), ioId, inCodeUKTZED);
   -- сохранили свойство <Од>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Exchange(), ioId, inExchangeId);
   -- сохранили свойство <Аналоги товара>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_GoodsAnalog(), ioId, inGoodsAnalogId);

   -- сохранили протокол - !!!только для "общего справочника"!!!
   IF COALESCE (inObjectId, 0) = 0
   THEN
       PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   END IF; 


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer, Integer) OWNER TO postgres;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.09.18                                                       *
 22.10.14                        *
 29.07.14                        *
 26.06.14                        *
 24.06.14         *
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
