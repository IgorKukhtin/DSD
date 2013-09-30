-- Function: gpSelect_MovementItem_IncomeFuel()

-- DROP FUNCTION gpSelect_MovementItem_IncomeFuel (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_IncomeFuel(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat
             , Price TFloat, CountForPrice TFloat
             , AmountSumm TFloat, isErased Boolean
              )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Income());

     -- inShowAll:= TRUE;

     IF inShowAll THEN 

     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , CAST (NULL AS TFloat) AS Amount

           , CAST (NULL AS TFloat) AS Price
           , CAST (NULL AS TFloat) AS CountForPrice

           , CAST (NULL AS TFloat) AS AmountSumm
           , FALSE AS isErased

       FROM ObjectLink AS ObjectLink_InfoMoney
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_InfoMoney.ObjectId

            LEFT JOIN MovementItem
                   ON MovementItem.ObjectId = ObjectLink_InfoMoney.ObjectId
                  AND MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId =  zc_MI_Master()

       WHERE ObjectLink_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
         AND ObjectLink_InfoMoney.ChildObjectId = zc_Enum_InfoMoney_20401()
         AND MovementItem.MovementId IS NULL
      UNION ALL
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount

           , MIFloat_Price.ValueData AS Price
           , MIFloat_CountForPrice.ValueData AS CountForPrice

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm
           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();

     ELSE
  
     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount

           , MIFloat_Price.ValueData AS Price
           , MIFloat_CountForPrice.ValueData AS CountForPrice

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( MovementItem.Amount * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( MovementItem.Amount * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) AS AmountSumm
           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();
 
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_IncomeFuel (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 29.09.13                                        *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_IncomeFuel (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_IncomeFuel (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
