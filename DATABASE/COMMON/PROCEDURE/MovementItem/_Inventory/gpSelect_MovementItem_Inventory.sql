-- Function: gpSelect_MovementItem_Inventory()

-- DROP FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_Inventory(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , -- 
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat
             , HeadCount TFloat, Count TFloat, Summ TFloat
             , PartionGoodsDate TDateTime, PartionGoods TVarChar, GoodsKindName  TVarChar
             , AssetId Integer, AssetName TVarChar 
             , isErased Boolean
             )
AS
$BODY$
BEGIN

     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_Inventory());

     -- inShowAll:= TRUE;

     IF inShowAll THEN 

     RETURN QUERY 
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , CAST (NULL AS TFloat) AS Amount

           , CAST (NULL AS TFloat) AS HeadCount
           , CAST (NULL AS TFloat) AS Count
           , CAST (NULL AS TFloat) AS Summ
           
           , CAST (NULL AS TDateTime) AS PartionGoodsDate
           , CAST (NULL AS TVarChar)  AS PartionGoods

           , Object_GoodsKind.ValueData AS GoodsKindName
           
           , Object_Asset.Id         AS AssetId
           , Object_Asset.ValueData  AS AssetName

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
                                            
            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId


       WHERE Object_Goods.DescId = zc_Object_Goods()
         AND (MILinkObject_GoodsKind.ObjectId IS NULL OR (MovementItem.MovementId IS NULL AND lfObject_GoodsByGoodsKind.GoodsId IS NULL))
      UNION ALL
       SELECT
             MovementItem.Id
           , Object_Goods.Id          AS GoodsId
           , Object_Goods.ObjectCode  AS GoodsCode
           , Object_Goods.ValueData   AS GoodsName
           , MovementItem.Amount

           , MIFloat_HeadCount.ValueData AS HeadCount
           , MIFloat_Count.ValueData AS Count
           , MIFloat_Summ.ValueData  AS Summ

           , MIDate_PartionGoods.ValueData    AS PartionGoodsDate
           , MIString_PartionGoods.ValueData  AS PartionGoods

           , Object_GoodsKind.ValueData AS GoodsKindName

           , Object_Asset.Id         AS AssetId
           , Object_Asset.ValueData  AS AssetName

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()
            
            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()
         
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()                                        

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

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
         
           , MIFloat_HeadCount.ValueData AS HeadCount
           , MIFloat_Count.ValueData AS Count
           , MIFloat_Summ.ValueData  AS Summ

           , MIDate_PartionGoods.ValueData AS PartionGoodsDate
           , MIString_PartionGoods.ValueData AS PartionGoods

           , Object_GoodsKind.ValueData AS GoodsKindName

           , Object_Asset.Id         AS AssetId
           , Object_Asset.ValueData  AS AssetName

           , MovementItem.isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

            LEFT JOIN MovementItemFloat AS MIFloat_Count
                                        ON MIFloat_Count.MovementItemId = MovementItem.Id
                                       AND MIFloat_Count.DescId = zc_MIFloat_Count()
         
            LEFT JOIN MovementItemFloat AS MIFloat_Summ
                                        ON MIFloat_Summ.MovementItemId = MovementItem.Id
                                       AND MIFloat_Summ.DescId = zc_MIFloat_Summ()

            LEFT JOIN MovementItemDate AS MIDate_PartionGoods
                                       ON MIDate_PartionGoods.MovementItemId =  MovementItem.Id
                                      AND MIDate_PartionGoods.DescId = zc_MIDate_PartionGoods()

            LEFT JOIN MovementItemString AS MIString_PartionGoods
                                         ON MIString_PartionGoods.MovementItemId =  MovementItem.Id
                                        AND MIString_PartionGoods.DescId = zc_MIString_PartionGoods()

            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = MILinkObject_GoodsKind.ObjectId

            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

       WHERE MovementItem.MovementId = inMovementId
         AND MovementItem.DescId =  zc_MI_Master();
 
     END IF;

END;
$BODY$
LANGUAGE PLPGSQL VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_Inventory (Integer, Boolean, TVarChar) OWNER TO postgres;


/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.
 22.07.13         * add PartionGoodsDate              
 18.07.13         * 

*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 309, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_Inventory (inMovementId:= 309, inShowAll:= FALSE, inSession:= '2')
