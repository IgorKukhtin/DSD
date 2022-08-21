-- Function: gpUpdate_Movement_ReturnOut_Deferred_Revert()

DROP FUNCTION IF EXISTS gpUpdate_Movement_ReturnOut_Deferred_Revert(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_ReturnOut_Deferred_Revert(
    IN inMovementId          Integer   ,    -- ключ документа
    IN inisDeferred          Boolean   ,    -- Отложен
    IN inSession             TVarChar       -- текущий пользователь
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbStatusId Integer;
   DECLARE vbisDeferred Boolean;
BEGIN

   vbUserId := lpGetUserBySession (inSession);

   IF COALESCE(inMovementId, 0) = 0 THEN
      RETURN;
   END IF;

    -- параметры документа
    SELECT
        Movement.StatusId,
        COALESCE (MovementBoolean_Deferred.ValueData, FALSE)
    INTO
        vbStatusId,
        vbisDeferred
    FROM Movement
        LEFT JOIN MovementBoolean AS MovementBoolean_Deferred
                                  ON MovementBoolean_Deferred.MovementId = Movement.Id
                                 AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()
    WHERE Movement.Id = inMovementId;
   
   -- свойство меняем у не проведенных документов
   IF COALESCE (vbStatusId, 0) = zc_Enum_Status_UnComplete()
   THEN
     PERFORM gpUpdate_Movement_ReturnOut_Deferred(inMovementId := inMovementId, inisDeferred := NOT inisDeferred, inSession := inSession);
   END IF;
   
END;
$BODY$

LANGUAGE plpgsql VOLATILE;
  
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 18.08.22                                                      *
*/

