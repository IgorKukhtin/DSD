-- Function: gpSelect_Movement_TechnicalRediscount()

DROP FUNCTION IF EXISTS gpSelect_Movement_TechnicalRediscount (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TechnicalRediscount(
    IN inStartDate   TDateTime , --С даты
    IN inEndDate     TDateTime , --По дату
    IN inIsErased    Boolean ,   --Так же удаленные
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , TotalDiff TFloat, TotalDiffSumm TFloat
             , Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitIdStr    TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TechnicalRediscount());
     vbUserId:= lpGetUserBySession (inSession);
     vbUnitIdStr := COALESCE (lpGet_DefaultValue ('zc_Object_Unit', vbUserId), '0');
     IF vbUnitIdStr <> '' THEN 
        vbUnitId := vbUnitIdStr;
     ELSE
     	vbUnitId := 0;
     END IF;	   

    -- Для роли "Кассир" отключаем проверки
     IF NOT EXISTS(SELECT * FROM gpSelect_Object_RoleUser (inSession) AS Object_RoleUser
                   WHERE Object_RoleUser.ID = vbUserId AND Object_RoleUser.RoleId = zc_Enum_Role_CashierPharmacy())
     THEN
       vbUnitId := 0;
     END IF;
     
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

           , MovementFloat_TotalDiff.ValueData                    AS TotalDiff
           , MovementFloat_TotalDiffSumm.ValueData                AS TotalDiffSumm

           , COALESCE (MovementString_Comment.ValueData,'')     :: TVarChar AS Comment

       FROM (SELECT Movement.Id
                  , MovementLinkObject_Unit.ObjectId AS UnitId
             FROM tmpStatus
                  JOIN Movement ON Movement.OperDate BETWEEN date_trunc('month', inStartDate) AND date_trunc('month', inEndDate) + INTERVAL '1 MONTH' - INTERVAL '1 DAY'
                               AND Movement.DescId = zc_Movement_TechnicalRediscount() AND Movement.StatusId = tmpStatus.StatusId
                  LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                               ON MovementLinkObject_Unit.MovementId = Movement.Id
                                              AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
             WHERE (MovementLinkObject_Unit.ObjectId  = vbUnitId OR vbUnitId = 0)
            ) AS tmpMovement
            
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpMovement.UnitId
            
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiff
                                          ON MovementFloat_TotalDiff.MovementId = Movement.Id
                                         AND MovementFloat_TotalDiff.DescId = zc_MovementFloat_TotalDiff()
            LEFT OUTER JOIN MovementFloat AS MovementFloat_TotalDiffSumm
                                          ON MovementFloat_TotalDiffSumm.MovementId = Movement.Id
                                         AND MovementFloat_TotalDiffSumm.DescId = zc_MovementFloat_TotalDiffSumm()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_TechnicalRediscount (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_TechnicalRediscount (inStartDate:= '23.12.2019', inEndDate:= '23.02.2020', inIsErased:= FALSE, inSession:= '11316104')
