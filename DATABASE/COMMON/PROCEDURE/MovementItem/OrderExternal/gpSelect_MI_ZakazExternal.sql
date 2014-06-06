-- Function: gpSelect_MovementItem_ZakazExternal()

-- DROP FUNCTION gpSelect_MovementItem_ZakazExternal (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ZakazExternal(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat, AmountSecond TFloat
             , GoodsKindName  TVarChar
             , isErased Boolean
              )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ZakazExternal());

     -- inShowAll:= TRUE;

     IF inShowAll THEN 

     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName

           , CAST (NULL AS TFloat) AS Amount
           , CAST (NULL AS TFloat) AS AmountSecond

           , Object_GoodsKind.ValueData AS GoodsKindName

           , FALSE AS isErased

       FROM Object AS Object_Goods
            LEFT JOIN lfSelect_Object_GoodsByGoodsKind() AS lfObject_GoodsByGoodsKind ON lfObject_GoodsByGoodsKind.GoodsId = Object_Goods.Id
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = lfObject_GoodsByGoodsKind.GoodsKindId

            LEFT JOIN MovementItem
                   ON MovementItem.ObjectId = Object_Goods.Id
                  AND MovementItem.MovementId = inMovementId
                  AND MovementItem.DescId =  zc_MI_Master()
            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                                            AND MILinkObject_GoodsKind.ObjectId = lfObject_GoodsByGoodsKind.GoodsKindId

       WHERE Object_Goods.DescId = zc_Object_Goods()
        AND (MILinkObject_GoodsKind.ObjectId IS NULL OR (MovementItem.MovementId IS NULL AND lfObject_GoodsByGoodsKind.GoodsId IS NULL))
      UNION ALL
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount
           
           , MIFloat_AmountSecond.ValueData AS AmountSecond

           , Object_GoodsKind.ValueData AS GoodsKindName

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId
            
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
           
           , MIFloat_AmountSecond.ValueData AS AmountSecond

           , Object_GoodsKind.ValueData AS GoodsKindName

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountSecond
                                        ON MIFloat_AmountSecond.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountSecond.DescId = zc_MIFloat_AmountSecond()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();
 
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ZakazExternal (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 01.08.13         *

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ZakazExternal (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_ZakazExternal (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
