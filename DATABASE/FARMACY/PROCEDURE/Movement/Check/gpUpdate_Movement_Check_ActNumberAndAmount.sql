-- Function: gpUpdate_Movement_Check_ActNumberAndAmount()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_ActNumberAndAmount(Integer, TVarChar, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_ActNumberAndAmount(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
    IN inActNumber           TVarChar  , -- Номер акта
    IN inAmountAct           TFloat    , -- Сумма акта
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS VOID AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  --Меняем признак Номер акта
  Perform lpInsertUpdate_MovementString(zc_MovementString_ActNumber(), inMovementId, inActNumber);

  --Меняем признак Сумма акта
  Perform lpInsertUpdate_MovementFloat(zc_MovementFloat_AmountAct(), inMovementId, inAmountAct);

  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 14.03.23                                                                    *
*/

-- тест