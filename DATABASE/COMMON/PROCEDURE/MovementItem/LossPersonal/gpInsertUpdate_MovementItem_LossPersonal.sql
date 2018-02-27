-- Function: gpInsertUpdate_MovementItem_LossPersonal ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MovementItem_LossPersonal (Integer, Integer, Integer, TFloat, Integer, Integer, Integer, Integer, Integer, TVarChar, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MovementItem_LossPersonal(
 INOUT ioId                     Integer   , -- Ключ объекта <Элемент документа>
    IN inMovementId             Integer   , -- ключ Документа
    IN inPersonalId             Integer   , -- Сотрудник 
    IN inAmount                 TFloat    , -- Сумма Корректировки
    IN inBranchId              Integer   , -- Филиал
    IN inInfoMoneyId            Integer   , -- Статьи назначения
    IN inPositionId             Integer   , -- Должность
    IN inPersonalServiceListId  Integer   , -- Ведомость начисления
    IN inUnitId                 Integer   , -- Подразделение
    IN inComment                TVarChar  , -- Примечание
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossPersonal());

    -- сохранили <Элемент документа>
     ioId:= lpInsertUpdate_MovementItem_LossPersonal (ioId                    := ioId
                                                    , inMovementId            := inMovementId
                                                    , inPersonalId            := inPersonalId
                                                    , inAmount                := inAmount
                                                    , inBranchId              := inBranchId
                                                    , inInfoMoneyId           := inInfoMoneyId
                                                    , inPositionId            := inPositionId
                                                    , inPersonalServiceListId := inPersonalServiceListId
                                                    , inUnitId                := inUnitId
                                                    , inComment               := inComment
                                                    , inUserId                := vbUserId
                                                     );

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 27.02.18         *
*/

-- тест
-- 