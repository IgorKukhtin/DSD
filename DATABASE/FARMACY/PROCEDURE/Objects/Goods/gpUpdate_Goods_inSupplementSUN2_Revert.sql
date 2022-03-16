-- Function: gpUpdate_Goods_inSupplementSUN2_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN2_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN2_Revert(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisSupplementSUN2        Boolean  ,    -- Дополнение СУН1
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SupplementSUN2(), inGoodsMainId, not inisSupplementSUN2);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isSupplementSUN2 = not inisSupplementSUN2
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inSupplementSUN2_Revert', text_var1::TVarChar, vbUserId);
   END;
   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.20                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_inSupplementSUN2_Revert(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');