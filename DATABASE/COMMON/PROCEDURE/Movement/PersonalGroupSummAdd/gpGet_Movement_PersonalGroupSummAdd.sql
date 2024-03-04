-- Function: gpGet_Movement_PersonalGroupSummAdd (Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpGet_Movement_PersonalGroupSummAdd (Integer, TDateTime ,TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_PersonalGroupSummAdd (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalGroupSummAdd(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , --  
    IN inMask              Boolean  , -- добавить по маске
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar 
             , NormHour TFloat
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , UnitId Integer, UnitName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , isMask Boolean --вернуть false
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalGroupSummAdd());
     vbUserId:= lpGetUserBySession (inSession);

     -- создаем док по маске
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_PersonalGroupSummAdd_Mask (ioId        := inMovementId
                                                                , inOperDate  := inOperDate
                                                                , inSession   := inSession); 
     END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT 0 AS Id
            , CAST (NEXTVAL ('Movement_PersonalGroupSummAdd_seq') as TVarChar) AS InvNumber
            , inOperDate            AS OperDate                            --CURRENT_DATE
            , lfObject_Status.Code  AS StatusCode
            , lfObject_Status.Name  AS StatusName
            , 0        ::TFloat     AS NormHour
            , ''       :: TVarChar  AS Comment

            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName
            , 0                     AS UnitId
            , ''       :: TVarChar  AS UnitName
            , 0                     AS PersonalGroupId
            , ''       :: TVarChar  AS PersonalGroupName
            
            , CAST (FALSE AS Boolean) AS isMask

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = 298695   --" Премії виробництво" 
       ;
     ELSE
     RETURN QUERY 
       SELECT Movement.Id
            , Movement.InvNumber AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode   AS StatusCode
            , Object_Status.ValueData    AS StatusName
            , MovementFloat_NormHour.ValueData   AS NormHour
            , MovementString_Comment.ValueData   AS Comment

            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName
            , Object_Unit.Id                       AS UnitId
            , Object_Unit.ValueData                AS UnitName
            , Object_PersonalGroup.Id              AS PersonalGroupId
            , Object_PersonalGroup.ValueData       AS PersonalGroupName            
            , CAST (FALSE AS Boolean)            AS isMask
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementFloat AS MovementFloat_NormHour
                                    ON MovementFloat_NormHour.MovementId =  Movement.Id
                                   AND MovementFloat_NormHour.DescId = zc_MovementFloat_NormHour()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Unit
                                         ON MovementLinkObject_Unit.MovementId = Movement.Id
                                        AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
            LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MovementLinkObject_Unit.ObjectId

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalGroup
                                         ON MovementLinkObject_PersonalGroup.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalGroup.DescId = zc_MovementLinkObject_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = MovementLinkObject_PersonalGroup.ObjectId
       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_PersonalGroupSummAdd();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.24         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalGroupSummAdd (inMovementId:= 0, inOperDate := CURRENT_DATE, inMask := false, inSession:= zfCalc_UserAdmin())
