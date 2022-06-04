-- Function: gpUpdate_Object_PublishedSite()

DROP FUNCTION IF EXISTS gpUpdate_Goods_PublishedSite(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_PublishedSite(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inStatus              Integer   ,    -- опубликован на сайте
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

    IF COALESCE(inId, 0) = 0 THEN
      RETURN;
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), inId, inStatus <> 0);
    
    -- Сохранили в плоскую таблицй
    BEGIN
      UPDATE Object_Goods_Main SET isPublished = inStatus <> 0
                                 , DateUpdateSite = CURRENT_TIMESTAMP
      WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
    EXCEPTION
       WHEN others THEN 
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
         PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Object_PublishedSite', text_var1::TVarChar, vbUserId);
    END;
              
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Object_PublishedSite(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 03.06.22                                                      *         
*/

-- select * from gpUpdate_Goods_PublishedSite(inId := 30502  , inStatus := 0,  inSession := zfCalc_UserSite());

