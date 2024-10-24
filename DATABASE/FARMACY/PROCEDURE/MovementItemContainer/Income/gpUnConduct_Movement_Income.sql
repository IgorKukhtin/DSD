-- Function: gpUnConduct_Movement_Income (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpUnConduct_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUnConduct_Movement_Income(
    IN inMovementId        Integer               , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate    TDateTime;
  DECLARE vbUnit        Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight(inSession, zc_Enum_Process_UnComplete_Income());
     vbUserId:= inSession;

     -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

     IF NOT EXISTS(SELECT ValueData FROM  MovementBoolean 
                   WHERE MovementBoolean.DescId = zc_MovementBoolean_Conduct()
                     AND MovementBoolean.MovementId = inMovementId
                     AND MovementBoolean.ValueData = TRUE)
     THEN
         RAISE EXCEPTION 'Ошибка. Документ чатично не проведен..';
     END IF;

     IF NOT EXISTS(SELECT ValueData FROM MovementItem
                   INNER JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                 AND MovementItemBoolean.MovementItemId = MovementItem.Id
                                                 AND MovementItemBoolean.ValueData = TRUE
                   WHERE MovementItem.MovementId = inMovementId)
     THEN
         RAISE EXCEPTION 'Ошибка. Нет проведенных строк в документе..';
     END IF;


     PERFORM lpUnConduct_MovementItem_Income (inMovementId, MovementItem.Id, vbUserId) FROM MovementItem
                   INNER JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                 AND MovementItemBoolean.MovementItemId = MovementItem.Id
                                                 AND MovementItemBoolean.ValueData = TRUE
                    WHERE MovementItem.MovementId = inMovementId;

     -- сохранили свойство <Проведен по количеству>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Conduct(), inMovementId, False);

     -- сохранили свойство <Дата проведения по количеству>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Conduct(), inMovementId, CURRENT_TIMESTAMP);

     -- сохранили протокол
     PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 26.06.18         *
*/

-- тест
-- SELECT * FROM gpUnConduct_Movement_Income (inMovementId:= 149639, inSession:= zfCalc_UserAdmin())