-- Function: gpGet_Movement_PersonalReport()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalReport (Integer, Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalReport(
    IN inMovementId        Integer   , -- ключ Документа
    IN inMovementId_Value  Integer   ,
    IN inOperDate          TDateTime , --
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , AmountIn TFloat, AmountOut TFloat
             , Comment TVarChar
             , MemberId Integer, MemberName TVarChar
             , InfoMoneyId Integer, InfoMoneyName TVarChar
             , UnitId Integer, UnitName TVarChar
             , MoneyPlaceId Integer, MoneyPlaceName TVarChar
             , CarId Integer, CarName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalReport());
     vbUserId := lpGetUserBySession (inSession);

     IF COALESCE (inMovementId_Value, 0) = 0
     THEN

     RETURN QUERY
       SELECT
             0 AS Id
           , CAST (NEXTVAL ('Movement_PersonalReport_seq') AS TVarChar) AS InvNumber
--           , CAST (CURRENT_DATE AS TDateTime) AS OperDate
           , inOperDate AS OperDate
           , lfObject_Status.Code             AS StatusCode
           , lfObject_Status.Name             AS StatusName

           , 0::TFloat                        AS AmountIn
           , 0::TFloat                        AS AmountOut

           , ''::TVarChar                     AS Comment
           , 0                                AS MemberId
           , CAST ('' as TVarChar)            AS MemberName
           , 0                                AS InfoMoneyId
           , CAST ('' as TVarChar)            AS InfoMoneyName
           , 0                                AS UnitId
           , CAST ('' as TVarChar)            AS UnitName
           , 0                                AS MoneyPlaceId
           , CAST ('' as TVarChar)            AS MoneyPlaceName
           , 0                                AS CarId
           , CAST ('' as TVarChar)            AS CarName

       FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status;

     ELSE

     RETURN QUERY
       SELECT
             inMovementId as Id
           , CASE WHEN inMovementId = 0 THEN CAST (NEXTVAL ('movement_personalreport_seq') AS TVarChar) ELSE Movement.InvNumber END AS InvNumber
           , CASE WHEN inMovementId = 0 THEN inOperDate ELSE Movement.OperDate END AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName

           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN MovementItem.Amount > 0
                       THEN MovementItem.Amount
                  ELSE 0
             END :: TFloat                      AS AmountIn
           , CASE WHEN inMovementId = 0
                       THEN 0
                  WHEN MovementItem.Amount < 0
                       THEN -1 * MovementItem.Amount
                  ELSE 0
             END :: TFloat                      AS AmountOut

           , MIString_Comment.ValueData         AS Comment

           , Object_Member.ObjectCode           AS MemberCode
           , Object_Member.ValueData            AS MemberName
           , View_InfoMoney.InfoMoneyId
           , View_InfoMoney.InfoMoneyName_all   AS InfoMoneyName
           , Object_Unit.Id                     AS UnitId
           , Object_Unit.ValueData              AS UnitName
           , Object_MoneyPlace.Id               AS MoneyPlaceId
           , Object_MoneyPlace.ValueData        AS MoneyPlaceName

       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = CASE WHEN inMovementId = 0 THEN zc_Enum_Status_UnComplete() ELSE Movement.StatusId END

            LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()

            LEFT JOIN Object AS Object_Member ON Object_Member.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object_InfoMoney_View AS View_InfoMoney ON View_InfoMoney.InfoMoneyId = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                             ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_MoneyPlace
                                             ON MILinkObject_MoneyPlace.MovementItemId = MovementItem.Id
                                            AND MILinkObject_MoneyPlace.DescId = zc_MILinkObject_MoneyPlace()
            LEFT JOIN Object AS Object_MoneyPlace ON Object_MoneyPlace.Id = MILinkObject_MoneyPlace.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Car
                                             ON MILinkObject_Car.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Car.DescId = zc_MILinkObject_Car()
            LEFT JOIN Object AS Object_Car ON Object_Car.Id = MILinkObject_Car.ObjectId

       WHERE Movement.Id =  inMovementId_Value;

   END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_PersonalReport (Integer, Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 15.09.14                                                        *

*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalReport (inMovementId:= 1, inOperDate:= CURRENT_DATE, inMovementId_Value:=0,  inSession:= zfCalc_UserAdmin());
