-- Function: gpReComplete_Movement_Loss(integer, tvarchar)

DROP FUNCTION IF EXISTS gpReComplete_Movement_Loss (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpReComplete_Movement_Loss(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Loss());
    vbUserId:= lpGetUserBySession (inSession);
    
    -- только если документ проведен
    IF EXISTS(
                SELECT 1
                FROM Movement
                WHERE Id = inMovementId
                  AND StatusId = zc_Enum_Status_Complete()
              )
    THEN
        --распроводим документ
        PERFORM gpUpdate_Status_Loss(inMovementId := inMovementId,
                                          inStatusCode := zc_Enum_StatusCode_UnComplete(),
                                          inSession    := inSession);
        --Проводим документ
        PERFORM gpUpdate_Status_Loss(inMovementId := inMovementId,
                                          inStatusCode := zc_Enum_StatusCode_Complete(),
                                          inSession    := inSession);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.02.21         *
*/
