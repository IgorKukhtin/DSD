-- Function: gpSelect_Movement_ProfitIncomeService()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitIncomeService (TDateTime, TDateTime, Integer, Integer, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitIncomeService(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inJuridicalBasisId   Integer   , -- Главное юр.лицо
    IN inBranchId           Integer  ,
    IN inPaidKindId         Integer  ,
    IN inIsErased           Boolean ,
    IN inSession            TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , BonusValue TFloat  --, AmountPartner TFloat, Summ TFloat
             , Comment TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , JuridicalCode_Child Integer, JuridicalName_Child TVarChar, OKPO_Child TVarChar
             , RetailId Integer, RetailName TVarChar
             , PartnerCode Integer, PartnerName TVarChar, ItemName_Partner TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , ContractMasterId Integer, ContractMasterInvNumber TVarChar
             , ContractChildId Integer, ContractChildInvNumber TVarChar
             , PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , BranchId Integer, BranchName TVarChar
             , isLoad Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProfitIncomeService());
     vbUserId:= lpGetUserBySession (inSession);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- переопределяем,  важно, в случае с БН - ограничени по Филиалу не делать, что бы не выбрали
     IF COALESCE (inPaidKindId, 0) = zc_Enum_PaidKind_FirstForm()
     THEN
         inBranchId := 0;
     END IF;

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id                                    AS Id
           , Movement.InvNumber                             AS InvNumber
           , Movement.OperDate                              AS OperDate
           , Object_Status.ObjectCode                       AS StatusCode
           , Object_Status.ValueData                        AS StatusName
           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat                                    AS AmountIn
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat                                    AS AmountOut

           , MIFloat_BonusValue.ValueData                   AS BonusValue

           , MIString_Comment.ValueData                     AS Comment
           , Object_Juridical.ObjectCode                    AS JuridicalCode
           , Object_Juridical.ValueData                     AS JuridicalName
           , ObjectDesc.ItemName

           , ObjectHistory_JuridicalDetails_View.OKPO
           , Object_Juridical_Child.ObjectCode              AS JuridicalCode_Child
           , Object_Juridical_Child.ValueData               AS JuridicalName_Child
           , ObjectHistory_JuridicalDetails_View_Child.OKPO AS OKPO_Child

           , Object_Retail.Id                               AS RetailId
           , Object_Retail.ValueData                        AS RetailName

           , Object_Partner.ObjectCode                      AS PartnerCode
           , Object_Partner.ValueData                       AS PartnerName
           , ObjectDesc_Partner.ItemName                    AS ItemName_Partner

           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , View_Contract_InvNumber_master.ContractId      AS ContractMasterId
           , View_Contract_InvNumber_master.InvNumber       AS ContractMasterInvNumber
           , View_Contract_InvNumber_child.ContractId       AS ContractChildId
           , View_Contract_InvNumber_child.InvNumber        AS ContractChildInvNumber

           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_ContractConditionKind.Id                AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData         AS ContractConditionKindName

           , Object_BonusKind.Id                            AS BonusKindId
           , Object_BonusKind.ValueData                     AS BonusKindName
           
           
           , Object_Branch.Id                               AS BranchId
           , Object_Branch.ValueData                        AS BranchName

           , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) AS isLoad

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_ProfitIncomeService()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
          --JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

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

            LEFT JOIN MovementItemFloat AS MIFloat_BonusValue
                                        ON MIFloat_BonusValue.MovementItemId = MovementItem.Id
                                       AND MIFloat_BonusValue.DescId = zc_MIFloat_BonusValue()
            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractMaster
                                             ON MILinkObject_ContractMaster.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractMaster.DescId = zc_MILinkObject_ContractMaster()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_master 
                                                     ON View_Contract_InvNumber_master.ContractId = MILinkObject_ContractMaster.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractChild
                                             ON MILinkObject_ContractChild.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractChild.DescId = zc_MILinkObject_ContractChild()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber_child 
                                                     ON View_Contract_InvNumber_child.ContractId = MILinkObject_ContractChild.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PaidKind
                                             ON MILinkObject_PaidKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PaidKind.DescId = zc_MILinkObject_PaidKind()
            LEFT JOIN Object AS Object_PaidKind ON Object_PaidKind.Id = MILinkObject_PaidKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_ContractConditionKind
                                             ON MILinkObject_ContractConditionKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_ContractConditionKind.DescId = zc_MILinkObject_ContractConditionKind()
            LEFT JOIN Object AS Object_ContractConditionKind ON Object_ContractConditionKind.Id = MILinkObject_ContractConditionKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_BonusKind
                                             ON MILinkObject_BonusKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_BonusKind.DescId = zc_MILinkObject_BonusKind()
            LEFT JOIN Object AS Object_BonusKind ON Object_BonusKind.Id = MILinkObject_BonusKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Juridical
                                             ON MILinkObject_Juridical.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Juridical.DescId = zc_MILinkObject_Juridical()
            LEFT JOIN Object AS Object_Juridical_Child ON Object_Juridical_Child.Id = MILinkObject_Juridical.ObjectId
            LEFT JOIN ObjectHistory_JuridicalDetails_View ObjectHistory_JuridicalDetails_View_Child ON ObjectHistory_JuridicalDetails_View_Child.JuridicalId = MILinkObject_Juridical.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()
            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

            LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                      ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                     AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
       WHERE ( COALESCE (MILinkObject_PaidKind.ObjectId, 0) = inPaidKindId OR inPaidKindId = 0)
         AND ( COALESCE (MILinkObject_Branch.ObjectId, 0) = inBranchId OR inBranchId = 0)
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 28.07.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProfitIncomeService (inStartDate:= '30.01.2014' ::TDateTime, inEndDate:= '01.02.2014'::TDateTime, inJuridicalBasisId:=0, inBranchId:=0 , inPaidKindId := 0, inIsErased:=false::Boolean , inSession:= zfCalc_UserAdmin()::TVarChar)
