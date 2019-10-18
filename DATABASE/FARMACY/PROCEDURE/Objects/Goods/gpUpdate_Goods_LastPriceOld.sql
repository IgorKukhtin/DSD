-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_LastPriceOld(Integer, TDateTime, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_LastPriceOld(
    IN inGoodsMainId             Integer   ,    -- ключ объекта <Товар>
    IN inLastPriceDate           TDateTime ,    -- Послед. дата наличия на рынке
    IN inLastPriceOldDate        TDateTime ,    -- Пред Послед. дата наличия на рынке
   OUT outCountDays              TFloat    ,
    IN inSession                 TVarChar       -- текущий пользователь
)
RETURNS TFloat AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE vbLastPriceOldDate  TDateTime;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- находим сохраненное значение
   vbLastPriceOldDate := (SELECT COALESCE (ObjectDate_LastPriceOld.ValueData, Null)
                          FROM ObjectDate AS ObjectDate_LastPriceOld
                          WHERE ObjectDate_LastPriceOld.ObjectId = inGoodsMainId
                            AND ObjectDate_LastPriceOld.DescId = zc_ObjectDate_Goods_LastPriceOld()) :: TDateTime;
   
   outCountDays := CAST (DATE_PART ('DAY', (inLastPriceOldDate - inLastPriceDate)) AS NUMERIC (15,2))  :: TFloat;

   -- сохранили свойство <Пред Послед. дата наличия на рынке>
   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_LastPriceOld(), inGoodsMainId, inLastPriceOldDate);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET LastPriceOld = inLastPriceOldDate
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_LastPriceOld', text_var1::TVarChar, vbUserId);
   END;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 16.08.17         *

*/

-- тест
--select * from gpUpdate_Goods_LastPriceOld(inGoodsMainId := 39513 , inLastPriceDate := ('07.07.2017')::TDateTime , inLastPriceOldDate := ('14.08.2017')::TDateTime ,  inSession := '3');