-- Function: gpInsertUpdate_MovementItem_ChoiceCell()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_ChoiceCell (Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_ChoiceCell(
 INOUT ioId                  Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inChoiceCellId        Integer   , -- 
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_ChoiceCell());
	    
    -- сохранили
    ioId:= lpInsertUpdate_MovementItem_ChoiceCell (ioId                 := COALESCE(ioId,0)
                                                , inMovementId         := inMovementId
                                                , inChoiceCellId          := inChoiceCellId
                                                , inUserId             := vbUserId
                                                 );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.08.24         *
*/

-- тест
-- 