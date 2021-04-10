-- Function: gpComplete_Movement_ReturnOut()

--DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpComplete_Movement_ReturnOut (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ReturnOut(
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
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ReturnOut());

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
        PERFORM lpInsertUpdate_Movement (inMovementId, zc_Movement_ReturnOut(), vbInvNumber, outOperDate, vbParentID);
        
/*     ELSE
         IF ((outOperDate <> CURRENT_DATE) OR (outOperDate <> CURRENT_DATE + INTERVAL '1 MONTH')) AND (inIsCurrentData = FALSE)
         THEN
             -- проверка прав на проведение задним числом
             vbUserId:= lpCheckRight (inSession, zc_Enum_Process_CompleteDate_ReturnOut());
         END IF;*/
     END IF;

     -- Проверили перед проведением на достаточность наличия, НДС и пр.
     PERFORM lpCheckComplete_Movement_ReturnOut (inMovementId);
     
      -- пересчитали Итоговые суммы
     PERFORM lpInsertUpdate_MovementFloat_TotalSumm (inMovementId);
     
     -- собственно проводки
     PERFORM lpComplete_Movement_ReturnOut(inMovementId, -- ключ Документа
                                           vbUserId);    -- Пользователь                          

     UPDATE Movement SET StatusId = zc_Enum_Status_Complete() WHERE Id = inMovementId AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

       -- Проверим а не провели за время отложки были прицеденты
     IF COALESCE ((SELECT MB.ValueData FROM MovementBoolean AS MB 
                   WHERE MB.MovementId = inMovementId 
                     AND MB.DescId = zc_MovementBoolean_Deferred()), FALSE) = TRUE
     THEN
         RAISE EXCEPTION 'Ошибка. За время проведения документ отлаживали.';
     END IF;
  
    --Если в документе установлена дата возврата поставщика - то создаем документ на изменение долга 
    IF EXISTS(SELECT 1 FROM Movement_ReturnOut_View WHERE Id = inMovementId AND OperDatePartner is not null)
    THEN

    --Создали документ на изменение долга по приходам
        SELECT 
            lpInsertUpdate_Movement_ChangeIncomePayment(
                ioId := COALESCE(ChangeIncomePayment.Id,0), -- Ключ объекта <Документ изменения долга по приходам>
                inInvNumber := COALESCE(ChangeIncomePayment.InvNumber, NEXTVAL('movement_ChangeIncomePayment_seq')::TVarChar), -- Номер документа
                inOperDate := ReturnOut.OperDatePartner, -- Дата документа
                inTotalSumm := ReturnOut.TotalSumm, -- Сумма изменения долга
                inFromId := ReturnOut.ToId, -- От кого (в документе)
                inJuridicalId := ReturnOut.JuridicalId, -- Для какого юрлица
                inChangeIncomePaymentKindId := zc_Enum_ChangeIncomePaymentKind_ReturnOut(), -- Типы изменения суммы долга
                inComment := NULL::TVarChar, -- Комментарий
                inUserId := vbUserId)
        INTO
            vbChangeIncomePaymentId
        FROM
            Movement_ReturnOut_View AS ReturnOut
            LEFT OUTER JOIN MovementLinkMovement AS NLN_ChangeIncomePayment
                                                 ON NLN_ChangeIncomePayment.MovementId = ReturnOut.ID
                                                AND NLN_ChangeIncomePayment.DescId = zc_MovementLinkMovement_ChangeIncomePayment()
            LEFT OUTER JOIN Movement AS ChangeIncomePayment
                                     ON ChangeIncomePayment.Id = NLN_ChangeIncomePayment.MovementChildId
        WHERE
            ReturnOut.Id = inMovementId;
        --Прописали номер поставщика, для акта сверки
        PERFORM lpInsertUpdate_MovementString(zc_MovementString_InvNumberPartner(),vbChangeIncomePaymentId,(SELECT InvNumberPartner FROM Movement_ReturnOut_View WHERE Id = inMovementId));
        
        --Связали возврат и документ на изменение долга по приходам
        PERFORM lpInsertUpdate_MovementLinkMovement(zc_MovementLinkMovement_ChangeIncomePayment(),inMovementId,vbChangeIncomePaymentId);
        --Провели документ на изменение долга по приходам
        PERFORM lpComplete_Movement_ChangeIncomePayment(vbChangeIncomePaymentId,vbUserId);
    END IF;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 05.02.15                         * 

*/

-- тест
-- SELECT * FROM gpUnComplete_Movement (inMovementId:= 579, inSession:= '2')
-- SELECT * FROM gpComplete_Movement_ReturnOut (inMovementId:= 579, inIsLastComplete:= FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItemContainer_Movement (inMovementId:= 579, inSession:= '2')
