-- Function: gpInsertUpdate_MovementItem_PersonalGroupSummAdd()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroupSummAdd (Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalGroupSummAdd(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPositionId            Integer   , -- 
    IN inPositionLevelId       Integer   , --
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroupSummAdd());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_PersonalGroupSummAdd (ioId              := ioId
                                                             , inMovementId      := inMovementId
                                                             , inPositionId      := inPositionId 
                                                             , inPositionLevelId := inPositionLevelId
                                                             , inAmount          := inAmount
                                                             , inComment         := inComment
                                                             , inUserId          := vbUserId
                                                              ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.24         *
*/

-- тест
--