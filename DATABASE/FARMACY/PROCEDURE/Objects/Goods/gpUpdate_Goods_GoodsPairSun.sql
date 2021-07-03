-- Function: gpUpdate_Goods_GoodsPairSun()

DROP FUNCTION IF EXISTS gpUpdate_Goods_GoodsPairSun(Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpUpdate_Goods_GoodsPairSun(Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_GoodsPairSun(
    IN inId             Integer   ,    -- ключ объекта <>
    IN inGoodsPairSunId Integer   ,    --
    IN inPairSunAmount  TFloat    ,    --
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId      Integer;
   DECLARE vbGoodsPairSunId Integer;
   DECLARE text_var1     text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   -- свойство zc_ObjectDate_Goods_PairSun Формируется автоматом, после первого заполнения zc_ObjectLink_Goods_GoodsPairSun
   vbGoodsPairSunId := (SELECT ObjectLink.ChildObjectId FROM ObjectLink WHERE ObjectLink.DescId = zc_ObjectLink_Goods_GoodsPairSun() AND ObjectLink.ObjectId = inId);

   -- записываем только при первом сохранении
   IF COALESCE (vbGoodsPairSunId,0) = 0 AND COALESCE (inGoodsPairSunId) <> 0
   THEN
       PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_PairSun(), inId, CURRENT_Date);

       -- Сохранили в плоскую таблицй
       BEGIN
         UPDATE Object_Goods_Retail SET PairSunDate = CURRENT_Date
         WHERE Object_Goods_Retail.Id = inId;  
       EXCEPTION
          WHEN others THEN 
            GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
            PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_PairSunDate', text_var1::TVarChar, vbUserId);
       END;

   END IF;

   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_GoodsPairSun(), inId, inGoodsPairSunId);
   -- сохранили свойство <>
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_PairSunAmount(), inId, inPairSunAmount);

   -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Retail SET GoodsPairSunId = inGoodsPairSunId
                                  , PairSunAmount  = inPairSunAmount
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


-- select * from gpUpdate_Goods_GoodsPairSun(inGoodsId := 596529 , inGoodsPairSunId := 42562 , inPairSunAmount := 2 ,  inSession := '3');