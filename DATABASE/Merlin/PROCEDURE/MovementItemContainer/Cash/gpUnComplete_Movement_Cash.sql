-- Function: gpUnComplete_Movement_Cash (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnComplete_Movement_Cash (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnComplete_Movement_Cash(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar                -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_UnComplete_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Проверка - Если Корректировка подтверждена
     IF EXISTS (SELECT 1 FROM MovementBoolean AS MB WHERE MB.MovementId = inMovementId AND MB.DescId = zc_MovementBoolean_Sign() AND MB.ValueData = TRUE)
     THEN
        RAISE EXCEPTION 'Ошибка.Корректировка подтверждена.Изменения невозможны.';
     END IF;

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
