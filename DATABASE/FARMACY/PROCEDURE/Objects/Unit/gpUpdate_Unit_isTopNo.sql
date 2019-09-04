-- Function: gpUpdate_Unit_isTopNo()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isTopNo(Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpUpdate_Unit_isTopNo(
    IN inId             Integer   ,    -- ключ объекта <подразделение>
    IN inisTopNo        Boolean   ,    -- 
   OUT outisTopNo       Boolean   ,
    IN inSession        TVarChar       -- текущий пользователь
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
   outisTopNo:= NOT inisTopNo;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_TopNo(), inId, outisTopNo);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.19         *

*/
--