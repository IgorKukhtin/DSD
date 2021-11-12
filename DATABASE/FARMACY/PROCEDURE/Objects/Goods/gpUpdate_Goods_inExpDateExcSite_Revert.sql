-- Function: gpUpdate_Goods_inExpDateExcSite_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inExpDateExcSite_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inExpDateExcSite_Revert(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisExpDateExcSite          Boolean  ,    -- Невидимка для ограничений по СУН
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
   
   -- сохранили свойство <Невидимка для ограничений по СУН>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_ExpDateExcSite(), inGoodsMainId, not inisExpDateExcSite);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isExpDateExcSite = not inisExpDateExcSite
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inExpDateExcSite', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.11.21                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_inExpDateExcSite_Revert(inGoodsMainId := 39513 , inisExpDateExcSite := '',  inSession := '3');