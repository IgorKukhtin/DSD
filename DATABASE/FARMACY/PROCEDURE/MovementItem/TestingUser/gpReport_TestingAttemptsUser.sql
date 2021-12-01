-- Function: gpReport_TestingAttemptsUser (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_TestingAttemptsUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TestingAttemptsUser(
    IN inOperDate    TDateTime,     -- дата
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
         Id             Integer
       , Code           Integer
       , MemberName     TVarChar
       , PositionName   TVarChar
       , UnitName       TVarChar
       , Result         TFloat
       , Attempts       Integer
       , DateTimeTest   TDateTime
       , AverAttempts1  TFloat
       , Attempts1      Integer
       , Count1         Integer
       , AverAttempts2  TFloat
       , Attempts2      Integer
       , Count2         Integer
)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDateStart TDateTime;
BEGIN

   vbDateStart := date_trunc('month', inOperDate);

   RETURN QUERY
   WITH tmpTestingUser AS (SELECT
                                  MovementItem.ObjectId                                          AS UserID
                                , COALESCE(MIBoolean_Passed.ValueData, False)                    AS isPassed  
                                , MovementItem.Amount                                            AS Result
                                , MovementItemFloat.ValueData::Integer                           AS Attempts
                                , MovementItemDate.ValueData                                     AS DateTimeTest
                           FROM Movement

                                LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                        AND MovementFloat.DescId = zc_MovementFloat_TestingUser_Question()

                                LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                       AND MovementItem.DescId = zc_MI_Master()

                                LEFT JOIN MovementItemBoolean AS MIBoolean_Passed
                                                              ON MIBoolean_Passed.DescId = zc_MIBoolean_Passed()
                                                             AND MIBoolean_Passed.MovementItemId = MovementItem.Id

                                LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                                           AND MovementItemDate.DescId = zc_MIDate_TestingUser()

                                LEFT JOIN MovementItemFloat ON MovementItemFloat.MovementItemId = MovementItem.Id
                                                            AND MovementItemFloat.DescId = zc_MIFloat_TestingUser_Attempts()

                           WHERE Movement.DescId = zc_Movement_TestingUser()
                             AND Movement.OperDate = vbDateStart),
        tmpResult AS (SELECT
                             Result.UserId                                AS Id
                           , Object_User.ObjectCode                       AS Code
                           , Object_Member.ValueData                      AS MemberName
                           , Object_Position.ValueData                    AS PositionName
                           , Object_Unit.ValueData                        AS UnitName
                           , Result.Result                                AS Result
                           , Result.Attempts                              AS Attempts
                           , Result.DateTimeTest                          AS DateTimeTest
                           , Object_Position.ObjectCode                   AS PositionCode
                       FROM tmpTestingUser AS Result

                            INNER JOIN Object AS Object_User ON Object_User.Id =  Result.UserId

                            INNER JOIN ObjectLink AS ObjectLink_User_Member
                                                 ON ObjectLink_User_Member.ObjectId = Result.UserId
                                                AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                            INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                                                 ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
                            LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

                            LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                                                 ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                                                AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
                            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId


                       WHERE Object_Position.ObjectCode in (1, 2)
                         AND Result.isPassed = True
                       ORDER BY Object_Member.ValueData),
        tmpItog AS (SELECT
                           (SUM(CASE WHEN PositionCode = 1 THEN Result.Attempts END)::TFloat / 
                            SUM(CASE WHEN PositionCode = 1 THEN 1 END)::TFloat)::TFloat                    AS AverAttempts1
                         , SUM(CASE WHEN PositionCode = 1 THEN Result.Attempts END)::Integer               AS Attempts1
                         , SUM(CASE WHEN PositionCode = 1 THEN 1 END)::Integer                             AS Count1
                         , (SUM(CASE WHEN PositionCode = 2 THEN Result.Attempts END)::TFloat / 
                            SUM(CASE WHEN PositionCode = 2 THEN 1 END)::TFloat)::TFloat                    AS AverAttempts2
                         , SUM(CASE WHEN PositionCode = 2 THEN Result.Attempts END)::Integer               AS Attempts2
                         , SUM(CASE WHEN PositionCode = 2 THEN 1 END)::Integer                             AS Count2
                     FROM tmpResult AS Result )
                       
    SELECT
           Result.Id
         , Result.Code
         , Result.MemberName
         , Result.PositionName
         , Result.UnitName
         , Result.Result
         , Result.Attempts
         , Result.DateTimeTest
         , tmpItog.AverAttempts1
         , tmpItog.Attempts1
         , tmpItog.Count1
         , tmpItog.AverAttempts2
         , tmpItog.Attempts2
         , tmpItog.Count2
     FROM tmpResult AS Result    
     
          LEFT JOIN tmpItog ON 1 = 1                   
     ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_TestingUser (TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.  Шаблий О.В.
 01.12.21                                                      *
*/

-- тест
-- 

select * from gpReport_TestingAttemptsUser(inOperDate := ('30.11.2021')::TDateTime ,  inSession := '3');