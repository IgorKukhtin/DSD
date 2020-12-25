-- Function: gpUpdate_Unit_isSUN_Supplement_out()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_Supplement_out(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_Supplement_out(
    IN inId                       Integer   ,    -- ключ объекта <Подразделение>
    IN inisSUN_Supplement_out     Boolean   ,    -- Работают по СУН
   OUT outisSUN_Supplement_out    Boolean   ,
    IN inSession                  TVarChar       -- текущий пользователь
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
   outisSUN_Supplement_out:= NOT inisSUN_Supplement_out;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_Supplement_out(), inId, outisSUN_Supplement_out);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.12.20                                                       *
*/