-- Function: gpSelect_MovementItem_ReturnOut()

DROP FUNCTION IF EXISTS gpSelect_MovementItem_ReturnOut (Integer, Boolean, Boolean, TVarChar);

CREATE OR REPLACE FUNCTION gpSelect_MovementItem_ReturnOut(
    IN inMovementId  Integer      , -- ключ Документа
    IN inShowAll     Boolean      , --
    IN inisErased    Boolean      , --
    IN inSession     TVarChar       -- сессия пользователя
)
RETURNS TABLE (Id Integer, GoodsId Integer, GoodsCode Integer, GoodsName TVarChar, GoodsName_old TVarChar
             , GoodsGroupNameFull TVarChar, MeasureName TVarChar
             , Amount TFloat, AmountPartner TFloat
             , Price TFloat, CountForPrice TFloat, HeadCount TFloat
             , PartionGoods TVarChar, GoodsKindId Integer, GoodsKindName  TVarChar
             , AssetId Integer, AssetName TVarChar
             , AmountSumm TFloat, isErased Boolean
             )
AS
$BODY$
  DECLARE vbUserId Integer;

  DECLARE vbPriceListId Integer;
BEGIN
     -- проверка прав пользователя на вызов процедуры
     -- vbUserId:= lpCheckRight (inSession, zc_Enum_Process_Select_MI_ReturnOut());
     vbUserId:= lpGetUserBySession (inSession);

     -- inShowAll:= TRUE;


     -- определяется - Пав-ны приход
     vbPriceListId:= (SELECT 140208 WHERE EXISTS (SELECT UserId FROM ObjectLink_UserRole_View WHERE UserId = vbUserId AND RoleId IN (80548/*, zc_Enum_Role_Admin()*/))); -- Бухгалтер ПАВИЛЬОНЫ


     -- Результат
     IF inShowAll = TRUE THEN

     -- Результат такой
     RETURN QUERY
       WITH tmpPrice AS (SELECT tmp.GoodsId
                              , tmp.GoodsKindId
                              , tmp.ValuePrice
                         FROM lfSelect_ObjectHistory_PriceListItem (inPriceListId:= vbPriceListId, inOperDate:= (SELECT Movement.OperDate FROM Movement WHERE Movement.Id = inMovementId)) AS tmp)
       SELECT
             0                                           AS Id
           , tmpGoods.GoodsId                            AS GoodsId
           , tmpGoods.GoodsCode                          AS GoodsCode
           , tmpGoods.GoodsName                          AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData     AS MeasureName

           , CAST (NULL AS TFloat)      AS Amount
           , CAST (NULL AS TFloat)      AS AmountPartner
           , COALESCE (tmpPrice_kind.ValuePrice, tmpPrice.ValuePrice) :: TFloat AS Price
           , 1      :: TFloat           AS CountForPrice
           , CAST (NULL AS TFloat)      AS HeadCount
           , CAST (NULL AS TVarChar)    AS PartionGoods
           , Object_GoodsKind.Id        AS GoodsKindId
           , Object_GoodsKind.ValueData AS GoodsKindName
           , tmpMI.AssetId              AS AssetId
           , tmpMI.AssetName            AS AssetName
           , CAST (NULL AS TFloat)      AS AmountSumm
           , FALSE                      AS isErased

       FROM (SELECT Object_Goods.Id                                                   AS GoodsId
                  , Object_Goods.ObjectCode                                           AS GoodsCode
                  , Object_Goods.ValueData                                            AS GoodsName
                  , COALESCE (Object_GoodsByGoodsKind_View.GoodsKindId, 0)            AS GoodsKindId
                  , ObjectLink_Goods_InfoMoney.ChildObjectId                          AS InfoMoneyId
             FROM Object AS Object_Goods
                  LEFT JOIN ObjectLink AS ObjectLink_Goods_InfoMoney
                                       ON ObjectLink_Goods_InfoMoney.ObjectId = Object_Goods.Id
                                      AND ObjectLink_Goods_InfoMoney.DescId = zc_ObjectLink_Goods_InfoMoney()
                  LEFT JOIN Object_GoodsByGoodsKind_View ON Object_GoodsByGoodsKind_View.GoodsId = Object_Goods.Id
                                                        AND ObjectLink_Goods_InfoMoney.ChildObjectId IN (zc_Enum_InfoMoney_20901(), zc_Enum_InfoMoney_30101(), zc_Enum_InfoMoney_30201()) -- Ирна + Готовая продукция + Доходы Мясное сырье
             WHERE Object_Goods.DescId = zc_Object_Goods()
               AND Object_Goods.isErased = FALSE
            ) AS tmpGoods
            LEFT JOIN (SELECT MovementItem.ObjectId                         AS GoodsId
                            , COALESCE (MILinkObject_GoodsKind.ObjectId, 0) AS GoodsKindId
                            , Object_Asset.Id                               AS AssetId
                            , Object_Asset.ValueData                        AS AssetName
                       FROM (SELECT FALSE AS isErased UNION ALL SELECT inIsErased AS isErased WHERE inIsErased = TRUE) AS tmpIsErased
                            JOIN MovementItem ON MovementItem.MovementId = inMovementId
                                             AND MovementItem.DescId     = zc_MI_Master()
                                             AND MovementItem.isErased   = tmpIsErased.isErased
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_GoodsKind
                                                             ON MILinkObject_GoodsKind.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_GoodsKind.DescId = zc_MILinkObject_GoodsKind()
                            LEFT JOIN MovementItemLinkObject AS MILinkObject_Asset
                                                             ON MILinkObject_Asset.MovementItemId = MovementItem.Id
                                                            AND MILinkObject_Asset.DescId = zc_MILinkObject_Asset()
                            LEFT JOIN Object AS Object_Asset ON Object_Asset.Id = MILinkObject_Asset.ObjectId

                      ) AS tmpMI ON tmpMI.GoodsId     = tmpGoods.GoodsId
                                AND tmpMI.GoodsKindId = tmpGoods.GoodsKindId
            LEFT JOIN Object AS Object_GoodsKind ON Object_GoodsKind.Id = tmpGoods.GoodsKindId

            -- привязываем цены 2 раза по виду и без
            LEFT JOIN tmpPrice ON tmpPrice.GoodsId = tmpGoods.GoodsId
                              AND tmpPrice.GoodsKindId IS NULL
            LEFT JOIN tmpPrice AS tmpPrice_kind
                               ON tmpPrice_kind.GoodsId = tmpGoods.GoodsId
                              AND COALESCE (tmpPrice_kind.GoodsKindId,0) = COALESCE (tmpGoods.GoodsKindId,0)

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = tmpGoods.GoodsId
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = tmpGoods.GoodsId
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId


       WHERE tmpMI.GoodsId IS NULL
         AND (COALESCE (tmpPrice_kind.ValuePrice, tmpPrice.ValuePrice) <> 0 OR vbPriceListId IS NULL)
      UNION ALL
       SELECT
             MovementItem.Id				 AS Id
           , Object_Goods.Id          		 	 AS GoodsId
           , Object_Goods.ObjectCode  		 	 AS GoodsCode
           , Object_Goods.ValueData   		 	 AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount		AS Amount
           , MIFloat_AmountPartner.ValueData    AS AmountPartner
           , MIFloat_Price.ValueData 		AS Price
           , MIFloat_CountForPrice.ValueData 	AS CountForPrice
           , MIFloat_HeadCount.ValueData 	AS HeadCount

           , MIString_PartionGoods.ValueData 	AS PartionGoods
           , Object_GoodsKind.Id        	AS GoodsKindId
           , Object_GoodsKind.ValueData 	AS GoodsKindName

           , Object_Asset.Id         		AS AssetId
           , Object_Asset.ValueData  		AS AssetName

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

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId
            ;

     ELSE

     -- Результат другой
     RETURN QUERY
       SELECT
             MovementItem.Id                             AS Id
           , Object_Goods.Id          			 AS GoodsId
           , Object_Goods.ObjectCode  			 AS GoodsCode
           , Object_Goods.ValueData   			 AS GoodsName
           , ObjectString_Goods_Scale.ValueData          AS GoodsName_old
           , ObjectString_Goods_GoodsGroupFull.ValueData AS GoodsGroupNameFull
           , Object_Measure.ValueData                    AS MeasureName

           , MovementItem.Amount		         AS Amount
           , MIFloat_AmountPartner.ValueData   	         AS AmountPartner
           , MIFloat_Price.ValueData 		         AS Price
           , MIFloat_CountForPrice.ValueData             AS CountForPrice
           , MIFloat_HeadCount.ValueData                 AS HeadCount
           , MIString_PartionGoods.ValueData             AS PartionGoods
           , Object_GoodsKind.Id                         AS GoodsKindId
           , Object_GoodsKind.ValueData                  AS GoodsKindName
           , Object_Asset.Id         	                 AS AssetId
           , Object_Asset.ValueData                      AS AssetName
           , CAST (CASE WHEN MIFloat_CountForPrice.ValueData > 0
                           THEN CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData / MIFloat_CountForPrice.ValueData AS NUMERIC (16, 2))
                        ELSE CAST ( (COALESCE (MIFloat_AmountPartner.ValueData, 0)) * MIFloat_Price.ValueData AS NUMERIC (16, 2))
                   END AS TFloat)                        AS AmountSumm
           , MovementItem.isErased                       AS isErased

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

            LEFT JOIN ObjectString AS ObjectString_Goods_GoodsGroupFull
                                   ON ObjectString_Goods_GoodsGroupFull.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_GoodsGroupFull.DescId = zc_ObjectString_Goods_GroupNameFull()
            LEFT JOIN ObjectString AS ObjectString_Goods_Scale
                                   ON ObjectString_Goods_Scale.ObjectId = Object_Goods.Id
                                  AND ObjectString_Goods_Scale.DescId   = zc_ObjectString_Goods_Scale()

            LEFT JOIN ObjectLink AS ObjectLink_Goods_Measure
                                 ON ObjectLink_Goods_Measure.ObjectId = Object_Goods.Id
                                AND ObjectLink_Goods_Measure.DescId = zc_ObjectLink_Goods_Measure()
            LEFT JOIN Object AS Object_Measure ON Object_Measure.Id = ObjectLink_Goods_Measure.ChildObjectId

            ;

     END IF;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE;

/*
 ИСТОРИЯ РАЗРАБОТКИ: ДАТА, АВТОР
               Фелонюк И.В.   Кухтин И.В.   Климентьев К.И.   Манько Д.А.
 02.12.19         *
 31.03.15         * add GoodsGroupNameFull
 14.02.14                                                       *
 10.02.14                                                       *
*/

-- тест
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= TRUE, inisErased:=FALSE, inSession:= '2')
-- SELECT * FROM gpSelect_MovementItem_ReturnOut (inMovementId:= 25173, inShowAll:= FALSE, inisErased:=FALSE, inSession:= '2')
