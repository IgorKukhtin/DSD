-- Function: gpUpdate_Unit_isMessageByTime()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isMessageByTime(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isMessageByTime(
    IN inId                      Integer   ,    -- ключ объекта <Подразделение>
    IN inisMessageByTime         Boolean   ,    -- Сообщение в кассе по срокам
   OUT outisMessageByTime        Boolean   ,
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
   outisMessageByTime:= NOT inisMessageByTime;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_MessageByTime(), inId, outisMessageByTime);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.04.21                                                       *
*/