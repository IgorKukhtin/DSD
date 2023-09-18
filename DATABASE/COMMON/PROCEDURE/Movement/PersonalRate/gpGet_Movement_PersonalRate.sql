-- Function: gpGet_Movement_PersonalRate (Integer, TVarChar)

--DROP FUNCTION IF EXISTS gpGet_Movement_PersonalRate (Integer, TDateTime ,TVarChar);
DROP FUNCTION IF EXISTS gpGet_Movement_PersonalRate (Integer, TDateTime, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_PersonalRate(
    IN inMovementId        Integer  , -- ключ Документа
    IN inOperDate          TDateTime , --  
    IN inMask              Boolean  , -- добавить по маске
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime
             , StatusCode Integer, StatusName TVarChar
             , Comment TVarChar
             , PersonalServiceListId Integer, PersonalServiceListName TVarChar
             , isMask Boolean --вернуть false
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Get_Movement_PersonalRate());
     vbUserId:= lpGetUserBySession (inSession);

     -- создаем док по маске
     IF COALESCE (inMask, False) = True
     THEN
     inMovementId := gpInsert_Movement_PersonalRate_Mask (ioId        := inMovementId
                                                        , inOperDate  := inOperDate
                                                        , inSession   := inSession); 
     END IF;


     IF COALESCE (inMovementId, 0) = 0
     THEN
     RETURN QUERY 
       SELECT 0 AS Id
            , CAST (NEXTVAL ('Movement_PersonalRate_seq') as TVarChar) AS InvNumber
            , inOperDate            AS OperDate                            --CURRENT_DATE
            , lfObject_Status.Code  AS StatusCode
            , lfObject_Status.Name  AS StatusName

            , ''       :: TVarChar  AS Comment

            , 0                     AS PersonalServiceListId
            , ''       :: TVarChar  AS PersonalServiceListName
            , CAST (FALSE AS Boolean) AS isMask

          FROM lfGet_Object_Status (zc_Enum_Status_UnComplete()) AS lfObject_Status
       ;
     ELSE
     RETURN QUERY 
       SELECT Movement.Id
            , Movement.InvNumber AS InvNumber
            , Movement.OperDate
            , Object_Status.ObjectCode   AS StatusCode
            , Object_Status.ValueData    AS StatusName

            , MovementString_Comment.ValueData   AS Comment

            , Object_PersonalServiceList.Id        AS PersonalServiceListId
            , Object_PersonalServiceList.ValueData AS PersonalServiceListName
            , CAST (FALSE AS Boolean)            AS isMask
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_PersonalServiceList
                                         ON MovementLinkObject_PersonalServiceList.MovementId = Movement.Id
                                        AND MovementLinkObject_PersonalServiceList.DescId     = zc_MovementLinkObject_PersonalServiceList()
            LEFT JOIN Object AS Object_PersonalServiceList ON Object_PersonalServiceList.Id = MovementLinkObject_PersonalServiceList.ObjectId

       WHERE Movement.Id = inMovementId
         AND Movement.DescId = zc_Movement_PersonalRate();

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
--ALTER FUNCTION gpGet_Movement_PersonalRate (Integer, TDateTime, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.09.23         *
 20.09.19         *
*/

-- тест
-- SELECT * FROM gpGet_Movement_PersonalRate (inMovementId:= 0, inOperDate := CURRENT_DATE, inMask := false, inSession:= zfCalc_UserAdmin())
