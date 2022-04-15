-- Function: gpSelect_MovementItem_PersonalGroup (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalGroup (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalGroup(
    IN inMovementId  Integer      , -- ключ Документа
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, MemberId Integer
             , PersonalId Integer, PersonalCode Integer, PersonalName TVarChar
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , PersonalGroupId Integer, PersonalGroupName TVarChar
             , WorkTimeKindId Integer, WorkTimeKindCode Integer, WorkTimeKindName TVarChar
             , UnitName_inf TVarChar, PositionName_inf TVarChar
             , DateOut TDateTime, isMain Boolean
             , Amount TFloat
             , Count_Personal TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbPersonalServiceListId Integer;
   DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalRate());
     vbUserId:= lpGetUserBySession (inSession);

     --Дата тек.документа
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)

          , tmpMI AS (SELECT MovementItem.Id
                           , MovementItem.Amount
                           , MovementItem.ObjectId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased
                     )

       -- Результат
       SELECT MovementItem.Id
            , View_Personal.MemberId
            , View_Personal.PersonalId
            , View_Personal.PersonalCode
            , View_Personal.PersonalName

            , Object_Position.Id             AS PositionId
            , Object_Position.ValueData      AS PositionName
            , Object_PositionLevel.Id        AS PositionLevelId
            , Object_PositionLevel.ValueData AS PositionLevelName
            , Object_PersonalGroup.Id        AS PersonalGroupId
            , Object_PersonalGroup.ValueData AS PersonalGroupName

            , Object_WorkTimeKind.Id         AS WorkTimeKindId     
            , Object_WorkTimeKind.ObjectCode AS WorkTimeKindCode
            , Object_WorkTimeKind.ValueData  AS WorkTimeKindName

            , View_Personal.UnitName         AS UnitName_inf
            , View_Personal.PositionName     AS PositionName_inf

              -- дата увольнения
            , CASE WHEN COALESCE (ObjectDate_Personal_DateOut.ValueData, zc_DateEnd()) = zc_DateEnd() THEN NULL ELSE ObjectDate_Personal_DateOut.ValueData END :: TDateTime AS DateOut
            , COALESCE (ObjectBoolean_Personal_Main.ValueData, FALSE) :: Boolean AS isMain

            , MovementItem.Amount :: TFloat  AS Amount
            , CASE WHEN MovementItem.Amount <> 0 THEN 1 ELSE 0 END :: TFloat  AS Count_Personal

            , MIString_Comment.ValueData :: TVarChar AS Comment

            , MovementItem.isErased

       FROM tmpMI AS MovementItem
            LEFT JOIN Object_Personal_View AS View_Personal ON View_Personal.PersonalId = MovementItem.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Position
                                             ON MILinkObject_Position.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Position.DescId = zc_MILinkObject_Position()
            LEFT JOIN Object AS Object_Position ON Object_Position.Id = MILinkObject_Position.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                             ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                            AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = MILinkObject_PositionLevel.ObjectId

            LEFT JOIN ObjectLink AS ObjectLink_Personal_PersonalGroup
                                 ON ObjectLink_Personal_PersonalGroup.ObjectId = View_Personal.PersonalId
                                AND ObjectLink_Personal_PersonalGroup.DescId = zc_ObjectLink_Personal_PersonalGroup()
            LEFT JOIN Object AS Object_PersonalGroup ON Object_PersonalGroup.Id = ObjectLink_Personal_PersonalGroup.ChildObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_WorkTimeKind
                                             ON MILinkObject_WorkTimeKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_WorkTimeKind.DescId = zc_MILinkObject_WorkTimeKind()
            LEFT JOIN Object AS Object_WorkTimeKind ON Object_WorkTimeKind.Id = MILinkObject_WorkTimeKind.ObjectId

            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = MovementItem.Id
                                        AND MIString_Comment.DescId = zc_MIString_Comment()
            LEFT JOIN ObjectDate AS ObjectDate_Personal_DateOut
                                 ON ObjectDate_Personal_DateOut.ObjectId = MovementItem.ObjectId
                                AND ObjectDate_Personal_DateOut.DescId   = zc_ObjectDate_Personal_Out()
            LEFT JOIN ObjectBoolean AS ObjectBoolean_Personal_Main
                                    ON ObjectBoolean_Personal_Main.ObjectId = MovementItem.ObjectId
                                   AND ObjectBoolean_Personal_Main.DescId = zc_ObjectBoolean_Personal_Main()
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 15.04.22         * WorkTimeKindCode
 02.03.22         * Comment
 22.11.21         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_PersonalGroup (inMovementId:= 14521952, inIsErased:= TRUE, inSession:= '2')
