-- Function: gpSelect_Movement_Service_Print()

DROP FUNCTION IF EXISTS gpSelect_Movement_Service_Print (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Service_Print(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (OperDate TDateTime
             , ServiceDate TDateTime
             , Amount TFloat
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , InfoMoneyId Integer, InfoMoneyCode Integer, InfoMoneyName TVarChar
             , CommentInfoMoneyId Integer, CommentInfoMoneyCode Integer, CommentInfoMoneyName TVarChar       
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Service());
     vbUserId:= lpGetUserBySession (inSession);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                       --UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                       --UNION SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
         , tmpMovement AS (SELECT Movement.*
                           FROM tmpStatus
                               JOIN Movement ON Movement.DescId = zc_Movement_Service()
                                            AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.StatusId = tmpStatus.StatusId
                           )

         , tmpMI AS (SELECT MovementItem.*
                     FROM MovementItem
                     WHERE MovementItem.MovementId IN (SELECT DISTINCT tmpMovement.Id FROM tmpMovement)
                       AND MovementItem.DescId = zc_MI_Master()
                     )

       SELECT Movement.OperDate
            , MIDate_ServiceDate.ValueData       AS ServiceDate
            , MovementItem.Amount  ::TFloat      AS Amount
            , Object_Unit.Id                     AS UnitId
            , Object_Unit.ObjectCode             AS UnitCode
            , Object_Unit.ValueData              AS UnitName
            , Object_InfoMoney.Id                AS InfoMoneyId
            , Object_InfoMoney.ObjectCode        AS InfoMoneyCode
            , Object_InfoMoney.ValueData         AS InfoMoneyName
            , Object_CommentInfoMoney.Id         AS CommentInfoMoneyId
            , Object_CommentInfoMoney.ObjectCode AS CommentInfoMoneyCode
            , Object_CommentInfoMoney.ValueData  AS CommentInfoMoneyName

       FROM tmpMovement AS Movement
            --
            LEFT JOIN tmpMI AS MovementItem ON MovementItem.MovementId = Movement.Id AND MovementItem.DescId = zc_MI_Master()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementItem.ObjectId
            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_InfoMoney
                                             ON MILinkObject_InfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_InfoMoney.DescId = zc_MILinkObject_InfoMoney()
            LEFT JOIN Object AS Object_InfoMoney ON Object_InfoMoney.Id = MILinkObject_InfoMoney.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_CommentInfoMoney
                                             ON MILinkObject_CommentInfoMoney.MovementItemId = MovementItem.Id
                                            AND MILinkObject_CommentInfoMoney.DescId         = zc_MILinkObject_CommentInfoMoney()
            LEFT JOIN Object AS Object_CommentInfoMoney ON Object_CommentInfoMoney.Id = MILinkObject_CommentInfoMoney.ObjectId

            LEFT JOIN MovementItemDate AS MIDate_ServiceDate
                                       ON MIDate_ServiceDate.MovementItemId = MovementItem.Id
                                      AND MIDate_ServiceDate.DescId = zc_MIDate_ServiceDate()
       ;


END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 19.04.22         *
 */

-- тест
-- SELECT * FROM gpSelect_Movement_Service_Print (inStartDate:= '30.01.2015', inEndDate:= '01.01.2015', inSession:= zfCalc_UserAdmin())
