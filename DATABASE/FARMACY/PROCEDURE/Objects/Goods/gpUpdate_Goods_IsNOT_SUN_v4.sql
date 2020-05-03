-- Function: gpUpdate_Goods_IsNOT_SUN_v4()

DROP FUNCTION IF EXISTS gpUpdate_Goods_IsNOT_SUN_v4(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IsNOT_SUN_v4(
    IN inId               Integer   ,    -- ключ объекта <Товар>
    IN inisNOT_SUN_v4     Boolean   ,    -- НОТ-неперемещаемый остаток для СУН-v2 ПИ
   OUT outisNOT_SUN_v4    Boolean   ,    -- НОТ-неперемещаемый остаток для СУН-v2 ПИ
    IN inSession          TVarChar       -- текущий пользователь
)
RETURNS BOOLEAN AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);
   
   outisNOT_SUN_v4 := inisNOT_SUN_v4;

   -- сохранили св-во
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NOT_Sun_v4(), inId, inisNOT_SUN_v4);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isNOT_Sun_v4 = inisNOT_SUN_v4
     WHERE Object_Goods_Main.Id = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isNOT_Sun_v4', text_var1::TVarChar, vbUserId);
   END;
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 03.05.20         *
*/