-- Function: gpUpdate_Unit_isPauseDistribListDiff()

DROP FUNCTION IF EXISTS gpUpdate_Unit_isPauseDistribListDiff(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Unit_isPauseDistribListDiff(
    IN inId                         Integer   ,    -- ключ объекта <Подразделение>
    IN inisPauseDistribListDiff     Boolean   ,    -- Разрешить заказ без контроля остатка по сети
    IN inSession                    TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

   IF COALESCE(inId, 0) = 0 THEN
      RETURN;
   END IF;

   vbUserId := lpGetUserBySession (inSession);


   PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_PauseDistribListDiff(), inId, not inisPauseDistribListDiff);
   
   IF COALESCE (inisPauseDistribListDiff, FALSE) = FALSE
   THEN
     PERFORM lpInsertUpdate_ObjectBoolean (zc_ObjectBoolean_Unit_RequestDistribListDiff(), inId, False);
   END IF;

   -- сохранили протокол
   PERFORM lpInsert_ObjectProtocol (inId, vbUserId);

END;$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.07.21                                                       *
*/