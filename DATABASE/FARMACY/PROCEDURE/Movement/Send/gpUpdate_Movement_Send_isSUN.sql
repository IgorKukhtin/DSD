-- Function: gpUpdate_Movement_Send_isSUN()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Send_isSUN(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Send_isSUN(
    IN inMovementId     Integer   ,    -- ключ документа
    IN inisSUN          Boolean   ,    -- 
   OUT outisSUN         Boolean   ,
    IN inSession        TVarChar       -- текущий пользователь
)
RETURNS Boolean AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbisDefSUN Boolean;
BEGIN

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

   -- проверка прав
   --vbUserId := lpGetUserBySession (inSession);
   vbUserId := lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Send_IsSUN());

   -- параметры документа
   SELECT COALESCE (MovementBoolean_DefSUN.ValueData, FALSE) isDefSUN
   INTO vbisDefSUN
   FROM MovementBoolean AS MovementBoolean_DefSUN
   WHERE MovementBoolean_DefSUN.MovementId = inMovementId
     AND MovementBoolean_DefSUN.DescId = zc_MovementBoolean_DefSUN();

   -- переопределили
   outisSUN := not inisSUN;
   
   -- проверка если уже установлена галка isDefSUN
   IF outisSUN = TRUE AND vbisDefSUN = TRUE
   THEN
       outisSUN := inisSUN;
       RAISE EXCEPTION 'Ошибка. Уже установлено свойство Отложенно перемещение по СУН.';
   END IF;

   -- сохранили признак
   PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_SUN(), inMovementId, outisSUN);
   
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