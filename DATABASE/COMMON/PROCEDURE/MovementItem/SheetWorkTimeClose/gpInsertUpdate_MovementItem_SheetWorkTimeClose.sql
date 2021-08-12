-- Function: gpInsertUpdate_MovementItem_SheetWorkTimeClose()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_SheetWorkTimeClose (Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_SheetWorkTimeClose(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент>
    IN inMovementId             Integer   , -- Ключ объекта <Документ>
    --IN inMemberId               Integer   , -- физ.лицо кто выполнил действие
    IN inAmount                 TFloat    , -- Открыт или закрыт  0 или 1
    IN inSession                TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_SheetWorkTimeClose());
 
     -- сохранили <Элемент документа>
     ioId := lpInsertUpdate_MovementItem_SheetWorkTimeClose (ioId         := ioId
                                                           , inMovementId := inMovementId
                                                           , inAmount     := inAmount
                                                           , inUserId     := vbUserId
                                                            ) AS tmp;
     --если были ручные правки убираем галку Авто
     PERFORM lpInsertUpdate_MovementBoolean (zc_MovementBoolean_ClosedAuto(), inMovementId, FALSE);

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