-- Function: gpUpdate_Unit_isCheckUKTZED()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isCheckUKTZED(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isCheckUKTZED(
    IN inId                   Integer   ,    -- ключ объекта <Подразделение>
    IN inisCheckUKTZED        Boolean   ,    -- Запрет на печать чека, если есть позиция по УКТВЭД
   OUT outisCheckUKTZED       Boolean   ,
    IN inSession              TVarChar       -- текущий пользователь
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
   outisCheckUKTZED:= NOT inisCheckUKTZED;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_CheckUKTZED(), inId, outisCheckUKTZED);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 31.01.21                                                       *
*/