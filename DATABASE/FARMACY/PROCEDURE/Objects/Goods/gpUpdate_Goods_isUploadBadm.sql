-- Function: gpUpdate_Goods_isUploadBadm()

DROP FUNCTION IF EXISTS gpUpdate_Goods_isUploadBadm(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Goods_isUploadBadm(
    IN inId                  Integer   ,    -- ключ объекта <подразделение>
    IN inisUploadBadm        Boolean   ,    -- 
   OUT outisUploadBadm       Boolean   ,
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE text_var1 text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      -- определили признак
      outisUploadBadm:= inisUploadBadm;
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisUploadBadm:= inisUploadBadm;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Goods_UploadBadm(), inId, outisUploadBadm);

     -- Сохранили в плоскую таблицй
   BEGIN
     UPDATE Object_Goods_Juridical SET isUploadBadm = COALESCE(inisUploadBadm, FALSE)
                                     , UserUpdateId = vbUserId
                                     , DateUpdate   = CURRENT_TIMESTAMP
     WHERE Object_Goods_Juridical.Id = inId
       AND Object_Goods_Juridical.isUploadBadm <> COALESCE(inisUploadBadm, FALSE);  
   EXCEPTION
      WHEN others THEN 
        GET STACKED DIAGNOSTICS text_var1 = MESSAGE_TEXT; 
        PERFORM lpAddObject_Goods_Temp_Error('gpUpdate_Goods_isUploadBadm', text_var1::TVarChar, vbUserId);
   END;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.  Шаблий О.В.
 17.10.19                                                                      * 
 18.01.17         *

*/
--select * from gpUpdate_Goods_isUploadBadm(inId := 1393106 , inisUploadBadm := 'False' ,  inSession := '3');
--select * from gpUpdate_Goods_isUploadBadm(inId := 0 , inisUploadBadm := 'False' ,  inSession := '3');