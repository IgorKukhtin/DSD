-- Function: gpInsertUpdate_MI_LossPersonal_Load ()

DROP FUNCTION IF EXISTS gpInsertUpdate_MI_LossPersonal_Load (Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_MI_LossPersonal_Load(
    IN inMovementId             Integer   , -- ключ Документа
    IN inINN                    TVarChar  , -- ИНН Сотрудника 
    IN inAmount                 TFloat    , -- Сумма Корректировки
    IN inSession                TVarChar    -- сессия пользователя
)                              
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_LossPersonal());

    -- сохранили <Элемент документа>
     PERFORM lpInsertUpdate_MovementItem_LossPersonal (ioId                    := 0
                                                     , inMovementId            := inMovementId                   ::Integer
                                                     , inPersonalId            := lfSelect.PersonalId            ::Integer
                                                     , inAmount                := inAmount                       ::TFloat
                                                     , inBranchId              := lfSelect.BranchId              ::Integer
                                                     , inInfoMoneyId           := zc_Enum_InfoMoney_60101()      ::Integer                       --60101 Заработная плата
                                                     , inPositionId            := lfSelect.PositionId            ::Integer
                                                     , inPersonalServiceListId := lfSelect.PersonalServiceListId ::Integer
                                                     , inUnitId                := lfSelect.UnitId
                                                     , inComment               := NULL ::TVarChar
                                                     , inUserId                := vbUserId
                                                      )
     FROM ObjectString AS ObjectString_INN
          INNER JOIN lfSelect_Object_Member_findPersonal (inSession) AS lfSelect ON lfSelect.MemberId = ObjectString_INN.ObjectId
     WHERE ObjectString_INN.DescId = zc_ObjectString_Member_INN() 
       AND TRIM (ObjectString_INN.ValueData) = TRIM (inINN)
     LIMIT 1;            --на всякий случай


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 05.12.22         *
*/

-- тест
-- 