-- Function: gpSelect_MovementItem_IncomeFuel (Integer, Boolean, Boolean, TVarChar)

DROP FUNCTION IF EXISTS gpSelect_MovementItem_IncomeFuel (Integer, Boolean, TVarChar);
DROP FUNCTION IF EXISTS gpSelect_MovementItem_IncomeFuel (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_IncomeFuel(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inIsErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, FuelCode Integer, FuelName TVarChar
             , Amount TFloat, Price TFloat, CountForPrice TFloat
             , AmountSumm TFloat
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbUserId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId := PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MI_IncomeFuel());
     vbUserId:= lpGetUserBySession (inSession);


     IF inShowAll = TRUE
     THEN

         RETURN QUERY
           WITH tmpMIContainer AS (SELECT *
                                   FROM MovementItemContainer AS MIContainer_Count
                                   WHERE MIContainer_Count.MovementId = inMovementId
                                     AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                  )
           -- Результат
           SELECT
                 0 AS Id
               , Object_Goods.Id          AS GoodsId
               , Object_Goods.ObjectCode  AS GoodsCode
               , Object_Goods.ValueData   AS GoodsName
               , Object_Fuel.ObjectCode   AS FuelCode
               , Object_Fuel.ValueData    AS FuelName

               , CAST (NULL AS TFloat) AS Amount
               , CAST (NULL AS TFloat) AS Price
               , CAST (NULL AS TFloat) AS CountForPrice
               , CAST (NULL AS TFloat) AS AmountSumm

               , FALSE AS isErased

           FROM ObjectLink AS ObjectLink_Goods_Fuel
                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_Fuel.ObjectId
                LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = ObjectLink_Goods_Fuel.ChildObjectId
                LEFT JOIN ObjectLink AS ObjectLink_TicketFuel_Goods
                                     ON ObjectLink_TicketFuel_Goods.ChildObjectId = Object_Goods.Id
                                    AND ObjectLink_TicketFuel_Goods.DescId = zc_ObjectLink_TicketFuel_Goods()

                LEFT JOIN (SELECT MovementItem.ObjectId AS GoodsId
                           FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                                JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                                 AND MovementItem.DescId     =  zc_MI_Master()
                                                 AND MovementItem.isErased   =  tmpIsErased.isErased
                          ) AS tmpMI ON tmpMI.GoodsId = ObjectLink_Goods_Fuel.ObjectId

           WHERE ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
             AND ObjectLink_Goods_Fuel.ChildObjectId > 0
             AND ObjectLink_TicketFuel_Goods.ChildObjectId IS NULL
             AND tmpMI.GoodsId IS NULL

          UNION ALL
           SELECT
                 MovementItem.Id
               , Object_Goods.Id          AS GoodsId
               , Object_Goods.ObjectCode  AS GoodsCode
               , Object_Goods.ValueData   AS GoodsName
               , Object_Fuel.ObjectCode   AS FuelCode
               , Object_Fuel.ValueData    AS FuelName

               , MovementItem.Amount
               , MIFloat_Price.ValueData AS Price
               , MIFloat_CountForPrice.ValueData AS CountForPrice
               , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                               THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                            ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                       END AS TFloat) AS AmountSumm

               , MovementItem.isErased

           FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = tmpIsErased.isErased
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

                LEFT JOIN tmpMIContainer AS MIContainer_Count ON MIContainer_Count.MovementItemId = MovementItem.Id
                                                             AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                                             AND MIContainer_Count.isActive = TRUE -- Вид топлива есть только в приходной количественной проводке
                LEFT JOIN Container AS Container_Count ON Container_Count.Id = MIContainer_Count.ContainerId
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                                             AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = COALESCE (Container_Count.ObjectId, ObjectLink_Goods_Fuel.ChildObjectId)
          ;

     ELSE

         RETURN QUERY
           WITH tmpMIContainer AS (SELECT *
                                   FROM MovementItemContainer AS MIContainer_Count
                                   WHERE MIContainer_Count.MovementId = inMovementId
                                     AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                  )
           -- Результат
           SELECT
                 MovementItem.Id
               , Object_Goods.Id          AS GoodsId
               , Object_Goods.ObjectCode  AS GoodsCode
               , Object_Goods.ValueData   AS GoodsName
               , Object_Fuel.ObjectCode   AS FuelCode
               , Object_Fuel.ValueData    AS FuelName

               , MovementItem.Amount
               , MIFloat_Price.ValueData         AS Price
               , MIFloat_CountForPrice.ValueData AS CountForPrice
               , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                               THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                            ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                       END AS TFloat) AS AmountSumm

               , MovementItem.isErased

           FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                 AND MovementItem.DescId     = zc_MI_Master()
                                 AND MovementItem.isErased   = tmpIsErased.isErased
                LEFT JOIN MovementItemFloat AS MIFloat_Price
                                            ON MIFloat_Price.MovementItemId = MovementItem.Id
                                           AND MIFloat_Price.DescId = zc_MIFloat_Price()
                LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                            ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                           AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

                LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId
                LEFT JOIN ObjectLink AS ObjectLink_Goods_Fuel ON ObjectLink_Goods_Fuel.ObjectId = MovementItem.ObjectId
                                                             AND ObjectLink_Goods_Fuel.DescId = zc_ObjectLink_Goods_Fuel()
                                                             AND 1=0 -- заблокировал, что б всегда видеть по какому Виду топлива прошла количественная проводка

                LEFT JOIN tmpMIContainer AS MIContainer_Count ON MIContainer_Count.MovementItemId = MovementItem.Id
                                                                    AND MIContainer_Count.DescId = zc_MIContainer_Count()
                                                                    AND MIContainer_Count.isActive = TRUE -- Вид топлива есть только в приходной количественной проводке
                LEFT JOIN Container AS Container_Count ON Container_Count.Id = MIContainer_Count.ContainerId

                LEFT JOIN Object AS Object_Fuel ON Object_Fuel.Id = COALESCE (Container_Count.ObjectId, ObjectLink_Goods_Fuel.ChildObjectId)
          ;

         END IF;

END;
$BODY$
  LANGUAGE PLPGSQL VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 09.11.13                                        * add zc_ObjectLink_TicketFuel_Goods
 30.10.13                                        * add MIContainer_Count.isActive = TRUE
 04.10.13                                        * add inIsErased
 04.10.13                                        * add FuelName
 29.09.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_IncomeFuel (inMovementId:= 25173, inShowAll:= TRUE, inIsErased:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_IncomeFuel (inMovementId:= 25173, inShowAll:= FALSE, inIsErased:= FALSE, inSession:= '2')
