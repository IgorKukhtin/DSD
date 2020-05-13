-- Function: gpGet_Movement_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpGet_Movement_ProjectsImprovements (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpGet_Movement_ProjectsImprovements(
    IN inMovementId        Integer  , -- ключ Документа
    IN inSession           TVarChar   -- сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , isApprovedBy Boolean, UserName TVarChar
             , Title TVarChar, Description Text, Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProjectsImprovements());
     vbUserId:= lpGetUserBySession (inSession);

     IF COALESCE (inMovementId, 0) = 0
     THEN
         RETURN QUERY
         SELECT
               0 AS Id
             , CAST (NEXTVAL ('Movement_ProjectsImprovements_seq') AS TVarChar) AS InvNumber
             , CURRENT_DATE::TDateTime          AS OperDate
             , Object_Status.Code               AS StatusCode
             , Object_Status.Name               AS StatusName
             , False                            AS isApprovedBy
             
             , Object_User.ValueData            AS UserName
             , ''::TVarChar                     AS Title
             , ''::Text                         AS Description
             , ''::TVarChar                     AS Comment


             , 0                                AS UnitId
             , CAST ('' as TVarChar)            AS UnitName
             , 60 :: Integer                    AS DayCount
             , Null :: TFloat                   AS TotalDiff
             , Null :: TFloat                   AS TotalDiffSumm
             , CAST ('' as TVarChar)            AS Comment
             , False :: Boolean                 AS isRedCheck
             , False :: Boolean                 AS isAdjustment
          FROM lfGet_Object_Status(zc_Enum_Status_UnComplete()) AS Object_Status
               LEFT JOIN Object AS Object_User ON Object_User.Id = vbUserId;
     ELSE
       RETURN QUERY
       SELECT
             Movement.Id                                            AS Id
           , Movement.InvNumber                                     AS InvNumber
           , Movement.OperDate                                      AS OperDate
           , Object_Status.ObjectCode                               AS StatusCode
           , Object_Status.ValueData                                AS StatusName
           , COALESCE (MovementBoolean_ApprovedBy.ValueData, False) AS isApprovedBy
           
           , Object_User.ValueData                                  AS UserName
           , MovementString_Title.ValueData                         AS Title
           , MovementBlob_Description.ValueData::Text               AS Description
           , MovementString_Comment.ValueData                       AS Comment
       FROM Movement
            LEFT JOIN Object AS Object_Status ON Object_Status.Id = Movement.StatusId

            LEFT JOIN MovementString AS MovementString_Title
                                     ON MovementString_Title.MovementId = Movement.Id
                                    AND MovementString_Title.DescId = zc_MovementString_Title()

            LEFT JOIN MovementBlob AS MovementBlob_Description
                                     ON MovementBlob_Description.MovementId = Movement.Id
                                    AND MovementBlob_Description.DescId = zc_MovementBlob_Description()

            LEFT JOIN MovementString AS MovementString_Comment
                                     ON MovementString_Comment.MovementId = Movement.Id
                                    AND MovementString_Comment.DescId = zc_MovementString_Comment()

            LEFT JOIN MovementBoolean AS MovementBoolean_ApprovedBy
                                      ON MovementBoolean_ApprovedBy.MovementId = Movement.Id
                                     AND MovementBoolean_ApprovedBy.DescId = zc_MovementBoolean_ApprovedBy()

            LEFT JOIN MovementLinkObject AS MovementLinkObject_Insert
                                         ON MovementLinkObject_Insert.MovementId = Movement.Id
                                        AND MovementLinkObject_Insert.DescId = zc_MovementLinkObject_Insert()
            LEFT JOIN Object AS Object_User ON Object_User.Id = MovementLinkObject_Insert.ObjectId
         WHERE Movement.Id =  inMovementId
         AND Movement.DescId = zc_Movement_ProjectsImprovements();

   END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpGet_Movement_ProjectsImprovements (Integer, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
 */

-- тест
--  SELECT * FROM gpGet_Movement_ProjectsImprovements (inMovementId:= 18831165 , inSession:= '3')
