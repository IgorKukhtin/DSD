-- Function: gpUpdate_Movement_Check_DateCompensation()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_DateCompensation(Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_DateCompensation(
    IN inMovementId          Integer   , -- Ключ объекта <Документ>
 INOUT ioDateCompensation    TDateTime , -- Дата компенсации
    IN inSummChangePercent   TFloat    , -- Будущая компенсация
    IN inSession             TVarChar    -- сессия пользователя
)
RETURNS TDateTime AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;

  IF COALESCE(inSummChangePercent, 0) = 0
  THEN
    ioDateCompensation := NULL;
    RETURN;
  END IF;

  IF COALESCE(inMovementId, 0) = 0
  THEN
      RAISE EXCEPTION 'Документ не записан.';
  END IF;
          
  --Меняем признак Дата компенсации
  Perform lpInsertUpdate_MovementDate(zc_MovementDate_Compensation(), inMovementId, ioDateCompensation);
  
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 15.04.21                                                                    *
*/

-- тест