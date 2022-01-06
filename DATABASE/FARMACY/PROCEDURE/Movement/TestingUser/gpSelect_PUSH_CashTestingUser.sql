-- Function: gpSelect_PUSH_CashTestingUser (TVarChar)

DROP FUNCTION IF EXISTS gpSelect_PUSH_CashTestingUser (Integer, Integer, Integer);

CREATE OR REPLACE FUNCTION gpSelect_PUSH_CashTestingUser(
    IN inMovementID    Integer    , -- Movement PUSH
    IN inUnitID        Integer    , -- Подразделение
    IN inUserId        Integer      -- Cотрудник
)
RETURNS TABLE (Message TBlob
             , FormName TVarChar
             , Button TVarChar
             , Params TVarChar
             , TypeParams TVarChar
             , ValueParams TVarChar
             )
AS
$BODY$
  DECLARE vbDateStart TDateTime;
BEGIN

   vbDateStart := date_trunc('month', CURRENT_DATE);
   
   IF date_part('DAY',  CURRENT_DATE) <= date_part('DAY',  vbDateStart + INTERVAL '1 MONTH' - INTERVAL '7 DAY')
   THEN
     RETURN;
   END IF;
   
   RETURN QUERY
   WITH tmpResult AS (SELECT
                             MovementItem.ObjectId                                          AS UserID
                           , COALESCE(MIBoolean_Passed.ValueData, False)                    AS isPassed
                      FROM Movement

                           LEFT JOIN MovementFloat ON MovementFloat.MovementId = Movement.Id
                                                   AND MovementFloat.DescId = zc_MovementFloat_TestingUser_Question()

                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           LEFT JOIN MovementItemDate ON MovementItemDate.MovementItemId = MovementItem.Id
                                                      AND MovementItemDate.DescId = zc_MIDate_TestingUser()

                           LEFT JOIN MovementItemBoolean AS MIBoolean_Passed
                                                         ON MIBoolean_Passed.DescId = zc_MIBoolean_Passed()
                                                        AND MIBoolean_Passed.MovementItemId = MovementItem.Id

                      WHERE Movement.DescId = zc_Movement_TestingUser()
                        AND Movement.OperDate = vbDateStart),
        tmpWages AS (SELECT DISTINCT MovementItem.ObjectId                   AS UserID
                      FROM Movement

                           INNER JOIN MovementItem ON MovementItem.MovementId = Movement.Id
                                                  AND MovementItem.DescId = zc_MI_Master()

                           INNER JOIN MovementItemBoolean ON MovementItemBoolean.MovementItemId = MovementItem.Id
                                                         AND MovementItemBoolean.DescId = zc_MIBoolean_isTestingUser()
                                                         AND MovementItemBoolean.ValueData = True


                      WHERE Movement.DescId = zc_Movement_Wages()
                        AND Movement.OperDate = vbDateStart),
        tmpUser AS (SELECT Object_User.Id                               AS UserId
                         , Object_User.ObjectCode                       AS UserCode
                         , Object_User.ValueData                        AS UserName
                         , Max(ObjectDate_DateIn.ValueData)::TDateTime  AS DateIn
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

                          LEFT JOIN ObjectLink AS ObjectLink_Personal_Member
                                               ON ObjectLink_Personal_Member.ChildObjectId = Object_Member.Id
                                              AND ObjectLink_Personal_Member.DescId = zc_ObjectLink_Personal_Member()

                          LEFT JOIN ObjectDate AS ObjectDate_DateIn
                                               ON ObjectDate_DateIn.ObjectId = ObjectLink_Personal_Member.ObjectId
                                              AND ObjectDate_DateIn.DescId = zc_ObjectDate_Personal_In()

                     WHERE Object_User.DescId = zc_Object_User()
                       AND (Object_Position.ObjectCode = 1 OR Object_Position.ObjectCode = 2 AND vbDateStart >= '01.02.2022')
                       AND COALESCE (Object_Unit.ValueData ) <> ''
                       AND Object_User.isErased = False
                     GROUP BY Object_User.Id
                            , Object_User.ObjectCode
                            , Object_User.ValueData),
        tmpProtocol AS (SELECT tmpUser.UserId
                             , min(ObjectProtocol.OperDate)::TDateTime AS DateInsert
                        FROM tmpUser
                             INNER JOIN ObjectProtocol ON ObjectProtocol.ObjectId = tmpUser.UserId
                        GROUP BY tmpUser.UserId
                        ),
        tmpProtocolArc AS (SELECT tmpUser.UserId
                                , min(ObjectProtocol.OperDate)::TDateTime AS DateInsert
                           FROM tmpUser
                                INNER JOIN ObjectProtocol_Arc AS ObjectProtocol 
                                                              ON ObjectProtocol.ObjectId = tmpUser.UserId
                           GROUP BY tmpUser.UserId
                           )

   SELECT 'У вас не сдан экзамен! Сдайте его в текущем месяце!'::TBlob AS Message,
          ''::TVarChar            AS FormName,
          ''::TVarChar            AS Button,
          ''::TVarChar            AS Params,
          ''::TVarChar            AS TypeParams,
          ''::TVarChar            AS ValueParams
   FROM tmpUser

        LEFT JOIN tmpResult ON tmpResult.UserID = tmpUser.UserId
          
        LEFT JOIN tmpProtocol ON tmpProtocol.UserID = tmpUser.UserId

        LEFT JOIN tmpProtocolArc ON tmpProtocolArc.UserID = tmpUser.UserId

        LEFT JOIN tmpWages ON tmpWages.UserID = tmpUser.UserId

   WHERE tmpResult.isPassed = False
     AND COALESCE(tmpUser.DateIn, tmpProtocolArc.DateInsert, tmpProtocol.DateInsert, '01.01.2021') < vbDateStart
     AND COALESCE(tmpWages.UserId, 0) = 0
     AND tmpUser.UserId = inUserId
   LIMIT 1;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_PUSH_CashTestingUser (Integer, Integer, Integer) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 04.02.21         *
*/

-- тест
--
 select * from gpSelect_PUSH_CashTestingUser(inMovementID := 0, inUnitID := 0, inUserId :=  11973669 );