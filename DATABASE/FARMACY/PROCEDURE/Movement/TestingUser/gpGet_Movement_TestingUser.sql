-- Function: gpGet_Movement_TestingUser (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_TestingUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_TestingUser (
    IN inOperDate    TDateTime,     -- дата
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
         Id           Integer
       , Version      Integer
       , Question     Integer
       , MaxAttempts  Integer
)
AS
$BODY$
  DECLARE vbDateStart TDateTime;
BEGIN

   vbDateStart := date_trunc('month', inOperDate);

   RETURN QUERY
   SELECT 
          Movement.Id
        , MovementFloat_Version.ValueData::Integer      AS Version
        , MovementFloat_Question.ValueData::Integer     AS Question
        , MovementFloat_MaxAttempts.ValueData::Integer  AS  MaxAttempts
   FROM Movement

        LEFT JOIN MovementFloat AS MovementFloat_Version
                                ON MovementFloat_Version.MovementId = Movement.Id
                               AND MovementFloat_Version.DescId = zc_MovementFloat_TestingUser_Version()
                                
        LEFT JOIN MovementFloat AS MovementFloat_Question
                                ON MovementFloat_Question.MovementId = Movement.Id
                               AND MovementFloat_Question.DescId = zc_MovementFloat_TestingUser_Question()

        LEFT JOIN MovementFloat AS MovementFloat_MaxAttempts
                                ON MovementFloat_MaxAttempts.MovementId = Movement.Id
                               AND MovementFloat_MaxAttempts.DescId = zc_MovementFloat_TestingUser_MaxAttempts()

   WHERE Movement.DescId = zc_Movement_TestingUser()
     AND Movement.OperDate = vbDateStart;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_TestingUser (TDateTime, TVarChar) OWNER TO postgres;


-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 25.06.19        *
 15.10.18         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_TestingUser ('20181001', '3') 