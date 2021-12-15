-- Function: gpGet_Movement_PersonalGroup()

DROP FUNCTION IF EXISTS gpGet_Movement_PersonalGroup (Integer, TDateTime, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalGroup(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime, -- дата Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , PairDayId Integer, PairDayName TVarChar
             , InsertId Integer, InsertName TVarChar
             , InsertDate TDateTime
             , UpdateId Integer, UpdateName TVarChar
             , UpdateDate TDateTime
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalGroup());

     IF COALESCE (inMovementId, 0) = 0
     THEN
         --при создании Unit берем по автору документа - основное место работы, если там пусто - хардкодим Цех Упаковки
         vbUnitId := COALESCE ((SELECT tmpPersonal.UnitId
                                FROM ObjectLink AS ObjectLink_User_Member
                                     LEFT JOIN (SELECT lfSelect.MemberId
                                                     , lfSelect.UnitId
                                                FROM lfSelect_Object_Member_findPersonal (inSession) AS lfSelect
                                               ) AS tmpPersonal ON tmpPersonal.MemberId = ObjectLink_User_Member.ChildObjectId
                                WHERE ObjectLink_User_Member.ObjectId = vbUserId
                                  AND ObjectLink_User_Member.DescId = zc_ObjectLink_User_Member()
                                  AND 1=0
                               )

                               , 8451 );   -- по умолчанию цех упаковки

         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('movement_PersonalGroup_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE :: TDateTime                AS OperDate
             , Object_Status.Code                       AS StatusCode
             , Object_Status.Name                       AS StatusName
             , Object_Unit.Id                           AS UnitId
             , Object_Unit.ValueData                    AS UnitName
             , 0                     		        AS PersonalGroupId
             , '' :: TVarChar                           AS PersonalGroupName
             , 0                     		        AS PairDayId
             , '' :: TVarChar                           AS PairDayName
             , 0                     		        AS InsertId
             , '' :: TVarChar                           AS InsertName
             , CAST (NULL AS TDateTime)                 AS InsertDate
             , 0                     		        AS UpdateId
             , '' :: TVarChar                           AS UpdateName
             , CAST (NULL AS TDateTime)                 AS UpdateDate
          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS Object_Status
             LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = vbUnitId
         ;

     ELSE

     RETURN QUERY
       SELECT
             Movement.Id                         AS Id
           , Movement.InvNumber                  AS InvNumber
           , Movement.OperDate                   AS OperDate
           , Object_Status.ObjectCode            AS StatusCode
           , Object_Status.ValueData             AS StatusName
           , Object_Unit.Id                      AS UnitId
           , Object_Unit.ValueData               AS UnitName
           , Object_PersonalGroup.Id             AS PersonalGroupId
           , Object_PersonalGroup.ValueData      AS PersonalGroupName
           , Object_PairDay.Id                   AS PairDayId
           , Object_PairDay.ValueData            AS PairDayName
           , Object_Insert.Id                    AS InsertId
           , Object_Insert.ValueData             AS InsertName
           , MovementDate_Insert.ValueData       AS InsertDate
           , Object_Update.Id                    AS UpdateId
           , Object_Update.ValueData             AS UpdateName
           , MovementDate_Update.ValueData       AS UpdateDate
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PairDay
                                         ON MovementLinkObject_PairDay.MovementId = Movement.Id
                                        AND MovementLinkObject_PairDay.DescId = zc_MovementLinkObject_PairDay()
            LEFT JOIN Object AS Object_PairDay ON Object_PairDay.Id = MovementLinkObject_PairDay.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId     = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MovementLinkObject_Insert.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Update
                                         ON MovementLinkObject_Update.MovementId = Movement.Id
                                        AND MovementLinkObject_Update.DescId     = zc_MovementLinkObject_Update()
            LEFT JOIN Object AS Object_Update ON Object_Update.Id = MovementLinkObject_Update.ObjectId

            LEFT JOIN MovementDate AS MovementDate_Insert
                                   ON MovementDate_Insert.MovementId = Movement.Id
                                  AND MovementDate_Insert.DescId = zc_MovementDate_Insert()
            LEFT JOIN MovementDate AS MovementDate_Update
                                   ON MovementDate_Update.MovementId = Movement.Id
                                  AND MovementDate_Update.DescId = zc_MovementDate_Update()
         WHERE Movement.Id = inMovementId
           AND Movement.DescId = zc_Movement_PersonalGroup();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 24.03.17         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalGroup (inMovementId:= 1, inOperDate:= CURRENT_DATE, inSession:= zfCalc_UserAdmin())