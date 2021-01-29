-- Function: gpUpdate_Unit_isOutUKTZED_SUN1()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isOutUKTZED_SUN1(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isOutUKTZED_SUN1(
    IN inId                       Integer   ,    -- ключ объекта <Подразделение>
    IN inisOutUKTZED_SUN1         Boolean   ,    -- Работают по СУН
   OUT outisOutUKTZED_SUN1        Boolean   ,
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
   outisOutUKTZED_SUN1:= NOT inisOutUKTZED_SUN1;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_OutUKTZED_SUN1(), inId, outisOutUKTZED_SUN1);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 29.01.21                                                       *
*/