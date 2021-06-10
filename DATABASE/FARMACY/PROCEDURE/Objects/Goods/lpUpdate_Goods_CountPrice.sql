-- Function: lpUpdate_Goods_CountPrice()

DROP FUNCTION IF EXISTS lpUpdate_Goods_CountPrice(Integer, TFloat, Integer);

CREATE OR REPLACE FUNCTION lpUpdate_Goods_CountPrice(
    IN inGoodsId                 Integer   ,   -- ключ объекта <Товар>
    IN inCountPrice              TFloat    ,   -- Дополнение СУН1
    IN inUserId                  Integer        -- 
)
RETURNS VOID AS
$BODY$
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_CountPrice(), inGoodsId, inCountPrice);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET CountPrice = inCountPrice
     WHERE Object_Goods_Main.Id = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inGoodsId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Multiplicity', text_var1::TVarChar, inUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 10.06.21                                                       *  

*/

-- тест
--select * from lpUpdate_Goods_CountPrice(inGoodsMainId := 39513 , inMultiplicity := '',  inSession := '3');