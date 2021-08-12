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

     -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_SheetWorkTimeClose (ioId         := 0
                                                           , inMovementId := inMovementId
                                                           , inAmount     := inAmount
                                                           , inUserId     := vbUserId
                                                            ) AS tmp;

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