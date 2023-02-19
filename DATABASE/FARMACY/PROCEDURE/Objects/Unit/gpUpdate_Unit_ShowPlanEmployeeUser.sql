-- Function: gpUpdate_Unit_ShowPlanEmployeeUser()

DROP FUNCTION IF EXISTS gpUpdate_Unit_ShowPlanEmployeeUser(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_ShowPlanEmployeeUser(
    IN inId                     Integer   ,    -- ключ объекта <Подразделение>
    IN inisShowPlanEmployeeUser    Boolean   ,    -- Экспресс подтверждение ВИП
    IN inSession                TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 OR 
      COALESCE((SELECT ObjectBoolean_ShowPlanEmployeeUser.ValueData 
                FROM ObjectBoolean AS ObjectBoolean_ShowPlanEmployeeUser
                WHERE ObjectBoolean_ShowPlanEmployeeUser.ObjectId = COALESCE(inId, 0)
                  AND ObjectBoolean_ShowPlanEmployeeUser.DescId = zc_ObjectBoolean_Unit_ShowPlanEmployeeUser()), False) <>
      inisShowPlanEmployeeUser
   THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShowPlanEmployeeUser(), inId, not inisShowPlanEmployeeUser);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.06.22                                                       *
*/

-- select * from gpUpdate_Unit_ShowPlanEmployeeUser(inId := 13338606 , inisShowPlanEmployeeUser := 'False' ,  inSession := '3');