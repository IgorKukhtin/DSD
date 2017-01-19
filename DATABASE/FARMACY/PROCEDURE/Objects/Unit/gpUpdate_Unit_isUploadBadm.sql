-- Function: gpUpdate_Unit_isUploadBadm()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isUploadBadm(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isUploadBadm(
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
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   -- определили признак
   outisUploadBadm:= NOT inisUploadBadm;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_UploadBadm(), inId, outisUploadBadm);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 17.01.17         *

*/
--select * from gpUpdate_Unit_isUploadBadm(inId := 1393106 , inisUploadBadm := 'False' ,  inSession := '3');