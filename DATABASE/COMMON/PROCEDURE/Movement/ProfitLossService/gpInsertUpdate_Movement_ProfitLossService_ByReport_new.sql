-- Function: gpInsertUpdate_Movement_ProfitLossService_ByReport_new

DROP FUNCTION IF EXISTS gpInsertUpdate_Movement_ProfitLossService_ByReport_new (TDateTime, TDateTime, Integer, Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpInsertUpdate_Movement_ProfitLossService_ByReport_new (
    IN inStartDate                TDateTime ,  
    IN inEndDate                  TDateTime ,
    IN inPaidKindId               Integer   ,
    IN inJuridicalId              Integer   ,
    IN inBranchId                 Integer   ,
    IN inSession                  TVarChar        -- сессия пользователя
)
RETURNS VOID
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_InsertUpdate_Movement_ProfitLossService());
       
       
     /*   -- удаляем все документы сформированные автоматически
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
      */
      
     -- создаются временные таблицы - для формирование данных для проводок
     PERFORM lpComplete_Movement_Finance_CreateTemp();

     -- 
     PERFORM gpReport_CheckBonus_SaleReturn (inStartDate:= inStartDate, inEndDate:= inEndDate, inPaidKindID:= inPaidKindID, inJuridicalId:= inJuridicalId, inBranchId:= inBranchId, inSession:= inSession);
     
     -- 
     UPDATE tmpData_res SET MovementId_pl = lpInsertUpdate_Movement_ProfitLossService (ioId                := 0
                                                                                     , inInvNumber         := CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) 
                                                                                     , inOperDate          := inEndDate
                                                                                     , inAmountIn          := 0                               :: TFloat
                                                                                     , inAmountOut         := Sum_Bonus_real                  :: TFloat
                                                                                     , inBonusValue        := CAST (Value AS NUMERIC (16, 2)) :: TFloat
                                                                                     , inAmountCurrency    := 0    :: TFloat
                                                                                     , inComment           := Comment                         :: TVarChar
                                                                                     , inContractId        := ContractId_find
                                                                                     , inContractMasterId  := ContractId_master
                                                                                     , inContractChildId   := ContractId_Child
                                                                                     , inInfoMoneyId       := InfoMoneyId_find
                                                                                     , inJuridicalId       := CASE WHEN PartnerId > 0 THEN PartnerId ELSE JuridicalId END  -- если выбран контрагент - записываем его а по нему уже понятно кто юр.лицо JuridicalId
                                                                                     , inPaidKindId        := PaidKindId
                                                                                     , inUnitId            := 0                               :: Integer
                                                                                     , inContractConditionKindId   := ConditionKindId
                                                                                     , inBonusKindId       := BonusKindId
                                                                                     , inBranchId          := BranchId
                                                                                     , inCurrencyPartnerId := 0
                                                                                     , inIsLoad            := TRUE                            :: Boolean
                                                                                     , inUserId            := vbUserId
                                                                                      )
     WHERE tmpData_res.Sum_Bonus <> 0 OR tmpData_res.Sum_Bonus_real <> 0
    ;

     PERFORM lpInsertUpdate_MI_ProfitLossService_Child (ioId                  := 0
                                                      , inParentId            := MovementItem.Id
                                                      , inMovementId          := tmpData_res.MovementId_pl
                                                      , inJuridicalId         := tmpData_res.JuridicalId
                                                      , inJuridicalId_Child   := NULL
                                                      , inPartnerId           := NULL
                                                      , inBranchId            := COALESCE (ObjectLink_Unit_Branch.ChildObjectId, zc_Branch_Basis())
                                                      , inGoodsId             := NULL
                                                      , inGoodsKindId         := NULL
                                                      , inAmount              := CASE WHEN tmpData_res.ContractConditionKindId = zc_Enum_ContractConditionKind_BonusPercentSale() THEN (tmpBase.Sum_Sale/100 * tmpData_res.Value)
                                                                                      WHEN tmpData_res.ContractConditionKindId = zc_Enum_ContractConditionKind_BonusPercentSaleReturn() THEN (tmpBase.Sum_SaleReturnIn/100 * tmpData_res.Value) 
                                                                                      WHEN tmpData_res.ContractConditionKindId = zc_Enum_ContractConditionKind_BonusPercentAccount() THEN (tmpBase.Sum_SaleReturnIn/100 * tmpData_res.Value)
                                                                                 END
                                                      , inAmountPartner       := 0 -- Сумма продаж
                                                      , inSumm                := 0 -- База для начисления 
                                                      , inMovementId_child    := tmpBase.MovementId
                                                      , inOperDate            := NULL
                                                      , inUserId              := NULL
                                                       )
     FROM tmpData_res
          INNER JOIN MovementItem ON MovementItem.MovementId = tmpData_res.MovementId_pl
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = FALSE
          INNER JOIN tmpBase ON tmpBase.JuridicalId       = tmpData_res.JuridicalId
                            AND tmpBase.ContractId_child  = tmpData_res.ContractId_child
                            AND tmpBase.InfoMoneyId_child = tmpData_res.InfoMoneyId_child
                          --AND tmpBase.PaidKindId_byBase = tmpContract.PaidKindId_byBase
          LEFT JOIN MovementLinkObject AS MLO_Unit
                                       ON MLO_Unit.MovementId = tmpBase.MovementId
                                      AND MLO_Unit.DescId = CASE WHEN tmpBase.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From()
                                                                 WHEN tmpBase.MovementDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To()
                                                            END
         /*LEFT JOIN MovementLinkObject AS MLO_Partner
                                       ON MLO_Partner.MovementId = tmpBase.MovementId
                                      AND MLO_Partner.DescId = CASE WHEN tmpBase.MovementDescId = zc_Movement_Sale() THEN zc_MovementLinkObject_From()
                                                                    WHEN tmpBase.MovementDescId = zc_Movement_ReturnIn() THEN zc_MovementLinkObject_To()
                                                               END*/
          LEFT JOIN ObjectLink AS ObjectLink_Unit_Branch
                               ON ObjectLink_Unit_Branch.ObjectId = MLO_Unit.ObjectId
                              AND ObjectLink_Unit_Branch.DescId   = zc_ObjectLink_Unit_Branch()
     WHERE tmpData_res.Sum_Bonus <> 0
    ;
    
    
    CREATE TEMP TABLE tmpCheck_bonus ON COMMIT DROP
       AS (SELECT tmpData_res.JuridicalId
                , tmpData_res.ContractId_child
                , tmpData_res.InfoMoneyId_child
                , tmpData_res.Sum_Bonus
                , CAST (SUM (COALESCE(MovementItem.Amount, 0)) AS NUMERIC (16, 2)) AS Sum_Bonus_mi
           FROM tmpData_res
                LEFT JOIN MovementItem ON MovementItem.MovementId = tmpData_res.MovementId_pl
                                      AND MovementItem.DescId     = zc_MI_Child()
                                      AND MovementItem.isErased   = FALSE
           WHERE tmpData_res.Sum_Bonus <> 0
           GROUP BY tmpData_res.JuridicalId
                  , tmpData_res.ContractId_child
                  , tmpData_res.InfoMoneyId_child
                  , tmpData_res.Sum_Bonus
           HAVING tmpData_res.Sum_Bonus <> CAST (SUM (COALESCE(MovementItem.Amount, 0)) AS NUMERIC (16, 2))
          );

    -- Проверка
    IF EXISTS (SELECT 1 FROM tmpCheck_bonus)
    THEN
        RAISE EXCEPTION 'Ошибка.Проверка сумм : Оригинал = <%> Sum_Bonus = <%>  Sum_Bonus_mi = <%>  % %  % %  % %'
                   , (SELECT tmpData_res.Sum_Bonus
                      FROM tmpCheck_bonus
                           JOIN tmpData_res ON tmpData_res.JuridicalId        = tmpCheck_bonus.JuridicalId
                                           AND tmpData_res.ContractId_child   = tmpCheck_bonus.ContractId_child
                                           AND tmpData_res.InfoMoneyId_child  = tmpCheck_bonus.InfoMoneyId_child
                      ORDER BY tmpCheck_bonus.JuridicalId, tmpCheck_bonus.ContractId_child, tmpCheck_bonus.InfoMoneyId_child, tmpCheck_bonus.Sum_Bonus
                      LIMIT 1
                     )
                   , (SELECT tmpCheck_bonus.Sum_Bonus
                      FROM tmpCheck_bonus
                      ORDER BY tmpCheck_bonus.JuridicalId, tmpCheck_bonus.ContractId_child, tmpCheck_bonus.InfoMoneyId_child, tmpCheck_bonus.Sum_Bonus
                      LIMIT 1
                     )
                   , (SELECT tmpCheck_bonus.Sum_Bonus_mi
                      FROM tmpCheck_bonus
                      ORDER BY tmpCheck_bonus.JuridicalId, tmpCheck_bonus.ContractId_child, tmpCheck_bonus.InfoMoneyId_child, tmpCheck_bonus.Sum_Bonus
                      LIMIT 1
                     )
                   , CHR (13)
                   , (SELECT lfGet_Object_ValueData (tmpCheck_bonus.JuridicalId)
                      FROM tmpCheck_bonus
                      ORDER BY tmpCheck_bonus.JuridicalId, tmpCheck_bonus.ContractId_child, tmpCheck_bonus.InfoMoneyId_child, tmpCheck_bonus.Sum_Bonus
                      LIMIT 1
                     )
                   , CHR (13)
                   , (SELECT lfGet_Object_ValueData (tmpCheck_bonus.ContractId_child)
                      FROM tmpCheck_bonus
                      ORDER BY tmpCheck_bonus.JuridicalId, tmpCheck_bonus.ContractId_child, tmpCheck_bonus.InfoMoneyId_child, tmpCheck_bonus.Sum_Bonus
                      LIMIT 1
                     )
                   , CHR (13)
                   , (SELECT lfGet_Object_ValueData (tmpCheck_bonus.InfoMoneyId_child)
                      FROM tmpCheck_bonus
                      ORDER BY tmpCheck_bonus.JuridicalId, tmpCheck_bonus.ContractId_child, tmpCheck_bonus.InfoMoneyId_child, tmpCheck_bonus.Sum_Bonus
                      LIMIT 1
                     )
                     ;
    END IF;

-- if vbUserId = 5
-- then
--     RAISE EXCEPTION 'Ошибка. test end';
-- end if;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 20.05.20         * add inBranchId
 09.12.15         * 
 03.12.14         *
*/

-- тест
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_ByReport_new (inStartDate := '01.01.2013', inEndDate := '01.01.2013' , inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpInsertUpdate_Movement_ProfitLossService_ByReport_new(inStartDate := ('01.06.2020')::TDateTime , inEndDate := ('30.06.2020')::TDateTime , inPaidKindId := 3 , inJuridicalId := 0 , inBranchId := 0 ,  inSession := zfCalc_UserAdmin());
-- select * from gpInsertUpdate_Movement_ProfitLossService_ByReport_new(inStartDate := ('28.08.2020')::TDateTime , inEndDate := ('28.08.2020')::TDateTime , inPaidKindId := 3 , inJuridicalId := 15212 , inBranchId := 0 ,  inSession := '5');
