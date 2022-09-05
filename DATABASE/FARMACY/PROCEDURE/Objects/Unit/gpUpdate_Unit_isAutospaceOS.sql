-- Function: gpUpdate_Unit_isAutospaceOS()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isAutospaceOS(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isAutospaceOS(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisAutospaceOS       Boolean   ,    -- Автопростановка ОС	
   OUT outisAutospaceOS      Boolean   ,    -- Автопростановка ОС	
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
   outisAutospaceOS:= NOT inisAutospaceOS;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_AutospaceOS(), inId, outisAutospaceOS);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.22                                                       *
*/