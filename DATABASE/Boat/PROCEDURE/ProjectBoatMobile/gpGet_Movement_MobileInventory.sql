-- Function: gpGet_Movement_MobileInventory()

DROP FUNCTION IF EXISTS gpGet_Movement_MobileInventory (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_MobileInventory(
    IN inMovementId        Integer ,   -- Id
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusId Integer, StatusName TVarChar
             , TotalCount TFloat
             , UnitId Integer, UnitName TVarChar
             , Comment TVarChar 
             , isList Boolean
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId := lpCheckRight (inSession, zc_Enum_Process_Select_Movement_Inventory());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 
       SELECT
             Movement.Id
           , Movement.InvNumber
           , Movement.OperDate
           , Object_Status.ObjectCode                          AS StatusId
           , Object_Status.ValueData                           AS Status
           , MovementFloat_TotalCount.ValueData                AS TotalCount
           , Object_Unit.Id                                    AS UnitId
           , Object_Unit.ValueData                             AS UnitName
           , MovementString_Comment.ValueData                  AS Comment
           , COALESCE (MovementBoolean_List.ValueData, FALSE) ::Boolean AS isList
       FROM Movement

            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment 
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_List 
                                      ON MovementBoolean_List.MovementId = Movement.Id
                                     AND MovementBoolean_List.DescId = zc_MovementBoolean_List()

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

       WHERE Movement.Id = inMovementId
     ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 23.02.24                                                       *
*/

-- тест
-- SELECT * FROM gpGet_Movement_MobileInventory (inMovementId := 2741, inSession:= zfCalc_UserAdmin())