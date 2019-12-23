-- Function: gpInsertUpdate_Movement_IlliquidUnit_Formation()

-- Function: gpSelect_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS gpSelect_Movement_IlliquidUnit (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_IlliquidUnit(
    IN inStartDate   TDateTime , --С даты
    IN inEndDate     TDateTime , --По дату
    IN inIsErased    Boolean ,   --Так же удаленные
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , TotalCount TFloat, DayCount Integer, ProcGoods TFloat, ProcUnit TFloat, Penalty TFloat
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_IlliquidUnit());
     vbUserId:= lpGetUserBySession (inSession);
     

     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       -- Результат
       SELECT
             Movement.Id                                          AS Id
           , Movement.InvNumber                                   AS InvNumber
           , Movement.OperDate                                    AS OperDate
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName
           
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName

           , MovementFloat_TotalCount.ValueData                   AS TotalCount
           , MovementFloat_DayCount.ValueData::Integer            AS DayCount
           , MovementFloat_ProcGoods.ValueData                    AS ProcGoods
           , MovementFloat_ProcUnit.ValueData                     AS ProcUnit
           , MovementFloat_Penalty.ValueData                      AS Penalty

           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

       FROM (SELECT Movement.Id
                  , MovementLinkObject_Unit.ObjectId AS UnitId
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN date_trunc('month', inStartDate) AND date_trunc('month', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                               AND Movement.DescId = zc_Movement_IlliquidUnit() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            ) AS tmpMovement
            
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
            
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalCount
                                          ON MovementFloat_TotalCount.MovementId = Movement.Id
                                         AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_DayCount
                                          ON MovementFloat_DayCount.MovementId = Movement.Id
                                         AND MovementFloat_DayCount.DescId = zc_MovementFloat_DayCount()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProcGoods
                                          ON MovementFloat_ProcGoods.MovementId = Movement.Id
                                         AND MovementFloat_ProcGoods.DescId = zc_MovementFloat_ProcGoods()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_ProcUnit
                                          ON MovementFloat_ProcUnit.MovementId = Movement.Id
                                         AND MovementFloat_ProcUnit.DescId = zc_MovementFloat_ProcUnit()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_Penalty
                                          ON MovementFloat_Penalty.MovementId = Movement.Id
                                         AND MovementFloat_Penalty.DescId = zc_MovementFloat_Penalty()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_IlliquidUnit (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 22.12.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_IlliquidUnit (inStartDate:= '23.12.2019', inEndDate:= '23.12.2019', inIsErased:= FALSE, inSession:= '3')
