-- Function: gpSelect_Movement_BankAccount()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalCash (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalCash (TDateTime, TDateTime, TDateTime, Boolean, Integer, Integer, TVarChar, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalCash(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inServiceDate   TDateTime , --
    IN inisServiceDate Boolean , --
    IN inUnitId        Integer , --
    IN inCashId        Integer , --
    IN inProcess       TVarChar  ,
    IN inIsErased      Boolean   ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Amount TFloat 
             , ServiceDate TDateTime
             , Comment TVarChar
             , CashId Integer, CashName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar, InfoMoneyName_all TVarChar
             , PersonalId Integer, PersonalName TVarChar
             , PositionId Integer, PositionName TVarChar
             , UnitId Integer, UnitName TVarChar
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
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode   AS StatusCode
           , Object_Status.ValueData    AS StatusName
           , MI_Child.Amount 
  
           , MIDate_ServiceDate.ValueData      AS ServiceDate
           , MIString_Comment.ValueData        AS Comment
           , Object_Cash.Id                    AS CashId
           , Object_Cash.ValueData             AS CashName
           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyCode
           , View_InfoMoney.InfoMoneyName
           , View_InfoMoney.InfoMoneyName_all
           , Object_Personal_View.PersonalId   AS PersonalId
           , Object_Personal_View.PersonalName AS PersonalName
           , Object_Position.Id                AS PositionId
           , Object_Position.ValueData         AS PositionName
           , Object_Unit.Id                    AS UnitId
           , Object_Unit.ValueData             AS UnitName
       FROM Movement
           -- INNER JOIN (SELECT AccessKeyId FROM Object_RoleAccessKey_View WHERE UserId = vbUserId GROUP BY AccessKeyId) AS tmpRoleAccessKey ON tmpRoleAccessKey.AccessKeyId = Movement.AccessKeyId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                                                                             AND MovementItem.ObjectId = inCashId
            LEFT JOIN Object AS Object_Cash ON Object_Cash.Id = MovementItem.ObjectId

            JOIN MovementItem AS MI_Child ON MI_Child.MovementId = Movement.Id AND MI_Child.DescId = zc_MI_Child() 
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                         ON MILinkObject_InfoMoney.MovementItemId = MI_Child.Id
                                        AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN Object_Personal_View ON Object_Personal_View.Personalid = MI_Child.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MI_Child.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                         ON MILinkObject_Unit.MovementItemId = MI_Child.Id
                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MI_Child.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
                                      --AND MILinkObject_InfoMoney.ObjectId = zc_Enum_InfoMoney_60101() -- Заработная плата + Заработная плата
                                      
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MI_Child.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

       WHERE Movement.DescId = zc_Movement_Cash()
         AND Movement.OperDate BETWEEN inStartDate AND inEndDate
         AND (MILinkObject_Unit.ObjectId = inUnitId OR COALESCE (inUnitId, 0) = 0)
         AND (CASE WHEN inisServiceDate = True THEN MIDate_ServiceDate.ValueData = inServiceDate else 0 = 0 END);
   
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpSelect_Movement_PersonalCash (TDateTime, TDateTime, Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.
 10.09.14         *

*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalCash (inStartDate:= '30.01.2012', inEndDate:= '01.01.2016', inCashId:= 14462, inSession:= '2')
