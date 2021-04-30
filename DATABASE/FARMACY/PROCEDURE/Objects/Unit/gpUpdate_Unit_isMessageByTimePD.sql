-- Function: gpUpdate_Unit_isMessageByTimePD()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isMessageByTimePD(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isMessageByTimePD(
    IN inId                      Integer   ,    -- ключ объекта <Подразделение>
    IN inisMessageByTimePD       Boolean   ,    -- Сообщение в кассе по срокам
   OUT outisMessageByTimePD      Boolean   ,
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
   outisMessageByTimePD:= NOT inisMessageByTimePD;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_MessageByTimePD(), inId, outisMessageByTimePD);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.04.21                                                       *
*/