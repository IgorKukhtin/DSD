-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer, Integer);
DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inObjectId            Integer   ,    -- Юр лицо или торговая сеть
    IN inUserId              Integer   ,    -- 
    IN inMakerId             Integer  DEFAULT 0,      -- Производитель
    IN inMakerName           TVarChar DEFAULT '',     -- Производитель
    IN inCheckName           Boolean  DEFAULT true ,
    IN inAreaId              Integer  DEFAULT 0,      -- 
    IN inNameUkr             TVarChar DEFAULT '',     -- Название украинское
    IN inCodeUKTZED          TVarChar DEFAULT '',     -- Код УКТЗЭД
    IN inExchangeId          Integer  DEFAULT 0       -- Од:
)
RETURNS Integer
AS
$BODY$
  DECLARE vbCode Integer;
  DECLARE text_var1 text;
BEGIN

   IF COALESCE(ioId, 0) <> 0 AND inName <> (SELECT Object.ValueData FROM Object WHERE Object.ID = ioId) AND
      EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Retail())
   THEN
     PERFORM lpCheckRight (inUserId::TVarChar, zc_Enum_Process_InsertUpdate_Object_Goods());
   END IF;

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

   -- Только товарам поставщиков
   IF EXISTS (SELECT 1 FROM Object WHERE Object.ID = inObjectId AND Object.DescId = zc_Object_Juridical())
   THEN
     -- сохранили свойство <Производитель>
     -- PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Maker(), ioId, inMakerId); Заремил не используеться
     -- сохранили свойство <Производитель>
     PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_Maker(), ioId, inMakerName);
   END IF;

   -- сохранили свойство <Название украинское>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_NameUkr(), ioId, inNameUkr);
   -- сохранили свойство <Код УКТЗЭД>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CodeUKTZED(), ioId, inCodeUKTZED);
   -- сохранили свойство <Од>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Exchange(), ioId, inExchangeId);
   
    -- Сохранили в плоскую таблицй
   BEGIN
   PERFORM lpInsertUpdate_Object_Goods_Flat (ioId             :=  ioId
                                            , inCode           :=  inCode
                                            , inName           :=  inName
                                            , inGoodsGroupId   :=  inGoodsGroupId
                                            , inMeasureId      :=  inMeasureId
                                            , inNDSKindId      :=  inNDSKindId
                                            , inObjectId       :=  inObjectId
                                            , inUserId         :=  inUserId
                                            , inMakerId        :=  inMakerId
                                            , inMakerName      :=  inMakerName
                                            , inCheckName      :=  inCheckName
                                            , inAreaId         :=  inAreaId
                                            , inNameUkr        :=  inNameUkr 
                                            , inCodeUKTZED     :=  inCodeUKTZED
                                            , inExchangeId     :=  inExchangeId);
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('lpInsertUpdate_Object_Goods_Flat', text_var1::TVarChar, inUserId);
   END;

   -- сохранили протокол - !!!только для "общего справочника"!!!
   IF COALESCE (inObjectId, 0) = 0
   THEN
       PERFORM lpInsert_ObjectProtocol (ioId, inUserId);
   END IF; 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods(Integer, TVarChar, TVarChar, Integer, Integer, Integer, Integer, Integer, Integer, TVarChar, Boolean, Integer, TVarChar, TVarChar, Integer) OWNER TO postgres;
  
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