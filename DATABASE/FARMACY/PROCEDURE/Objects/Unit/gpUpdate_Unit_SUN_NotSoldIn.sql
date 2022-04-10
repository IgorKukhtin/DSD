-- Function: gpUpdate_Unit_SUN_NotSoldIn()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SUN_NotSoldIn(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SUN_NotSoldIn(
    IN inId                Integer   ,    -- ключ объекта <Подразделение>
    IN inisSUN_NotSoldIn   Boolean   ,    -- Работают по СУН
   OUT outisSUN_NotSoldIn  Boolean   ,
    IN inSession           TVarChar       -- текущий пользователь
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
   outisSUN_NotSoldIn:= NOT inisSUN_NotSoldIn;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_NotSoldIn(), inId, outisSUN_NotSoldIn);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 09.04.22                                                       *
*/