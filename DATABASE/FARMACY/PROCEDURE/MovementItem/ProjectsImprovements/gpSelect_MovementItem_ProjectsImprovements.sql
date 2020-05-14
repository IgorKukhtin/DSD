-- Function: gpSelect_MovementItem_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProjectsImprovements (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProjectsImprovements(
    IN inMovementId   Integer      , -- ключ Документа
    IN inShowAll      Boolean      , --
    IN inIsErased     Boolean      , --
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, OperDate TDateTime
             , isApprovedBy Boolean, UserName TVarChar, isPerformed Boolean
             , Title TVarChar, Description TVarChar
             , isErased Boolean
             )
AS
$BODY$
DECLARE
  vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ProjectsImprovements());
    -- inShowAll:= TRUE;
    vbUserId:= lpGetUserBySession (inSession);

    -- РЕЗУЛЬТАТ
    RETURN QUERY
    WITH tmpStatus AS (SELECT zc_Enum_Status_Complete()    AS StatusId WHERE inShowAll = TRUE
                       UNION SELECT zc_Enum_Status_UnComplete() AS StatusId
                       UNION SELECT zc_Enum_Status_Erased()     AS StatusId WHERE inIsErased = TRUE
                       ),
         tmpMovement AS (SELECT Movement.Id
                         FROM tmpStatus
                              INNER JOIN Movement ON Movement.DescId = zc_Movement_ProjectsImprovements() AND Movement.StatusId = tmpStatus.StatusId
                         WHERE (Movement.ID  = inMovementId OR COALESCE(inMovementId, 0) = 0)
                         ),
         tmpMovementItem AS (SELECT MovementItem.Id                                                     AS Id
                                  , MovementItem.MovementId                                             AS ParentId  
                                  , MovementItem.Amount = 1                                             AS isPerformed
                                  , MovementItem.isErased                                               AS isErased
                              FROM tmpMovement
                                   INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                                          AND MovementItem.DescId     = zc_MI_Master()
                                                          AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE)
                                                   ),
         tmpMIDate AS (SELECT * FROM MovementItemDate 
                       WHERE MovementItemDate.MovementItemId in (SELECT tmpMovementItem.Id FROM tmpMovementItem)
                       ),
         tmpMIString AS (SELECT * FROM MovementItemString
                         WHERE MovementItemString.MovementItemId in (SELECT tmpMovementItem.Id FROM tmpMovementItem)
                        ),
         tmpMIBoolean AS (SELECT * FROM MovementItemBoolean
                          WHERE MovementItemBoolean.MovementItemId in (SELECT tmpMovementItem.Id FROM tmpMovementItem)
                         ),
         tmpMILinkObject AS (SELECT * FROM MovementItemLinkObject
                             WHERE MovementItemLinkObject.MovementItemId in (SELECT tmpMovementItem.Id FROM tmpMovementItem)
                            )
            
    SELECT MovementItem.Id                                                     AS Id
         , MovementItem.ParentId                                               AS ParentId  
         , MIDate_OperDate.ValueData                                           AS OperDate
         , COALESCE (MIBoolean_ApprovedBy.ValueData, False)                    AS isApprovedBy
         , Object_User.ValueData                                               AS UserName
         , MovementItem.isPerformed                                            AS isPerformed
         , MIString_Comment.ValueData                                          AS Title
         , MIString_Description.ValueData                                      AS Description
         , MovementItem.isErased                                               AS isErased
    FROM tmpMovementItem AS MovementItem 
                                
         LEFT JOIN tmpMIDate AS MIDate_OperDate
                             ON MIDate_OperDate.MovementItemId = MovementItem.Id
                            AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

         LEFT JOIN tmpMIString AS MIString_Comment
                               ON MIString_Comment.MovementItemId = MovementItem.Id
                              AND MIString_Comment.DescId = zc_MIString_Comment()
         LEFT JOIN tmpMIString AS MIString_Description
                               ON MIString_Description.MovementItemId = MovementItem.Id
                              AND MIString_Description.DescId = zc_MIString_Description()

         LEFT JOIN tmpMIBoolean AS MIBoolean_ApprovedBy
                                ON MIBoolean_ApprovedBy.MovementItemId = MovementItem.Id
                               AND MIBoolean_ApprovedBy.DescId = zc_MIBoolean_ApprovedBy()

         LEFT JOIN tmpMILinkObject AS MILinkObject_Insert
                                   ON MILinkObject_Insert.MovementItemId = MovementItem.Id
                                  AND MILinkObject_Insert.DescId = zc_MILinkObject_Insert()
         LEFT JOIN Object AS Object_User ON Object_User.Id = MILinkObject_Insert.ObjectId
    ;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ProjectsImprovements (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.A.   Шаблий О.В.
 13.05.20                                                                     *
*/

-- тест
-- select * from gpSelect_MovementItem_ProjectsImprovements(inMovementId := 0 , inShowAll := 'False' , inIsErased := 'False' ,  inSession := '3');