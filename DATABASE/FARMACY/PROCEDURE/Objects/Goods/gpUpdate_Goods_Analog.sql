-- Function: gpUpdate_Goods_Analog()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Analog(Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Analog(
    IN inGoodsMainId             Integer   ,    -- ключ объекта <Товар>
 INOUT ioAnalog                  TVarChar  ,    -- Перечень аналогов товара
    IN inSession                 TVarChar       -- текущий пользователь
)
RETURNS TVarChar AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      ioAnalog := '';
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- сохранили свойство <Перечень аналогов товара>
   PERFORM lpInsertUpdate_ObjectString (zc_ObjectString_Goods_Analog(), inGoodsMainId, ioAnalog);
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.08.17         *

*/

-- тест
--select * from gpUpdate_Goods_Analog(inGoodsMainId := 39513 , ioAnalog := '',  inSession := '3');