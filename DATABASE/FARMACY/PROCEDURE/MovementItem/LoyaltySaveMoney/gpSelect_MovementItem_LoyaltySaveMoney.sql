--- Function: gpSelect_MovementItem_LoyaltySaveMoney()


DROP FUNCTION IF EXISTS gpSelect_MovementItem_LoyaltySaveMoney (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_LoyaltySaveMoney(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , -- все
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id             Integer

             , BuyerID        Integer
             , BuyerCode      Integer
             , BuyerPhone     TVarChar
             , BuyerName      TVarChar
             , Amount         TFloat
             , SummaUse       TFloat
             , SummaRemainder TFloat

             , Comment        TVarChar
             , UnitID         Integer, UnitName       TVarChar
             , InsertName TVarChar, UpdateName TVarChar
             , InsertDate TDateTime, UpdateDate TDateTime
             , isErased   Boolean

              )
AS
$BODY$
    DECLARE vbUserId Integer;
BEGIN
    -- проверка прав пользователя на вызов процедуры
    -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Promo());
    vbUserId:= lpGetUserBySession (inSession);

        RETURN QUERY
           SELECT MovementItem.Id

                , Object_Buyer.ID                                AS BuyerID
                , Object_Buyer.ObjectCode                        AS BuyerCode
                , Object_Buyer.ValueData                         AS BuyerPhone
                , ObjectString_Buyer_Name.ValueData              AS BuyerName

                , MovementItem.Amount
                , COALESCE(MIFloat_Summ.ValueData, 0)::TFloat    AS SummaUse
                , (MovementItem.Amount -
                  COALESCE(MIFloat_Summ.ValueData, 0))::TFloat   AS SummaRemainder

                , MIString_Comment.ValueData                     AS Comment

                , Object_Unit.ID                                 AS UnitID
                , Object_Unit.ValueData                          AS UnitName

                , Object_Insert.ValueData                        AS InsertName
                , Object_Update.ValueData                        AS UpdateName
                , MIDate_Insert.ValueData                        AS InsertDate
                , MIDate_Update.ValueData                        AS UpdateDate

                , MovementItem.IsErased

           FROM MovementItem

               LEFT JOIN Object AS Object_Buyer ON Object_Buyer.Id = MovementItem.ObjectId
               LEFT JOIN ObjectString AS ObjectString_Buyer_Name
                                      ON ObjectString_Buyer_Name.ObjectId = Object_Buyer.Id
                                     AND ObjectString_Buyer_Name.DescId = zc_ObjectString_Buyer_Name()

               LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                           ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                          AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

               LEFT JOIN MovementItemString AS MIString_Comment
                                            ON MIString_Comment.MovementItemId = MovementItem.Id
                                           AND MIString_Comment.DescId = zc_MIString_Comment()

               LEFT JOIN MovementItemLinkObject AS MILinkObject_Unit
                                                ON MILinkObject_Unit.MovementItemId = MovementItem.Id
                                               AND MILinkObject_Unit.DescId = zc_MILinkObject_Unit()
               LEFT JOIN Object AS Object_Unit ON Object_Unit.Id = MILinkObject_Unit.ObjectId

               LEFT JOIN MovementItemDate AS MIDate_Insert
                                          ON MIDate_Insert.MovementItemId = MovementItem.Id
                                         AND MIDate_Insert.DescId = zc_MIDate_Insert()
               LEFT JOIN MovementItemDate AS MIDate_Update
                                          ON MIDate_Update.MovementItemId = MovementItem.Id
                                         AND MIDate_Update.DescId = zc_MIDate_Update()

               LEFT JOIN MovementItemLinkObject AS MILO_Insert
                                                ON MILO_Insert.MovementItemId = MovementItem.Id
                                               AND MILO_Insert.DescId = zc_MILinkObject_Insert()
               LEFT JOIN Object AS Object_Insert ON Object_Insert.Id = MILO_Insert.ObjectId
               LEFT JOIN MovementItemLinkObject AS MILO_Update
                                                ON MILO_Update.MovementItemId = MovementItem.Id
                                               AND MILO_Update.DescId = zc_MILinkObject_Update()
               LEFT JOIN Object AS Object_Update ON Object_Update.Id = MILO_Update.ObjectId

           WHERE MovementItem.MovementId = inMovementId
             AND MovementItem.DescId = zc_MI_Master()
             AND (MovementItem.isErased = FALSE or inIsErased = TRUE)
       ORDER BY MovementItem.ID;


END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В.
 05

27.12.19                                                       *
*/


-- select * from gpSelect_MovementItem_LoyaltySaveMoney(inMovementId := 16406918 , inShowAll := 'False', inIsErased := 'False' ,  inSession := '3');