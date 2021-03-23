-- Function: gpGet_Movement_FinalSUA()

DROP FUNCTION IF EXISTS gpGet_Movement_FinalSUA (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_FinalSUA(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
             , UpdateId Integer, UpdateName TVarChar, UpdateDate TDateTime
             , Calculation TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbUnitKey TVarChar;
  DECLARE vbUnitId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_FinalSUA());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN

     IF vbUserId IN (SELECT UserId FROM ObjectLink_UserRole_View WHERE RoleId IN (308121)) -- Кассир аптеки
     THEN 
       vbUnitKey := COALESCE(lpGet_DefaultValue('zc_Object_Unit', vbUserId), '');
       IF vbUnitKey = '' THEN
          vbUnitKey := '0';
       END IF;   
       vbUnitId := vbUnitKey::Integer;
     ELSE
       vbUnitId := 0;
     END IF;

     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_FinalSUA_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , CAST ('' AS TVarChar) 		                    AS Comment
             , Object_Insert.Id                                 AS InsertId
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP                   :: TDateTime AS InsertDate
             , NULL  ::Integer                                  AS UpdateId
             , NULL  ::TVarChar                                 AS UpdateName
             , Null  :: TDateTime                               AS UpdateDate
             , Null  :: TDateTime                               AS Calculation
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
               LEFT JOIN Object AS Object_Unit ON Object_Insert.Id = vbUnitId;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , COALESCE (MovementString_Comment.ValueData,'') ::TVarChar AS Comment
           , Object_Insert.Id                     AS InsertId
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.Id                     AS UpdateId
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
           , MovementDate_Calculation.ValueData   AS Calculation
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()


            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementLinkObject AS MLO_Insert
                                         ON MLO_Insert.MovementId = Movement.Id
                                        AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId  

            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
            LEFT JOIN MovementLinkObject AS MLO_Update
                                         ON MLO_Update.MovementId = Movement.Id
                                        AND MLO_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId 

            LEFT JOIN MovementDate AS MovementDate_Calculation
                                   ON MovementDate_Calculation.MovementId = Movement.Id
                                  AND MovementDate_Calculation.DescId = zc_MovementDate_Calculation()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_FinalSUA();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 11.02.21                                                       *
 */

-- тест
-- SELECT * FROM gpGet_Movement_FinalSUA (inMovementId:= 1, inOperDate := CURRENT_TIMESTAMP, inSession:= '9818')