-- Function: gpUpdate_Goods_PercentWages()

DROP FUNCTION IF EXISTS gpUpdate_Goods_PercentWages(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_PercentWages(
    IN inId               Integer   ,    -- ключ объекта <Товар>
    IN inPercentWages     TFloat    ,    -- % от продажи в зарплату
    IN inSession          TVarChar       -- текущий пользователь
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
   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_SummaWages(), inId, inPercentWages);

    -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Retail SET PercentWages = inPercentWages
     WHERE Object_Goods_Retail.Id = inId;  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_PercentWages', text_var1::TVarChar, vbUserId);
   END;


   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
29.10.20                                                        *
*/