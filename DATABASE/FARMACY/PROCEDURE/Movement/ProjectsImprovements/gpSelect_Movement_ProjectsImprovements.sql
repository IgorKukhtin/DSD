-- Function: gpSelect_Movement_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpSelect_Movement_ProjectsImprovements (Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_Movement_ProjectsImprovements(
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean ,   --Так же удаленные
    IN inSession     TVarChar    --сессия пользователя
)
RETURNS TABLE (Id Integer, InvNumber TVarChar, OperDate TDateTime, StatusCode Integer, StatusName TVarChar
             , isApprovedBy Boolean, UserName TVarChar
             , Title TVarChar, Description Text, Comment TVarChar
             )
AS
$BODY$
   DECLARE vbUserId Integer;
   DECLARE vbObjectId Integer;
   DECLARE vbUnitKey TVarChar;
   DECLARE vbUnitId Integer;
   DECLARE vbUnitIdStr    TVarChar;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     --vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_Movement_ProjectsImprovements());
     vbUserId:= lpGetUserBySession (inSession);
     
     RETURN QUERY
     WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()   AS StatusId WHERE inShowAll = TRUE
                  UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                  UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       )

       -- Результат
       SELECT
             Movement.Id                                            AS Id
           , Movement.InvNumber                                     AS InvNumber
           , Movement.OperDate                                      AS OperDate
           , Object_Status.ObjectCode                               AS StatusCode
           , CASE Movement.StatusId WHEN zc_Enum_Status_Complete() THEN 'Выполнено'
                                    WHEN zc_Enum_Status_UnComplete() THEN 'Не выполнено'
                                    ELSE 'Удален' END::TVarChar     AS StatusName
           , COALESCE (MovementBoolean_ApprovedBy.ValueData, False) AS isApprovedBy
           
           , Object_User.ValueData                                  AS UserName
           , MovementString_Title.ValueData                         AS Title
           , MovementBlob_Description.ValueData::Text               AS Description
           , MovementString_Comment.ValueData                       AS Comment


       FROM (SELECT Movement.Id
             FROM tmpStatus
                  JOIN Movement ON Movement.DescId = zc_Movement_ProjectsImprovements() AND Movement.StatusId = tmpStatus.StatusId
            ) AS tmpMovement
            
            LEFT JOIN Movement ON Movement.Id = tmpMovement.Id

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
            ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_Movement_ProjectsImprovements (Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 15.02.20                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_Movement_ProjectsImprovements (inShowAll := FALSE, inIsErased:= FALSE, inSession:= '3')

