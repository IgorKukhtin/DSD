-- Function: gpUpdate_Movement_OrderFinance_byReport()

DROP FUNCTION IF EXISTS gpUpdate_Movement_OrderFinance_byReport (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpUpdate_Movement_OrderFinance_byReport(
    IN inMovementId            Integer   , -- Ключ объекта <Документ>
    IN inSession               TVarChar    -- сессия пользователя
)
RETURNS Void
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId := lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_MI_OrderFinance());

    CREATE TEMP TABLE _tmpReport (JuridicalId Integer, PaidKindId Integer, ContractId Integer
                                , DebetRemains TFloat, KreditRemains TFloat
                                , DefermentPaymentRemains TFloat   --Долг с отсрочкой
                                , Remains TFloat) ON COMMIT DROP;
    INSERT INTO _tmpReport (JuridicalId, PaidKindId, ContractId
                          , DebetRemains, KreditRemains
                          , DefermentPaymentRemains   --Долг с отсрочкой
                          , Remains)
	    SELECT JuridicalId, PaidKindId, ContractId
                 , DebetRemains, KreditRemains
                 , DefermentPaymentRemains   --Долг с отсрочкой
                 , Remains 
            FROM gpReport_JuridicalDefermentIncome(inOperDate      := vbOperDate 
                                                 , inEmptyParam    := vbOperDate
                                                 , inAccountId     := 0
                                                 , inPaidKindId    := vbPaidKindId
                                                 , inBranchId      := 0
                                                 , inJuridicalGroupId := 0
                                                 , inSession       := inSession);

SELECT *
            FROM gpReport_JuridicalDefermentIncome(inOperDate      := '30.07.2019' 
                                                 , inEmptyParam    := '30.07.2019'
                                                 , inAccountId     := 0
                                                 , inPaidKindId    := 3
                                                 , inBranchId      := 0
                                                 , inJuridicalGroupId := 0
                                                 , inSession       := '5'::TVarchar);
                                                 
                                                 

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 30.07.19         *
*/

-- тест
--