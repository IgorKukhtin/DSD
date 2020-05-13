-- Function: gpUpdate_Goods_inInvisibleSUN_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inInvisibleSUN_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inInvisibleSUN_Revert(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisInvisibleSUN          Boolean  ,    -- Невидимка для ограничений по СУН
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   -- сохранили свойство <Невидимка для ограничений по СУН>
   PERFORM gpUpdate_Goods_inInvisibleSUN (inGoodsMainId, not inisInvisibleSUN, inSession);
   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.05.20                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_inInvisibleSUN_Revert(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');