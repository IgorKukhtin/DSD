-- Function: gpSelect_Movement_Layout()

DROP FUNCTION IF EXISTS gpSelect_Movement_Layout (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_Layout(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , TotalCount TFloat
--             , UnitId Integer, UnitName TVarChar
--             , JuridicalName TVarChar
             , LayoutId Integer, LayoutName TVarChar
             , Comment TVarChar
             , isPharmacyItem Boolean
             , isNotMoveRemainder6 Boolean
              )

AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Layout());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

        , tmpMovement AS (SELECT Movement.*
                          FROM tmpStatus
                               JOIN Movement ON /*Movement.OperDate BETWEEN inStartDate AND inEndDate   -- выбираем все документы
                                            AND */Movement.DescId = zc_Movement_Layout()
                                            AND Movement.StatusId = tmpStatus.StatusId
                         )

       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementFloat_TotalCount.ValueData AS TotalCount
           , Object_Layout.Id                   AS LayoutId
           , Object_Layout.ValueData            AS LayoutName
           , COALESCE (MovementString_Comment.ValueData,'') :: TVarChar AS Comment
           , COALESCE(MovementBoolean_PharmacyItem.ValueData, FALSE)    AS isPharmacyItem
           , COALESCE(MovementBoolean_NotMoveRemainder6.ValueData, FALSE)    AS isNotMoveRemainder6

       FROM tmpMovement AS Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_PharmacyItem
                                      ON MovementBoolean_PharmacyItem.MovementId = Movement.Id
                                     AND MovementBoolean_PharmacyItem.DescId = zc_MovementBoolean_PharmacyItem()

            LEFT JOIN MovementBoolean AS MovementBoolean_NotMoveRemainder6
                                      ON MovementBoolean_NotMoveRemainder6.MovementId = Movement.Id
                                     AND MovementBoolean_NotMoveRemainder6.DescId = zc_MovementBoolean_NotMoveRemainder6()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Layout
                                         ON MovementLinkObject_Layout.MovementId = Movement.Id
                                        AND MovementLinkObject_Layout.DescId = zc_MovementLinkObject_Layout()
            LEFT JOIN Object AS Object_Layout ON Object_Layout.Id = MovementLinkObject_Layout.ObjectId

            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 27.08.20         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_Layout (inStartDate:= '30.01.2020', inEndDate:= '01.02.2020', inIsErased := FALSE, inSession:= '3')

