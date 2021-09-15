-- Function: gpInsertUpdate_Object_Goods()

DROP FUNCTION IF EXISTS gpUpdate_Goods_MinimumLot(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Goods_MinimumLot(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inMinimumLot          TFloat    ,    -- Групповая упаковка
   OUT outUpdateDate         TDateTime ,
   OUT outUpdateName         TVarChar  ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS record AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbMinimumLot TFloat; 
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   IF inMinimumLot = 0 THEN 
      inMinimumLot := NULL;
   END IF;   	

    -- Получаем сохраненное значение св-ва
    vbMinimumLot:=COALESCE((SELECT ObjectFloat.ValueData FROM ObjectFloat WHERE ObjectFloat.DescId = zc_ObjectFloat_Goods_MinimumLot() AND ObjectFloat.ObjectId = inId),0);


   PERFORM lpInsertUpdate_ObjectFloat (zc_ObjectFloat_Goods_MinimumLot(), inId, inMinimumLot);

   IF COALESCE(inMinimumLot,0) <> vbMinimumLot 
   THEN
         -- сохранили свойство <Дата корректировки>
        PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Goods_UpdateMinimumLot(), inId, CURRENT_TIMESTAMP);
        -- сохранили свойство <Пользователь (корректировка)>
        PERFORM lpInsertUpdate_ObjectLink (zc_ObjectLink_Goods_UpdateMinimumLot(), inId, vbUserId);
   
          -- Сохранили в плоскую таблицй
         BEGIN
           UPDATE Object_Goods_Juridical SET isMinimumLot = inMinimumLot
                                           , UserUpdateId = vbUserId
                                           , DateUpdate   = CURRENT_TIMESTAMP
                                           , UserUpdateMinimumLotId = vbUserId
                                           , DateUpdateMinimumLot   = CURRENT_TIMESTAMP
           WHERE Object_Goods_Juridical.Id = inId;  
         EXCEPTION
            WHEN others THEN 
              GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
              PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_MinimumLot', text_var1::TVarChar, vbUserId);
         END;
   END IF;

          outUpdateDate:=COALESCE((SELECT ObjectDate.ValueData FROM ObjectDate WHERE ObjectDate.ObjectId = inId AND ObjectDate.DescId = zc_ObjectDate_Protocol_Update()),Null) ::TDateTime;    

          outUpdateName:=COALESCE((SELECT Object.ValueData
                                   FROM ObjectLink
                                     LEFT JOIN Object ON Object.Id = ObjectLink.ChildObjectId
                                   WHERE ObjectLink.ObjectId = inId AND ObjectLink.DescId =  zc_ObjectLink_Protocol_Update()),'') ::TVarChar;    

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpUpdate_Goods_MinimumLot(Integer, TFloat, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 17.10.19                                                      * 
 11.11.14                        *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Object_Goods