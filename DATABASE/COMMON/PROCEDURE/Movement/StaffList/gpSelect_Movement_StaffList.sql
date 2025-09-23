-- Function: gpSelect_Movement_StaffList()
DROP FUNCTION IF EXISTS gpSelect_Movement_StaffList (TDateTime, TDateTime, Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_Movement_StaffList (TDateTime, TDateTime, Integer, Integer, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_Movement_StaffList(
    IN inStartDate         TDateTime , --
    IN inEndDate           TDateTime , --
    IN inJuridicalBasisId  Integer   , -- гл. юр.лицо
    IN inUnitId            Integer   , -- подразделение
    IN inIsErased          Boolean   ,
    IN inSession           TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar                               -- Подразделение
             , PersonalHeadId Integer, PersonalHeadName TVarChar               -- Руководитель подразделения
             , DepartmentId Integer, DepartmentName TVarChar                   -- Департамент 
             , Department_twoId Integer, Department_twoName TVarChar
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
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_StaffList());
     vbUserId:= lpGetUserBySession (inSession);


     -- !!!Проверка прав роль - Ограничение просмотра данных ЗП!!!
     PERFORM lpCheck_UserRole_8813637 (vbUserId);

     -- !!!Только просмотр Аудитор!!!
     PERFORM lpCheckPeriodClose_auditor (inStartDate, inEndDate, NULL, NULL, NULL, vbUserId);

     -- Результат
     RETURN QUERY
       WITH tmpStatus AS (SELECT zc_Enum_Status_Complete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_UnComplete() AS StatusId
                         UNION
                          SELECT zc_Enum_Status_Erased() AS StatusId WHERE inIsErased = TRUE
                         )
       -- 
       SELECT Movement.Id                        AS Id
            , Movement.InvNumber                 AS InvNumber
            , Movement.OperDate                  AS OperDate
            , Object_Status.ObjectCode           AS StatusCode
            , Object_Status.ValueData            AS StatusName

            , Object_Unit.Id                     AS UnitId
            , Object_Unit.ValueData              AS UnitName
            , Object_PersonalHead.Id             AS PersonalHeadId
            , Object_PersonalHead.ValueData      AS PersonalHeadName
            , Object_Department.Id               AS DepartmentId
            , Object_Department.ValueData        AS DepartmentName
            , Object_Department_two.Id         AS Department_twoId
            , Object_Department_two.ValueData  AS Department_twoName

            , MovementString_Comment.ValueData   AS Comment

            , Object_Insert.ValueData          AS InsertName
            , MovementDate_Insert.ValueData    AS InsertDate
            , Object_Update.ValueData          AS UpdateName
            , MovementDate_Update.ValueData    AS UpdateDate
       FROM tmpStatus
            INNER JOIN Movement ON Movement.DescId = zc_Movement_StaffList()
                               AND Movement.OperDate BETWEEN inStartDate AND inEndDate
                               AND Movement.StatusId = tmpStatus.StatusId

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

            LEFT JOIN ObjectLink AS ObjectLink_Unit_Department_two
                                 ON ObjectLink_Unit_Department_two.ObjectId = MovementLinkObject_Unit.ObjectId
                                AND ObjectLink_Unit_Department_two.DescId = zc_ObjectLink_Unit_Department_two()
            LEFT JOIN Object AS Object_Department_two ON Object_Department_two.Id = ObjectLink_Unit_Department_two.ChildObjectId

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
       WHERE MovementLinkObject_Unit.ObjectId = inUnitId OR inUnitId = 0

       ;
  
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.08.25         *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_StaffList (inStartDate:= '30.01.2013', inEndDate:= '01.02.2013',inJuridicalBasisId:=0,  inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
