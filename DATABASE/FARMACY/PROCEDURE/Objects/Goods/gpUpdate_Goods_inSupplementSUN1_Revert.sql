-- Function: gpUpdate_Goods_inSupplementSUN1_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inSupplementSUN1_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inSupplementSUN1_Revert(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisSupplementSUN1        Boolean  ,    -- Дополнение СУН1
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   -- сохранили свойство <Дополнение СУН1>
   PERFORM gpUpdate_Goods_inSupplementSUN1 (inGoodsMainId, not inisSupplementSUN1, inSession);
   -- сохранили свойство <Дополнение СУН1 маркетинг>
   PERFORM gpUpdate_Goods_inSupplementMarkSUN1_Revert (inGoodsMainId, inisSupplementSUN1, inSession);
   

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.20                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_inSupplementSUN1_Revert(inGoodsMainId := 39513 , inisInvisibleSUN := '',  inSession := '3');