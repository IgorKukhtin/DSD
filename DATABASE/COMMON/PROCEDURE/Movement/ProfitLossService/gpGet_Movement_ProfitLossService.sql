-- Function: gpGet_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpGet_Movement_ProfitLossService (Integer, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProfitLossService (Integer, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_ProfitLossService (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProfitLossService(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , BonusValue TFloat
             , Comment TVarChar
             , JuridicalId Integer, JuridicalName TVarChar
             , PartnerId Integer, PartnerName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , ContractId Integer, ContractInvNumber TVarChar
             , ContractMasterId Integer, ContractMasterInvNumber TVarChar
             , ContractChildId Integer, ContractChildInvNumber TVarChar
             , UnitId Integer, UnitName TVarChar
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , CurrencyPartnerId Integer
             , CurrencyPartnerName TVarChar
             , CurrencyPartnerValue TFloat
             , ParPartnerValue      TFloat
             , AmountCurrency       TFloat
             , isLoad Boolean
             , TradeMarkId Integer, TradeMarkName TVarChar
             , MovementId_doc Integer, InvNumber_doc TVarChar, InvNumber_full_doc TVarChar
             , InvNumberInvoice TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProfitLossService());
     vbUserId := lpGetUserBySession (inSession);

     -- !!! странная замена!!!
     IF COALESCE (inMovementId_Value, 0) = 0 AND inMovementId > 0
     THEN inMovementId_Value:= inMovementId;
     END IF;

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     /*IF inCurrencyPartnerId <> zc_Enum_Currency_Basis()
          THEN SELECT Amount, ParValue INTO outCurrencyValue, outParValue
               FROM lfSelect_Movement_Currency_byDate (inOperDate:= inOperDatePartner, inCurrencyFromId:= zc_Enum_Currency_Basis(), inCurrencyToId:= inCurrencyPartnerId, inPaidKindId:= inPaidKindId);
          ELSE outCurrencyValue:= 0;
               outParValue:=0;
          END IF;
          */
     RETURN QUERY
       SELECT
             0                                AS Id
           , CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar) AS InvNumber
           , inOperDate                       AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName
           , 0::TFloat                        AS AmountIn
           , 0::TFloat                        AS AmountOut
           , 0::TFloat                        AS BonusValue
           , ''::TVarChar                     AS Comment
           , 0                                AS JuridicalId
           , CAST ('' as TVarChar)            AS JuridicalName
           , 0                                AS PartnerId
           , CAST ('' as TVarChar)            AS PartnerName
           , 0                                AS InfoMoneyId
           , CAST ('' as TVarChar)            AS InfoMoneyName
           , 0                                AS ContractId
           , ''::TVarChar                     AS ContractInvNumber
           , 0                                AS ContractMasterId
           , ''::TVarChar                     AS ContractMasterInvNumber
           , 0                                AS ContractChildId
           , ''::TVarChar                     AS ContractChildInvNumber                      
           , 0                                AS UnitId
           , CAST ('' as TVarChar)            AS UnitName
           , 0                                AS PaidKindId
           , CAST ('' as TVarChar)            AS PaidKindName
           , 0                                AS ContractConditionKindId
           , CAST ('' as TVarChar)            AS ContractConditionKindName
           , 0                                AS BonusKindId
           , CAST ('' as TVarChar)            AS BonusKindName
           , 0                                AS BranchIdId
           , CAST ('' as TVarChar)            AS BranchName

           , 0                                AS CurrencyPartnerId
           , CAST ('' as TVarChar)            AS CurrencyPartnerName    
           , 0::TFloat                        AS CurrencyPartnerValue
           , 0::TFloat                        AS ParPartnerValue
           , 0::TFloat                        AS AmountCurrency

           , CAST (FALSE AS Boolean)          AS isLoad 

           , 0                                AS TradeMarkId
           , CAST ('' as TVarChar)            AS TradeMarkName
           , 0                                AS MovementId_doc
           , CAST ('' as TVarChar)            AS InvNumber_doc
           , CAST ('' as TVarChar)            AS InvNumber_full_doc
           , CAST ('' AS TVarChar)            AS InvNumberInvoice
       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;

     ELSE

     RETURN QUERY
       SELECT
             CASE WHEN inMovementId = -1 
                  THEN 0
                  ELSE     inMovementId 
             END as Id
           , CASE WHEN inMovementId = 0
                  THEN CAST (NEXTVAL ('movement_profitlossservice_seq') AS TVarChar)
                  ELSE Movement.InvNumber END       AS InvNumber
           , CASE WHEN inMovementId = 0
                  THEN inOperDate
                  ELSE Movement.OperDate END        AS OperDate
           , Object_Status.ObjectCode               AS StatusCode
           , Object_Status.ValueData                AS StatusName

           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN (MovementItem.Amount > 0) AND (Movement.descid <> zc_Movement_SendDebt())
                       THEN MovementItem.Amount
                  ELSE 0
             END :: TFloat                          AS AmountIn
           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN (MovementItem.Amount < 0) OR (Movement.descid = zc_Movement_SendDebt())
                       THEN -1 * MovementItem.Amount * ((Movement.descid <> zc_Movement_SendDebt())::INTEGER*2 - 1)
                  ELSE 0
             END :: TFloat                          AS AmountOut
           , MIFloat_BonusValue.ValueData           AS BonusValue
           , MIString_Comment.ValueData             AS Comment
           , Object_Juridical.Id                    AS JuridicalId
           , Object_Juridical.ValueData             AS JuridicalName
           , Object_Partner.Id                      AS PartnerId
           , Object_Partner.ValueData               AS PartnerName
           , View_InfoMoney.InfoMoneyId             AS InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all       AS InfoMoneyName
           , View_Contract_InvNumber.ContractId     AS ContractId
           , View_Contract_InvNumber.InvNumber      AS ContractInvNumber
           , View_ContractMaster_InvNumber.ContractId     AS ContractMasterId
           , View_ContractMaster_InvNumber.InvNumber      AS ContractMasterInvNumber
           , View_ContractChild_InvNumber.ContractId      AS ContractChildId
           , View_ContractChild_InvNumber.InvNumber       AS ContractChildInvNumber                      
           , Object_Unit.Id                         AS UnitId
           , Object_Unit.ValueData                  AS UnitName
           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_BonusKind.Id                    AS BonusKindId
           , Object_BonusKind.ValueData             AS BonusKindName
 
           , Object_Branch.Id                       AS BranchId
           , Object_Branch.ValueData                AS BranchName

           , Object_CurrencyPartner.Id                                     AS CurrencyPartnerId
           , Object_CurrencyPartner.ValueData                              AS CurrencyPartnerName  
           , MovementFloat_CurrencyPartnerValue.ValueData         ::TFloat AS CurrencyPartnerValue
           , COALESCE (MovementFloat_ParPartnerValue.ValueData,1) ::TFloat AS ParPartnerValue
           , COALESCE (MIFloat_AmountCurrency.ValueData,0)        ::TFloat AS AmountCurrency

           , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) AS isLoad

           , Object_TradeMark.Id                    AS TradeMarkId
           , Object_TradeMark.ValueData             AS TradeMarkName
           , Movement_Doc.Id                        AS MovementId_doc
           , Movement_Doc.InvNumber                 AS InvNumber_doc
           , zfCalc_PartionMovementName (Movement_Doc.DescId, MovementDesc_Doc.ItemName, Movement_Doc.InvNumber, Movement_Doc.OperDate) :: TVarChar AS InvNumber_full_doc
           , MovementString_InvNumberInvoice.ValueData ::TVarChar AS InvNumberInvoice
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementLinkObject AS MovementLinkObject_CurrencyPartner
                                         ON MovementLinkObject_CurrencyPartner.MovementId = Movement.Id
                                        AND MovementLinkObject_CurrencyPartner.DescId = zc_MovementLinkObject_CurrencyPartner()
            LEFT JOIN Object AS Object_CurrencyPartner ON Object_CurrencyPartner.Id = MovementLinkObject_CurrencyPartner.ObjectId

            LEFT JOIN MovementString AS MovementString_InvNumberInvoice
                                     ON MovementString_InvNumberInvoice.MovementId = Movement.Id
                                    AND MovementString_InvNumberInvoice.DescId = zc_MovementString_InvNumberInvoice()

            LEFT JOIN MovementFloat AS MovementFloat_CurrencyPartnerValue
                                    ON MovementFloat_CurrencyPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_CurrencyPartnerValue.DescId = zc_MovementFloat_CurrencyPartnerValue()
            LEFT JOIN MovementFloat AS MovementFloat_ParPartnerValue
                                    ON MovementFloat_ParPartnerValue.MovementId = Movement.Id
                                   AND MovementFloat_ParPartnerValue.DescId = zc_MovementFloat_ParPartnerValue()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_TradeMark
                                         ON MovementLinkObject_TradeMark.MovementId = Movement.Id
                                        AND MovementLinkObject_TradeMark.DescId = zc_MovementLinkObject_TradeMark()
            LEFT JOIN Object AS Object_TradeMark ON Object_TradeMark.Id = MovementLinkObject_TradeMark.ObjectId

            LEFT JOIN MovementLinkMovement AS MLM_Doc
                                           ON MLM_Doc.MovementId = Movement.Id
                                          AND MLM_Doc.DescId = zc_MovementLinkMovement_Doc()
            LEFT JOIN Movement AS Movement_Doc ON Movement_Doc.Id = MLM_Doc.MovementChildId
            LEFT JOIN MovementDesc AS MovementDesc_Doc ON MovementDesc_Doc.Id = Movement_Doc.DescId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE(MILinkObject_MoneyPlace.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

            LEFT JOIN MovementItemFloat AS MIFloat_AmountCurrency
                                        ON MIFloat_AmountCurrency.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountCurrency.DescId = zc_MIFloat_AmountCurrency()
            LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                        ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                             ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber 
                                                     ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
            --LEFT JOIN Object AS Object_Contract ON Object_Contract.Id = MILinkObject_Contract.ObjectId
            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
            LEFT JOIN Object_Contract_InvNumber_View AS View_ContractMaster_InvNumber 
                                                     ON View_ContractMaster_InvNumber.ContractId = MILinkObject_ContractMaster.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
            LEFT JOIN Object_Contract_InvNumber_View AS View_ContractChild_InvNumber 
                                                     ON View_ContractChild_InvNumber.ContractId = MILinkObject_ContractChild.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = CASE WHEN inMovementId = - 1
                                                                             THEN zc_Enum_PaidKind_FirstForm()
                                                                             ELSE MILinkObject_PaidKind.ObjectId
                                                                        END 
            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                             ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                      ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                     AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

       WHERE Movement.Id =  inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_ProfitLossService (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.    Манько Д.А
 24.07.20         *
 18.02.15         * add ContractMaster, ContractChild
 23.06.14                        * 
 19.02.14         * add BonusKind
 18.02.14                                                         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ProfitLossService(inMovementId := 1 , inMovementId_Value := 266333 , inOperDate := ('01.05.2014')::TDateTime ,  inSession := '5');
