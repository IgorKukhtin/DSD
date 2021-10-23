-- Function: gpReport_TestingUserAttempts (TVarChar)

DROP FUNCTION IF EXISTS gpReport_TestingUserAttempts (TVarChar);

CREATE OR REPLACE FUNCTION gpReport_TestingUserAttempts(
    IN inSession     TVarChar       -- ÒÂÒÒËˇ ÔÓÎ¸ÁÓ‚‡ÚÂÎˇ
)
RETURNS TABLE (
         Id                  Integer
       , Code                Integer
       , MemberName          TVarChar
       , PositionName        TVarChar
       , UnitName            TVarChar
       , Result              TFloat
       , Attempts            Integer
       , Status              TVarChar
       , CountSubstitution   Integer
)
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN

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
                        AND Movement.OperDate = date_trunc('month', CURRENT_DATE) - INTERVAL '1 MONTH'
                        AND COALESCE (MovementItemFloat.ValueData, 0) > 0),
        tmpSubstitution AS (SELECT MIMaster.ObjectId            AS UserID
                                  , COUNT(*)                     AS CountSubstitution
                            FROM Movement

                                 INNER JOIN MovementItem AS MIMaster
                                                         ON MIMaster.MovementId = Movement.id
                                                        AND MIMaster.DescId = zc_MI_Master()

                                 LEFT JOIN MovementItem AS MIChild
                                                        ON MIChild.MovementId = Movement.id
                                                       AND MIChild.ParentId = MIMaster.ID
                                                       AND MIChild.DescId = zc_MI_Child()

                                 LEFT JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                                                  ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                                                 AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()

                            WHERE Movement.ID = (SELECT Max(Movement.ID) FROM Movement
                                                 WHERE Movement.DescId = zc_Movement_EmployeeSchedule()
                                                   AND Movement.OperDate = date_trunc('month', CURRENT_DATE))
                              AND MILinkObject_PayrollType.ObjectId IN (zc_Enum_PayrollType_WorkSCS(), zc_Enum_PayrollType_WorkSAS())
                              GROUP BY MIMaster.ObjectId)

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
       , tmpSubstitution.CountSubstitution::Integer   AS CountSubstitution
   FROM tmpResult
   
        INNER JOIN Object AS Object_User ON Object_User.Id = tmpResult.UserID

        LEFT JOIN tmpSubstitution ON tmpSubstitution.UserID = tmpResult.UserID

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                            ON ObjectLink_User_Member.ObjectId = Object_User.Id
                           AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                             ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()
        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = ObjectLink_Member_Unit.ChildObjectId
   ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpReport_TestingUser (TDateTime, TVarChar) OWNER TO postgres;

/*
 »—“Œ–»ﬂ –¿«–¿¡Œ“ »: ƒ¿“¿, ¿¬“Œ–
               ÿ‡·ÎËÈ Œ.¬.
 22.10.20         *
*/

-- ÚÂÒÚ
-- 


select * from gpReport_TestingUserAttempts(inSession := '3');