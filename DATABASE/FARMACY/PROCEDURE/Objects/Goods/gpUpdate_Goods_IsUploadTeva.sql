-- Function: gpUpdate_Goods_isUploadTeva()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isUploadTeva(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_isUploadTeva(
    IN inId            Integer   ,    -- ключ объекта <подразделение>
    IN inisUploadTeva  Boolean   ,    --
   OUT outisUploadTeva Boolean   ,
    IN inSession       TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN


      
      IF COALESCE(inId, 0) = 0 
      THEN
           -- определили признак
           outisUploadTeva:= inisUploadTeva;
           RETURN;
      END IF;

      vbUserId := lpGetUserBySession (inSession);

      -- определили признак
      outisUploadTeva:= inisUploadTeva;

      PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_UploadTeva(), inId, outisUploadTeva);

        -- Сохранили в плоскую таблицй
      BEGIN
        UPDATE Object_Goods_Juridical SET isUploadTeva = COALESCE(inisUploadTeva, FALSE)
                                        , UserUpdateId = vbUserId
                                        , DateUpdate   = CURRENT_TIMESTAMP
        WHERE Object_Goods_Juridical.Id = inId
          AND Object_Goods_Juridical.isUploadTeva <> COALESCE(inisUploadTeva, FALSE);  
      EXCEPTION
         WHEN others THEN 
           GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
           PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isUploadTeva', text_var1::TVarChar, vbUserId);
      END;

      -- сохранили протокол
      PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Ярошенко Р.Ф.  Шаблий О.В.
 17.10.19                                                                                     * 
 30.03.17                                                                       *

*/
--select * from gpUpdate_Goods_isUploadTeva(inId := 1393106 , inisUploadTeva := 'False' ,  inSession := '3');