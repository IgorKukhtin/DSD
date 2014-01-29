-- Function: gpSelect_MovementItem_ReturnIn()

-- DROP FUNCTION gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, Boolean, TVarChar);



CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn(
    IN inMovementId  Integer      , -- ���� ���������
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- ������ ������������
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat, AmountPartner TFloat
             , Price TFloat, CountForPrice TFloat, HeadCount TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar
             , AssetId Integer, AssetName TVarChar
             , AmountSumm TFloat, isErased Boolean
             )
AS
$BODY$
BEGIN

     -- �������� ���� ������������ �� ����� ���������
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ReturnIn());

     -- inShowAll:= TRUE;

     IF inShowAll THEN

     RETURN QUERY
       SELECT
             MovementItem.Id			AS Id
           , Object_Goods.Id            AS GoodsId
           , Object_Goods.ObjectCode    AS GoodsCode
           , Object_Goods.ValueData     AS GoodsName
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountPartner
           , CAST (NULL AS TFloat)      AS Price
           , CAST (NULL AS TFloat)      AS CountForPrice
           , CAST (NULL AS TFloat)      AS HeadCount
           , CAST (NULL AS TVarChar)    AS PartionGoods
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , Object_Asset.Id            AS AssetId
           , Object_Asset.ValueData     AS AssetName
           , CAST (NULL AS TFloat)      AS AmountSumm
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
             MovementItem.Id					AS Id
           , Object_Goods.Id          			AS GoodsId
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData   			AS GoodsName
           , MovementItem.Amount				AS Amount
           , MIFloat_AmountPartner.ValueData    AS AmountPartner
           , MIFloat_Price.ValueData 			AS Price
           , MIFloat_CountForPrice.ValueData 	AS CountForPrice
           , MIFloat_HeadCount.ValueData 		AS HeadCount

           , MIString_PartionGoods.ValueData 	AS PartionGoods
           , Object_GoodsKind.Id        		AS GoodsKindId
           , Object_GoodsKind.ValueData 		AS GoodsKindName

           , Object_Asset.Id         			AS AssetId
           , Object_Asset.ValueData  			AS AssetName

           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                        THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0) ) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat) 				AS AmountSumm
           , MovementItem.isErased				AS isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()
            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

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
             MovementItem.Id					AS Id
           , Object_Goods.Id          			AS GoodsId
           , Object_Goods.ObjectCode  			AS GoodsCode
           , Object_Goods.ValueData   			AS GoodsName
           , MovementItem.Amount				AS Amount
           , MIFloat_AmountPartner.ValueData   	AS AmountPartner
           , MIFloat_Price.ValueData 			AS Price
           , MIFloat_CountForPrice.ValueData 	AS CountForPrice
           , MIFloat_HeadCount.ValueData 		AS HeadCount
           , MIString_PartionGoods.ValueData 	AS PartionGoods
           , Object_GoodsKind.Id        		AS GoodsKindId
           , Object_GoodsKind.ValueData 		AS GoodsKindName
           , Object_Asset.Id         			AS AssetId
           , Object_Asset.ValueData  			AS AssetName
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)			    AS AmountSumm
           , MovementItem.isErased              AS isErased

       FROM MovementItem
            LEFT JOIN Object AS Object_Goods ON Object_Goods.Id = MovementItem.ObjectId

            LEFT JOIN MovementItemFloat AS MIFloat_AmountPartner
                                        ON MIFloat_AmountPartner.MovementItemId = MovementItem.Id
                                       AND MIFloat_AmountPartner.DescId = zc_MIFloat_AmountPartner()

            LEFT JOIN MovementItemFloat AS MIFloat_Price
                                        ON MIFloat_Price.MovementItemId = MovementItem.Id
                                       AND MIFloat_Price.DescId = zc_MIFloat_Price()

            LEFT JOIN MovementItemFloat AS MIFloat_CountForPrice
                                        ON MIFloat_CountForPrice.MovementItemId = MovementItem.Id
                                       AND MIFloat_CountForPrice.DescId = zc_MIFloat_CountForPrice()

            LEFT JOIN MovementItemFloat AS MIFloat_HeadCount
                                        ON MIFloat_HeadCount.MovementItemId = MovementItem.Id
                                       AND MIFloat_HeadCount.DescId = zc_MIFloat_HeadCount()

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
ALTER FUNCTION gpSelect_MovementItem_ReturnIn (Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;


/*
 ������� ����������: ����, �����
               ������� �.�.   ������ �.�.   ���������� �.�.  ������ �.�.
 27.01.14														*  + inisErased (�������)
 18.07.13         * add Object_Asset
 17.07.13         *

*/

-- ����
-- SELECT * FROM gpSelect_MovementItem_ReturnIn (inMovementId:= 25173, inShowAll:= TRUE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_ReturnIn (inMovementId:= 25173, inShowAll:= FALSE, inSession:= '2')
