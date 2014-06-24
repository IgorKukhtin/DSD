-- Function: gpInsertUpdate_Object_Goods()

-- DROP FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Object_Goods(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                Integer   ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inExtraChargeCategoriesId  Integer   ,    -- Категория наценок
    IN inNDS                 TFloat    ,    -- НДС
    IN inCashName            TVarChar  ,    -- Название в кассе
    IN inPartyCount          TFloat    ,    -- Минимальная партия в заказе
    IN inisReceiptNeed       Boolean   ,    -- Нужен ли рецепт
    IN inPrice               TFloat    ,    -- Цена
    IN inPercentReprice      TFloat    ,    -- % наценки
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS integer AS
$BODY$
   DECLARE UserId Integer;
   DECLARE Code_max Integer;   
BEGIN

   --   PERFORM lpCheckRight(inSession, zc_Enum_Process_GoodsGroup());
   UserId := inSession;
   
   -- !!! Если код не установлен, определяем его каи последний+1 (!!! ПОТОМ НАДО БУДЕТ ЭТО ВКЛЮЧИТЬ !!!)
   -- !!! IF COALESCE (inCode, 0) = 0
   -- !!! THEN 
   -- !!!     SELECT MAX (ObjectCode) + 1 INTO Code_max FROM Object WHERE Object.DescId = zc_Object_Goods();
   -- !!!  ELSE
   -- !!!     Code_max := inCode;
   -- !!! END IF; 
   IF COALESCE (inCode, 0) = 0  THEN Code_max := NULL; ELSE Code_max := inCode; END IF; -- !!! А ЭТО УБРАТЬ !!!
   
   -- !!! проверка уникальности <Наименование>
   -- !!! PERFORM lpCheckUnique_Object_ValueData(ioId, zc_Object_Goods(), inName);

   -- проверка уникальности <Код>
   PERFORM lpCheckUnique_Object_ObjectCode (ioId, zc_Object_Goods(), Code_max);

   -- сохранили <Объект>
   ioId := lpInsertUpdate_Object(ioId, zc_Object_Goods(), Code_max, inName);
   -- сохранили связь с <Категория наценок>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_ExtraChargeCategories(), ioId, inExtraChargeCategoriesId);
   -- сохранили связь с <>
   PERFORM lpInsertUpdate_ObjectLink(zc_ObjectLink_Goods_Measure(), ioId, inMeasureId);
   -- сохранили свойство <НДС>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_NDS(), ioId, inNDS);
   -- сохранили свойство <Минимальная партия в заказе>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_PartyCount(), ioId, inPartyCount);
   -- сохранили свойство <Цена>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_Price(), ioId, inPrice);
   -- сохранили свойство <% наценки>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Goods_PercentReprice(), ioId, inPercentReprice);
   -- сохранили свойство <Название в кассе>
   PERFORM lpInsertUpdate_ObjectString(zc_ObjectString_Goods_CashName(), ioId, inCashName);
   -- сохранили свойство <Нужен ли рецепт>
   PERFORM lpInsertUpdate_ObjectBoolean(zc_ObjectBoolean_Goods_isReceiptNeed(), ioId, inisReceiptNeed);

   -- сохранили протокол
   -- PERFORM lpInsert_ObjectProtocol (ioId, UserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpInsertUpdate_Object_Goods(Integer, Integer, TVarChar, Integer, Integer, TFloat, TVarChar, TFloat, Boolean, TFloat, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.06.13                        * 

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods
