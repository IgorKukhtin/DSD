-- Function: gpInsertUpdate_Object_Goods_Retail()

DROP FUNCTION IF EXISTS lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, Integer, Integer);

CREATE OR REPLACE FUNCTION lpInsertUpdate_Object_Goods_Retail(
 INOUT ioId                  Integer   ,    -- ключ объекта <Товар>
    IN inCode                TVarChar  ,    -- Код объекта <Товар>
    IN inName                TVarChar  ,    -- Название объекта <Товар>
    IN inGoodsGroupId        Integer   ,    -- группы товаров
    IN inMeasureId           Integer   ,    -- ссылка на единицу измерения
    IN inNDSKindId           Integer   ,    -- НДС
    IN inMinimumLot          TFloat    ,    -- Групповая упаковка
    IN inReferCode           Integer   ,    -- Код для стыковки спецпроекта
    IN inReferPrice          TFloat    ,    -- Референтная цена упаковки
    IN inPrice               TFloat    ,    -- Цена реализации
    IN inIsClose             Boolean   ,    -- Код закрыт
    IN inTOP                 Boolean   ,    -- ТОП - позиция
    IN inPercentMarkup	     TFloat    ,    -- % наценки
    IN inObjectId            Integer   ,    -- 
    IN inUserId              Integer        -- Пользователь
)
RETURNS Integer
AS
$BODY$
BEGIN
     -- сохранили <Товар Торговой сети>
     ioId:= lpInsertUpdate_Object_Goods (ioId, inCode, inName, inGoodsGroupId, inMeasureId, inNDSKindId, inObjectId, inUserId, 0, '');

     -- !!!замена!!!
     IF inMinimumLot = 0 THEN inMinimumLot := NULL; END IF;   	

     -- сохранили еще свойства для <Товар Торговой сети>
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_MinimumLot(), ioId, inMinimumLot);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ReferCode(), ioId, inReferCode);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_ReferPrice(), ioId, inReferPrice);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Price(), ioId, inPrice);

     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Close(), ioId, inIsClose);
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_TOP(), ioId, inTOP);
     PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PercentMarkup(), ioId, inPercentMarkup);

     -- сохранили протокол
     PERFORM lpInsert_ObjectProtocol (ioId, inUserId);


END;$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION lpInsertUpdate_Object_Goods_Retail (Integer, TVarChar, TVarChar, Integer, Integer, Integer, TFloat, Integer, TFloat, TFloat, Boolean, Boolean, TFloat, Integer, Integer) OWNER TO postgres;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 25.03.16                                        *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods_Retail
