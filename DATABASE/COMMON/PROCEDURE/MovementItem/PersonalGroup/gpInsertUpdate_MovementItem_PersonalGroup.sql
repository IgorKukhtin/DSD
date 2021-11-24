-- Function: gpInsertUpdate_MovementItem_PersonalGroup()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_PersonalGroup (Integer, Integer, Integer, Integer, Integer, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_PersonalGroup(
 INOUT ioId                    Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inPersonalId            Integer   , -- Сотрудники
    IN inPositionId            Integer   , --
    IN inPositionLevelId       Integer   , --
    IN inAmount                TFloat    , -- 
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbAmount TFloat;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_PersonalGroup());

     --проверка   можно менять inAmount но не больше чем было значение
     IF COALESCE (ioId,0) <> 0
     THEN
         vbAmount := (SELECT MI.Amount FROM MovementItem AS MI WHERE MI.Id = ioId);
         IF COALESCE (inAmount,0) > COALESCE (vbAmount,0) AND COALESCE (vbAmount,0) <> 0
         THEN
             RAISE EXCEPTION 'Ошибка.Дневной план не может превышать <%>', vbAmount;
         END IF;
     END IF;
     
     
     
     -- сохранили
     ioId := lpInsertUpdate_MovementItem_PersonalGroup (ioId             := ioId
                                                      , inMovementId      := inMovementId
                                                      , inPersonalId      := inPersonalId
                                                      , inPositionId      := inPositionId
                                                      , inPositionLevelId := inPositionLevelId
                                                      , inAmount          := inAmount
                                                      , inUserId          := vbUserId
                                                       ) AS tmp;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.11.21         *
*/

-- тест
--