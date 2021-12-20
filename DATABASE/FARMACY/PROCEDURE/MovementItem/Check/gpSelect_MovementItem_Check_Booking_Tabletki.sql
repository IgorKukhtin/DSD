-- Function: gpSelect_MovementItem_Check_Booking_Tabletki()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_Check_Booking_Tabletki (Integer, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Check_Booking_Tabletki(
    IN inUnitId        Integer   , -- Подразделение
    IN inSession       TVarChar    -- сессия пользователя
)
RETURNS TABLE (Id Integer, MovementId Integer
             , GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, MakerName TVarChar
             , AmountOrder TFloat, Amount TFloat
             , Price TFloat, isCancelReason Boolean
              )
AS
$BODY$
   DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_Movement_OrderInternal());
     vbUserId:= lpGetUserBySession (inSession);


     RETURN QUERY
       WITH tmpMovement AS (SELECT Movement.Id FROM gpSelect_Movement_Check_Booking_Tabletki(inUnitId, inSession) AS Movement
                         )
          , tmpMI AS (SELECT MovementItem.MovementId
                           , MovementItem.Id
                           , MovementItem.ObjectId
                           , Object_Goods.ObjectCode             AS GoodsCode
                           , Object_Goods.Name                   AS GoodsName
                           , Object_Goods.MakerName              AS MakerName
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
          , MovementItem.MakerName
          , MIFloat_AmountOrder.ValueData       AS AmountOrder
          , MovementItem.Amount
          , MIFloat_Price.ValueData             AS Price
          , (MIFloat_AmountOrder.ValueData > MovementItem.Amount) AND 
            (MIFloat_AmountOrder.ValueData - MovementItem.Amount) > 0.1 AS isCancelReason
     FROM tmpMI AS MovementItem

          LEFT JOIN tmpMIFloat AS MIFloat_Price
                               ON MIFloat_Price.MovementItemId = MovementItem.Id
                              AND MIFloat_Price.DescId = zc_MIFloat_Price()

          LEFT JOIN MovementItemFloat AS MIFloat_AmountOrder
                                      ON MIFloat_AmountOrder.MovementItemId = MovementItem.Id
                                     AND MIFloat_AmountOrder.DescId = zc_MIFloat_AmountOrder()
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
--
SELECT * FROM gpSelect_MovementItem_Check_Booking_Tabletki (0 , '3');