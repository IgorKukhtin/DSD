-- Function: gpSelect_MovementItem_PUSH()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_PUSH (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_PUSH(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, Views Integer, UserId Integer, UserCode Integer, UserName TVarChar
             , UnitId Integer, UnitCode Integer, UnitName TVarChar
             , DateViewed TDateTime
             , isErased Boolean
              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_UnnamedEnterprises());
    vbUserId:= lpGetUserBySession (inSession);

    RETURN QUERY

      SELECT
             MovementItem.Id                                     AS Id
           , MovementItem.Amount::Integer                        AS Views
           , Object_User.Id                                      AS UserId
           , Object_User.ObjectCode                              AS UserCode
           , Object_User.ValueData                               AS UserName
           , Object_Unit.Id                                      AS UnitId
           , Object_Unit.ObjectCode                              AS UnitCode
           , Object_Unit.ValueData                               AS UnitName
           , MovementItemDate_Viewed.ValueData                   AS DateViewed

           , MovementItem.IsErased    AS isErased
      FROM MovementItem
      

                LEFT JOIN Object AS Object_User ON Object_User.Id = MovementItem.ObjectId

                LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                 ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                                AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
                LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

                LEFT JOIN MovementItemDate AS MovementItemDate_Viewed
                                           ON MovementItemDate_Viewed.MovementItemId = MovementItem.Id
                                          AND MovementItemDate_Viewed.DescId = zc_MIDate_Viewed()
                
      WHERE MovementItem.MovementID = inMovementId;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 21.03.19         *
*/
-- select * from gpSelect_MovementItem_PUSH(inMovementId := 10582538  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
