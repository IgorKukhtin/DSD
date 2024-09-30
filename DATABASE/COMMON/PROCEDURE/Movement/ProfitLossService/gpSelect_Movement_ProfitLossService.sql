-- Function: gpSelect_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Boolean, TVarChar);
--DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossService (
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inJuridicalBasisId   Integer   , -- Главное юр.лицо
    IN inBranchId           Integer  ,
    IN inPaidKindId         Integer  ,
    IN inIsErased           Boolean ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, InvNumber_full TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , ServiceDate  TDateTime
             , TotalSumm  TFloat
             , PercentRet TFloat
             , PartKg     TFloat
             , CurrencyPartnerValue TFloat
             , ParPartnerValue      TFloat
             , AmountIn TFloat, AmountOut TFloat
             , BonusValue TFloat, AmountPartner TFloat, Summ TFloat
             , Summ_51201 TFloat
             , AmountCurrency TFloat 
             , Comment TVarChar
             , JuridicalId Integer, JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , JuridicalCode_Child Integer, JuridicalName_Child TVarChar, OKPO_Child TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerId Integer, PartnerCode Integer, PartnerName TVarChar, ItemName_Partner TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractId Integer, ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar, ContractTagGroupName TVarChar
             , ContractMasterId Integer, ContractMasterInvNumber TVarChar
             , ContractTagId_master Integer, ContractTagName_master TVarChar
             , ContractChildId Integer, ContractChildInvNumber TVarChar
             , ContractTagId_child Integer, ContractTagName_child TVarChar
             , UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchCode Integer, BranchName TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , PersonalId_main Integer, PersonalName_main TVarChar
             , PaidKindId_Child Integer, PaidKindName_Child TVarChar
             , CurrencyPartnerId Integer
             , CurrencyPartnerName TVarChar 
             , TradeMarkId Integer, TradeMarkName TVarChar
             , MovementId_doc Integer, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar, DescName_doc TVarChar
             , InvNumberInvoice TVarChar
             , isLoad Boolean

             , ProfitLossGroupName     TVarChar
             , ProfitLossDirectionName TVarChar
             , ProfitLossName          TVarChar
             , ProfitLossName_all      TVarChar
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProfitLossService());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- переопределяем,  важно, в случае с БН - ограничени по Филиалу не делать, что бы не выбрали
     IF COALESCE (inPaidKindId, 0) = zc_Enum_PaidKind_FirstForm()
     THEN
         inBranchId := 0;
     END IF;

 /*
     -- Разрешен просмотр долги Маркетинг - НАЛ
     IF NOT EXISTS (SELECT 1 FROM ObjectLink_UserRole_View AS tmp WHERE tmp.UserId = vbUserId AND tmp.RoleId = 8852398)
        AND COALESCE (inPaidKindId, 0) IN (0, zc_Enum_PaidKind_SecdondForm())
     THEN
         RAISE EXCEPTION 'Ошибка.Нет прав просмотра данных <НАЛ>.' ;
     END IF;
 */    

     -- Результат
    RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )

          , tmpRoleAccessKey AS (SELECT DISTINCT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId OR (UserId IN (5) AND vbUserId = 471654) -- Холод А.В.
                              --UNION
                              -- SELECT DISTINCT AccessKeyId FROM Object_RoleAccessKey_View WHERE vbUserId = 471654 -- Холод А.В.
                                ) 
          , tmpMovement AS (SELECT Movement.*
                            FROM tmpStatus
                                 JOIN Movement ON Movement.DescId = zc_Movement_ProfitLossService()
                                              AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                              AND Movement.StatusId = tmpStatus.StatusId
                                 JOIN tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
                            )
          , tmpMI_Child AS (SELECT tmpMovement.Id            AS MovementId
                                 , SUM (MovementItem.Amount) AS Amount
                            FROM tmpMovement
                                 LEFT JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                       AND MovementItem.DescId = zc_MI_Child()
                            GROUP BY tmpMovement.Id
                            )

          , tmpMovementFloat AS (SELECT *
                                 FROM MovementFloat
                                 WHERE MovementFloat.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementFloat.DescId IN (zc_MovementFloat_TotalSumm()
                                                              , zc_MovementFloat_PercentRet()
                                                              , zc_MovementFloat_PartKg()
                                                              , zc_MovementFloat_CurrencyPartnerValue()
                                                              , zc_MovementFloat_ParPartnerValue()
                                                              )
                                )
          , tmpMovementString AS (SELECT *
                                  FROM MovementString
                                  WHERE MovementString.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                    AND MovementString.DescId IN (zc_MovementString_InvNumberInvoice()
                                                               )
                                 )
         -- ProfitLoss из проводок
         , tmpMIС_ProfitLoss AS (SELECT DISTINCT MovementItemContainer.MovementId
                                      , CLO_ProfitLoss.ObjectId AS ProfitLossId
                                 FROM MovementItemContainer
                                      INNER JOIN ContainerLinkObject AS CLO_ProfitLoss
                                                                     ON CLO_ProfitLoss.ContainerId = MovementItemContainer.ContainerId
                                                                    AND CLO_ProfitLoss.DescId      = zc_ContainerLinkObject_ProfitLoss()
                                 WHERE MovementItemContainer.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                                   AND MovementItemContainer.DescId     = zc_MIContainer_Summ()
                                   AND MovementItemContainer.AccountId  = zc_Enum_Account_100301()   -- прибыль текущего периода
                                   -- !!! временно, т.к. долго!!!
                                   AND 1=0
                                )
         , tmpProfitLoss_View AS (SELECT * FROM Object_ProfitLoss_View WHERE Object_ProfitLoss_View.ProfitLossId IN (SELECT tmpMIС_ProfitLoss.ProfitLossId FROM tmpMIС_ProfitLoss))

         , tmpMI AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId = zc_MI_Master()
                     )
        
         , tmpMovementItemFloat AS (SELECT *
                                    FROM MovementItemFloat
                                    WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MovementItemFloat.DescId IN (zc_MIFloat_BonusValue()
                                                                     , zc_MIFloat_AmountPartner()
                                                                     , zc_MIFloat_Summ()
                                                                     , zc_MIFloat_AmountCurrency()
                                                                     )
                                    )

         , tmpMovementItemString AS (SELECT *
                                    FROM MovementItemString
                                    WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                      AND MovementItemString.DescId IN (zc_MIString_Comment())
                                    )

         , tmpMovementItemLinkObject AS (SELECT *
                                         FROM MovementItemLinkObject
                                         WHERE MovementItemLinkObject.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                                           AND MovementItemLinkObject.DescId IN (zc_MILinkObject_InfoMoney()
                                            , zc_MILinkObject_Contract()
                                            , zc_MILinkObject_ContractMaster()
                                            , zc_MILinkObject_ContractChild()
                                            , zc_MILinkObject_Unit()
                                            , zc_MILinkObject_PaidKind()
                                            , zc_MILinkObject_ContractConditionKind()
                                            , zc_MILinkObject_BonusKind()
                                            , zc_MILinkObject_Juridical()
                                            , zc_MILinkObject_Branch())
                                         )

         , tmpObject_Contract AS (SELECT Object_Contract_InvNumber_View.*
                                  FROM Object_Contract_InvNumber_View
                                  WHERE Object_Contract_InvNumber_View.ContractId IN (SELECT DISTINCT tmp.ObjectId FROM tmpMovementItemLinkObject AS tmp)
                                  )
         , tmpObject_InfoMoney AS (SELECT Object_InfoMoney_View.*
                                  FROM Object_InfoMoney_View
                                  WHERE Object_InfoMoney_View.InfoMoneyId IN (SELECT DISTINCT tmp.ObjectId FROM tmpMovementItemLinkObject AS tmp)
                                  )

       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , zfCalc_PartionMovementName (Movement.DescId, MovementDesc.ItemName, Movement.InvNumber, Movement.OperDate) :: TVarChar AS InvNumber_full
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , MovementDate_ServiceDate.ValueData  ::TDateTime AS ServiceDate 
           
           , MovementFloat_TotalSumm.ValueData   ::TFloat   AS TotalSumm
           , MovementFloat_PercentRet.ValueData  ::TFloat   AS PercentRet
           , MovementFloat_PartKg.ValueData      ::TFloat   AS PartKg
           
           , MovementFloat_CurrencyPartnerValue.ValueData ::TFloat AS CurrencyPartnerValue
           , MovementFloat_ParPartnerValue.ValueData      ::TFloat AS ParPartnerValue

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat                                    AS AmountIn
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat                                    AS AmountOut

           , MIFloat_BonusValue.ValueData                   AS BonusValue
           , MIFloat_AmountPartner.ValueData                AS AmountPartner
           , MIFloat_Summ.ValueData                         AS Summ
           , COALESCE (tmpMI_Child.Amount, 0)     :: TFloat AS Summ_51201
           , COALESCE (MIFloat_AmountCurrency.ValueData,0)  :: TFloat AS AmountCurrency

           , MIString_Comment.ValueData                     AS Comment
           , Object_Juridical.Id                            AS JuridicalId
           , Object_Juridical.ObjectCode          ::Integer AS JuridicalCode
           , Object_Juridical.ValueData                     AS JuridicalName
           , ObjectDesc.ItemName

           , ObjectHistory_JuridicalDetails_View.OKPO
           , Object_Juridical_Child.ObjectCode              AS JuridicalCode_Child
           , Object_Juridical_Child.ValueData               AS JuridicalName_Child
           , ObjectHistory_JuridicalDetails_View_Child.OKPO AS OKPO_Child

           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName

           , Object_Partner.Id                              AS PartnerId
           , Object_Partner.ObjectCode                      AS PartnerCode
           , Object_Partner.ValueData                       AS PartnerName
           , ObjectDesc_Partner.ItemName                    AS ItemName_Partner

           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyId              AS InfoMoneyId
           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , View_Contract_InvNumber.ContractId
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , View_Contract_InvNumber.ContractTagGroupName
           , View_Contract_InvNumber_master.ContractId      AS ContractMasterId
           , View_Contract_InvNumber_master.InvNumber       AS ContractMasterInvNumber
           , View_Contract_InvNumber_master.ContractTagId   AS ContractTagId_master
           , View_Contract_InvNumber_master.ContractTagName AS ContractTagName_master
           , View_Contract_InvNumber_child.ContractId       AS ContractChildId
           , View_Contract_InvNumber_child.InvNumber        AS ContractChildInvNumber
           , View_Contract_InvNumber_child.ContractTagId    AS ContractTagId_child
           , View_Contract_InvNumber_child.ContractTagName  AS ContractTagName_child

           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.Id                             AS PaidKindId
           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_ContractConditionKind.Id                AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData         AS ContractConditionKindName

           , Object_BonusKind.Id                            AS BonusKindId
           , Object_BonusKind.ValueData                     AS BonusKindName
           
           , Object_Branch.Id                               AS BranchId
           , Object_Branch.ObjectCode                       AS BranchCode
           , Object_Branch.ValueData                        AS BranchName

           , COALESCE (Object_PersonalTrade.Id, Object_PersonalTrade_inf.Id)               AS PersonalId
           , COALESCE (Object_PersonalTrade.ValueData, Object_PersonalTrade_inf.ValueData) AS PersonalName
           , COALESCE (Object_PersonalMain.Id, Object_Personal_inf.Id)                     AS PersonalId_main
           , COALESCE (Object_PersonalMain.ValueData, Object_Personal_inf.ValueData)       AS PersonalName_main
           
           , Object_PaidKind_Child.Id                      AS PaidKindId_Child
           , Object_PaidKind_Child.ValueData               AS PaidKindName_Child
           
           , Object_CurrencyPartner.Id                     AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData              AS CurrencyPartnerName

           , Object_TradeMark.Id                           AS TradeMarkId
           , Object_TradeMark.ValueData                    AS TradeMarkName
           
           , COALESCE (Movement_Doc.Id,-1)::Integer        AS MovementId_doc
           , Movement_Doc.InvNumber                        AS InvNumber_doc
           , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
           , MovementDesc_Doc.ItemName                     AS DescName_doc
           , MovementString_InvNumberInvoice.ValueData ::TVarChar AS InvNumberInvoice
           
           , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) AS isLoad

           , tmpProfitLoss_View.ProfitLossGroupName     ::TVarChar
           , tmpProfitLoss_View.ProfitLossDirectionName ::TVarChar
           , tmpProfitLoss_View.ProfitLossName          ::TVarChar
           , tmpProfitLoss_View.ProfitLossName_all      ::TVarChar
       FROM tmpMovement AS Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId
            LEFT JOIN  MovementDesc ON MovementDesc.Id = Movement.DescId

            LEFT JOIN MovementDate AS MovementDate_ServiceDate
                                   ON MovementDate_ServiceDate.MovementId = Movement.Id
                                  AND MovementDate_ServiceDate.DescId = zc_MovementDate_ServiceDate()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalTrade
                                         ON MovementLinkObject_PersonalTrade.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalTrade.DescId = zc_MovementLinkObject_PersonalTrade()
            LEFT JOIN Object AS Object_PersonalTrade ON Object_PersonalTrade.Id = MovementLinkObject_PersonalTrade.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalMain
                                         ON MovementLinkObject_PersonalMain.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalMain.DescId = zc_MovementLinkObject_PersonalMain()
            LEFT JOIN Object AS Object_PersonalMain ON Object_PersonalMain.Id = MovementLinkObject_PersonalMain.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PaidKind
                                         ON MovementLinkObject_PaidKind.MovementId = Movement.Id
                                        AND MovementLinkObject_PaidKind.DescId = zc_MovementLinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind_Child ON Object_PaidKind_Child.Id = MovementLinkObject_PaidKind.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_TradeMark
                                         ON MovementLinkObject_TradeMark.MovementId = Movement.Id
                                        AND MovementLinkObject_TradeMark.DescId = zc_MovementLinkObject_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = MovementLinkObject_TradeMark.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Doc
                                           ON MLM_Doc.MovementId = Movement.Id
                                          AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc()
            LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = MLM_Doc.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId

            LEFT JOIN tmpMovementString AS MovementString_InvNumberInvoice
                                        ON MovementString_InvNumberInvoice.MovementId = Movement.Id
                                       AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

            LEFT JOIN tmpMovementFloat AS MovementFloat_TotalSumm
                                       ON MovementFloat_TotalSumm.MovementId = Movement.Id
                                      AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()
            LEFT JOIN tmpMovementFloat AS MovementFloat_PercentRet
                                       ON MovementFloat_PercentRet.MovementId = Movement.Id
                                      AND MovementFloat_PercentRet.DescId = zc_MovementFloat_PercentRet()
            LEFT JOIN tmpMovementFloat AS MovementFloat_PartKg
                                       ON MovementFloat_PartKg.MovementId = Movement.Id
                                      AND MovementFloat_PartKg.DescId = zc_MovementFloat_PartKg()

            LEFT JOIN tmpMovementFloat AS MovementFloat_CurrencyPartnerValue
                                       ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN tmpMovementFloat AS MovementFloat_ParPartnerValue
                                       ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                      AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()
            --
            LEFT JOIN tmpMIС_ProfitLoss ON tmpMIС_ProfitLoss.MovementId = Movement.Id
            LEFT JOIN tmpProfitLoss_View ON tmpProfitLoss_View.ProfitLossId = tmpMIС_ProfitLoss.ProfitLossId

            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId
            LEFT JOIN ObjectDesc AS ObjectDesc_Partner ON ObjectDesc_Partner.Id = Object_Partner.DescId
            
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

            LEFT JOIN ObjectLink AS ObjectLink_Juridical_Retail
                                 ON ObjectLink_Juridical_Retail.ObjectId = Object_Juridical.Id
                                AND ObjectLink_Juridical_Retail.DescId = zc_ObjectLink_Juridical_Retail()
            LEFT JOIN Object AS Object_Retail ON Object_Retail.Id = ObjectLink_Juridical_Retail.ChildObjectId

            LEFT JOIN tmpMovementItemFloat AS MIFloat_BonusValue
                                           ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                          AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountPartner
                                           ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN tmpMovementItemFloat AS MIFloat_Summ
                                           ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                          AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN tmpMovementItemFloat AS MIFloat_AmountCurrency
                                           ON MIFloat_AmountCurrency.MovementItemId = MovementItem.Id
                                          AND MIFloat_AmountCurrency.DescId = zc_MIFloat_AmountCurrency()

            LEFT JOIN tmpMovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN tmpObject_InfoMoney AS Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN tmpObject_Contract AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_ContractMaster
                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
            LEFT JOIN tmpObject_Contract AS View_Contract_InvNumber_master 
                                                     ON View_Contract_InvNumber_master.ContractId = MILinkObject_ContractMaster.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_ContractChild
                                                ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                               AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
            LEFT JOIN tmpObject_Contract AS View_Contract_InvNumber_child 
                                                     ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_BonusKind
                                             ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Juridical
                                             ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical_Child ON Object_Juridical_Child.Id = MILinkObject_Juridical.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ObjectHistory_JuridicalDetails_View_Child ON ObjectHistory_JuridicalDetails_View_Child.JuridicalId = MILinkObject_Juridical.ObjectId

            LEFT JOIN tmpMovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                      ON MovementBoolean_isLoad.MovementId = Movement.Id
                                     AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

            LEFT JOIN tmpMI_Child ON tmpMI_Child.MovementId = Movement.Id

            --для бн берем из договора
            LEFT JOIN ObjectLink AS ObjectLink_Contract_PersonalTrade
                                 ON ObjectLink_Contract_PersonalTrade.ObjectId = MILinkObject_ContractMaster.ObjectId
                                AND ObjectLink_Contract_PersonalTrade.DescId = zc_ObjectLink_Contract_PersonalTrade()
            --для нал берем из контрагента          
            LEFT JOIN ObjectLink AS ObjectLink_Partner_PersonalTrade
                                 ON ObjectLink_Partner_PersonalTrade.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                AND ObjectLink_Partner_PersonalTrade.DescId = zc_ObjectLink_Partner_PersonalTrade()
                                AND (COALESCE (MILinkObject_PaidKind.ObjectId, 0) = zc_Enum_PaidKind_SecondForm()
                                   OR COALESCE (ObjectLink_Contract_PersonalTrade.ChildObjectId,0) = 0
                                     )
            LEFT JOIN Object AS Object_PersonalTrade_inf ON Object_PersonalTrade_inf.Id = COALESCE (ObjectLink_Partner_PersonalTrade.ChildObjectId, ObjectLink_Contract_PersonalTrade.ChildObjectId)

            --для нал берем из контрагента          
            LEFT JOIN ObjectLink AS ObjectLink_Partner_Personal
                                 ON ObjectLink_Partner_Personal.ObjectId = ObjectLink_Partner_Juridical.ObjectId
                                AND ObjectLink_Partner_Personal.DescId = zc_ObjectLink_Partner_Personal()
            LEFT JOIN Object AS Object_Personal_inf ON Object_Personal_inf.Id = ObjectLink_Partner_Personal.ChildObjectId


       WHERE ( COALESCE (MILinkObject_PaidKind.ObjectId, 0) = inPaidKindId OR inPaidKindId = 0)
         AND ( COALESCE (MILinkObject_Branch.ObjectId, 0) = inBranchId OR inBranchId = 0)
      ;
      
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 07.08.24         * 
 31.08.20         *
 21.05.20         *
 06.10.16         * add inJuridicalBasisId
 18.02.15         * add ContractMaster, ContractChild
 06.03.14                                        * add Object_RoleAccessKey_View
 19.02.14         * add BonusKind
 18.02.14                                                         *
*/

-- тест
--SELECT * FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.09.2021' , inEndDate:= '30.09.2021' , inJuridicalBasisId:=0, inBranchId:=0 , inPaidKindId := 0, inIsErased:=false, inSession:= '5')

--SELECT * FROM gpSelect_Movement_ProfitLossService (inStartDate:= '01.08.2024' , inEndDate:= '01.08.2024' , inJuridicalBasisId:=0, inBranchId:=0 , inPaidKindId := 0, inIsErased:=false, inSession:= '5')
