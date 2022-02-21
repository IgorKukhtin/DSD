-- Function: gpInsertUpdate_Goods_AddSupplement()

DROP FUNCTION IF EXISTS gpInsertUpdate_Goods_AddSupplement(Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Goods_AddSupplement(
    IN inGoodsId             Integer   ,   -- ключ объекта <Товар>
    IN inSession             TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   IF EXISTS(SELECT 1
             FROM Object_Goods_Retail
                  INNER JOIN Object_Goods_Main ON Object_Goods_Main.ID = Object_Goods_Retail.GoodsMainId
                                              AND Object_Goods_Main.isSupplementSUN1 = TRUE
             WHERE Object_Goods_Retail.Id = inGoodsId )
   THEN
     RAISE EXCEPTION 'Товар уже добавлен для распределения по дополнению СУН 1.';       
   END IF;
   
   
   -- сохранили свойство <Дополнение СУН1>
   PERFORM gpUpdate_Goods_inSupplementSUN1(inGoodsMainId := Object_Goods_Retail.GoodsMainId , inisSupplementSUN1 := False,  inSession := inSession)
   FROM Object_Goods_Retail
   WHERE Object_Goods_Retail.Id = inGoodsId;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.06.20                                                       *  

*/

-- тест
--
--select * from gpInsertUpdate_Goods_AddSupplement(inGoodsId := 15704741 ,  inSession := '3');