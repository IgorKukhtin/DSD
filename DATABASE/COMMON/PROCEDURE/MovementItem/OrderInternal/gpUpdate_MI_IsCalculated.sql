-- Function: gpUpdate_MI_IsCalculated()

DROP FUNCTION IF EXISTS gpUpdate_MI_IsCalculated(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_IsCalculated(
    IN inId                  Integer   ,    -- ключ объекта <>
    IN inIsCalculated        Boolean   ,    -- 
   OUT outIsCalculated       Boolean   ,
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
   outIsCalculated:= NOT inIsCalculated;
   
   -- сохраняем 
   PERFORM lpInsertUpdate_MovementItemBoolean (zc_MIBoolean_Calculated(), inId, inIsCalculated);

   -- сохранили протокол
   PERFORM lpInsert_MovementItemProtocol (inId, vbUserId, FALSE);

END;$BODY$

LANGUAGE plpgsql VOLATILE;

  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 03.11.20         *

*/