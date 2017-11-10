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

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 18.01.17         *

*/
--select * from gpUpdate_Goods_isUploadBadm(inId := 1393106 , inisUploadBadm := 'False' ,  inSession := '3');
--select * from gpUpdate_Goods_isUploadBadm(inId := 0 , inisUploadBadm := 'False' ,  inSession := '3');