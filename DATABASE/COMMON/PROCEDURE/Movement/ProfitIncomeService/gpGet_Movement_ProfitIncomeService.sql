-- Function: gpGet_Movement_ProfitIncomeService()

DROP FUNCTION IF EXISTS gpGet_Movement_ProfitIncomeService (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProfitIncomeService(
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
             , PaidKindId Integer, PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , isLoad Boolean)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_ProfitIncomeService());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY
       SELECT
             0                                AS Id
           , CAST (NEXTVAL ('movement_ProfitIncomeService_seq') AS TVarChar) AS InvNumber
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
           , 0                                AS PaidKindId
           , CAST ('' as TVarChar)            AS PaidKindName
           , 0                                AS ContractConditionKindId
           , CAST ('' as TVarChar)            AS ContractConditionKindName
           , 0                                AS BonusKindId
           , CAST ('' as TVarChar)            AS BonusKindName
           , CAST (FALSE AS Boolean)          AS isLoad 

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;

     ELSE

     RETURN QUERY
     --WITH
     --tmpContract_View AS (SELECT * FROM Object_Contract_InvNumber_View)
     
       SELECT
             CASE WHEN inMovementId = -1 
                  THEN 0
                  ELSE     inMovementId 
             END as Id
           , CASE WHEN inMovementId = 0
                  THEN CAST (NEXTVAL ('movement_ProfitIncomeService_seq') AS TVarChar)
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
           , Object_Contract_InvNumber.Id           AS ContractId
           , Object_Contract_InvNumber.ValueData        AS ContractInvNumber
           , Object_ContractMaster_InvNumber.Id         AS ContractMasterId
           , Object_ContractMaster_InvNumber.ValueData  AS ContractMasterInvNumber
           , Object_ContractChild_InvNumber.Id          AS ContractChildId
           , Object_ContractChild_InvNumber.ValueData   AS ContractChildInvNumber                      
           , Object_PaidKind.Id                     AS PaidKindId
           , Object_PaidKind.ValueData              AS PaidKindName

           , Object_ContractConditionKind.Id        AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData AS ContractConditionKindName

           , Object_BonusKind.Id                    AS BonusKindId
           , Object_BonusKind.ValueData             AS BonusKindName
 
           , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) AS isLoad

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN Object AS Object_Partner ON Object_Partner.Id = ObjectLink_Partner_Juridical.ObjectId

            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = COALESCE(MILinkObject_MoneyPlace.ObjectId, ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

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
            --LEFT JOIN tmpContract_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId
            LEFT JOIN Object AS Object_Contract_InvNumber ON Object_Contract_InvNumber.Id = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
            --LEFT JOIN tmpContract_View AS View_ContractMaster_InvNumber ON View_ContractMaster_InvNumber.ContractId = MILinkObject_ContractMaster.ObjectId
            LEFT JOIN Object AS Object_ContractMaster_InvNumber ON Object_ContractMaster_InvNumber.Id = MILinkObject_ContractMaster.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
            --LEFT JOIN tmpContract_View AS View_ContractChild_InvNumber ON View_ContractChild_InvNumber.ContractId = MILinkObject_ContractChild.ObjectId
            LEFT JOIN Object AS Object_ContractChild_InvNumber ON Object_ContractChild_InvNumber.Id = MILinkObject_ContractChild.ObjectId

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

            LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                      ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                     AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()

       WHERE Movement.Id =  inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_ProfitIncomeService(inMovementId := 1 , inMovementId_Value := 266333 , inOperDate := ('01.05.2014')::TDateTime ,  inSession := '5');
