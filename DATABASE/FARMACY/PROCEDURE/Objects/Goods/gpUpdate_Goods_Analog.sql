-- Function: gpUpdate_Goods_Analog()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Analog(Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_Analog(Integer, TVarChar, TVarChar, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Analog(
    IN inGoodsMainId             Integer   ,    -- ключ объекта <Товар>
 INOUT ioAnalog                  TVarChar  ,    -- Перечень аналогов товара
 INOUT ioAnalogATC               TVarChar  ,    -- Перечень аналогов товара ATC
 INOUT ioActiveSubstance         TVarChar  ,    -- Действующее вещество
    IN inSession                 TVarChar       -- текущий пользователь
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      ioAnalog := '';
      ioAnalogATC := '';
      ioActiveSubstance := '';
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- сохранили свойство <Перечень аналогов товара>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Analog(), inGoodsMainId, ioAnalog);
   -- сохранили свойство <Перечень аналогов товара ATC>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_AnalogATC(), inGoodsMainId, ioAnalogATC);
   -- сохранили свойство <Действующее вещество>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_ActiveSubstance(), inGoodsMainId, ioActiveSubstance);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET Analog = ioAnalog
                                , AnalogATC = ioAnalogATC
                                , ActiveSubstance = ioActiveSubstance
     WHERE Object_Goods_Main.Id = inGoodsMainId;
   EXCEPTION
      WHEN others THEN
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT;
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Analog', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 24.04.19                                                       *
 17.10.19                                                       *
 16.08.17                                                       *

*/

-- тест
--select * from gpUpdate_Goods_Analog(inGoodsMainId := 39513 , ioAnalog := '',  inSession := '3');