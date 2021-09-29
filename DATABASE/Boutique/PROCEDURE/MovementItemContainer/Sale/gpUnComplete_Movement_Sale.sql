-- Function: gpUnComplete_Movement_Sale (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Sale (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Sale(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId   Integer;
  DECLARE vbStatusId Integer;
BEGIN
    IF zfConvert_StringToNumber (inSession) < 0
    THEN
        -- проверка прав пользователя на вызов процедуры
        vbUserId:= lpCheckRight ((-1 * zfConvert_StringToNumber (inSession)) :: TVarChar, zc_Enum_Process_UnComplete_Sale());
    ELSE
        -- проверка прав пользователя на вызов процедуры
        vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Sale());
        -- vbUserId:= lpGetUserBySession (inSession);
    END IF;


    -- Проверка - Дата Документа
    PERFORM lpCheckOperDate_byUnit (inUnitId_by:= lpGetUnit_byUser (vbUserId), inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId), inUserId:= vbUserId);

    -- тек.статус документа
    vbStatusId:= (SELECT Movement.StatusId FROM Movement WHERE Movement.Id = inMovementId);

    -- Распроводим Документ
    PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                 , inUserId     := vbUserId);

    -- Если был статус Проведен
    IF vbStatusId = zc_Enum_Status_Complete()
    THEN
         -- меняются ИТОГОВЫЕ суммы по покупателю
         PERFORM lpUpdate_Object_Client_Total (inMovementId:= inMovementId, inIsComplete:= FALSE, inUserId:= vbUserId);
    END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А
 14.05.17         *
*/

-- тест
-- SELECT * FROM gpUnComplete_Movement_Sale (inMovementId:= 1100, inSession:= zfCalc_UserAdmin())
