-- Function: gpSelect_MI_IncomeFuel_Sign (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_IncomeFuel_Sign (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_IncomeFuel_Sign(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, SignInternalId Integer, SignInternalName TVarChar
             , Amount TFloat
             , UserId Integer, UserCode Integer, UserName TVarChar
             , InsertName TVarChar, InsertDate TDateTime
             , isSign Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
  DECLARE vbMovementDescId Integer;
  DECLARE vbObjectDescId Integer;
  DECLARE vbObjectId Integer;  
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_IncomeFuel());
     vbUserId := inSession;

     SELECT Movement.DescId                               AS MovementDescId
          , COALESCE(Object_To.DescId,0)                  AS ObjectDescId
          , COALESCE(MovementLinkObject_From.ObjectId,0)  AS ObjectId

     INTO vbMovementDescId, vbObjectDescId, vbObjectId
     FROM Movement
            LEFT JOIN MovementLinkObject AS MovementLinkObject_From
                                         ON MovementLinkObject_From.MovementId = Movement.Id
                                        AND MovementLinkObject_From.DescId = zc_MovementLinkObject_From()
            
            LEFT JOIN MovementLinkObject AS MovementLinkObject_To
                                         ON MovementLinkObject_To.MovementId = Movement.Id
                                        AND MovementLinkObject_To.DescId = zc_MovementLinkObject_To()
            LEFT JOIN Object AS Object_To ON Object_To.Id = MovementLinkObject_To.ObjectId
     WHERE Movement.Id = inMovementId;

     
     RETURN QUERY 
     WITH 
     tmpSignInternal AS (SELECT * 
                             FROM lpSelect_Object_SignInternalItem (vbMovementDescId, vbObjectDescId, 0)
                             )
            
     , tmpMISign AS (SELECT MovementItem.Id
                          , Object_SignInternal.Id              AS SignInternalId
                          , Object_SignInternal.ValueData       AS SignInternalName
                          , MovementItem.Amount
                          , Object_Insert.Id                    AS InsertId
                          , Object_Insert.ObjectCode            AS InsertCode
                          , Object_Insert.ValueData             AS InsertName
                          , MIDate_Insert.ValueData             AS InsertDate
                     FROM (SELECT FALSE AS isErased UNION ALL SELECT TRUE AS isErased WHERE TRUE = TRUE) AS tmpIsErased
                         JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                          AND MovementItem.DescId     = zc_MI_Sign()
                                          AND MovementItem.isErased   = tmpIsErased.isErased
                         LEFT JOIN Object AS Object_SignInternal ON Object_SignInternal.Id =  MovementItem.ObjectId 
     
                         LEFT JOIN MovementItemDate AS MIDate_Insert
                                                    ON MIDate_Insert.MovementItemId = MovementItem.Id
                                                   AND MIDate_Insert.DescId = zc_MIDate_Insert()
                         LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                          ON MILO_Insert.MovementItemId = MovementItem.Id
                                                         AND MILO_Insert.DescId = zc_MILinkObject_Insert()
                         LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
                     )


  SELECT COALESCE (tmpMISign.Id,0) AS Id 
       , tmpSignInternal.SignInternalId 
       , tmpSignInternal.SignInternalName
       
       , COALESCE (tmpMISign.Amount,tmpSignInternal.Code) :: TFloat AS Amount  -- AS SignInternalItemCode
       , tmpSignInternal.UserId
       , tmpSignInternal.UserCode
       , tmpSignInternal.UserName
 
       , COALESCE (tmpMISign.InsertName, Null):: TVarChar   AS InsertName
       , COALESCE (tmpMISign.InsertDate, Null):: TDateTime  AS InsertDate
       
       , CASE WHEN COALESCE (tmpMISign.Amount,0) = 0 THEN False ELSE TRUE END isSign   --подписан / не подписан
   FROM tmpSignInternal
     LEFT JOIN tmpMISign ON tmpMISign.SignInternalId = tmpSignInternal.SignInternalId
                        AND tmpMISign.InsertId = tmpSignInternal.UserId
       
      ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 23.08.16         * 
 
*/

-- тест
-- SELECT * FROM gpSelect_MI_IncomeFuel_Sign (inMovementId:= 4135607  , inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MI_IncomeFuel_Sign (inMovementId:= 4135607  , inIsErased:= FALSE, inSession:= '2')
