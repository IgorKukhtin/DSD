-- Function: gpInsertUpdate_MovementItem_PersonalRate()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalRate (Integer, Integer, Integer, TFloat, TVarChar, Integer, Integer, TVarChar);
DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalRate (Integer, Integer, Integer, TFloat, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalRate(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPersonalId            Integer   , -- Сотрудники
    IN inAmount                TFloat    , -- 
    IN inComment               TVarChar  , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalRate());

     -- сохранили
     ioId := lpInsertUpdate_MovementItem_PersonalRate (ioId                    := ioId
                                                     , inMovementId            := inMovementId
                                                     , inPersonalId            := inPersonalId
                                                     , inAmount                := inAmount
                                                     , inComment               := inComment
                                                     , inUserId                := vbUserId
                                                      ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.19         *
*/

-- тест
--