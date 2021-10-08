-- Function: gpSelect_MovementItem_TestingTuning_Master()

DROP FUNCTION IF EXISTS gpSelect_Movement_TestingTuning (TDateTime, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_TestingTuning(
    IN inStartDate     TDateTime , --
    IN inEndDate       TDateTime , --
    IN inIsErased      Boolean ,
    IN inSession       TVarChar    -- сессия пользователя
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_TestingTuning());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )
        , tmpMovement AS (SELECT Movement.Id
                          FROM tmpStatus
                               JOIN Movement ON Movement.OperDate BETWEEN inStartDate AND inEndDate
                                            AND Movement.DescId = zc_Movement_TestingTuning()
                                            AND Movement.StatusId = tmpStatus.StatusId
                         )
       SELECT
             Movement.Id                        AS Id
           , Movement.InvNumber                 AS InvNumber
           , Movement.OperDate                  AS OperDate
           , Object_Status.ObjectCode           AS StatusCode
           , Object_Status.ValueData            AS StatusName
           , MovementFloat_TotalCount.ValueData::Integer   AS TotalCount
           , MovementFloat_Question.ValueData::Integer     AS Question
           , MovementFloat_Time.ValueData::Integer         AS TimeTest
           , MovementFloat_QuestionStorekeeper.ValueData::Integer     AS QuestionStorekeeper
           , MovementFloat_TimeStorekeeper.ValueData::Integer         AS TimeTestStorekeeper
           , COALESCE (MovementString_Comment.ValueData,''):: TVarChar AS Comment

       FROM tmpMovement

            LEFT JOIN Movement ON Movement.id = tmpMovement.Id

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

            ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_Movement_TestingTuning (TDateTime, TDateTime, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.   Шаблий О.В.
 06.07.21                                                                     *  
*/

-- тест
-- select * from gpSelect_Movement_TestingTuning(inStartDate:= '30.01.2020', inEndDate:= '01.02.2020', inIsErased := FALSE, inSession:= '3');