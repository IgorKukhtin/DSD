-- Function: gpUpdate_Goods_UnitSupplementSUN1Out()

DROP FUNCTION IF EXISTS gpUpdate_Goods_UnitSupplementSUN1Out(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_UnitSupplementSUN1Out(
    IN inGoodsMainId               Integer   ,   -- ключ объекта <Товар>
    IN inUnitSupplementSUN1OutId   Integer  ,    -- Подразделения для отправки по дополнению СУН1
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
   

   IF EXISTS(SELECT Object_Goods_Main.UnitSupplementSUN1OutId
             FROM Object_Goods_Main  
             WHERE Object_Goods_Main.Id = inGoodsMainId
               AND COALESCE (Object_Goods_Main.UnitSupplementSUN1OutId, 0) <> 0)
   THEN
     PERFORM gpDelete_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId               := inGoodsMainId
                                                    , inUnitSupplementSUN1OutId   := (SELECT Object_Goods_Main.UnitSupplementSUN1OutId
                                                                                      FROM Object_Goods_Main  
                                                                                      WHERE Object_Goods_Main.Id = inGoodsMainId)
                                                    , inSession                   := inSession);
   END IF; 
      
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UnitSupplementSUN1Out(), inGoodsMainId, inUnitSupplementSUN1OutId);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET UnitSupplementSUN1OutId = inUnitSupplementSUN1OutId
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_UnitSupplementSUN1Out', text_var1::TVarChar, vbUserId);
   END;
   
   IF COALESCE (inUnitSupplementSUN1OutId, 0) <> 0
   THEN
     PERFORM gpInsertUpdate_GoodsBlob_UnitSupplementSUN1Out(inGoodsMainId               := inGoodsMainId
                                                          , inUnitSupplementSUN1OutId   := inUnitSupplementSUN1OutId
                                                          , inSession                   := inSession);
   END IF; 

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inGoodsMainId, vbUserId);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.01.21                                                       *  

*/

-- тест
-- select * from gpUpdate_Goods_UnitSupplementSUN1Out(inGoodsMainId := 24168 , inUnitSupplementSUN1OutId := 375626 ,  inSession := '3');
-- select * from gpUpdate_Goods_UnitSupplementSUN1Out(inGoodsMainId := 24168 , inUnitSupplementSUN1OutId := 1529734 ,  inSession := '3');