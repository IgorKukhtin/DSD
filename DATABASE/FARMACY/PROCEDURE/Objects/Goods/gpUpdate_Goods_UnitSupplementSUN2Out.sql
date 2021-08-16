-- Function: gpUpdate_Goods_UnitSupplementSUN2Out()

DROP FUNCTION IF EXISTS gpUpdate_Goods_UnitSupplementSUN2Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_UnitSupplementSUN2Out(
    IN inGoodsMainId               Integer   ,   -- ключ объекта <Товар>
    IN inUnitSupplementSUN2OutiD   Integer  ,    -- Подразделения для отправки по дополнению СУН1
    IN inSession                   TVarChar      -- текущий пользователь
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
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN2Out(), inGoodsMainId, inUnitSupplementSUN2OutiD);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET UnitSupplementSUN2OutId = inUnitSupplementSUN2OutiD
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_UnitSupplementSUN2Out', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.01.21                                                       *  

*/

-- тест
-- select * from gpUpdate_Goods_UnitSupplementSUN2Out(inGoodsMainId := 2389216 , inUnitSupplementSUN2Out := 377610 ,  inSession := '3');