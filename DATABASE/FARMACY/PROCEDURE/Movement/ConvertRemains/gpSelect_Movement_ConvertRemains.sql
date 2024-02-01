-- Function: gpSelect_Movement_ConvertRemains()

DROP FUNCTION IF EXISTS gpSelect_Movement_ConvertRemains (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ConvertRemains(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , TotalCount TFloat, TotalSumm TFloat
             , Comment TVarChar
              )

AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ConvertRemains());
     vbUserId:= lpGetUserBySession (inSession);

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
 
       SELECT Movement.Id                           AS Id
            , Movement.InvNumber                    AS InvNumber
            , Movement.OperDate                     AS OperDate
            , Object_Status.ObjectCode              AS StatusCode
            , Object_Status.ValueData               AS StatusName
            , Object_Unit.Id                        AS UnitId
            , Object_Unit.ObjectCode                AS UnitCode
            , Object_Unit.ValueData                 AS UnitName
            , MovementFloat_TotalCount.ValueData    AS TotalCount
            , MovementFloat_TotalSumm.ValueData     AS TotalSumm
            , MovementString_Comment.ValueData      AS Comment

       FROM tmpStatus
            LEFT JOIN Movement ON Movement.DescId = zc_Movement_ConvertRemains()
                              AND Movement.StatusId = tmpStatus.StatusId
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_TotalSumm
                                    ON MovementFloat_TotalSumm.MovementId =  Movement.Id
                                   AND MovementFloat_TotalSumm.DescId = zc_MovementFloat_TotalSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.OperDate  <=inEndDate
         AND Movement.OperDate  >= inStartDate 
            
            ;
END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 25.10.2023                                                     *
*/

-- тест
-- 
select * from gpSelect_Movement_ConvertRemains(instartdate := ('23.06.2022')::TDateTime , inenddate := ('23.06.2022')::TDateTime , inIsErased := 'False' ,  inSession := '3');