-- Function: gpInsertUpdate_MovementItem_PersonalTransport()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalTransport (Integer, Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalTransport(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPersonalId            Integer   , -- Сотрудники 
    IN inInfoMoneyId           Integer   , -- Статьи назначения
    IN inUnitId                Integer   , -- Подразделение
    IN inPositionId            Integer   , -- Должность
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalTransport());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_PersonalTransport (ioId          := ioId
                                                          , inMovementId  := inMovementId
                                                          , inPersonalId  := inPersonalId 
                                                          , inInfoMoneyId := inInfoMoneyId
                                                          , inUnitId      := inUnitId
                                                          , inPositionId  := inPositionId 
                                                          , inAmount      := inAmount
                                                          , inComment     := inComment
                                                          , inUserId      := vbUserId
                                                           ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.22         *
*/

-- тест
--