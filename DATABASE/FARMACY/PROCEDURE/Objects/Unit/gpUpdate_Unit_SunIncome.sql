-- Function: gpUpdate_Unit_SunIncome()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SunIncome(Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SunIncome(
    IN inId             Integer   ,    -- ключ объекта <>
    IN inis_v1          Boolean   ,    --
    IN inis_v2          Boolean   ,    --
    IN inis_v4          Boolean   ,    --
    IN inSunIncome      TFloat    ,    --
    IN inSun_v2Income   TFloat    ,    --
    IN inSun_v4Income   TFloat    ,    --
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId     Integer;
   DECLARE text_var1    text;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;
   
   -- проверка прав пользователя на вызов процедуры
   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE (inis_v1, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_SunIncome(), inId, inSunIncome);
   END IF;
   
   IF COALESCE (inis_v2, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Sun_v2Income(), inId, inSun_v2Income);
   END IF;
   
   IF COALESCE (inis_v4, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_Sun_v4Income(), inId, inSun_v4Income);
   END IF;
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 112.05.20         *
*/