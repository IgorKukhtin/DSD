-- Function: gpGet_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpGet_Movement_TechnicalRediscount (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TechnicalRediscount(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , TotalDiff TFloat, TotalDiffSumm TFloat
             , Comment TVarChar, isRedCheck Boolean, isAdjustment Boolean
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TechnicalRediscount());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_TechnicalRediscount_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime          AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             , 0                                AS UnitId
             , CAST ('' as TVarChar)            AS UnitName
             , 60 :: Integer                    AS DayCount
             , Null :: TFloat                   AS TotalDiff
             , Null :: TFloat                   AS TotalDiffSumm
             , CAST ('' as TVarChar)            AS Comment
             , False :: Boolean                 AS isRedCheck
             , False :: Boolean                 AS isAdjustment
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
           , MovementFloat_TotalDiff.ValueData                    AS TotalDiff
           , MovementFloat_TotalDiffSumm.ValueData                AS TotalDiffSumm
           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment
           , COALESCE (MovementBoolean_RedCheck.ValueData, False) AS isRedCheck
           , COALESCE (MovementBoolean_Adjustment.ValueData, False) AS isAdjustment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiff
                                          ON MovementFloat_TotalDiff.MovementId = Movement.Id
                                         AND MovementFloat_TotalDiff.DescId = zc_MovementFloat_TotalDiff()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                          ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                         AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_RedCheck
                                      ON MovementBoolean_RedCheck.MovementId = Movement.Id
                                     AND MovementBoolean_RedCheck.DescId = zc_MovementBoolean_RedCheck()
            LEFT JOIN MovementBoolean AS MovementBoolean_Adjustment
                                      ON MovementBoolean_Adjustment.MovementId = Movement.Id
                                     AND MovementBoolean_Adjustment.DescId = zc_MovementBoolean_Adjustment()

         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TechnicalRediscount();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TechnicalRediscount (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
 */

-- тест
--  SELECT * FROM gpGet_Movement_TechnicalRediscount (inMovementId:= 17924741 , inSession:= '3')
