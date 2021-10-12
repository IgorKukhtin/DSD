-- Function: gpGet_Movement_TestingTuning()

DROP FUNCTION IF EXISTS gpGet_Movement_TestingTuning (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TestingTuning(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , TotalCount Integer
             , Question Integer
             , TimeTest Integer
             , QuestionStorekeeper Integer
             , TimeTestStorekeeper Integer
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Get_Movement_TestingTuning());
     vbUserId := inSession;

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_TestingTuning_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime                          AS OperDate 
             , Object_Status.Code                               AS StatusCode
             , Object_Status.Name                               AS StatusName
             , 0                                                AS TotalCount
             , 0                                                AS Question
             , 0                     				            AS TimeTest
             , 0                                                AS QuestionStorekeeper
             , 0                     				            AS TimeTestStorekeeper
             , CAST ('' AS TVarChar) 		                    AS Comment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status;
     ELSE
     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , MovementFloat_TotalCount.ValueData::Integer        AS TotalCount
           , MovementFloat_Question.ValueData::Integer          AS Question
           , MovementFloat_Time.ValueData::Integer              AS TimeTest
           , MovementFloat_QuestionStorekeeper.ValueData::Integer     AS QuestionStorekeeper
           , MovementFloat_TimeStorekeeper.ValueData::Integer         AS TimeTestStorekeeper
           , COALESCE (MovementString_Comment.ValueData,'')     ::TVarChar AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_Question
                                    ON MovementFloat_Question.MovementId = Movement.Id
                                   AND MovementFloat_Question.DescId = zc_MovementFloat_TestingUser_Question()
            LEFT JOIN MovementFloat AS MovementFloat_Time
                                    ON MovementFloat_Time.MovementId = Movement.Id
                                   AND MovementFloat_Time.DescId = zc_MovementFloat_Time()

            LEFT JOIN MovementFloat AS MovementFloat_QuestionStorekeeper
                                    ON MovementFloat_QuestionStorekeeper.MovementId = Movement.Id
                                   AND MovementFloat_QuestionStorekeeper.DescId = zc_MovementFloat_QuestionStorekeeper()
            LEFT JOIN MovementFloat AS MovementFloat_TimeStorekeeper
                                    ON MovementFloat_TimeStorekeeper.MovementId = Movement.Id
                                   AND MovementFloat_TimeStorekeeper.DescId = zc_MovementFloat_TimeStorekeeper()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_TestingTuning();

       END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_Movement_TestingTuning (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 06.07.21                                                       *
 */

-- тест
-- select * from gpGet_Movement_TestingTuning(inMovementId := 1 , inSession := '3');