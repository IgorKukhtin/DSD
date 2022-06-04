-- Function: gpUpdate_Goods_PublishedAll()

DROP FUNCTION IF EXISTS gpUpdate_Goods_PublishedAll(Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_PublishedAll(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
    IN inIsPublished         Boolean   ,    -- опубликован на сайте
    IN inIsPublishedSite     Boolean   ,    -- опубликован на сайте с сайта
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

    IF COALESCE(inId, 0) = 0 
    THEN
      RETURN;
    END IF;
    
    IF NOT EXISTS(SELECT  
                  FROM Object_Goods_Main
                  WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId)
                    AND (isPublished <> inIsPublished OR isPublishedSite is NOT NULL AND isPublishedSite <> inIsPublishedSite))
    THEN
      RETURN;
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), inId, inIsPublished);
    
    -- Сохранили в плоскую таблицй
    BEGIN
      UPDATE Object_Goods_Main SET isPublished = inIsPublished
                                 , isPublishedSite = CASE WHEN isPublishedSite is NULL THEN isPublishedSite ELSE inIsPublishedSite END
                                 , DateUpdateSite = CASE WHEN isPublished <> inIsPublished THEN CURRENT_TIMESTAMP ELSE DateUpdateSite END
      WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
    EXCEPTION
       WHEN others THEN 
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
         PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_PublishedAll', text_var1::TVarChar, vbUserId);
    END;
              
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Goods_Published(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 17.05.22                                                                      *         
*/

-- select * from gpUpdate_Goods_PublishedAll(inId := 30502 , inIsPublished := 'True' , inIsPublishedSite := 'False',  inSession := '3');

