-- Function: gpUpdate_Unit_KoeffSUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_KoeffSUN(Integer, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_KoeffSUN(
    IN inId               Integer   ,    -- ключ объекта <Подразделение>
    IN inKoeffInSUN       TFloat    ,    --
    IN inKoeffOutSUN      TFloat    ,    --
    IN inSession          TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffInSUN(), inId, inKoeffInSUN);
   -- сохранили <>
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_KoeffOutSUN(), inId, inKoeffOutSUN);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.09.19         *
*/