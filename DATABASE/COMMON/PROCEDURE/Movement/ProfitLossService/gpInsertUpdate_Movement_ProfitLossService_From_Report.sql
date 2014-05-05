-- Function: gpInsertUpdate_Movement_ProfitLossService_From_Report 

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_From_Report (TDateTime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);
DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_From_Report (TDateTime, TDateTime, tfloat, integer, integer, integer, integer, integer, integer, tvarchar);



CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_From_Report (
   OUT ioId                       Integer   ,
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,
    IN inAmount                   TFloat    , -- Сумма операции
    IN inContractId               Integer   , -- Договор
    IN inInfoMoneyId              Integer   , -- Статьи назначения
    IN inJuridicalId              Integer   , -- Юр. лицо
    IN inPaidKindId               Integer   , -- Виды форм оплаты
    --IN inUnitId                 Integer   , -- Подразделение
    IN inContractConditionKindId  Integer   , -- Типы условий договоров
    IN inBonusKindId              Integer   , -- Виды бонусов
--  IN inisLoad                   Boolean   , -- Сформирован автоматически (по отчету)
    IN inSession                  TVarChar    -- сессия пользователя
)
RETURNS Integer AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbId Integer;

BEGIN
     IF inAmount <> 0 THEN
      
       -- проверка прав пользователя на вызов процедуры
       vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());  
  
       -- удаляем все документы сформированные автоматически
       -- 
       PERFORM lpSetErased_Movement (inMovementId:= Movement.Id
                                   , inUserId    := vbUserId)
       FROM Movement
            INNER JOIN MovementBoolean AS MovementBoolean_isLoad
                                       ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                      AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
                                      AND MovementBoolean_isLoad.ValueData = TRUE
       WHERE Movement.DescId = zc_Movement_ProfitLossService()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (Movement.StatusId = zc_Enum_Status_Complete() OR Movement.StatusId = zc_Enum_Status_UnComplete())
       ;

       ioId :=  gpInsertUpdate_Movement_ProfitLossService (ioId              := 0             --COALESCE (vbId,0)
                                                         , inInvNumber       := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                         , inOperDate        := inEndDate
                                                         , inAmountIn        := 0
                                                         , inAmountOut       := inAmount
                                                         , inComment         := ''
                                                         , inContractId      := inContractId
                                                         , inInfoMoneyId     := inInfoMoneyId
                                                         , inJuridicalId     := inJuridicalId
                                                         , inPaidKindId      := inPaidKindId
                                                         , inUnitId          := 0
                                                         , inContractConditionKindId   := inContractConditionKindId
                                                         , inBonusKindId     := inBonusKindId
                                                         , inisLoad          := TRUE
                                                         , inSession         := inSession
                                                         );


     ELSE
        ioId := 0 ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 01.05.14         *

*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_From_Report (ioId := 0 , inInvNumber := '-1' , inOperDate := '01.01.2013', inAmountIn:= 20 , inAmountOut := 0 , inComment := '' , inContractId :=1 ,      inInfoMoneyId := 0,     inJuridicalId:= 1,       inPaidKindId:= 1,   inUnitId:= 0,   inContractConditionKindId:=0,     inSession:= '2')
