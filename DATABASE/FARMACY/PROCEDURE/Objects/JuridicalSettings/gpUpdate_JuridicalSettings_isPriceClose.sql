-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isPriceClose(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isPriceClose(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisPriceClose        Boolean   ,    -- правйс закрыт
   OUT outisPriceClose       Boolean   ,
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
   outisPriceClose:= NOT inisPriceClose;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isPriceClose(), inId, inisPriceClose);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Воробкало А.А.
 07.10.18         *
*/