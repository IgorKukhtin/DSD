-- Function: gpUpdate_Unit_isErrorRROToVIP()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isErrorRROToVIP(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isErrorRROToVIP(
    IN inId                      Integer   ,    -- ключ объекта <подразделение>
    IN inisErrorRROToVIP         Boolean   ,    -- 
   OUT outisErrorRROToVIP        Boolean   ,
    IN inSession                 TVarChar       -- текущий пользователь
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
   outisErrorRROToVIP:= NOT inisErrorRROToVIP;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ErrorRROToVIP(), inId, outisErrorRROToVIP);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 14.12.21                                                      *

*/
--select * from gpUpdate_Unit_isErrorRROToVIP(inId := 1393106 , inisErrorRROToVIP := 'False' ,  inSession := '3');