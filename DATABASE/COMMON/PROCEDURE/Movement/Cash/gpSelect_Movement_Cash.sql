-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Cash(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inCashId      Integer , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat 
             , AmountOut TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashName TVarChar
             , MoneyPlaceCode Integer, MoneyPlaceName TVarChar, OKPO TVarChar, ItemName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , MemberName TVarChar, PositionName TVarChar
             , ContractCode Integer, ContractInvNumber TVarChar, ContractTagName TVarChar
             , UnitName TVarChar
)
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Cash());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY 
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId, inStartDate AS StartDate, inEndDate AS EndDate WHERE inIsErased = TRUE
                         )
          , tmpRoleAccessKey_all AS (SELECT AccessKeyId, UserId FROM Object_RoleAccessKey_View)
          , tmpRoleAccessKey_user AS (SELECT AccessKeyId FROM tmpRoleAccessKey_all WHERE UserId = vbUserId GROUP BY AccessKeyId)
          , tmpAccessKey_isCashAll AS (SELECT 1 AS Id FROM ObjectLink_UserRole_View WHERE RoleId = zc_Enum_Role_Admin() AND UserId = vbUserId
                                 UNION SELECT 1 AS Id FROM tmpRoleAccessKey_user WHERE AccessKeyId = zc_Enum_Process_AccessKey_CashAll()
                                      )
          , tmpRoleAccessKey AS (SELECT tmpRoleAccessKey_user.AccessKeyId FROM tmpRoleAccessKey_user WHERE NOT EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll)
                           UNION SELECT AccessKeyId FROM Object_RoleAccessKeyDocument_View WHERE ProcessId = zc_Enum_Process_InsertUpdate_Movement_Cash() AND EXISTS (SELECT tmpAccessKey_isCashAll.Id FROM tmpAccessKey_isCashAll) GROUP BY AccessKeyId
                                )
          , tmpAll AS (SELECT tmpStatus.StatusId, tmpStatus.StartDate, tmpStatus.EndDate, tmpRoleAccessKey.AccessKeyId FROM tmpStatus, tmpRoleAccessKey)
          , Movement AS (SELECT Movement.*
                              , Object_Status.ObjectCode AS StatusCode
                              , Object_Status.ValueData  AS StatusName
                         FROM tmpAll
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_Cash()
                                                 AND Movement.OperDate BETWEEN tmpAll.StartDate AND tmpAll.EndDate -- inStartDate AND inEndDate
                                                 AND Movement.StatusId = tmpAll.StatusId
                                                 AND Movement.AccessKeyId = tmpAll.AccessKeyId
                              LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpAll.StatusId
                        )
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Movement.StatusCode
           , Movement.StatusName
           , CASE WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountIn
           , CASE WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END::TFloat AS AmountOut
           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.ValueData             AS CashName
           , Object_MoneyPlace.ObjectCode      AS MoneyPlaceCode
           , Object_MoneyPlace.ValueData       AS MoneyPlaceName
           , ObjectHistory_JuridicalDetails_View.OKPO
           , ObjectDesc.ItemName
           , View_InfoMoney.InfoMoneyGroupName
           , View_InfoMoney.InfoMoneyDestinationName
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           , Object_Member.ValueData            AS MemberName
           , Object_Position.ValueData          AS PositionName
           , View_Contract_InvNumber.ContractCode
           , View_Contract_InvNumber.InvNumber  AS ContractInvNumber
           , View_Contract_InvNumber.ContractTagName
           , Object_Unit.ValueData              AS UnitName
       FROM Movement
            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                   AND MovementItem.DescId = zc_MI_Master()
                                   AND MovementItem.ObjectId = inCashId
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                         ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                        AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId
            LEFT JOIN ObjectDesc ON ObjectDesc.Id = Object_MoneyPlace.DescId

            LEFT JOIN ObjectLink AS ObjectLink_Partner_Juridical
                                 ON ObjectLink_Partner_Juridical.ObjectId = MILinkObject_MoneyPlace.ObjectId
                                AND ObjectLink_Partner_Juridical.DescId = zc_ObjectLink_Partner_Juridical()
            LEFT JOIN ObjectHistory_JuridicalDetails_View ON ObjectHistory_JuridicalDetails_View.JuridicalId = ObjectLink_Partner_Juridical.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Member
                                             ON MILinkObject_Member.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Member.DescId = zc_MILinkObject_Member()
            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MILinkObject_Member.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Contract
                                         ON MILinkObject_Contract.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Contract.DescId = zc_MILinkObject_Contract()
            LEFT JOIN Object_Contract_InvNumber_View AS View_Contract_InvNumber ON View_Contract_InvNumber.ContractId = MILinkObject_Contract.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                      AND MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                                      AND MILinkObject_MoneyPlace.ObjectId > 0
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_Cash (TDateTime, TDateTime, Integer, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 30.08.14                                        * all
 14.01.14                                        * add Object_Contract_InvNumber_View
 26.12.13                                        * add View_InfoMoney
 26.12.13                                        * add Object_RoleAccessKey_View
 23.12.13                          *
 09.08.13         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '01.06.2014', inEndDate:= '30.06.2014', inCashId:= 273734, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_Movement_Cash (inStartDate:= '30.01.2013', inEndDate:= '01.01.2014', inCashId:= 1, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
