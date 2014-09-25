-- Function: gpSelect_Movement_Service()

DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_Service (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Service(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , OperDatePartner TDateTime, InvNumberPartner TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , Comment TVarChar
             , JuridicalCode Integer, JuridicalName TVarChar, ItemName TVarChar, OKPO TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitName TVarChar
             , PaidKindName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName

           , MovementDate_OperDatePartner.ValueData    AS OperDatePartner
           , MovementString_InvNumberPartner.ValueData AS InvNumberPartner

           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountOut

           , MIString_Comment.ValueData       AS Comment

           , Object_Juridical.ObjectCode      AS JuridicalCode
           , Object_Juridical.ValueData       AS JuridicalName
           , ObjectDesc.ItemName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_InfoMoney_View.InfoMoneyName_all
           , View_Contract_InvNumber.InvNumber AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , Object_Unit.ValueData            AS UnitName
           , Object_PaidKind.ValueData        AS PaidKindName

       FROM tmpStatus
            JOIN Movement ON Movement.DescId = zc_Movement_Service()
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

            LEFT JOIN MovementItemString AS MIString_Comment 
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementDate AS MovementDate_OperDatePartner
                                   ON MovementDate_OperDatePartner.MovementId = Movement.Id
                                  AND MovementDate_OperDatePartner.DescId = zc_MovementDate_OperDatePartner()

            LEFT JOIN MovementString AS MovementString_InvNumberPartner
                                     ON MovementString_InvNumberPartner.MovementId =  Movement.Id
                                    AND MovementString_InvNumberPartner.DescId = zc_MovementString_InvNumberPartner()

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
      ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Service (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 17.03.14         * add zc_MovementDate_OperDatePartner, zc_MovementString_InvNumberPartner
 14.01.14         * del ContractConditionKind
 31.01.14                                        * add inIsErased
 28.01.14         * add ContractConditionKind
 14.01.14                                        * add Object_Contract_InvNumber_View
 28.12.13                                        * add Object_InfoMoney_View
 28.12.13                                        * add Object_RoleAccessKey_View
 27.12.13                         *
 11.08.13         *
*/

-- тест
--  SELECT * FROM gpSelect_Movement_Service (inStartDate:= '30.01.2013', inEndDate:= '01.02.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin())
