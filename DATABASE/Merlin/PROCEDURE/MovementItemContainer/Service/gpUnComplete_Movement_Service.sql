-- Function: gpUnComplete_Movement_Service (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Service (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Service(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Service());
    vbUserId:= lpGetUserBySession (inSession);

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.01.22         *
*/