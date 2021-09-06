-- Function: gpUpdate_Movement_Check_RetrievedAccounting()

DROP FUNCTION IF EXISTS gpUpdate_Movement_Check_RetrievedAccounting(Integer, Boolean, TFloat, TFloat, TFloat, TFloat, TFloat, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_Check_RetrievedAccounting(
    IN inMovementId                Integer   , -- Ключ объекта <Документ>
    IN inisRetrievedAccounting     Boolean   , -- Получено бухгалтерией
    IN inTotalSumm                 TFloat    , -- Сумма
 INOUT ioSummaReceivedFact         TFloat    , -- Сумма получено по факту
 INOUT ioRetrievedAccounting       TFloat    , -- Получено бухгалтерией
 INOUT ioSummaReceived             TFloat    , -- Сумма по факту
 INOUT ioSummaReceivedDelta        TFloat    , -- Разница
    IN inSession                   TVarChar    -- сессия пользователя
)
RETURNS RECORD AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
  -- проверка прав пользователя на вызов процедуры
  -- PERFORM lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MovementItem_Income());
  vbUserId := inSession;


  IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View  WHERE UserId = vbUserId AND RoleId in (zc_Enum_Role_Admin(), 6534523))
  THEN
    RAISE EXCEPTION 'Изменение признака <Получено бухгалтерией> вам запрещено.';
  END IF;
  
  IF COALESCE(inisRetrievedAccounting, False) = TRUE AND
     EXISTS(SELECT * FROM  MovementFloat AS MovementFloat_SummaReceivedFact
            WHERE MovementFloat_SummaReceivedFact.MovementId =  inMovementId
              AND MovementFloat_SummaReceivedFact.DescId = zc_MovementFloat_SummaReceivedFact()
              AND COALESCE(MovementFloat_SummaReceivedFact.ValueData, 0) <> 0)
  THEN
    RAISE EXCEPTION 'Заполнена <Сумма получено по факту> признака <Получено бухгалтерией> устанавливать нельзя.';
  END IF;
  
      
  --Меняем Получено бухгалтерией
  PERFORM lpInsertUpdate_MovementBoolean(zc_MovementBoolean_RetrievedAccounting(), inMovementId, inisRetrievedAccounting);

  --Меняем Сумма получено по факту
  IF COALESCE (ioSummaReceivedFact, 0) <> 0
  THEN
    PERFORM lpInsertUpdate_MovementFloat(zc_MovementFloat_SummaReceivedFact(), inMovementId, 0);
      
    ioRetrievedAccounting := ioRetrievedAccounting - inTotalSumm;
    ioSummaReceived := ioSummaReceived - ioSummaReceivedFact;      
  END IF;
  
  IF inisRetrievedAccounting = TRUE
  THEN
    ioRetrievedAccounting := ioRetrievedAccounting + inTotalSumm;
    ioSummaReceived := ioSummaReceived + inTotalSumm;
  ELSE
    ioRetrievedAccounting := ioRetrievedAccounting - inTotalSumm;
    ioSummaReceived := ioSummaReceived - inTotalSumm;  
  END IF;
  
  ioSummaReceivedDelta := ioRetrievedAccounting - ioSummaReceived;
  ioSummaReceivedFact := 0;
    
  -- сохранили протокол
  PERFORM lpInsert_MovementProtocol (inMovementId, vbUserId, False);

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Шаблий О.В.
 29.07.21                                                                    *
*/

-- тест