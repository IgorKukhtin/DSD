-- Function: gpUpdate_Unit_isSUN_v2_Supplement_in()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isSUN_v2_Supplement_in(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isSUN_v2_Supplement_in(
    IN inId                         Integer   ,    -- ключ объекта <Подразделение>
    IN inisSUN_v2_Supplement_in     Boolean   ,    -- Работают по СУН
   OUT outisSUN_v2_Supplement_in    Boolean   ,
    IN inSession                    TVarChar       -- текущий пользователь
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
   outisSUN_v2_Supplement_in:= NOT inisSUN_v2_Supplement_in;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_SUN_v2_Supplement_in(), inId, outisSUN_v2_Supplement_in);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.12.20                                                       *
*/