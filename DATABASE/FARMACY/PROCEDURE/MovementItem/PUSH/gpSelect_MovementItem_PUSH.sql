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
             , DateViewed TDateTime, Result TVarChar
             , ViewsLastDay Integer, ViewsCurrDay Integer
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
             MovementItem.Id                                      AS Id
           , MovementItem.Amount::Integer                         AS Views
           , Object_User.Id                                       AS UserId
           , Object_User.ObjectCode                               AS UserCode
           , Object_User.ValueData                                AS UserName
           , Object_Unit.Id                                       AS UnitId
           , Object_Unit.ObjectCode                               AS UnitCode
           , Object_Unit.ValueData                                AS UnitName
           , MovementItemDate_Viewed.ValueData                    AS DateViewed
           , MIString_Result.ValueData                            AS Result
           , COALESCE(MIFloat_AmountSecond.ValueData, 1)::Integer AS ViewsLastDay
           , CASE WHEN date_trunc('day',MovementItemDate_Viewed.ValueData) = CURRENT_DATE 
                  THEN COALESCE(MIFloat_AmountSecond.ValueData, 1) ELSE 0 END::Integer AS ViewsCurrDay
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
                
                LEFT JOIN MovementItemString AS MIString_Result
                                            ON MIString_Result.MovementItemId = MovementItem.Id
                                           AND MIString_Result.DescId = zc_MIString_Result()

                LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                            ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                           AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()
      WHERE MovementItem.MovementID = inMovementId
        AND MovementItem.DescId = zc_MI_Master();

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Шаблий О.В.
 05.03.20        *
 10.05.19         *
 21.03.19         *
*/
-- select * from gpSelect_MovementItem_PUSH(inMovementId := 10582538  , inShowAll := 'True' , inIsErased := 'False' ,  inSession := '3');
