-- Function: gpGet_Movement_StaffList (Integer, TVarChar)

DROP FUNCTION IF EXISTS gpGet_Movement_StaffList (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_StaffList(
    IN inMovementId        Integer   , -- ключ Документа
    IN inOperDate          TDateTime , --  
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar                               -- Подразделение
             , PersonalHeadId Integer, PersonalHeadName TVarChar               -- Руководитель подразделения
             , DepartmentId Integer, DepartmentName TVarChar                   -- Департамент
             , Comment TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , UpdateName TVarChar
             , UpdateDate TDateTime
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_StaffList());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT 0 AS Id
            , CAST (NEXTVAL ('Movement_StaffList_seq') as TVarChar) AS InvNumber
            , inOperDate            AS OperDate                            --CURRENT_DATE
            , Object_Status.Code    AS StatusCode
            , Object_Status.Name    AS StatusName

            , 0                     AS UnitId
            , ''       :: TVarChar  AS UnitName
            , 0                     AS PersonalHeadId
            , ''       :: TVarChar  AS PersonalHeadName
            , 0                     AS DepartmentId
            , ''       :: TVarChar  AS DepartmentName

            , ''       :: TVarChar  AS Comment

            , Object_Insert.ValueData          AS InsertName
            , CURRENT_TIMESTAMP ::TDateTime    AS InsertDate
            , CAST ('' AS TVarChar)            AS UpdateName
            , CAST (Null AS TDateTime)         AS UpdateDate

       FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = vbUserId
       ;
     ELSE
     RETURN QUERY 
       SELECT Movement.Id
            , Movement.InvNumber               AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode         AS StatusCode
            , Object_Status.ValueData          AS StatusName

            , Object_Unit.Id                   AS UnitId
            , Object_Unit.ValueData            AS UnitName
            , Object_PersonalHead.Id           AS PersonalHeadId
            , Object_PersonalHead.ValueData    AS PersonalHeadName
            , Object_Department.Id             AS DepartmentId
            , Object_Department.ValueData      AS DepartmentName

            , MovementString_Comment.ValueData AS Comment

            , Object_Insert.ValueData          AS InsertName
            , MovementDate_Insert.ValueData    AS InsertDate
            , Object_Update.ValueData          AS UpdateName
            , MovementDate_Update.ValueData    AS UpdateDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department
                                 ON ObjectLink_Unit_Department.ObjectId = MovementLinkObject_Unit.ObjectId
                                AND ObjectLink_Unit_Department.DescId = zc_ObjectLink_Unit_Department()
            LEFT JOIN Object AS Object_Department ON Object_Department.Id = ObjectLink_Unit_Department.ChildObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalHead
                                         ON MovementLinkObject_PersonalHead.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalHead.DescId = zc_MovementLinkObject_PersonalHead()
            LEFT JOIN Object AS Object_PersonalHead ON Object_PersonalHead.Id = MovementLinkObject_PersonalHead.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_StaffList();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.25         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_StaffList (inMovementId:= 0, inOperDate := CURRENT_DATE, inSession:= zfCalc_UserAdmin())
