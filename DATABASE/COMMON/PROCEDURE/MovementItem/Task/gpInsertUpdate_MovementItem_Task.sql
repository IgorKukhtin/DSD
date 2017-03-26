-- Function: gpInsertUpdate_MovementItem_Task()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_Task (Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_Task(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inPartnerId           Integer   , -- 
    IN inDescription         TVarChar  , -- Описание задания
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_Task());
	    
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_Task (ioId                 := COALESCE(ioId,0)
                                           , inMovementId         := inMovementId
                                           , inPartnerId          := inPartnerId
                                           , inDescription        := inDescription
                                           , inUserId             := vbUserId
                                            );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.   Воробкало А.А.
 24.03.17         *
*/

-- тест
-- 