-- Function: gpSelect_MovementItem_ReturnIn()

-- DROP FUNCTION gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Boolean, Boolean, TVarChar);
 DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnIn (Integer, Integer, Boolean, Boolean, TVarChar);


CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnIn(
    IN inMovementId  Integer      , -- ключ Документа
    IN inPriceListId Integer      , -- ключ Прайс листа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, Amount TFloat, AmountPartner TFloat
             , Price TFloat, CountForPrice TFloat, HeadCount TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar
             , AssetId Integer, AssetName TVarChar
             , AmountSumm TFloat, isErased Boolean
             )
AS
$BODY$
  DECLARE vbOperDate TDateTime;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- PERFORM lpCheckRight (inSession, zc_Enum_Process_Select_MovementItem_ReturnIn());

     --
     IF inShowAll THEN

     --
     vbOperDate := (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId);

     -- Результат
     RETURN QUERY
       SELECT
             0                          AS Id
           , tmpGoods.GoodsId           AS GoodsId
           , tmpGoods.GoodsCode         AS GoodsCode
           , tmpGoods.GoodsName         AS GoodsName
           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountPartner
           , CAST (lfObjectHistory_PriceListItem.ValuePrice AS TFloat) AS Price
           , CAST (NULL AS TFloat)      AS CountForPrice
           , CAST (NULL AS TFloat)      AS HeadCount
           , CAST (NULL AS TVarChar)    AS PartionGoods
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , 0 ::Integer                AS AssetId
           , '' ::TVarChar              AS AssetName
           , CAST (NULL AS TFloat)      AS AmountSumm
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id           AS GoodsId
                  , Object_Goods.ObjectCode   AS GoodsCode
                  , Object_Goods.ValueData    AS GoodsName
                  , zc_Enum_GoodsKind_Main()  AS GoodsKindId
                  -- , COALESCE (ObjectLink_GoodsByGoodsKind_GoodsKind.ChildObjectId, 0) AS GoodsKindId
             FROM Object_InfoMoney_View
                  JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                  ON ObjectLink_Goods_InfoMoney.ChildObjectId = Object_InfoMoney_View.InfoMoneyId
                                 AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  JOIN Object AS Object_Goods ON Object_Goods.Id = ObjectLink_Goods_InfoMoney.ObjectId
                                             AND Object_Goods.isErased = FALSE
                  /*LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_Goods
                                       ON ObjectLink_GoodsByGoodsKind_Goods.ChildObjectId = Object_Goods.Id
                                      AND ObjectLink_GoodsByGoodsKind_Goods.DescId = zc_ObjectLink_GoodsByGoodsKind_Goods()
                  LEFT JOIN ObjectLink AS ObjectLink_GoodsByGoodsKind_GoodsKind
                                       ON ObjectLink_GoodsByGoodsKind_GoodsKind.ObjectId = ObjectLink_GoodsByGoodsKind_Goods.ObjectId
                                      AND ObjectLink_GoodsByGoodsKind_GoodsKind.DescId = zc_ObjectLink_GoodsByGoodsKind_GoodsKind()*/
             WHERE Object_InfoMoney_View.InfoMoneyDestinationId IN (zc_Enum_InfoMoneyDestination_20900(), zc_Enum_InfoMoneyDestination_21000(), zc_Enum_InfoMoneyDestination_21100(), zc_Enum_InfoMoneyDestination_30100())
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId
            LEFT JOIN lfSelect_ObjectHistory_PriceListItem (inPriceListId:= inPriceListId, inOperDate:= vbOperDate)
                   AS lfObjectHistory_PriceListItem ON lfObjectHistory_PriceListItem.GoodsId = tmpGoods.GoodsId

       WHERE tmpMI.GoodsId IS NULL
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

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
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
            ;

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

       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                             AND MovementItem.DescId     = zc_MI_Master()
                             AND MovementItem.isErased   = tmpIsErased.isErased
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
            ;
     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION gpSelect_MovementItem_ReturnIn (Integer, Integer, Boolean, Boolean, TVarChar) OWNER TO postgres;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 08.04.14                                        * add zc_Enum_InfoMoneyDestination_30100
 12.02.14                                                       * inPriceListId
 30.01.14							* add inisErased
 18.07.13         * add Object_Asset
 17.07.13         *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnIn (inMovementId:= 25173, inShowAll:= TRUE, inisErased:= TRUE, inPriceListId:=18840, inSession:= '2')
