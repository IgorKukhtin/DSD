-- Function: gpUpdateMovement_Desc()

DROP FUNCTION IF EXISTS gpUpdateMovement_Desc (Integer, TVarChar, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdateMovement_Desc(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inMovementDescId_new  TVarChar   , -- 
    IN inFromId_new          Integer   , -- 
    IN inToId_new            Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID 
AS
$BODY$
    DECLARE vbUserId Integer;

    DECLARE vbMovementDescId_old Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Update_Movement_Sale_Desc());


     -- Проверка
     IF COALESCE (inFromId_new, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение Подразделение <От кого>.';
     END IF;
     -- Проверка
     IF COALESCE (inToId_new, 0) = 0
     THEN
         RAISE EXCEPTION 'Ошибка.Не установлено значение Подразделение <Кому>.';
     END IF;

     -- нашли
     vbMovementDescId_old:= (SELECT Movement.DescId FROM Movement WHERE Movement.Id = inMovementId);
     -- Проверка
     IF vbMovementDescId_old <> zc_Movement_Sale()
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять <Вид документа>.';
     END IF;
     -- Проверка
     IF NOT EXISTS (SELECT MovementDesc.Id FROM MovementDesc WHERE MovementDesc.Code = inMovementDescId_new AND MovementDesc.Id = zc_Movement_SendOnPrice())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав менять <Вид документа>.';
     END IF;
     -- Проверка
     IF EXISTS (SELECT 1 FROM MovementLinkMovement AS MLM JOIN Movement ON Movement.Id = MLM.MovementChildId AND Movement.StatusId <> zc_Enum_Status_Erased() WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master())
     THEN
         RAISE EXCEPTION 'Ошибка. Найден документ <Налоговая накладная> № <%> от <%>.', (SELECT MovementString.ValueData FROM MovementLinkMovement AS MLM JOIN MovementString ON MovementString.MovementId = MLM.MovementChildId AND MovementString.DescId = zc_MovementString_InvNumberPartner() WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master())
                                                                                      , DATE ((SELECT Movement.OperDate FROM MovementLinkMovement AS MLM JOIN Movement ON Movement.Id = MLM.MovementChildId AND Movement.StatusId <> zc_Enum_Status_Erased() WHERE MLM.MovementId = inMovementId AND MLM.DescId = zc_MovementLinkMovement_Master()));
     END IF;


     IF vbUserId = lpCheckRight(inSession, zc_Enum_Process_UnComplete_Send())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId);
     END IF;


     -- сохранили <Документ>
     IF COALESCE (inMovementId, 0) <> COALESCE ((SELECT lpInsertUpdate_Movement (inMovementId, zc_Movement_SendOnPrice(), Movement.InvNumber, Movement.OperDate, Movement.ParentId, Movement.AccessKeyId) FROM Movement WHERE Movement.Id = inMovementId), -1)
     THEN
         RAISE EXCEPTION 'Ошибка. Найден документ <Налоговая>.';
     END IF;

     -- сохранили связь с <Кому (в документе)>
     PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_To(), inMovementId, inToId_new);


      -- удалили связь с Налоговым документом
      PERFORM lpInsertUpdate_MovementLinkMovement (zc_MovementLinkMovement_Master(), inMovementId, NULL);
      -- удалили связь с <Тип формирования налогового документа>
      PERFORM lpInsertUpdate_MovementLinkObject (zc_MovementLinkObject_DocumentTaxKind(), inMovementId, NULL);


     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_SendOnPrice_CreateTemp();
     -- Проводим Документ
     PERFORM lpComplete_Movement_SendOnPrice (inMovementId     := inMovementId
                                            , inUserId         := vbUserId);


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 04.08.15                                        *
*/


-- тест
-- SELECT * FROM gpUpdateMovement_Desc (inMovementId:= 275079, inDesc:= 'False', inSession:= '2')
