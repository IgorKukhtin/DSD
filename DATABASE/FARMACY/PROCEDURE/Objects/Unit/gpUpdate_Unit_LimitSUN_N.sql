-- Function: gpUpdate_Unit_LimitSUN_N()

DROP FUNCTION IF EXISTS gpUpdate_Unit_LimitSUN_N(Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_LimitSUN_N(
    IN inId             Integer   ,    -- ключ объекта <Подразделение>
    IN inLimitSUN_N     TFloat    ,    --
    IN inSession        TVarChar       -- текущий пользователь
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
   PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_LimitSUN_N(), inId, inLimitSUN_N);
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.05.20         *
*/