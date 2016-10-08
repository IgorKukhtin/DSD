-- Function: gpSelect_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossService(
    IN inStartDate          TDateTime , --
    IN inEndDate            TDateTime , --
    IN inJuridicalBasisId   Integer   , -- ������� ��.����
    IN inIsErased           Boolean ,
    IN inSession            TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , BonusValue TFloat, AmountPartner TFloat, Summ TFloat
             , Comment TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , JuridicalCode_Child Integer, JuridicalName_Child TVarChar, OKPO_Child TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , ContractMasterId Integer, ContractMasterInvNumber TVarChar
             , ContractChildId Integer, ContractChildInvNumber TVarChar
             , UnitName TVarChar
             , PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BonusKindId Integer, BonusKindName TVarChar
             , isLoad Boolean
               )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- �������� ���� ������������ �� ����� ���������
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProfitLossService());
     vbUserId:= lpGetUserBySession (inSession);

     -- ���������
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
           , MIFloat_AmountPartner.ValueData                AS AmountPartner
           , MIFloat_Summ.ValueData                         AS Summ

           , MIString_Comment.ValueData                     AS Comment
           , Object_Juridical.ObjectCode                    AS JuridicalCode
           , Object_Juridical.ValueData                     AS JuridicalName
           , ObjectDesc.ItemName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , Object_Juridical_Child.ObjectCode              AS JuridicalCode_Child
           , Object_Juridical_Child.ValueData               AS JuridicalName_Child
           , ObjectHistory_JuridicalDetails_View_Child.OKPO AS OKPO_Child

           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber              AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , View_Contract_InvNumber_master.ContractId     AS ContractMasterId
           , View_Contract_InvNumber_master.InvNumber      AS ContractMasterInvNumber
           , View_Contract_InvNumber_child.ContractId      AS ContractChildId
           , View_Contract_InvNumber_child.InvNumber       AS ContractChildInvNumber
           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_ContractConditionKind.Id                AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData         AS ContractConditionKindName

           , Object_BonusKind.Id                            AS BonusKindId
           , Object_BonusKind.ValueData                     AS BonusKindName

           , COALESCE (MovementBoolean_isLoad.ValueData, FALSE) AS isLoad

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_ProfitLossService()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
            JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_Juridical.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MovementItem.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = COALESCE (ObjectLink_Partner_Juridical.ChildObjectId, MovementItem.ObjectId)

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

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

            LEFT JOIN MovementBoolean AS MovementBoolean_isLoad
                                      ON MovementBoolean_isLoad.MovementId =  Movement.Id
                                     AND MovementBoolean_isLoad.DescId = zc_MovementBoolean_isLoad()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 06.10.16         * add inJuridicalBasisId
 18.02.15         * add ContractMaster, ContractChild
 06.03.14                                        * add Object_RoleAccessKey_View
 19.02.14         * add BonusKind
 18.02.14                                                         *
*/

-- ����
-- SELECT * FROM gpSelect_Movement_ProfitLossService (inStartDate:= '30.01.2014', inEndDate:= '01.02.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin())
