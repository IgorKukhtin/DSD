-- Function: gpGet_Movement_EmployeeSchedule_UserEdit()

DROP FUNCTION IF EXISTS gpGet_Movement_EmployeeSchedule_UserEdit (Integer, Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_EmployeeSchedule_UserEdit(
    IN inId                Integer  , -- ключ содержимого Документа
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , InvNumber TVarChar
             , OperDate TDateTime
             , StatusCode Integer
             , StatusName TVarChar
             , UserCode Integer
             , UserName TVarChar
             , UnitName TVarChar
             )
AS
$BODY$
  DECLARE vbUserId    Integer;
BEGIN

    vbUserId:= inSession;
    
    IF COALESCE (inId, 0) = 0 OR COALESCE (inMovementId, 0) = 0
    THEN
      RAISE EXCEPTION 'Изменение <График работы сотрудеиков> вам запрещено.';
    END IF;
    
    RETURN QUERY
    SELECT
        Movement.Id
      , Movement.InvNumber
      , Movement.OperDate
      , Object_Status.ObjectCode                 AS StatusCode
      , Object_Status.ValueData                  AS StatusName
      , Object_User.ObjectCode                   AS UserCode    
      , Object_Member.ValueData                  AS UserName
      , Object_Unit.ValueData                    AS UnitName

    FROM Movement
        LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

        LEFT JOIN MovementDate AS MovementDate_Insert
                               ON MovementDate_Insert.MovementId = Movement.Id
                              AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
        LEFT JOIN MovementDate AS MovementDate_Update
                               ON MovementDate_Update.MovementId = Movement.Id
                              AND MovementDate_Update.DescId = zc_MovementDate_Update()

        LEFT JOIN MovementLinkObject AS MLO_Insert
                                     ON MLO_Insert.MovementId = Movement.Id
                                    AND MLO_Insert.DescId = zc_MovementLinkObject_Insert()
        LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MLO_Insert.ObjectId

        LEFT JOIN MovementLinkObject AS MLO_Update
                                     ON MLO_Update.MovementId = Movement.Id
                                    AND MLO_Update.DescId = zc_MovementLinkObject_Update()
        LEFT JOIN Object AS Object_Update ON Object_Update.Id = MLO_Update.ObjectId
        
        LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                              AND MovementItem.Id = inId

        LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                         ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                        AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()

        LEFT JOIN Object AS Object_User ON Object_User.Id = MovementItem.ObjectId

        LEFT JOIN ObjectLink AS ObjectLink_User_Member
                             ON ObjectLink_User_Member.ObjectId = MovementItem.ObjectId
                            AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
        LEFT JOIN Object AS Object_Member ON Object_Member.Id = ObjectLink_User_Member.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Position
                             ON ObjectLink_Member_Position.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Position.DescId = zc_ObjectLink_Member_Position()
        LEFT JOIN Object AS Object_Position ON Object_Position.Id = ObjectLink_Member_Position.ChildObjectId

        LEFT JOIN ObjectLink AS ObjectLink_Member_Unit
                             ON ObjectLink_Member_Unit.ObjectId = ObjectLink_User_Member.ChildObjectId
                            AND ObjectLink_Member_Unit.DescId = zc_ObjectLink_Member_Unit()

        LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = COALESCE(ObjectLink_Member_Unit.ChildObjectId, MILinkObject_Unit.ObjectId)

    WHERE Movement.Id =  inMovementId;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_EmployeeSchedule_UserEdit (Integer, Integer, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.09.19        *
*/

-- select * from gpGet_Movement_EmployeeSchedule_UserEdit(inId := 275217437 , inMovementId := 15463866 ,  inSession := '3');
