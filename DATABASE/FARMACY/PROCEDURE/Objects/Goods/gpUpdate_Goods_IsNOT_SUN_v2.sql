-- Function: gpUpdate_Goods_IsNOT_SUN_v2()

DROP FUNCTION IF EXISTS gpUpdate_Goods_IsNOT_SUN_v2(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_IsNOT_SUN_v2(
    IN inId               Integer   ,    -- ключ объекта <Товар>
    IN inisNOT_SUN_v2     Boolean   ,    -- НОТ-неперемещаемый остаток для СУН-v2
   OUT outisNOT_SUN_v2    Boolean   ,    -- НОТ-неперемещаемый остаток для СУН-v2
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
   
   outisNOT_SUN_v2 := inisNOT_SUN_v2;

   -- сохранили св-во
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NOT_SUN_v2(), inId, inisNOT_SUN_v2);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isNOT_Sun_v2 = inisNOT_SUN_v2
     WHERE Object_Goods_Main.Id = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isNOT_Sun_v2', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.12.19         *
*/