-- Function: gpSelect_Movement_ProfitLossService()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProfitLossService(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- ������ ������������
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , Comment TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , ContractInvNumber TVarChar
             , UnitName TVarChar
             , PaidKindName TVarChar
             , ContractConditionKindId Integer, ContractConditionKindName TVarChar
             , BranchId Integer, BranchName TVarChar
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
           , MIString_Comment.ValueData                     AS Comment
           , Object_Juridical.ObjectCode                    AS JuridicalCode
           , Object_Juridical.ValueData                     AS JuridicalName
           , Object_InfoMoney_View.InfoMoneyGroupName       AS InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName AS InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode            AS InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName            AS InfoMoneyName
           , View_Contract_InvNumber.InvNumber              AS ContractInvNumber
           , Object_Unit.ValueData                          AS UnitName
           , Object_PaidKind.ValueData                      AS PaidKindName
           , Object_ContractConditionKind.Id                AS ContractConditionKindId
           , Object_ContractConditionKind.ValueData         AS ContractConditionKindName
           , Object_Branch.Id                               AS BranchId
           , Object_Branch.ValueData                        AS BranchName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_ProfitLossService()
                         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                         AND Movement.StatusId = tmpStatus.StatusId
--            JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Juridical ON Object_Juridical.Id = MovementItem.ObjectId

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

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Branch
                                             ON MILinkObject_Branch.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Branch.DescId = zc_MILinkObject_Branch()

            LEFT JOIN Object AS Object_Branch ON Object_Branch.Id = MILinkObject_Branch.ObjectId

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProfitLossService (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.   ������ �.�.
 18.02.14                                                         *

*/

-- ����
-- SELECT * FROM gpSelect_Movement_ProfitLossService (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013', inSession:= zfCalc_UserAdmin())
