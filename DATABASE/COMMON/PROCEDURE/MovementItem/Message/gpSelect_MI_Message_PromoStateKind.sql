-- Function: gpSelect_MI_Message_PromoStateKind (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_Message_PromoStateKind (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Message_PromoStateKind(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Ord Integer
             , Comment TVarChar
             , PromoStateKindId Integer, PromoStateKindName TVarChar
             , InsertName TVarChar
             , InsertDate TDateTime
             , isQuickly Boolean
             , Amount TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_Promo());
     vbUserId:= lpGetUserBySession (inSession);


     -- Результат
     RETURN QUERY 

     SELECT MovementItem.Id                        AS Id
          , ROW_NUMBER() OVER (ORDER BY MovementItem.Id ASC) :: Integer AS Ord
          , MIString_Comment.ValueData :: TVarChar AS Comment
          , Object_PromoStateKind.Id               AS PromoStateKindId
          , Object_PromoStateKind.ValueData        AS PromoStateKindName
          , Object_Insert.ValueData                AS InsertName
          , MIDate_Insert.ValueData                AS InsertDate
          , CASE WHEN MovementItem.Amount = 1 THEN TRUE ELSE FALSE END :: Boolean AS isQuickly
          , MovementItem.Amount
          , MovementItem.isErased                  AS isErased
     FROM MovementItem
          LEFT JOIN Object AS Object_PromoStateKind ON Object_PromoStateKind.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = MovementItem.Id
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()

          LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                           ON MILO_Insert.MovementItemId = MovementItem.Id
                                          AND MILO_Insert.DescId = zc_MILinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

 
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Message()
       AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
       AND Object_PromoStateKind.DescId IN (zc_Object_PromoStateKind(), zc_Object_PromoTradeStateKind())
     ORDER BY 2 DESC
  /*  UNION
     SELECT 0                  AS Id
          , (SELECT COUNT(*)+1 
             FROM MovementItem
             WHERE MovementItem.MovementId = inMovementId
               AND MovementItem.DescId     = zc_MI_Message()
               AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE))  :: Integer AS Ord
          , '' :: TVarChar     AS Comment
          , 0                  AS PromoStateKindId
          , '' :: TVarChar     AS PromoStateKindName
          , '' :: TVarChar     AS InsertName
          , NULL :: TDateTime  AS InsertDate
          , FALSE              AS isQuickly
          , FALSE              AS isErased
   */
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.04.20         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_Message_PromoStateKind (inMovementId:= 4135607, inIsErased:= TRUE,  inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_Message_PromoStateKind (inMovementId:= 4135607, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
