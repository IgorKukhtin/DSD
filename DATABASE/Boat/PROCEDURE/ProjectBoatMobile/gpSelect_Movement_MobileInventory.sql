-- Function: gpSelect_Movement_MobileInventory()

DROP FUNCTION IF EXISTS gpSelect_Movement_MobileInventory (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_MobileInventory(
    IN inStartDate         TDateTime , -- Дата нач. периода
    IN inEndDate           TDateTime , -- Дата оконч. периода
    IN inIsErased          Boolean   , -- показывать удаленные Да/Нет
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TVarChar
             , StatusId Integer, StatusName TVarChar
             , TotalCount TVarChar
             , UnitName TVarChar
             , Comment TVarChar 
             , isList Boolean
             , EditButton Integer
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
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       SELECT
             Movement.Id
           , Movement.InvNumber
           , ('Дата: '||zfConvert_DateShortToString(Movement.OperDate))::TVarChar AS OperDate
           , Object_Status.ObjectCode                          AS StatusId
           , Object_Status.ValueData                           AS Status
           , ('Ост. факт: '||COALESCE(zfConvert_FloatToString(MovementFloat_TotalCount.ValueData), ''))::TVarChar  AS TotalCount
           , Object_Unit.ValueData                             AS UnitName
           , MovementString_Comment.ValueData                  AS Comment
           , COALESCE (MovementBoolean_List.ValueData, FALSE) ::Boolean AS isList
           , 4                                                 AS EditButton
       FROM tmpStatus
            JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate 
                         AND Movement.DescId = zc_Movement_Inventory()
                         AND Movement.StatusId = tmpStatus.StatusId

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
-- SELECT * FROM gpSelect_Movement_MobileInventory (inStartDate:= '01.01.2021', inEndDate:= '21.02.2024', inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())