-- Function: gpUpdate_Unit_T_SUN()

DROP FUNCTION IF EXISTS gpUpdate_Unit_T_SUN(Integer, Boolean, Boolean, Boolean, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_T_SUN(
    IN inId             Integer   ,    -- ключ объекта <Подразделение>
    IN inisT1_SUN_v2    Boolean    ,    --
    IN inisT2_SUN_v2    Boolean    ,    --
    IN inisT1_SUN_v4    Boolean    ,    --
    IN inT1_SUN_v2      TFloat    ,    --
    IN inT2_SUN_v2      TFloat    ,    --
    IN inT1_SUN_v4      TFloat    ,    --
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

   IF COALESCE (inisT1_SUN_v2, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T1_SUN_v2(), inId, inT1_SUN_v2);
   END IF;
   
   IF COALESCE (inisT2_SUN_v2, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T2_SUN_v2(), inId, inT2_SUN_v2);
   END IF;
   
   IF COALESCE (inisT1_SUN_v4, FALSE) = TRUE
   THEN
       -- сохранили <>
       PERFORM lpInsertUpdate_ObjectFloat(zc_ObjectFloat_Unit_T1_SUN_v4(), inId, inT1_SUN_v4);
   END IF;
  
   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.04.20         *
*/