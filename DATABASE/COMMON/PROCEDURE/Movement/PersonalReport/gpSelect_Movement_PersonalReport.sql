-- Function: gpSelect_Movement_PersonalReport()

DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalReport (TDateTime, TDateTime, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_PersonalReport (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_PersonalReport(
    IN inStartDate   TDateTime , --
    IN inEndDate     TDateTime , --
    IN inIsErased    Boolean ,
    IN inSession     TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , Comment TVarChar
             , MemberCode Integer, MemberName TVarChar
             , InfoMoneyGroupName TVarChar
             , InfoMoneyDestinationName TVarChar
             , InfoMoneyCode Integer, InfoMoneyName TVarChar
             , UnitName TVarChar
             , MoneyPlaceName TVarChar
             , CarName TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_PersonalReport());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (/*SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION*/
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       SELECT
             tmpMovement.MovementId AS Id
           , tmpMovement.InvNumber
           , tmpMovement.OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName

           , CASE WHEN tmpMovement.Amount > 0
                       THEN tmpMovement.Amount
                  ELSE 0
             END::TFloat                        AS AmountIn
           , CASE WHEN tmpMovement.Amount < 0
                       THEN -1 * tmpMovement.Amount
                  ELSE 0
             END::TFloat                        AS AmountOut

           , MIString_Comment.ValueData         AS Comment

           , Object_Member.ObjectCode           AS MemberCode
           , Object_Member.ValueData            AS MemberName
           , Object_InfoMoney_View.InfoMoneyGroupName
           , Object_InfoMoney_View.InfoMoneyDestinationName
           , Object_InfoMoney_View.InfoMoneyCode
           , Object_InfoMoney_View.InfoMoneyName
           , Object_Unit.ValueData              AS UnitName
           , Object_MoneyPlace.ValueData        AS MoneyPlaceName
           , Object_Car.ValueData               AS CarName

       FROM (SELECT CLO_Member.ContainerId     AS ContainerId
                  , CLO_Member.ObjectId        AS MemberId
                  , MIContainer.MovementDescId AS MovementDescId
                  , Movement.InvNumber
                  , Movement.StatusId
                  , MIContainer.MovementId
                  , MIContainer.OperDate
                  , MIContainer.MovementItemId
                  , MIContainer.Amount
                  , CLO_InfoMoney.ObjectId AS InfoMoneyId
                  , 0 AS UnitId
                  , 0 AS MoneyPlaceId
                  , CLO_Car.ObjectId       AS CarId

             FROM ContainerLinkObject AS CLO_Member
                  INNER JOIN MovementItemContainer AS MIContainer
                                                   ON MIContainer.ContainerId = CLO_Member.ContainerId
                                                  AND MIContainer.ContainerId = zc_MIContainer_Summ()
                                                  AND MIContainer.OperDate BETWEEN inStartDate AND inEndDate
                  LEFT JOIN Movement ON Movement.Id = MIContainer.MovementId
                  LEFT JOIN ContainerLinkObject AS CLO_InfoMoney
                                                ON CLO_InfoMoney.ContainerId = CLO_Member.ContainerId
                                               AND CLO_InfoMoney.DescId = zc_ContainerLinkObject_InfoMoney()
                  LEFT JOIN ContainerLinkObject AS CLO_Car
                                                ON CLO_Car.ContainerId = CLO_Member.ContainerId
                                               AND CLO_Car.DescId = zc_ContainerLinkObject_Car()

            UNION
             SELECT 0 AS ContainerId
                  , MovementItem.ObjectId AS MemberId
                  , Movement.DescId AS MovementDescId
                  , Movement.InvNumber
                  , Movement.StatusId
                  , Movement.Id AS MovementId
                  , Movement.OperDate
                  , MovementItem.Id AS MovementItemId
                  , MovementItem.Amount
                  , MILinkObject_InfoMoney.ObjectId  AS InfoMoneyId
                  , MILinkObject_Unit.ObjectId       AS UnitId
                  , MILinkObject_MoneyPlace.ObjectId AS MoneyPlaceId
                  , MILinkObject_Car.ObjectId        AS CarId
             FROM tmpStatus
                  INNER JOIN Movement ON Movement.DescId = zc_Movement_PersonalReport()
                                     AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                     AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                                   ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                   ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                                   ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
                  LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                                   ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                                  AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            ) AS tmpMovement


            LEFT JOIN Object AS Object_Status ON Object_Status.Id = tmpMovement.StatusId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpMovement.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = tmpMovement.MemberId
            LEFT JOIN Object_InfoMoney_View ON Object_InfoMoney_View.InfoMoneyId = tmpMovement.InfoMoneyId
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = tmpMovement.MoneyPlaceId
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = tmpMovement.CarId

      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_PersonalReport (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.04.15                                        * all
 15.09.14                                                        *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_PersonalReport (inStartDate:= '30.01.2013', inEndDate:= '01.02.2014', inIsErased:=false , inSession:= zfCalc_UserAdmin())
