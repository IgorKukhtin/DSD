-- Function: gpSelect_MovementItem_Check_Booking_Liki24()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check_Booking_Liki24 (TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check_Booking_Liki24(
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar
             , Amount TFloat
             , Price TFloat
             , ItemId TVarChar
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
       WITH tmpMovement AS (SELECT Movement.Id FROM gpSelect_Movement_Check_Booking_Liki24(inSession) AS Movement
                         )
          , tmpMI AS (SELECT MovementItem.MovementId
                           , MovementItem.Id
                           , MovementItem.ObjectId
                           , Object_Goods.ObjectCode             AS GoodsCode
                           , Object_Goods.Name                   AS GoodsName
                           , MovementItem.Amount
                      FROM tmpMovement AS Movement

                           LEFT JOIN MovementItem ON MovementItem.MovementId = Movement.ID
                                                 AND MovementItem.DescId     = zc_MI_Master()

                           LEFT JOIN Object_Goods_Retail AS Object_Goods_Retail ON Object_Goods_Retail.Id = MovementItem.ObjectId
                           LEFT JOIN Object_Goods_Main AS Object_Goods ON Object_Goods.Id = Object_Goods_Retail.GoodsMainId
                      )
          , tmpMIFloat AS (SELECT * FROM MovementItemFloat WHERE MovementItemFloat.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          )
          , tmpString AS (SELECT * FROM MovementItemString WHERE MovementItemString.MovementItemId IN (SELECT DISTINCT tmpMI.Id FROM tmpMI)
                          )
     SELECT MovementItem.Id
          , MovementItem.MovementId
          , MovementItem.ObjectId
          , MovementItem.GoodsCode
          , MovementItem.GoodsName
          , MovementItem.Amount
          , MIFloat_Price.ValueData             AS Price
          , MIString_ItemId.ValueData           AS ItemId
     FROM tmpMI AS MovementItem

          LEFT JOIN tmpMIFloat AS MIFloat_Price
                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                              AND MIFloat_Price.DescId = zc_MIFloat_Price()

          LEFT JOIN tmpString AS MIString_ItemId
                              ON MIString_ItemId.MovementItemId = MovementItem.Id
                             AND MIString_ItemId.DescId = zc_MIString_ItemId()
     ;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Шаблий О.В. +
 23.05.19                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Check_Booking_Liki24 (inSession:= '3')