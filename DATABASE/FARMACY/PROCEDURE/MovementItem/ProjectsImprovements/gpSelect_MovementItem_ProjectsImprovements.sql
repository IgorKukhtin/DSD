-- Function: gpSelect_MovementItem_ProjectsImprovements()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ProjectsImprovements (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ProjectsImprovements(
    IN inMovementId   Integer      , -- ключ Документа
    IN inShowAll      Boolean      , --
    IN inIsErased     Boolean      , --
    IN inSession      TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, ParentId Integer, OperDate TDateTime
             , isPerformed Boolean
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
                              JOIN Movement ON Movement.DescId = zc_Movement_ProjectsImprovements() AND Movement.StatusId = tmpStatus.StatusId
                         WHERE (Movement.ID  = inMovementId OR COALESCE(inMovementId, 0) = 0)
                         )
            
    SELECT MovementItem.Id                                                     AS Id
         , MovementItem.MovementId                                             AS ParentId  
         , MIDate_OperDate.ValueData                                           AS OperDate
         , MovementItem.Amount = 1                                             AS isPerformed
         , MIString_Comment.ValueData                                          AS Title
         , MIString_Description.ValueData                                      AS Description
         , MovementItem.isErased                                               AS isErased
    FROM tmpMovement
         INNER JOIN MovementItem ON MovementItem.MovementId = tmpMovement.Id
                                AND MovementItem.DescId     = zc_MI_Master()
                                AND (MovementItem.isErased  = FALSE OR inIsErased = TRUE)
                                
         LEFT JOIN MovementItemDate AS MIDate_OperDate
                                    ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                   AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

         LEFT JOIN MovementItemString AS MIString_Comment
                                      ON MIString_Comment.MovementItemId = MovementItem.Id
                                     AND MIString_Comment.DescId = zc_MIString_Comment()
         LEFT JOIN MovementItemString AS MIString_Description
                                      ON MIString_Description.MovementItemId = MovementItem.Id
                                     AND MIString_Description.DescId = zc_MIString_Description()
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
-- select * from gpSelect_MovementItem_ProjectsImprovements(inMovementId := 0     , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
