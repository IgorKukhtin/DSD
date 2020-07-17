-- Function: gpGet_Movement_SendPartionDate()

DROP FUNCTION IF EXISTS gpGet_Movement_SendPartionDate (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_SendPartionDate(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , ChangePercent TFloat, ChangePercentLess TFloat, ChangePercentMin TFloat
             , Comment TVarChar
             , Transfer Boolean
             , InsertId Integer, InsertName TVarChar, InsertDate TDateTime
             , UpdateId Integer, UpdateName TVarChar, UpdateDate TDateTime
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_SendPartionDate());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_SendPartionDate_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                     			                AS UnitId
             , CAST ('' AS TVarChar) 			                AS UnitName
             , CAST (20  AS TFloat)                             AS ChangePercent
             , CAST (50  AS TFloat)                             AS ChangePercentLess
             , CAST (100  AS TFloat)                            AS ChangePercentMin
             , CAST ('' AS TVarChar) 		                    AS Comment
             , False                		                    AS Transfer
             , Object_Insert.Id                                 AS InsertId
             , Object_Insert.ValueData                          AS InsertName
             , CURRENT_TIMESTAMP                   :: TDateTime AS InsertDate
             , NULL  ::Integer                                  AS UpdateId
             , NULL  ::TVarChar                                 AS UpdateName
             , Null  :: TDateTime                               AS UpdateDate
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                          AS Id
           , Movement.InvNumber                   AS InvNumber
           , Movement.OperDate                    AS OperDate
           , Object_Status.ObjectCode             AS StatusCode
           , Object_Status.ValueData              AS StatusName
           , Object_Unit.Id                       AS UnitId
           , Object_Unit.ValueData                AS UnitName
           , MovementFloat_ChangePercent.ValueData     AS ChangePercent
           , MovementFloat_ChangePercentLess.ValueData AS ChangePercentLess
           , MovementFloat_ChangePercentMin.ValueData  AS ChangePercentMin
           , COALESCE (MovementString_Comment.ValueData,'') ::TVarChar AS Comment
           , COALESCE (MovementBoolean_Transfer.ValueData, False)           AS Transfer
           , Object_Insert.Id                     AS InsertId
           , Object_Insert.ValueData              AS InsertName
           , MovementDate_Insert.ValueData        AS InsertDate
           , Object_Update.Id                     AS UpdateId
           , Object_Update.ValueData              AS UpdateName
           , MovementDate_Update.ValueData        AS UpdateDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId =  Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercent
                                    ON MovementFloat_ChangePercent.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercent.DescId = zc_MovementFloat_ChangePercent()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercentLess
                                    ON MovementFloat_ChangePercentLess.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercentLess.DescId = zc_MovementFloat_ChangePercentLess()

            LEFT JOIN MovementFloat AS MovementFloat_ChangePercentMin
                                    ON MovementFloat_ChangePercentMin.MovementId =  Movement.Id
                                   AND MovementFloat_ChangePercentMin.DescId = zc_MovementFloat_ChangePercentMin()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_Transfer
                                      ON MovementBoolean_Transfer.MovementId = Movement.Id
                                      AND MovementBoolean_Transfer.DescId = zc_MovementBoolean_Transfer()

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

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_SendPartionDate();

     END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.20                                                       *
 26.06.19                                                       *
 27.05.19         *
 02.04.19         *
 */

-- тест
-- SELECT * FROM gpGet_Movement_SendPartionDate (inMovementId:= 1, inOperDate := CURRENT_TIMESTAMP, inSession:= '9818')