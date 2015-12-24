-- Function: gpComplete_Movement_ChangeIncomePayment()

DROP FUNCTION IF EXISTS gpComplete_Movement_ChangeIncomePayment (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpComplete_Movement_ChangeIncomePayment(
    IN inMovementId        Integer              , -- ключ Документа
    IN inSession           TVarChar DEFAULT ''     -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbOperDate    TDateTime;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Complete_ChangeIncomePayment());
    vbUserId:= inSession;
    
     -- создаются временные таблицы - для формирование данных для проводок 
     -- так как процедура проведения вызывается так же из процедуры проведения возврата
    PERFORM lpComplete_Movement_Finance_CreateTemp();
    -- собственно проводки
    PERFORM lpComplete_Movement_ChangeIncomePayment(inMovementId, -- ключ Документа
                                                    vbUserId);    -- Пользователь                          

    UPDATE Movement SET StatusId = zc_Enum_Status_Complete() 
    WHERE Id = inMovementId 
      AND StatusId IN (zc_Enum_Status_UnComplete(), zc_Enum_Status_Erased());

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.  Воробкало А.А.
 21.12.15                                                                       * 

*/
