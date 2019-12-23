-- Function: gpGet_Movement_IlliquidUnit()

DROP FUNCTION IF EXISTS gpGet_Movement_IlliquidUnit (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_IlliquidUnit(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , DayCount Integer, ProcGoods TFloat, ProcUnit TFloat, Penalty TFloat
             , Comment TVarChar
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_IlliquidUnit());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_IlliquidUnit_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime          AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             , 0                                AS UnitId
             , CAST ('' as TVarChar)            AS UnitName
             , 60 :: Integer                    AS DayCount
             , 20 :: TFloat                     AS ProcGoods
             , 10 :: TFloat                     AS ProcUnit
             , 500 :: TFloat                    AS Penalty
             , CAST ('' as TVarChar)            AS Comment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
       RETURN QUERY
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                             AS StatusCode
           , Object_Status.ValueData                              AS StatusName
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ValueData                                AS UnitName
           , MovementFloat_DayCount.ValueData::Integer            AS DayCount
           , MovementFloat_ProcGoods.ValueData                    AS ProcGoods
           , MovementFloat_ProcUnit.ValueData                     AS ProcUnit
           , MovementFloat_Penalty.ValueData                      AS Penalty
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

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
         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_IlliquidUnit();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_IlliquidUnit (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 20.12.19                                                       *
 */

-- тест
-- 
SELECT * FROM gpGet_Movement_IlliquidUnit (inMovementId:= 1, inSession:= '3')
