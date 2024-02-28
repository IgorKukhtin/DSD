-- Function: gpSelect_MovementItem_PersonalGroupSummAdd (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PersonalGroupSummAdd (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PersonalGroupSummAdd(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inIsErased    Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer
             , PositionId Integer, PositionName TVarChar
             , PositionLevelId Integer, PositionLevelName TVarChar
             , Amount TFloat
             , Comment TVarChar
             , isErased Boolean
              )
AS
$BODY$
   DECLARE vbUserId   Integer;
   DECLARE vbUnitId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_PersonalGroupSummAdd());
     vbUserId:= lpGetUserBySession (inSession);

     -- Подразделение из шапки
     vbUnitId := (SELECT MovementLinkObject_Unit.ObjectId
                  FROM MovementLinkObject AS MovementLinkObject_Unit
                  WHERE MovementLinkObject_Unit.MovementId = inMovementId
                    AND MovementLinkObject_Unit.DescId = zc_MovementLinkObject_Unit()
                  );

     RETURN QUERY
       WITH tmpIsErased AS (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE)

          , tmpMI AS (SELECT MovementItem.Id                          AS MovementItemId
                           , MovementItem.Amount                      AS Amount
                           , MovementItem.ObjectId                    AS PositionId
                           , MILinkObject_PositionLevel.ObjectId      AS PositionLevelId
                           , MovementItem.isErased
                      FROM tmpIsErased
                           INNER JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                  AND MovementItem.DescId = zc_MI_Master()
                                                  AND MovementItem.isErased = tmpIsErased.isErased 
                           LEFT JOIN MovementItemLinkObject AS MILinkObject_PositionLevel
                                                            ON MILinkObject_PositionLevel.MovementItemId = MovementItem.Id
                                                           AND MILinkObject_PositionLevel.DescId = zc_MILinkObject_PositionLevel()
                     )

          , tmpPosition AS (SELECT 0 AS MovementItemId
                                 , 0 AS Amount
                                 , tmpPosition.PositionId
                                 , tmpPosition.PositionLevelId
                                 , FALSE AS isErased
                            FROM (SELECT DISTINCT
                                         ObjectLink_Personal_PositionLevel.ChildObjectId AS PositionLevelId
                                       , ObjectLink_Personal_Position.ChildObjectId      AS PositionId 
                                  FROM ObjectLink AS ObjectLink_Personal_Unit
                                       LEFT JOIN ObjectLink AS ObjectLink_Personal_Position
                                                            ON ObjectLink_Personal_Position.ObjectId = ObjectLink_Personal_Unit.ObjectId
                                                           AND ObjectLink_Personal_Position.DescId = zc_ObjectLink_Personal_Position()
                                 
                                       LEFT JOIN ObjectLink AS ObjectLink_Personal_PositionLevel
                                                            ON ObjectLink_Personal_PositionLevel.ObjectId = ObjectLink_Personal_Unit.ObjectId
                                                           AND ObjectLink_Personal_PositionLevel.DescId = zc_ObjectLink_Personal_PositionLevel()
                                  WHERE ObjectLink_Personal_Unit.ChildObjectId = vbUnitId
                                    AND ObjectLink_Personal_Unit.DescId = zc_ObjectLink_Personal_Unit()
                                    AND inShowAll = TRUE
                                 ) AS tmpPosition

                                 LEFT JOIN tmpMI ON tmpMI.PositionId = tmpPosition.PositionId
                                                AND tmpMI.PositionLevelId = tmpPosition.PositionLevelId
                            WHERE tmpMI.PositionId IS NULL
                           )

          , tmpAll AS (SELECT tmpMI.MovementItemId, tmpMI.Amount, tmpMI.PositionId, tmpMI.PositionLevelId, tmpMI.isErased FROM tmpMI
                      UNION ALL
                       SELECT tmpPosition.MovementItemId, tmpPosition.Amount, tmpPosition.PositionId, tmpPosition.PositionLevelId, tmpPosition.isErased FROM tmpPosition
                      )

       -- Результат
       SELECT tmpAll.MovementItemId                AS Id
            , Object_Position.Id                   AS PositionId
            , Object_Position.ValueData ::TVarChar AS PositionName
            , Object_PositionLevel.Id                   AS PositionLevelId
            , Object_PositionLevel.ValueData ::TVarChar AS PositionLevelName
            , tmpAll.Amount             :: TFloat  AS Amount
            , MIString_Comment.ValueData           AS Comment
            , tmpAll.isErased
       FROM tmpAll
            LEFT JOIN MovementItemString AS MIString_Comment
                                         ON MIString_Comment.MovementItemId = tmpAll.MovementItemId
                                        AND MIString_Comment.DescId = zc_MIString_Comment()

            LEFT JOIN Object AS Object_Position ON Object_Position.Id = tmpAll.PositionId
            LEFT JOIN Object AS Object_PositionLevel ON Object_PositionLevel.Id = tmpAll.PositionLevelId
      ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 27.02.24         *
*/

-- тест
--SELECT * FROM gpSelect_MovementItem_PersonalGroupSummAdd (inMovementId:= 14521952, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
--SELECT * FROM gpSelect_MovementItem_PersonalGroupSummAdd (inMovementId:= 14521952, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
