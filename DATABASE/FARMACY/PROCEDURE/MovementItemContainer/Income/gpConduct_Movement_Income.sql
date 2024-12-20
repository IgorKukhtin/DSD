-- Function: gpConduct_Movement_Income()

DROP FUNCTION IF EXISTS gpConduct_Movement_Income (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpConduct_Movement_Income(
    IN inMovementId          Integer              , -- ключ Документа
    IN inSession             TVarChar               -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbObjectId        Integer;
  DECLARE vbJuridicalId     Integer;
  DECLARE vbToId            Integer;
  DECLARE vbOperDate        TDateTime;
  DECLARE vbUnit            Integer;
  DECLARE vbOrderId         Integer;
  DECLARE vbGoodsName       TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
--     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Income());
     vbUserId:= inSession;

     -- !!!Проверка что б второй раз не провели накладную и проводки не задвоились!!!
     IF EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId = zc_Enum_Status_Complete())
     THEN
         RAISE EXCEPTION 'Ошибка.Документ уже проведен.';
     END IF;

     -- Временно заблокировали
     IF CURRENT_TIMESTAMP >= '11.03.2022 17:30'
     THEN
         RAISE EXCEPTION 'Действует блок на частичную проводку...';
     END IF;

     IF EXISTS(SELECT ValueData FROM MovementItem
                      INNER JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                   AND MovementItemBoolean.MovementItemId = MovementItem.Id
                                                   AND MovementItemBoolean.ValueData = TRUE
                      WHERE MovementItem.MovementId = inMovementId)
     THEN
         PERFORM lpUnConduct_MovementItem_Income (inMovementId, MovementItem.Id, vbUserId) FROM MovementItem
                      INNER JOIN MovementItemBoolean ON MovementItemBoolean.DescId = zc_MIBoolean_Conduct()
                                                   AND MovementItemBoolean.MovementItemId = MovementItem.Id
                                                   AND MovementItemBoolean.ValueData = TRUE
                      WHERE MovementItem.MovementId = inMovementId;
     END IF;

     -- сохранили свойство <Проведен по количеству>
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Conduct(), inMovementId, TRUE);

     -- сохранили свойство <Дата проведения по количеству>
     PERFORM lpInsertUpdate_MovementDate (zc_MovementDate_Conduct(), inMovementId, CURRENT_TIMESTAMP);
     
     IF EXISTS(SELECT MovementItem.Id
                     FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                             ON MIFloat_AmountManual.MovementItemId = MovementItem.ID
                            AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = FALSE
                       AND COALESCE(MIFloat_AmountManual.ValueData,0) > 0)
     THEN
        PERFORM lpConduct_MovementItem_Income (inMovementId, MovementItem.Id, inSession)
                     FROM MovementItem
                      LEFT JOIN MovementItemFloat AS MIFloat_AmountManual
                             ON MIFloat_AmountManual.MovementItemId = MovementItem.ID
                            AND MIFloat_AmountManual.DescId = zc_MIFloat_AmountManual()
                     WHERE MovementItem.MovementId = inMovementId
                       AND MovementItem.isErased = FALSE
                       AND COALESCE(MIFloat_AmountManual.ValueData, 0) > 0;
     END IF;

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
-- SELECT * FROM gpConduct_Movement_Income (inMovementId:= 579, inSession:= '2')