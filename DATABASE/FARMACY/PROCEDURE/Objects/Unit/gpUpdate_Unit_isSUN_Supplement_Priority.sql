-- Function: gpUpdate_Unit_isSUN_Supplement_Priority()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_Supplement_Priority(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_Supplement_Priority(
    IN inId                            Integer   ,    -- ключ объекта <Подразделение>
    IN inisSun_Supplement_Priority     Boolean   ,    -- Работают по СУН
   OUT outisSUN_Supplement_Priority    Boolean   ,
    IN inSession                       TVarChar       -- текущий пользователь
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
   outisSUN_Supplement_Priority:= NOT inisSUN_Supplement_Priority;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_Supplement_Priority(), inId, outisSUN_Supplement_Priority);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 17.04.21                                                       *
*/