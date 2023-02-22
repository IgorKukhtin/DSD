-- Function: gpUpdate_Unit_SetShowPlanMobileAppUser()

DROP FUNCTION IF EXISTS gpUpdate_Unit_SetShowPlanMobileAppUser(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_SetShowPlanMobileAppUser(
    IN inId                       Integer   ,    -- ключ объекта <Подразделение>
    IN inisShowPlanMobileAppUser   Boolean   ,    -- Экспресс подтверждение ВИП
    IN inSession                  TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);

   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_ShowPlanMobileAppUser(), inId, inisShowPlanMobileAppUser);

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 21.02.23                                                       *
*/

-- select * from gpUpdate_Unit_SetShowPlanMobileAppUser(inId := 13338606 , inisShowPlanMobileAppUser := 'False' ,  inSession := '3');