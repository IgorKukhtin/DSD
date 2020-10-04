-- Function: gpUpdate_Goods_inPresent_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Goods_inPresent_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_inPresent_Revert(
    IN inGoodsMainId             Integer   ,   -- ключ объекта <Товар>
    IN inisPresent               Boolean  ,    -- Подарок
    IN inSession                 TVarChar      -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId            Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inGoodsMainId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);
   
   -- сохранили свойство <Дополнение СУН1>
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Present(), inGoodsMainId, NOT inisPresent);
   
    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isPresent = NOT inisPresent
     WHERE Object_Goods_Main.Id = inGoodsMainId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_inPresent_Revert', text_var1::TVarChar, vbUserId);
   END;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 01.10.20                                                       *  

*/

-- тест
-- select * from gpUpdate_Goods_inPresent_Revert(inGoodsMainId := 26898 , inisPresent := 'False' ,  inSession := '3');