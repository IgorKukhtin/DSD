-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isBonusClose(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isBonusClose(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisBonusClose        Boolean   ,    -- бонус не использовать
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

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isBonusClose(), inId, inisBonusClose);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 06.02.19         *
*/