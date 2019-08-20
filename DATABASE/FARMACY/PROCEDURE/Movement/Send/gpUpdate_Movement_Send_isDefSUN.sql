-- Function: gpUpdate_Movement_Send_isDefSUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isDefSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isDefSUN(
    IN inMovementId     Integer   ,    -- ключ документа
    IN inisDefSUN       Boolean   ,    -- 
   OUT outisDefSUN      Boolean   ,
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisSUN Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   -- проверка прав
   --vbUserId := lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_IsDefSUN());
   
      -- параметры документа
   SELECT COALESCE (MovementBoolean_SUN.ValueData, FALSE) AS isSUN
   INTO vbisSUN
   FROM MovementBoolean AS MovementBoolean_SUN
   WHERE MovementBoolean_SUN.MovementId = inMovementId
     AND MovementBoolean_SUN.DescId = zc_MovementBoolean_SUN();

   -- переопределили
   outisDefSUN := not inisDefSUN;
   
   -- проверка если уже установлена галка isDefSUN
   IF outisDefSUN = TRUE AND vbisSUN = TRUE
   THEN
       outisDefSUN := inisDefSUN;
       RAISE EXCEPTION 'Ошибка. Уже установлено свойство Перемещение по СУН.';
   END IF;

   -- сохранили признак
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_DefSUN(), inMovementId, outisDefSUN);

   -- сохранили протокол
   PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, FALSE);

END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.19         *
*/