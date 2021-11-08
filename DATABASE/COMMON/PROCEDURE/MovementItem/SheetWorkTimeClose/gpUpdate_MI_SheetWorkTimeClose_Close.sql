-- Function: gpUpdate_MI_SheetWorkTimeClose_Close()

DROP FUNCTION IF EXISTS gpUpdate_MI_SheetWorkTimeClose_Close (Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_MI_SheetWorkTimeClose_Close(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inAmount              TFloat    , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Void AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTimeClose());


     -- 1. если  update
     IF inMovementId > 0 AND EXISTS (SELECT 1 FROM Movement WHERE Movement.Id = inMovementId AND Movement.StatusId <> zc_Enum_Status_UnComplete())
     THEN
         -- Распроводим Документ
         PERFORM lpUnComplete_Movement (inMovementId := inMovementId
                                      , inUserId     := vbUserId
                                       );
     END IF;

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_SheetWorkTimeClose (ioId         := 0
                                                           , inMovementId := inMovementId
                                                           , inAmount     := inAmount
                                                           , inUserId     := vbUserId
                                                            ) AS tmp;
     -- если
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_Closed(), inMovementId, CASE WHEN inAmount > 0 THEN TRUE ELSE FALSE END);

     -- если были ручные правки убираем галку Авто
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAuto(), inMovementId, FALSE);
     
     -- проводим Документ
     PERFORM lpComplete_Movement (inMovementId := inMovementId
                                , inDescId     := zc_Movement_SheetWorkTimeClose()
                                , inUserId     := vbUserId
                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 10.08.21         *
*/

-- тест
--