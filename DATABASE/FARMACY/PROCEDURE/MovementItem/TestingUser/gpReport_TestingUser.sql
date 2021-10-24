-- Function: gpReport_TestingUser (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_TestingUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TestingUser(
    IN inOperDate    TDateTime,     -- ‰‡Ú‡
    IN inSession     TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS TABLE (
         Id             Integer
       , Code           Integer
       , MemberName     TVarChar
       , PositionName   TVarChar
       , UnitName       TVarChar
       , Result         TFloat
       , Attempts       Integer
       , Status         TVarChar
       , DateTimeTest   TDateTime
)
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbDateStart TDateTime;
BEGIN

   vbDateStart := date_trunc('month', inOperDate);

   RETURN QUERY
   WITH tmpResult AS (SELECT
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
                        AND Movement.OperDate = vbDateStart)

   SELECT
         Object_User.Id                               AS Id
       , Object_User.ObjectCode                       AS Code
       , Object_Member.ValueData                      AS MemberName
       , Object_Position.ValueData                    AS PositionName
       , Object_Unit.ValueData                        AS UnitName
       , tmpResult.Result                             AS Result
       , tmpResult.Attempts                           AS Attempts
       , CASE WHEN COALESCE (tmpResult.Attempts, 0) = 0
         THEN NULL ELSE
         CASE WHEN tmpResult.isPassed = True
         THEN '—‰‡Ì' ELSE 'ÕÂ Ò‰‡Ì' END END::TVarChar AS Status
       , tmpResult.DateTimeTest                       AS DateTimeTest
   FROM Object AS Object_User

        INNER JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
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

        LEFT JOIN tmpResult ON tmpResult.UserID = Object_User.Id

   WHERE Object_User.DescId = zc_Object_User()
     AND Object_Position.ObjectCode in (1, 2)
     AND (COALESCE (Object_Unit.ValueData ) <> '' OR COALESCE (tmpResult.Attempts, 0) <> 0)
     AND Object_User.isErased = False
   ORDER BY Object_Member.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_TestingUser (TDateTime, TVarChar) OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ÿ‡·ÎËÈ Œ.¬.
 01.10.19         *
 25.06.19         *
 15.10.18         *
 11.09.18         *
*/

-- ÚÂÒÚ
-- select * from gpReport_TestingUser(inOperDate := ('01.10.2019')::TDateTime ,  inSession := '3');