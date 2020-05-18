-- Function: gpUpdate_Goods_GoodsPairSun()

DROP FUNCTION IF EXISTS gpUpdate_Goods_GoodsPairSun(Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_GoodsPairSun(
    IN inId             Integer   ,    -- ключ объекта <>
    IN inGoodsPairSunId Integer   ,    --
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE text_var1    text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPairSun(), inId, inGoodsPairSunId);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Retail SET GoodsPairSunId = inGoodsPairSunId
     WHERE Object_Goods_Retail.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_GoodsPairSunId', text_var1::TVarChar, vbUserId);
   END;

   
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.05.20         *
*/