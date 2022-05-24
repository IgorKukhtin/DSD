-- Function: gpUpdate_Object_Goods_Published()

DROP FUNCTION IF EXISTS gpUpdate_Goods_Published(Integer, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_Published(
    IN inId                  Integer   ,    -- ключ объекта <Товар>
   OUT outisPublished        Boolean   ,    -- опубликован на сайте
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

    IF COALESCE(inId, 0) = 0 THEN
      RETURN;
    END IF;

    vbUserId := lpGetUserBySession (inSession);

    outisPublished = False;
    
    PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_Published(), inId, False);
    
    -- Сохранили в плоскую таблицй
    BEGIN
      UPDATE Object_Goods_Main SET isPublished = False
                                 , DateUpdateSite = CURRENT_TIMESTAMP
      WHERE Object_Goods_Main.ID = (SELECT Object_Goods_Retail.GoodsMainId FROM Object_Goods_Retail WHERE Object_Goods_Retail.Id = inId);  
    EXCEPTION
       WHEN others THEN 
         GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
         PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_Published', text_var1::TVarChar, vbUserId);
    END;
              
    -- сохранили протокол
    PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpUpdate_Goods_Published(Integer, Boolean, TVarChar) OWNER TO postgres;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 17.10.19                                                                      *         
 30.04.16         *
*/

--select * from gpUpdate_Goods_Published(inId := 559417 , inIsPublished := 'True' ,  inSession := '3');