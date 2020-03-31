-- Function: gpUpdate_Goods_isSUN_v3()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isSUN_v3(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isSUN_v3(
    IN inId               Integer   ,    -- ключ объекта <Товар>
    IN inisSUN_v3         Boolean   ,    -- Работают по Э-СУН
   OUT outisSUN_v3        Boolean   ,    -- Работают по Э-СУН
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
   
   outisSUN_v3 := inisSUN_v3;

   -- сохранили св-во
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_SUN_v3(), inId, inisSUN_v3);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Retail SET isSUN_v3 = inisSUN_v3
     WHERE Object_Goods_Retail.GoodsMainId IN (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isSUN_v3', text_var1::TVarChar, vbUserId);
   END;


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.03.20         *
*/