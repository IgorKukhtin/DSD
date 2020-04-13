-- Function: gpUpdate_Unit_AlertRecounting()

DROP FUNCTION IF EXISTS gpUpdate_Unit_AlertRecounting(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_AlertRecounting(
    IN inId                       Integer   ,    -- ключ объекта <Подразделение>
    IN inisAlertRecounting    Boolean   ,    -- Технический переучет
   OUT outisAlertRecounting   Boolean   ,
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
   outisAlertRecounting:= NOT inisAlertRecounting;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_AlertRecounting(), inId, outisAlertRecounting);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 13.04.20                                                       *
*/