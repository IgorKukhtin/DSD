-- Function: gpUpdate_Goods_Multiplicity()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Multiplicity(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_Multiplicity(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inMultiplicity            TFloat  ,    -- Дополнение СУН1
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
   
   IF CEIL(1.0 / inMultiplicity) <> (1.0 / inMultiplicity)
   THEN
      RAISE EXCEPTION 'Ошибка. Введенное значение не кратно 1.';
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_Multiplicity(), inGoodsMainId, inMultiplicity);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET Multiplicity = inMultiplicity
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Multiplicity', text_var1::TVarChar, vbUserId);
   END;

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.03.21                                                       *  

*/

-- тест
--select * from gpUpdate_Goods_Multiplicity(inGoodsMainId := 39513 , inMultiplicity := '',  inSession := '3');