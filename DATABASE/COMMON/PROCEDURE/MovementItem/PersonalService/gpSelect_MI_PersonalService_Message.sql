-- Function: gpSelect_MI_PersonalService_Message (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_PersonalService_Message (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_PersonalService_Message(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , Comment TVarChar
             , UserId Integer, UserCode Integer, UserName TVarChar
             , OperDate TDateTime
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId := inSession;


     -- Параметры из документа - для определения <Модель электронной подписи>
     SELECT Movement.DescId  AS MovementDescId
            INTO vbMovementDescId
     FROM Movement
     WHERE Movement.Id = inMovementId;

     
     -- Результат
     RETURN QUERY 

     SELECT MovementItem.Id         AS Id
          , MIString_Comment.ValueData :: TVarChar AS Comment
          , Object_User.Id          AS UserId
          , Object_User.ObjectCode  AS UserCode
          , Object_User.ValueData   AS UserName
          , MIDate_Insert.ValueData AS OperDate
          , MovementItem.isErased   AS isErased
     FROM MovementItem
          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = MovementItem.Id
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
          LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                           ON MILO_Insert.MovementItemId = MovementItem.Id
                                          AND MILO_Insert.DescId = zc_MILinkObject_Insert()
          LEFT JOIN Object AS Object_User ON Object_User.Id = MILO_Insert.ObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Message()
       AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
     ORDER BY MovementItem.Id
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 20.09.16         * 
*/

-- тест
-- SELECT * FROM gpSelect_MI_PersonalService_Message (inMovementId:= 4135607, inIsErased:= TRUE,  inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_PersonalService_Message (inMovementId:= 4135607, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
