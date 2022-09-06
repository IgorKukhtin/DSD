-- Function: gpUpdate_Unit_SetDateRRO()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetDateRRO(Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetDateRRO(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inSetDateRRO          TDateTime ,    -- Автопростановка ОС	
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectDate (zc_ObjectDate_Unit_SetDateRRO(), inId, inSetDateRRO);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05.09.22                                                       *
*/