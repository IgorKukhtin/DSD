-- Function: gpUpdate_Unit_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpUpdate_Unit_TechnicalRediscount(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_TechnicalRediscount(
    IN inId                       Integer   ,    -- ключ объекта <Подразделение>
    IN inisTechnicalRediscount    Boolean   ,    -- Технический переучет
   OUT outisTechnicalRediscount   Boolean   ,
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
   outisTechnicalRediscount:= NOT inisTechnicalRediscount;

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_TechnicalRediscount(), inId, outisTechnicalRediscount);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 28.02.20                                                       *
*/