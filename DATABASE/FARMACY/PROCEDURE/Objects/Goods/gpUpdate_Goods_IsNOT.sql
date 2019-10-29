-- Function: gpUpdate_Object_Goods_IsHOT()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isNOT(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_isNOT(
    IN inId        Integer   ,    -- ключ объекта <Товар>
    IN inisNOT     Boolean   ,    -- НОТ-неперемещаемый остаток
    IN inSession   TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   --
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили св-во
   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_NOT(), inId, inisNOT);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Main SET isNOT = inisNOT
     WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isNOT', text_var1::TVarChar, vbUserId);
   END;

   --outisNOT:=
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.10.19                                                       *
 24.10.19         * 
*/