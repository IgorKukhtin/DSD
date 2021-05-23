-- Function: gpSelect_MI_Message (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MI_PersonalService_Message (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MI_Message (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MI_Message(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Ord Integer
             , Comment TVarChar
             , UserId Integer, UserName TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , OperDate TDateTime
             , isQuestion Boolean, isAnswer Boolean
             , isQuestionRead Boolean, isAnswerRead Boolean
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbMovementDescId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalService());
     vbUserId:= lpGetUserBySession (inSession);


     -- Параметры из документа - для определения <Модель электронной подписи>
     SELECT Movement.DescId  AS MovementDescId
            INTO vbMovementDescId
     FROM Movement
     WHERE Movement.Id = inMovementId;

     
     -- Результат
     RETURN QUERY 

     SELECT MovementItem.Id            AS Id
          , ROW_NUMBER() OVER (ORDER BY MovementItem.Id DESC) :: Integer AS Ord
          , MIString_Comment.ValueData :: TVarChar AS Comment
          , Object_User.Id             AS UserId
          , Object_User.ValueData      AS UserName
          , Object_Insert.ValueData    AS InsertName
          , Object_Update.ValueData    AS UpdateName
          , MIDate_Insert.ValueData    AS InsertDate
          , MIDate_Update.ValueData    AS UpdateDate
          , MIDate_OperDate.ValueData  AS OperDate
          , CASE WHEN MovementItem.Amount = 1 OR MovementItem.Amount = 3 THEN TRUE ELSE FALSE END AS isQuestion
          , CASE WHEN MovementItem.Amount = 2 OR MovementItem.Amount = 4 THEN TRUE ELSE FALSE END AS isAnswer
          , CASE WHEN MovementItem.Amount = 3 THEN TRUE ELSE FALSE END AS isQuestionRead
          , CASE WHEN MovementItem.Amount = 4 THEN TRUE ELSE FALSE END AS isAnswerRead
          , MovementItem.isErased      AS isErased
     FROM MovementItem
          LEFT JOIN Object AS Object_User ON Object_User.Id = MovementItem.ObjectId

          LEFT JOIN MovementItemString AS MIString_Comment
                                       ON MIString_Comment.MovementItemId = MovementItem.Id
                                      AND MIString_Comment.DescId = zc_MIString_Comment()

          LEFT JOIN MovementItemDate AS MIDate_Insert
                                     ON MIDate_Insert.MovementItemId = MovementItem.Id
                                    AND MIDate_Insert.DescId = zc_MIDate_Insert()
          LEFT JOIN MovementItemDate AS MIDate_Update
                                     ON MIDate_Update.MovementItemId = MovementItem.Id
                                    AND MIDate_Update.DescId = zc_MIDate_Update()
          LEFT JOIN MovementItemDate AS MIDate_OperDate
                                     ON MIDate_OperDate.MovementItemId = MovementItem.Id
                                    AND MIDate_OperDate.DescId = zc_MIDate_OperDate()

          LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                           ON MILO_Insert.MovementItemId = MovementItem.Id
                                          AND MILO_Insert.DescId = zc_MILinkObject_Insert()
          LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId

          LEFT JOIN MovementItemLinkObject AS MILO_Update
                                           ON MILO_Update.MovementItemId = MovementItem.Id
                                          AND MILO_Update.DescId = zc_MILinkObject_Update()
          LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId
     WHERE MovementItem.MovementId = inMovementId
       AND MovementItem.DescId     = zc_MI_Message()
       AND (MovementItem.isErased = inIsErased OR inIsErased = TRUE)
       AND Object_User.DescId = zc_Object_User()
    UNION
     SELECT 0                  AS Id
          , 0  :: Integer      AS Ord
          , '' :: TVarChar     AS Comment
          , 0                  AS UserId
          , '' :: TVarChar     AS UserName
          , '' :: TVarChar     AS InsertName
          , '' :: TVarChar     AS UpdateName
          , NULL :: TDateTime  AS InsertDate
          , NULL :: TDateTime  AS UpdateDate
          , NULL :: TDateTime  AS OperDate
          , FALSE              AS isQuestion
          , FALSE              AS isAnswer
          , FALSE              AS isQuestionRead
          , FALSE              AS isAnswerRead
          , FALSE              AS isErased
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
-- SELECT * FROM gpSelect_MI_Message (inMovementId:= 4135607, inIsErased:= TRUE,  inSession:= zfCalc_UserAdmin())
-- SELECT * FROM gpSelect_MI_Message (inMovementId:= 4135607, inIsErased:= FALSE, inSession:= zfCalc_UserAdmin())
