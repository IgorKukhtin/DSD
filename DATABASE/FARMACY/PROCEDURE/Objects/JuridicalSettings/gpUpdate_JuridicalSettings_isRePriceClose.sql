-- Function: 
DROP FUNCTION IF EXISTS gpUpdate_JuridicalSettings_isRePriceClose(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_JuridicalSettings_isRePriceClose(
    IN inId                  Integer   ,    -- ключ объекта <Подразделение>
    IN inisRePriceClose      Boolean   ,    -- правйс закрыт для автопереоценки
   OUT outisRePriceClose     Boolean   ,
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
   outisRePriceClose:= NOT inisRePriceClose;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_JuridicalSettings_isRePriceClose(), inId, inisRePriceClose);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 18.10.18         *
*/