-- Function: gpGet_TestingUser_Title()

DROP FUNCTION IF EXISTS gpGet_TestingUser_Title (TVarChar);

CREATE OR REPLACE FUNCTION gpGet_TestingUser_Title(
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , UserId Integer, UserName TVarChar
             , TotalCount Integer
             , Question Integer
             , TimeTest Integer
             , Comment TVarChar
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpGetUserBySession (inSession);

     IF inSession <> '3'
     THEN

       IF EXISTS(SELECT 1 FROM Movement
                 WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
                 AND Movement.DescId = zc_Movement_EmployeeSchedule())
       THEN

         SELECT Movement.ID
         INTO vbMovementID
         FROM Movement
         WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE)
           AND Movement.DescId = zc_Movement_EmployeeSchedule();

         IF NOT (
            EXISTS(SELECT 1 FROM MovementItem AS MIMaster
                          INNER JOIN MovementItem AS MIChild
                                                  ON MIChild.MovementId = vbMovementID
                                                 AND MIChild.DescId = zc_MI_Child()
                                                 AND MIChild.ParentId = MIMaster.ID
                                                 AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer
                          /*INNER JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                                            ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                                           AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()
                                                           AND COALESCE(MILinkObject_PayrollType.ObjectId, 0) <> 0*/
                          LEFT JOIN MovementItemDate AS MIDate_Start
                                                      ON MIDate_Start.MovementItemId = MIChild.Id
                                                     AND MIDate_Start.DescId = zc_MIDate_Start()

                          LEFT JOIN MovementItemDate AS MIDate_End
                                                     ON MIDate_End.MovementItemId = MIChild.Id
                                                    AND MIDate_End.DescId = zc_MIDate_End()

                          LEFT JOIN MovementItemBoolean AS MIBoolean_ServiceExit
                                                        ON MIBoolean_ServiceExit.MovementItemId = MIChild.Id
                                                       AND MIBoolean_ServiceExit.DescId = zc_MIBoolean_ServiceExit()
                   WHERE MIMaster.MovementId = vbMovementID
                     AND MIMaster.DescId = zc_MI_Master()
                     AND MIMaster.ObjectId = vbUserId
                     AND (COALESCE(MIBoolean_ServiceExit.ValueData, FALSE) = TRUE
                      OR MIBoolean_ServiceExit.ValueData IS NOT NULL AND MIDate_End.ValueData IS NOT NULL))
            OR
            EXISTS(SELECT 1
                   FROM MovementItem AS MIMaster
                        INNER JOIN MovementItem AS MIChild
                                                ON MIChild.MovementId = MIMaster.MovementId
                                               AND MIChild.DescId = zc_MI_Child()
                                               AND MIChild.ParentId = MIMaster.ID
                                               AND MIChild.Amount = date_part('DAY',  CURRENT_DATE)::Integer - 1
                        /*INNER JOIN MovementItemLinkObject AS MILinkObject_PayrollType
                                                          ON MILinkObject_PayrollType.MovementItemId = MIChild.Id
                                                         AND MILinkObject_PayrollType.DescId = zc_MILinkObject_PayrollType()
                                                         AND COALESCE(MILinkObject_PayrollType.ObjectId, 0) <> 0*/
                        INNER JOIN MovementItemDate AS MIDate_End
                                                    ON MIDate_End.MovementItemId = MIChild.Id
                                                   AND MIDate_End.DescId = zc_MIDate_End()
                                                   AND MIDate_End.ValueData > date_trunc('day', CURRENT_DATE)

                   WHERE MIMaster.MovementId = (SELECT Movement.ID
                                                FROM Movement
                                                WHERE Movement.OperDate = date_trunc('month', CURRENT_DATE - interval '1 day')
                                                 AND Movement.DescId = zc_Movement_EmployeeSchedule() )
                     AND MIMaster.DescId = zc_MI_Master()
                      AND MIMaster.ObjectId = vbUserId))
         THEN
           RAISE EXCEPTION 'Нет отметки времени прихода и ухода в графике.';     
         END IF;
         
         IF COALESCE((SELECT COUNT(*)
                      FROM Movement

                            INNER JOIN MovementLinkObject AS MovementLinkObject_Insert
                                                          ON MovementLinkObject_Insert.MovementId = Movement.Id
                                                         AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()

                      WHERE Movement.OperDate >= CURRENT_DATE
                        AND Movement.OperDate < CURRENT_DATE + INTERVAL '1 DAY'
                        AND MovementLinkObject_Insert.ObjectId = vbUserId
                        AND Movement.DescId = zc_Movement_Check()
                        AND Movement.StatusId = zc_Enum_Status_Complete()), 0) < 5
         THEN
           RAISE EXCEPTION 'Не найдены продажи по вам (минимум 5 чеков)..';              
         END IF;
       ELSE
         RAISE EXCEPTION 'Нет отметки времени прихода и ухода в графике.';     
       END IF;
     END IF;


     SELECT Movement.Id
          , ROW_NUMBER()OVER(ORDER BY Movement.StatusId DESC, Movement.OperDate DESC) as ORD
     INTO vbMovementId
     FROM Movement 
     WHERE Movement.OperDate <= CURRENT_DATE
       AND Movement.DescId = zc_Movement_TestingTuning()
       AND Movement.StatusId in (zc_Enum_Status_Complete(), zc_Enum_Status_UnComplete())
     ORDER BY 2
     LIMIT 1;
       
     IF COALESCE (vbMovementId, 0) = 0
     THEN
       RAISE EXCEPTION 'Не найден активный документ настройки тестирования.';     
     END IF;    
     
     
     RETURN QUERY
       SELECT
             Movement.Id                                        AS Id
           , Movement.InvNumber                                 AS InvNumber
           , Movement.OperDate                                  AS OperDate
           , Object_Status.ObjectCode                           AS StatusCode
           , Object_Status.ValueData                            AS StatusName
           , vbUserId                                           AS UserId
           , Object_User.ValueData                              AS UserName
           , MovementFloat_TotalCount.ValueData::Integer        AS TotalCount
           , MovementFloat_Question.ValueData::Integer          AS Question
           , MovementFloat_Time.ValueData::Integer              AS TimeTest
           , COALESCE (MovementString_Comment.ValueData,'')     ::TVarChar AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId

            LEFT JOIN MovementFloat AS MovementFloat_TotalCount
                                    ON MovementFloat_TotalCount.MovementId = Movement.Id
                                   AND MovementFloat_TotalCount.DescId = zc_MovementFloat_TotalCount()
            LEFT JOIN MovementFloat AS MovementFloat_Question
                                    ON MovementFloat_Question.MovementId = Movement.Id
                                   AND MovementFloat_Question.DescId = zc_MovementFloat_TestingUser_Question()
            LEFT JOIN MovementFloat AS MovementFloat_Time
                                    ON MovementFloat_Time.MovementId = Movement.Id
                                   AND MovementFloat_Time.DescId = zc_MovementFloat_Time()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

       WHERE Movement.Id =  vbMovementId
         AND Movement.DescId = zc_Movement_TestingTuning();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpGet_TestingUser_Title (TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.07.21                                                       *
 */

-- тест
-- 
select * from gpGet_TestingUser_Title(inSession := '3353680');