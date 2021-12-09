-- Function: gpComplete_Movement_Pretension()

--DROP FUNCTION IF EXISTS gpComplete_Movement_Pretension (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_Pretension (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_Pretension(
    IN inMovementId        Integer               , -- ключ Документа
    IN inIsCurrentData     Boolean               , -- дата документа текущая Да /Нет
   OUT outOperDate         TDateTime             , --
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS TDateTime
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbJuridicalId Integer;
  DECLARE vbUnit Integer;
  DECLARE vbParentID Integer;
  DECLARE vbOperDate  TDateTime;
  DECLARE vbChangeIncomePaymentId Integer;
  DECLARE vbInvNumber TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_Pretension());

      -- проверка
    IF COALESCE ((SELECT MovementBoolean_Deferred.ValueData FROM MovementBoolean  AS MovementBoolean_Deferred
                  WHERE MovementBoolean_Deferred.MovementId = inMovementId
                    AND MovementBoolean_Deferred.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
    THEN
         RAISE EXCEPTION 'Ошибка.Документ отложен, проведение запрещено!';
    END IF;

      -- параметры документа
     SELECT
          Movement.OperDate, Movement.InvNumber, Movement.ParentID
     INTO
          outOperDate, vbInvNumber, vbParentID
     FROM Movement
     WHERE Movement.Id = inMovementId;

     -- дата накладной перемещения должна совпадать с текущей датой.
     -- Если пытаются провести док-т числом позже - выдаем предупреждение
     IF (outOperDate <> CURRENT_DATE) AND (inIsCurrentData = TRUE)
     THEN
         --RAISE EXCEPTION 'Ошибка. ПОМЕНЯЙТЕ ДАТУ НАКЛАДНОЙ НА ТЕКУЩУЮ.';
        outOperDate:= CURRENT_DATE;
        -- сохранили <Документ> c новой датой 
        PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_Pretension(), vbInvNumber, outOperDate, vbParentID);
        
/*     ELSE
         IF ((outOperDate <> CURRENT_DATE) OR (outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH')) AND (inIsCurrentData = FALSE)
         THEN
             -- проверка прав на проведение задним числом
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompleteDate_Pretension());
         END IF;*/
     END IF;

     -- Проверили перед проведением на достаточность наличия, НДС и пр.
     PERFORM lpCheckComplete_Movement_Pretension (inMovementId);
     
      -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm_Pretension (inMovementId);
     
     -- собственно проводки
/*     PERFORM lpComplete_Movement_Pretension(inMovementId, -- ключ Документа
                                           vbUserId);    -- Пользователь                          
*/
     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

       -- Проверим а не провели за время отложки были прицеденты
     IF COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB 
                   WHERE MB.MovementId = inMovementId 
                     AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка. За время проведения документ отлаживали.';
     END IF;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 08.12.21                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')