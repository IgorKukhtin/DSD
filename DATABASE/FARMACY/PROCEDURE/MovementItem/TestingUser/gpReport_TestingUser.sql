-- Function: gpReport_TestingUser (TDateTime, TVarChar)

DROP FUNCTION IF EXISTS gpReport_TestingUser (TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TestingUser(
    IN inOperDate    TDateTime,     -- дата
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (
         Id             Integer
       , Code           Integer
       , MemberName     TVarChar
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
   WITH tmpPersonal AS (SELECT View_Personal.MemberId
                             , MAX (View_Personal.UnitId) AS UnitId
                        FROM Object_Personal_View AS View_Personal
                        WHERE View_Personal.isErased = FALSE
                          AND View_Personal.PositionId = 1672498
                          AND vbDateStart >= date_trunc('month', CURRENT_TIMESTAMP::TDateTime)
                        GROUP BY View_Personal.MemberId
                       ),
        tmpResult AS (SELECT
                             MovementItem.ObjectId                                          AS UserID
                           , MovementItem.Amount                                            AS Result
                           , MovementItemFloat.ValueData::Integer                           AS Attempts
                           , MovementItemDate.ValueData                                     AS DateTimeTest
                      FROM Movement

                           LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                   AND MovementFloat.DescId = zc_MovementFloat_TestingUser_Question()

                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()

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
       , Object_Unit.ValueData                        AS UnitName
       , tmpResult.Result                             AS Result
       , tmpResult.Attempts                           AS Attempts
       , CASE WHEN COALESCE (tmpResult.Attempts, 0) = 0
         THEN NULL ELSE
         CASE WHEN tmpResult.Result >= 85
         THEN 'Сдан' ELSE 'Не сдан' END END::TVarChar AS Status
       , tmpResult.DateTimeTest                       AS DateTimeTest
   FROM Object AS Object_User

        INNER JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = Object_User.Id
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        INNER JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN tmpResult ON tmpResult.UserID = Object_User.Id

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = tmpPersonal.UnitId
   WHERE Object_User.DescId = zc_Object_User()
     AND (tmpPersonal.MemberId IS NOT NULL OR tmpResult.UserID IS NOT NULL)
   ORDER BY Object_Member.ValueData;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_TestingUser (TDateTime, TVarChar) OWNER TO postgres;

-------------------------------------------------------------------------------
/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 25.06.19        *
 15.10.18         *
 11.09.18         *
*/

-- тест
-- SELECT * FROM gpReport_TestingUser ('20190601', '3')